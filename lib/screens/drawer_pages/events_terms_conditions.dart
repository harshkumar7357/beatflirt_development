// =============================================================================
// terms_conditions_widget.dart — Beat Flirt Terms & Conditions
// Riverpod 3 compatible
// =============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class TermsData {
  final String id;
  final String title;
  final String description; // raw HTML

  const TermsData({
    required this.id,
    required this.title,
    required this.description,
  });

  factory TermsData.fromJson(Map<String, dynamic> json) {
    return TermsData(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Terms and Conditions',
      description: json['description']?.toString() ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RIVERPOD PROVIDERS
// ─────────────────────────────────────────────────────────────────────────────

final termsProvider = FutureProvider.autoDispose<TermsData>((ref) async {
  const url =
      'https://app.beatflirtevent.com/App/auth/event_terms_condition';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body['status']?.toString() == '200') {
      final data = body['data'];

      if (data is List && data.isNotEmpty && data.first is Map) {
        return TermsData.fromJson(
          Map<String, dynamic>.from(data.first as Map),
        );
      }
    }
  }

  throw Exception('Failed to load Terms & Conditions');
});

// Tracks whether user has scrolled to bottom
class _TermsScrolledNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void markScrolled() {
    state = true;
  }

  void reset() {
    state = false;
  }
}

final _termsScrolledProvider =
    NotifierProvider.autoDispose<_TermsScrolledNotifier, bool>(
  _TermsScrolledNotifier.new,
);

// Tracks checkbox state
class _TermsCheckedNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setChecked(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }

  void reset() {
    state = false;
  }
}

final _termsCheckedProvider =
    NotifierProvider.autoDispose<_TermsCheckedNotifier, bool>(
  _TermsCheckedNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// HTML PARSER — strips HTML tags and decodes entities for plain text rendering
// ─────────────────────────────────────────────────────────────────────────────

class _HtmlParser {
  static String _decodeEntities(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
        .replaceAll('&#34;', '"');
  }

  static List<_HtmlBlock> parse(String html) {
    // Decode double-encoded entities first
    String text = html
        .replaceAll('&amp;lt;', '<')
        .replaceAll('&amp;gt;', '>')
        .replaceAll('&amp;amp;', '&')
        .replaceAll('&amp;nbsp;', ' ')
        .replaceAll('&amp;quot;', '"');

    text = _decodeEntities(text);

    final blocks = <_HtmlBlock>[];

    // Normalize line endings
    text = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Extract ordered list items
    final olRegex = RegExp(
      r'<ol[^>]*>(.*?)</ol>',
      dotAll: true,
      caseSensitive: false,
    );

    text = text.replaceAllMapped(olRegex, (match) {
      final inner = match.group(1) ?? '';

      final items = RegExp(
        r'<li[^>]*>(.*?)</li>',
        dotAll: true,
        caseSensitive: false,
      ).allMatches(inner).map((li) {
        final content = _stripTags(li.group(1) ?? '').trim();
        return '§LI§$content';
      }).join('\n');

      return '\n$items\n';
    });

    // Extract unordered list items
    final ulRegex = RegExp(
      r'<ul[^>]*>(.*?)</ul>',
      dotAll: true,
      caseSensitive: false,
    );

    text = text.replaceAllMapped(ulRegex, (match) {
      final inner = match.group(1) ?? '';

      final items = RegExp(
        r'<li[^>]*>(.*?)</li>',
        dotAll: true,
        caseSensitive: false,
      ).allMatches(inner).map((li) {
        final content = _stripTags(li.group(1) ?? '').trim();
        return '§LI§• $content';
      }).join('\n');

      return '\n$items\n';
    });

    // Mark bold/strong text before stripping
    text = text.replaceAllMapped(
      RegExp(
        r'<(strong|b)[^>]*>(.*?)</(strong|b)>',
        dotAll: true,
        caseSensitive: false,
      ),
      (match) => '§BOLD§${match.group(2)}§/BOLD§',
    );

    // Mark red/colored text
    text = text.replaceAllMapped(
      RegExp(
        r'<span[^>]*color\s*:\s*#ff0000[^>]*>(.*?)</span>',
        dotAll: true,
        caseSensitive: false,
      ),
      (match) => '§RED§${match.group(1)}§/RED§',
    );

    // Mark headings
    text = text.replaceAllMapped(
      RegExp(
        r'<h([1-6])[^>]*>(.*?)</h[1-6]>',
        dotAll: true,
        caseSensitive: false,
      ),
      (match) => '\n§H${match.group(1)}§${match.group(2)}§/H§\n',
    );

    // Convert paragraph and break tags to line breaks
    text = text.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n',
    );

    text = text.replaceAll(
      RegExp(r'</p\s*>', caseSensitive: false),
      '\n',
    );

    text = text.replaceAll(
      RegExp(r'<p[^>]*>', caseSensitive: false),
      '',
    );

    // Strip remaining tags
    text = _stripTags(text);

    final lines = text.split('\n');

    for (final raw in lines) {
      final line = raw.trim();

      if (line.isEmpty || line == '&nbsp;' || line == ' ') {
        blocks.add(const _HtmlBlock(type: _BlockType.spacer, text: ''));
        continue;
      }

      if (line.startsWith('§LI§')) {
        blocks.add(
          _HtmlBlock(
            type: _BlockType.listItem,
            text: _cleanMarkers(line.substring(4)),
          ),
        );
      } else if (line.startsWith('§H1§') ||
          line.startsWith('§H2§') ||
          line.startsWith('§H3§')) {
        blocks.add(
          _HtmlBlock(
            type: _BlockType.heading,
            text: _cleanMarkers(
              line.replaceAll(RegExp(r'§H\d§|§/H§'), ''),
            ),
          ),
        );
      } else {
        blocks.add(
          _HtmlBlock(
            type: _BlockType.paragraph,
            text: _cleanMarkers(line),
            hasBold: line.contains('§BOLD§'),
            hasRed: line.contains('§RED§'),
            rawLine: line,
          ),
        );
      }
    }

    // Remove consecutive spacers
    final cleaned = <_HtmlBlock>[];

    for (final block in blocks) {
      if (block.type == _BlockType.spacer &&
          cleaned.isNotEmpty &&
          cleaned.last.type == _BlockType.spacer) {
        continue;
      }

      cleaned.add(block);
    }

    return cleaned;
  }

  static String _stripTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]+>'), '');
  }

  static String _cleanMarkers(String value) {
    return value
        .replaceAll('§BOLD§', '')
        .replaceAll('§/BOLD§', '')
        .replaceAll('§RED§', '')
        .replaceAll('§/RED§', '')
        .replaceAll('§H1§', '')
        .replaceAll('§H2§', '')
        .replaceAll('§H3§', '')
        .replaceAll('§/H§', '')
        .replaceAll('§LI§', '')
        .replaceAll('&amp;', '&')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}

enum _BlockType {
  heading,
  paragraph,
  listItem,
  spacer,
}

class _HtmlBlock {
  final _BlockType type;
  final String text;
  final String rawLine;
  final bool hasBold;
  final bool hasRed;

  const _HtmlBlock({
    required this.type,
    required this.text,
    this.rawLine = '',
    this.hasBold = false,
    this.hasRed = false,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// TERMS SHEET — main entry point
// ─────────────────────────────────────────────────────────────────────────────

class TermsConditionsSheet {
  /// Shows the Terms & Conditions bottom sheet.
  /// Returns `true` if user agreed, `false` or `null` otherwise.
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return ProviderScope(
          child: _TermsSheetBody(
            onAgreed: () => Navigator.of(sheetContext).pop(true),
            onDeclined: () => Navigator.of(sheetContext).pop(false),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM SHEET BODY
// ─────────────────────────────────────────────────────────────────────────────

class _TermsSheetBody extends ConsumerStatefulWidget {
  final VoidCallback onAgreed;
  final VoidCallback onDeclined;

  const _TermsSheetBody({
    required this.onAgreed,
    required this.onDeclined,
  });

  @override
  ConsumerState<_TermsSheetBody> createState() => _TermsSheetBodyState();
}

class _TermsSheetBodyState extends ConsumerState<_TermsSheetBody> {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;

    final max = _scrollCtrl.position.maxScrollExtent;
    final current = _scrollCtrl.offset;

    // Mark as scrolled when content does not scroll or user is within 40px of bottom
    if (max <= 0 || current >= max - 40) {
      final hasScrolled = ref.read(_termsScrolledProvider);

      if (!hasScrolled) {
        ref.read(_termsScrolledProvider.notifier).markScrolled();
      }
    }
  }

  void _checkIfAlreadyAtBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollCtrl.hasClients) return;

      final max = _scrollCtrl.position.maxScrollExtent;

      if (max <= 0) {
        ref.read(_termsScrolledProvider.notifier).markScrolled();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final termsAsync = ref.watch(termsProvider);
    final isChecked = ref.watch(_termsCheckedProvider);
    final hasScrolled = ref.watch(_termsScrolledProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6B0035),
                  Color(0xFF1A0A2E),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: widget.onDeclined,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: termsAsync.when(
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF8B0045),
                  ),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Color(0xFF8B0045),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Failed to load Terms & Conditions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(termsProvider);
                            ref
                                .read(_termsScrolledProvider.notifier)
                                .reset();
                            ref.read(_termsCheckedProvider.notifier).reset();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B0045),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              data: (terms) {
                final blocks = _HtmlParser.parse(terms.description);

                _checkIfAlreadyAtBottom();

                return SingleChildScrollView(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!hasScrolled)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B0045).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  const Color(0xFF8B0045).withOpacity(0.2),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.swipe_down,
                                size: 16,
                                color: Color(0xFF8B0045),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Please scroll to the bottom to read all terms before agreeing.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8B0045),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (terms.title.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            terms.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                      ...blocks.map(
                        (block) => _BlockWidget(block: block),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
          ),

          // Footer
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: hasScrolled
                      ? () {
                          ref.read(_termsCheckedProvider.notifier).toggle();
                        }
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: isChecked,
                          activeColor: const Color(0xFF8B0045),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: hasScrolled
                              ? (value) {
                                  ref
                                      .read(_termsCheckedProvider.notifier)
                                      .setChecked(value ?? false);
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'I have read and agree to the Terms and Conditions',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (!hasScrolled)
                  const Padding(
                    padding: EdgeInsets.only(top: 4, left: 34),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 13,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Scroll to the bottom to enable',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onDeclined,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF8B0045),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(
                            color: Color(0xFF8B0045),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: isChecked ? widget.onAgreed : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isChecked
                              ? const Color(0xFF8B0045)
                              : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                          elevation: isChecked ? 2 : 0,
                        ),
                        child: Text(
                          'I Agree',
                          style: TextStyle(
                            color:
                                isChecked ? Colors.white : Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BLOCK WIDGET — renders each parsed HTML block
// ─────────────────────────────────────────────────────────────────────────────

class _BlockWidget extends StatelessWidget {
  final _HtmlBlock block;

  const _BlockWidget({
    required this.block,
  });

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case _BlockType.spacer:
        return const SizedBox(height: 10);

      case _BlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 6,
            top: 4,
          ),
          child: Text(
            block.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        );

      case _BlockType.listItem:
        return Padding(
          padding: const EdgeInsets.only(
            left: 12,
            bottom: 4,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  block.text.startsWith('• ')
                      ? block.text.substring(2)
                      : block.text,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );

      case _BlockType.paragraph:
        if (block.rawLine.contains('§RED§')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              block.text,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.red,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          );
        }

        if (block.rawLine.contains('§BOLD§')) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 6,
              top: 4,
            ),
            child: Text(
              block.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            block.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONVENIENCE BUTTON WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class TermsConditionsLink extends StatelessWidget {
  final void Function(bool agreed)? onResult;

  const TermsConditionsLink({
    super.key,
    this.onResult,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await TermsConditionsSheet.show(context);

        if (onResult != null) {
          onResult!(result == true);
        }
      },
      child: const Text(
        'View Terms & Conditions',
        style: TextStyle(
          fontSize: 13,
          color: Color(0xFF8B0045),
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// // =============================================================================
// //  terms_conditions_widget.dart  —  Beat Flirt Terms & Conditions
// //
// //  Usage — show the bottom sheet from anywhere:
// //
// //    final agreed = await TermsConditionsSheet.show(context);
// //    if (agreed == true) {
// //      // user agreed — proceed to buy ticket
// //    }
// //
// //  Or trigger it before BUY TICKET:
// //    TermsConditionsSheet.show(context).then((agreed) {
// //      if (agreed == true) { /* proceed */ }
// //    });
// //
// //  pubspec.yaml (add if not already):
// //    flutter_riverpod: ^2.5.1
// //    http: ^1.2.1
// //    flutter_html: ^3.0.0-beta.2   ← renders HTML beautifully
// // =============================================================================

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

// // ─────────────────────────────────────────────────────────────────────────────
// // MODEL
// // ─────────────────────────────────────────────────────────────────────────────

// class TermsData {
//   final String id;
//   final String title;
//   final String description; // raw HTML

//   const TermsData({
//     required this.id,
//     required this.title,
//     required this.description,
//   });

//   factory TermsData.fromJson(Map<String, dynamic> j) => TermsData(
//         id: j['id']?.toString() ?? '',
//         title: j['title']?.toString() ?? 'Terms and Conditions',
//         description: j['description']?.toString() ?? '',
//       );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // RIVERPOD PROVIDER
// // ─────────────────────────────────────────────────────────────────────────────

// final termsProvider = FutureProvider<TermsData>((ref) async {
//   const url = 'https://app.beatflirtevent.com/App/auth/event_terms_condition';

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     if (body['status']?.toString() == '200') {
//       final list = body['data'] as List;
//       if (list.isNotEmpty) {
//         return TermsData.fromJson(list.first as Map<String, dynamic>);
//       }
//     }
//   }
//   throw Exception('Failed to load Terms & Conditions');
// });

// // Tracks whether user has scrolled to bottom
// final _termsScrolledProvider = StateProvider<bool>((ref) => false);

// // Tracks checkbox state
// final _termsCheckedProvider = StateProvider<bool>((ref) => false);

// // ─────────────────────────────────────────────────────────────────────────────
// // HTML PARSER — strips HTML tags and decodes entities for plain text rendering
// // (No extra package needed — pure Dart)a
// // ─────────────────────────────────────────────────────────────────────────────

// class _HtmlParser {
//   /// Decode HTML entities
//   static String _decodeEntities(String text) {
//     return text
//         .replaceAll('&amp;', '&')
//         .replaceAll('&lt;', '<')
//         .replaceAll('&gt;', '>')
//         .replaceAll('&quot;', '"')
//         .replaceAll('&#39;', "'")
//         .replaceAll('&nbsp;', ' ')
//         .replaceAll('&#39;', "'")
//         .replaceAll('&ldquo;', '"')
//         .replaceAll('&rdquo;', '"')
//         .replaceAll('&#34;', '"');
//   }

//   /// Parse HTML into a list of _HtmlBlock (paragraphs, headings, list items)
//   static List<_HtmlBlock> parse(String html) {
//     // Decode double-encoded entities first
//     String text = html
//         .replaceAll('&amp;lt;', '<')
//         .replaceAll('&amp;gt;', '>')
//         .replaceAll('&amp;amp;', '&')
//         .replaceAll('&amp;nbsp;', ' ')
//         .replaceAll('&amp;quot;', '"');

//     text = _decodeEntities(text);

//     final blocks = <_HtmlBlock>[];

//     // Normalize line endings
//     text = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

//     // Extract ordered list items
//     final olRegex = RegExp(r'<ol[^>]*>(.*?)<\/ol>', dotAll: true);
//     text = text.replaceAllMapped(olRegex, (m) {
//       final inner = m.group(1) ?? '';
//       final items = RegExp(r'<li[^>]*>(.*?)<\/li>', dotAll: true)
//           .allMatches(inner)
//           .map((li) {
//         final content = _stripTags(li.group(1) ?? '').trim();
//         return '§LI§$content';
//       }).join('\n');
//       return '\n$items\n';
//     });

//     // Extract unordered list items
//     final ulRegex = RegExp(r'<ul[^>]*>(.*?)<\/ul>', dotAll: true);
//     text = text.replaceAllMapped(ulRegex, (m) {
//       final inner = m.group(1) ?? '';
//       final items = RegExp(r'<li[^>]*>(.*?)<\/li>', dotAll: true)
//           .allMatches(inner)
//           .map((li) {
//         final content = _stripTags(li.group(1) ?? '').trim();
//         return '§LI§• $content';
//       }).join('\n');
//       return '\n$items\n';
//     });

//     // Mark bold/strong text before stripping
//     text = text.replaceAllMapped(
//         RegExp(r'<(strong|b)[^>]*>(.*?)<\/(strong|b)>', dotAll: true),
//         (m) => '§BOLD§${m.group(2)}§/BOLD§');

//     // Mark red/colored text
//     text = text.replaceAllMapped(
//         RegExp(r'<span[^>]*color:\s*#ff0000[^>]*>(.*?)<\/span>', dotAll: true),
//         (m) => '§RED§${m.group(1)}§/RED§');

//     // Mark headings
//     text = text.replaceAllMapped(
//         RegExp(r'<h([1-6])[^>]*>(.*?)<\/h[1-6]>', dotAll: true),
//         (m) => '\n§H${m.group(1)}§${m.group(2)}§/H§\n');

//     // Strip remaining tags
//     text = _stripTags(text);

//     // Split into lines and build blocks
//     final lines = text.split('\n');
//     for (final raw in lines) {
//       final line = raw.trim();
//       if (line.isEmpty || line == '&nbsp;' || line == ' ') {
//         blocks.add(_HtmlBlock(type: _BlockType.spacer, text: ''));
//         continue;
//       }

//       if (line.startsWith('§LI§')) {
//         blocks.add(_HtmlBlock(
//           type: _BlockType.listItem,
//           text: _cleanMarkers(line.substring(4)),
//         ));
//       } else if (line.startsWith('§H1§') ||
//           line.startsWith('§H2§') ||
//           line.startsWith('§H3§')) {
//         blocks.add(_HtmlBlock(
//           type: _BlockType.heading,
//           text: _cleanMarkers(line.replaceAll(RegExp(r'§H\d§|§\/H§'), '')),
//         ));
//       } else {
//         // Check for inline bold/red markers
//         blocks.add(_HtmlBlock(
//           type: _BlockType.paragraph,
//           text: _cleanMarkers(line),
//           hasBold: line.contains('§BOLD§'),
//           hasRed: line.contains('§RED§'),
//           rawLine: line,
//         ));
//       }
//     }

//     // Remove consecutive spacers
//     final cleaned = <_HtmlBlock>[];
//     for (int i = 0; i < blocks.length; i++) {
//       if (blocks[i].type == _BlockType.spacer &&
//           cleaned.isNotEmpty &&
//           cleaned.last.type == _BlockType.spacer) {
//         continue;
//       }
//       cleaned.add(blocks[i]);
//     }

//     return cleaned;
//   }

//   static String _stripTags(String html) =>
//       html.replaceAll(RegExp(r'<[^>]+>'), '');

//   static String _cleanMarkers(String s) => s
//       .replaceAll('§BOLD§', '')
//       .replaceAll('§/BOLD§', '')
//       .replaceAll('§RED§', '')
//       .replaceAll('§/RED§', '')
//       .replaceAll('§H1§', '')
//       .replaceAll('§H2§', '')
//       .replaceAll('§H3§', '')
//       .replaceAll('§/H§', '')
//       .replaceAll('§LI§', '')
//       .replaceAll('&amp;', '&')
//       .replaceAll('&nbsp;', ' ')
//       .trim();
// }

// enum _BlockType { heading, paragraph, listItem, spacer }

// class _HtmlBlock {
//   final _BlockType type;
//   final String text;
//   final String rawLine;
//   final bool hasBold;
//   final bool hasRed;

//   const _HtmlBlock({
//     required this.type,
//     required this.text,
//     this.rawLine = '',
//     this.hasBold = false,
//     this.hasRed = false,
//   });
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TERMS SHEET — main entry point
// // ─────────────────────────────────────────────────────────────────────────────

// class TermsConditionsSheet {
//   /// Shows the Terms & Conditions bottom sheet.
//   /// Returns `true` if user agreed, `false`/`null` otherwise.
//   static Future<bool?> show(BuildContext context) {
//     return showModalBottomSheet<bool>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => ProviderScope(
//         child: _TermsSheetBody(
//           onAgreed: () => Navigator.of(context).pop(true),
//           onDeclined: () => Navigator.of(context).pop(false),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BOTTOM SHEET BODY
// // ─────────────────────────────────────────────────────────────────────────────

// class _TermsSheetBody extends ConsumerStatefulWidget {
//   final VoidCallback onAgreed;
//   final VoidCallback onDeclined;

//   const _TermsSheetBody({
//     required this.onAgreed,
//     required this.onDeclined,
//   });

//   @override
//   ConsumerState<_TermsSheetBody> createState() => _TermsSheetBodyState();
// }

// class _TermsSheetBodyState extends ConsumerState<_TermsSheetBody> {
//   final ScrollController _scrollCtrl = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollCtrl.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (!_scrollCtrl.hasClients) return;
//     final max = _scrollCtrl.position.maxScrollExtent;
//     final cur = _scrollCtrl.offset;
//     // Mark as scrolled when within 40px of bottom
//     if (cur >= max - 40) {
//       if (!ref.read(_termsScrolledProvider)) {
//         ref.read(_termsScrolledProvider.notifier).state = true;
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _scrollCtrl.removeListener(_onScroll);
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final termsAsync = ref.watch(termsProvider);
//     final isChecked = ref.watch(_termsCheckedProvider);
//     final hasScrolled = ref.watch(_termsScrolledProvider);
//     final screenH = MediaQuery.of(context).size.height;

//     return Container(
//       height: screenH * 0.90,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           // ── Header ──────────────────────────────────────────────────────
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF6B0035), Color(0xFF1A0A2E)],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//               borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
//             child: Row(
//               children: [
//                 const Icon(Icons.description_outlined,
//                     color: Colors.white, size: 22),
//                 const SizedBox(width: 10),
//                 const Expanded(
//                   child: Text(
//                     'Terms and Conditions',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white),
//                   onPressed: widget.onDeclined,
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ],
//             ),
//           ),

//           // ── Content ─────────────────────────────────────────────────────
//           Expanded(
//             child: termsAsync.when(
//               loading: () => const Center(
//                 child: CircularProgressIndicator(
//                     color: Color(0xFF8B0045)),
//               ),
//               error: (err, _) => Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.error_outline,
//                           size: 48, color: Color(0xFF8B0045)),
//                       const SizedBox(height: 12),
//                       const Text('Failed to load Terms & Conditions',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Text(err.toString(),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                               fontSize: 12, color: Colors.grey)),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () =>
//                             ref.refresh(termsProvider),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF8B0045)),
//                         child: const Text('Retry',
//                             style:
//                                 TextStyle(color: Colors.white)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               data: (terms) {
//                 final blocks = _HtmlParser.parse(terms.description);
//                 return SingleChildScrollView(
//                   controller: _scrollCtrl,
//                   padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
//                   child: Column(
//                     // crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Scroll hint banner
//                       if (!hasScrolled)
//                         Container(
//                           width: double.infinity,
//                           margin: const EdgeInsets.only(bottom: 12),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF8B0045)
//                                 .withOpacity(0.08),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                                 color: const Color(0xFF8B0045)
//                                     .withOpacity(0.2)),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(Icons.swipe_down,
//                                   size: 16, color: Color(0xFF8B0045)),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   'Please scroll to the bottom to read all terms before agreeing.',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Color(0xFF8B0045)),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                       // Terms content blocks
//                       ...blocks.map((block) =>
//                           _BlockWidget(block: block)),

//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),

//           // ── Divider ──────────────────────────────────────────────────────
//           const Divider(height: 1, thickness: 1),

//           // ── Footer: Checkbox + Buttons ───────────────────────────────────
//           Container(
//             color: Colors.white,
//             padding: EdgeInsets.fromLTRB(
//                 16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
//             child: Column(
//               children: [
//                 // Checkbox row
//                 GestureDetector(
//                   onTap: hasScrolled
//                       ? () {
//                           ref
//                               .read(_termsCheckedProvider.notifier)
//                               .state = !isChecked;
//                         }
//                       : null,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: Checkbox(
//                           value: isChecked,
//                           activeColor: const Color(0xFF8B0045),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(4)),
//                           onChanged: hasScrolled
//                               ? (val) => ref
//                                   .read(_termsCheckedProvider.notifier)
//                                   .state = val ?? false
//                               : null,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       const Expanded(
//                         child: Text(
//                           'I have read and agree to the Terms and Conditions',
//                           style: TextStyle(
//                               fontSize: 13, color: Colors.black87),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 if (!hasScrolled)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4, left: 34),
//                     child: Row(children: const [
//                       Icon(Icons.info_outline,
//                           size: 13, color: Colors.grey),
//                       SizedBox(width: 4),
//                       Text(
//                         'Scroll to the bottom to enable',
//                         style:
//                             TextStyle(fontSize: 11, color: Colors.grey),
//                       ),
//                     ]),
//                   ),

//                 const SizedBox(height: 12),

//                 // Buttons row
//                 Row(
//                   children: [
//                     // Decline
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: widget.onDeclined,
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(
//                               color: Color(0xFF8B0045)),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                           padding:
//                               const EdgeInsets.symmetric(vertical: 13),
//                         ),
//                         child: const Text(
//                           'Decline',
//                           style: TextStyle(
//                               color: Color(0xFF8B0045),
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // I Agree
//                     Expanded(
//                       flex: 2,
//                       child: ElevatedButton(
//                         onPressed: isChecked ? widget.onAgreed : null,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: isChecked
//                               ? const Color(0xFF8B0045)
//                               : Colors.grey[300],
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                           padding:
//                               const EdgeInsets.symmetric(vertical: 13),
//                           elevation: isChecked ? 2 : 0,
//                         ),
//                         child: Text(
//                           'I Agree',
//                           style: TextStyle(
//                             color: isChecked
//                                 ? Colors.white
//                                 : Colors.grey[500],
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BLOCK WIDGET — renders each parsed HTML block
// // ─────────────────────────────────────────────────────────────────────────────

// class _BlockWidget extends StatelessWidget {
//   final _HtmlBlock block;

//   const _BlockWidget({required this.block});

//   @override
//   Widget build(BuildContext context) {
//     switch (block.type) {
//       case _BlockType.spacer:
//         return const SizedBox(height: 10);

//       case _BlockType.heading:
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 6, top: 4),
//           child: Text(
//             block.text,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//               height: 1.4,
//             ),
//           ),
//         );

//       case _BlockType.listItem:
//         return Padding(
//           padding: const EdgeInsets.only(left: 12, bottom: 4),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('• ',
//                   style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.bold)),
//               Expanded(
//                 child: Text(
//                   block.text.startsWith('• ')
//                       ? block.text.substring(2)
//                       : block.text,
//                   textAlign: TextAlign.left,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Colors.black87,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );

//       case _BlockType.paragraph:
//         // Check for red text (e.g. "Strict Prohibition...")
//         if (block.rawLine.contains('§RED§')) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 6),
//             child: Text(
//               block.text,
//               textAlign: TextAlign.left,
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Colors.red,
//                 fontWeight: FontWeight.w600,
//                 height: 1.5,
//               ),
//             ),
//           );
//         }

//         // Check for bold text (headings styled as paragraphs)
//         if (block.rawLine.contains('§BOLD§')) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 6, top: 4),
//             child: Text(
//               block.text,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//                 height: 1.5,
//               ),
//             ),
//           );
//         }

//         return Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: Text(
//             block.text,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Colors.black87,
//               height: 1.6,
//             ),
//           ),
//         );
//     }
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CONVENIENCE BUTTON WIDGET — drop this anywhere in your UI
// // ─────────────────────────────────────────────────────────────────────────────

// /// A ready-made "Terms & Conditions" link text you can place anywhere.
// /// Tapping it opens the sheet.
// ///
// /// Example:
// ///   TermsConditionsLink()
// class TermsConditionsLink extends StatelessWidget {
//   final void Function(bool agreed)? onResult;

//   const TermsConditionsLink({super.key, this.onResult});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         final result = await TermsConditionsSheet.show(context);
//         if (onResult != null) onResult!(result == true);
//       },
//       child: const Text(
//         'View Terms & Conditions',
//         style: TextStyle(
//           fontSize: 13,
//           color: Color(0xFF8B0045),
//           decoration: TextDecoration.underline,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }
