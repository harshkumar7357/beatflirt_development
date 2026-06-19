
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Api_services/api_service.dart';
import '../../core/services/auth_services.dart';

/// Single-file New Members screen for Beat Flirt Event.
///
/// Add dependency in pubspec.yaml:
///   dependencies:
///     http: ^1.2.2
///
/// Usage:
///   Navigator.push(
///     context,
///     MaterialPageRoute(builder: (_) => const NewMembersPage()),
///   );
///
/// Or as a route/page:
///   const NewMembersPage()
class NewMembersScreen extends StatefulWidget {
  const NewMembersScreen({super.key});

  @override
  State<NewMembersScreen> createState() => _NewMembersScreenState();
}

class _NewMembersScreenState extends State<NewMembersScreen> {
  final NewMembersApi _api = NewMembersApi();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  int _page = 1;
  int _totalCount = 0;
  bool _hasMore = true;

  FilterSortType _sortType = FilterSortType.latest;
  final Set<ProfileFilterType> _profileFilters = <ProfileFilterType>{};

  List<NewMember> _members = <NewMember>[];

  @override
  void initState() {
    super.initState();
    _fetchMembers(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _usernameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _isLoadingMore ||
        _isInitialLoading ||
        !_hasMore)
      return;
    final threshold = _scrollController.position.maxScrollExtent - 600;
    if (_scrollController.offset >= threshold) {
      _fetchMembers(reset: false);
    }
  }

  Future<void> _fetchMembers({required bool reset}) async {
    if (reset) {
      setState(() {
        _page = 1;
        _hasMore = true;
        _isInitialLoading = true;
        _error = null;
      });
    } else {
      setState(() => _isLoadingMore = true);
    }

    try {
      final result = await _api.getAllNewUsers(
        type: _sortType.apiValue,
        searchKeyword: _usernameController.text.trim(),
        locationKeyword: _locationController.text.trim(),
        lat: '0',
        lng: '0',
        distance: 100,
        page: _page,
        profileTypeArray: _profileFilters.map((e) => e.apiValue).toList(),
      );

      if (!mounted) return;

      setState(() {
        _totalCount = result.totalUserCount;
        if (reset) {
          _members = result.data;
        } else {
          _members = <NewMember>[..._members, ...result.data];
        }

        // API usually returns a page chunk. Stop if no data or all total loaded.
        _hasMore = result.data.isNotEmpty && _members.length < _totalCount;
        if (_hasMore) _page += 1;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // _error = e.toString().replaceFirst('Exception: ', '');
        _error = 'Check Your Internet Connection';
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refresh() => _fetchMembers(reset: true);

  Future<void> _openFilter() async {
    final result = await showDialog<_FilterDialogResult>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.20),
      builder: (context) => _FilterDialog(
        initialSortType: _sortType,
        initialProfileFilters: _profileFilters,
        initialUsername: _usernameController.text,
        initialLocation: _locationController.text,
      ),
    );

    if (result == null) return;

    setState(() {
      _sortType = result.sortType;
      _profileFilters
        ..clear()
        ..addAll(result.profileFilters);
      _usernameController.text = result.username;
      _locationController.text = result.location;
    });

    await _fetchMembers(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title:_buildHeader(context),
        title: Text('New Members (${_totalCount == 0 ? 70 : _totalCount})',style: TextStyle(fontSize: 22,),),
        backgroundColor: const Color(0xFFFFF4FA),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFFF4FA),
      body: SafeArea(
        child: RefreshIndicator(
          color: _AppColors.hotPink,
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // SliverToBoxAdapter(child: _buildHeader(context)),
              if (_isInitialLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: _AppColors.hotPink),
                  ),
                )
              else if (_error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorState(
                    message: _error!,
                    onRetry: () => _fetchMembers(reset: true),
                  ),
                )
              else if (_members.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(onReset: _resetFiltersAndFetch),
                )
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final columns = _columnsForWidth(width);
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 38,
                          crossAxisSpacing: 24,
                          childAspectRatio: _cardAspectRatio(width, columns),
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              NewMemberCard(member: _members[index]),
                          childCount: _members.length,
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 28),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: _AppColors.hotPink,
                              ),
                            ),
                          )
                        : const SizedBox(height: 18),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final activeFilters =
        _profileFilters.length +
        (_usernameController.text.trim().isNotEmpty ? 1 : 0) +
        (_locationController.text.trim().isNotEmpty ? 1 : 0) +
        (_sortType == FilterSortType.all ? 1 : 0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 28, 26, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'New Members (${_totalCount == 0 ? 70 : _totalCount})',
              style: TextStyle(
                color: _AppColors.deepPurple,
                fontSize: MediaQuery.of(context).size.width < 420 ? 30 : 38,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'Filter',
                onPressed: _openFilter,
                icon: const Icon(
                  Icons.tune_rounded,
                  color: _AppColors.deepPurple,
                  size: 34,
                ),
              ),
              if (activeFilters > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: _AppColors.hotPink,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$activeFilters',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  int _columnsForWidth(double width) {
    if (width >= 1180) return 4;
    if (width >= 850) return 3;
    if (width >= 560) return 2;
    return 1;
  }

  double _cardAspectRatio(double width, int columns) {
    final cardWidth = (width - (columns - 1) * 24) / columns;
    // Taller on smaller screens, similar to the screenshots.
    if (cardWidth < 330) return 0.67;
    if (cardWidth < 390) return 0.72;
    return 0.76;
  }

  Future<void> _resetFiltersAndFetch() async {
    setState(() {
      _sortType = FilterSortType.latest;
      _profileFilters.clear();
      _usernameController.clear();
      _locationController.clear();
    });
    await _fetchMembers(reset: true);
  }
}

// class NewMemberCard extends StatelessWidget {
//   const NewMemberCard({super.key, required this.member});

//   final NewMember member;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final imageSize = (constraints.maxWidth * 0.34).clamp(92.0, 126.0);
//         return Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.topCenter,
//           children: [
//             Positioned.fill(
//               top: imageSize * 0.48,
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [_AppColors.cardTop, _AppColors.cardMid, _AppColors.cardBottom],
//                   ),
//                   borderRadius: BorderRadius.circular(18),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.22),
//                       blurRadius: 24,
//                       offset: const Offset(0, 12),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(20, imageSize * 0.47, 20, 16),
//                   child: Column(
//                     children: [
//                       Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(text: member.username),
//                             const TextSpan(text: ' '),
//                             const TextSpan(
//                               text: '💗',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                           ],
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.w900,
//                           height: 1.0,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       _AgePill(member: member),
//                       const SizedBox(height: 24),
//                       _InsightBox(text: member.aiInsight),
//                       const SizedBox(height: 18),
//                       if (member.showGender)
//                         Text(
//                           member.genderProfileType,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
//                         ),
//                       const SizedBox(height: 14),
//                       if (member.showLocation)
//                         _LocationText(member: member),
//                       const Spacer(),
//                       _StatsRow(member: member),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 0,
//               child: Container(
//                 width: imageSize,
//                 height: imageSize,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: _AppColors.hotPink, width: 4),
//                   boxShadow: [
//                     BoxShadow(color: _AppColors.hotPink.withOpacity(0.25), blurRadius: 16),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: _ProfileImage(member: member),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: imageSize * 0.62,
//               left: 16,
//               child: _MatchBadge(score: member.aiMatchScore),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.member});

  final NewMember member;

  @override
  Widget build(BuildContext context) {
    if (member.imageUrl.isEmpty || !member.showProfileImage) {
      return _ImageFallback(member: member);
    }
    return Image.network(
      member.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.white.withOpacity(0.12),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _AppColors.hotPink,
              ),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _ImageFallback(member: member),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.member});

  final NewMember member;

  @override
  Widget build(BuildContext context) {
    final isCouple = member.profileType.toLowerCase() == 'couple';
    final icon = isCouple
        ? Icons.diversity_1_rounded
        : member.genderProfileType.toLowerCase().contains('female')
        ? Icons.woman_rounded
        : Icons.man_rounded;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_AppColors.cardTop, _AppColors.hotPink],
        ),
      ),
      child: Icon(icon, color: Colors.white, size: 48),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge({required this.score});

  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 165),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [_AppColors.hotPink, _AppColors.purpleBadge],
        ),
        boxShadow: [
          BoxShadow(
            color: _AppColors.hotPink.withOpacity(0.38),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flash_on_rounded, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              '${_formatScore(score)} Match',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatScore(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) return value;
    return '${parsed.toStringAsFixed(1)}%';
  }
}
// class _MatchBadge extends StatelessWidget {
//   const _MatchBadge({required this.score});

//   final String score;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(26),
//         gradient: const LinearGradient(colors: [_AppColors.hotPink, _AppColors.purpleBadge]),
//         boxShadow: [
//           BoxShadow(color: _AppColors.hotPink.withOpacity(0.45), blurRadius: 18, offset: const Offset(0, 7)),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
//           const SizedBox(width: 6),
//           Text(
//             '${_formatScore(score)} Match',
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

//   static String _formatScore(String value) {
//     final parsed = double.tryParse(value);
//     if (parsed == null) return value;
//     return '${parsed.toStringAsFixed(1)}%';
//   }
// }

class _AgePill extends StatelessWidget {
  const _AgePill({required this.member});

  final NewMember member;

  @override
  Widget build(BuildContext context) {
    if (!member.showAge) return const SizedBox.shrink();
    final ageText = member.age2Text.isNotEmpty
        ? 'Age ${member.ageText} | ${member.age2Text}'
        : 'Age ${member.ageText}';
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _AppColors.hotPink,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        ageText,
        // style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

class NewMemberCard extends StatelessWidget {
  const NewMemberCard({super.key, required this.member});

  final NewMember member;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // This stops system font size from making the card huge.
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;

          final imageSize = cardWidth < 380 ? 96.0 : 108.0;
          final cardTopOffset = imageSize * 0.52;
          final contentTopPadding = imageSize * 0.76;

          final horizontalPadding = cardWidth < 380 ? 18.0 : 20.0;
          final usernameFont = cardWidth < 380 ? 20.0 : 22.0;

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                top: cardTopOffset,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _AppColors.cardTop,
                        _AppColors.cardMid,
                        _AppColors.cardBottom,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      contentTopPadding,
                      horizontalPadding,
                      14,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: member.username),
                                  const TextSpan(text: ' '),
                                  const TextSpan(
                                    text: '💗',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: usernameFont,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        _AgePill(member: member),

                        const SizedBox(height: 16),

                        _InsightBox(text: member.aiInsight),

                        const SizedBox(height: 12),

                        if (member.showGender)
                          Text(
                            member.genderProfileType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                        const SizedBox(height: 10),

                        if (member.showLocation) _LocationText(member: member),

                        const Spacer(),

                        _StatsRow(member: member),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 0,
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _AppColors.hotPink, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _AppColors.hotPink.withOpacity(0.25),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: _ProfileImage(member: member),
                  ),
                ),
              ),

              Positioned(
                top: imageSize * 0.68,
                left: 18,
                child: _MatchBadge(score: member.aiMatchScore),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_rounded, color: _AppColors.hotPink, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.isEmpty ? 'Compatible with your profile vibe.' : text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _AppColors.hotPink,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationText extends StatelessWidget {
  const _LocationText({required this.member});

  final NewMember member;

  @override
  Widget build(BuildContext context) {
    final address = member.formattedAddress.isNotEmpty
        ? member.formattedAddress
        : member.cityName;
    final distance = member.totalDistance > 0
        ? ' | ${member.totalDistance} ${member.distanceUnit}'
        : '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: Colors.white, size: 22),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$address$distance',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.member});

  final NewMember member;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.96,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StatItem(
            icon: Icons.photo_camera_outlined,
            value: member.imageCount,
          ),
          _StatItem(
            icon: Icons.favorite_border_rounded,
            value: member.likesCount,
          ),
          _StatItem(
            icon: Icons.person_outline_rounded,
            value: member.friendsCount,
          ),
          _StatItem(
            icon: Icons.verified_outlined,
            value: member.validationCount,
          ),
          _StatItem(
            icon: Icons.play_circle_outline_rounded,
            value: member.videoCount,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.value});

  final IconData icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(height: 5),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDialog extends StatefulWidget {
  const _FilterDialog({
    required this.initialSortType,
    required this.initialProfileFilters,
    required this.initialUsername,
    required this.initialLocation,
  });

  final FilterSortType initialSortType;
  final Set<ProfileFilterType> initialProfileFilters;
  final String initialUsername;
  final String initialLocation;

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late FilterSortType _sortType;
  late Set<ProfileFilterType> _profileFilters;
  late TextEditingController _usernameController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _sortType = widget.initialSortType;
    _profileFilters = <ProfileFilterType>{...widget.initialProfileFilters};
    _usernameController = TextEditingController(text: widget.initialUsername);
    _locationController = TextEditingController(text: widget.initialLocation);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    // Many Android phones are 393/411 logical pixels wide, so use a higher
    // compact breakpoint. This keeps the popup small instead of oversized.
    // final isSmallPhone = screen.width < 430;
    final isSmallPhone = screen.width < 500;
    // final dialogWidth = screen.width < 640 ? screen.width - (isSmallPhone ? 48 : 42) : 560.0;
    final dialogWidth = screen.width < 640 ? screen.width - 72 : 520.0;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        // horizontal: isSmallPhone ? 12 : 18,
        // vertical: isSmallPhone ? 12 : 28,
        horizontal: 20,
        vertical: 20,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // maxHeight: screen.height * 0.70,
          maxHeight: screen.height * 0.62,
          maxWidth: dialogWidth,
        ),
        child: Container(
          width: dialogWidth,
          margin: EdgeInsets.only(top: isSmallPhone ? 8 : 24),
          padding: EdgeInsets.fromLTRB(
            isSmallPhone ? 18 : 32,
            isSmallPhone ? 18 : 28,
            isSmallPhone ? 18 : 32,
            isSmallPhone ? 18 : 32,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _AppColors.cardTop,
                _AppColors.cardMid,
                _AppColors.cardBottom,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RadioTile(
                  label: 'Latest',
                  selected: _sortType == FilterSortType.latest,
                  onTap: () =>
                      setState(() => _sortType = FilterSortType.latest),
                ),
                SizedBox(height: isSmallPhone ? 12 : 18),
                _RadioTile(
                  label: 'All',
                  selected: _sortType == FilterSortType.all,
                  onTap: () => setState(() => _sortType = FilterSortType.all),
                ),
                SizedBox(height: isSmallPhone ? 16 : 26),
                Divider(color: Colors.white.withOpacity(0.45), thickness: 1.1),
                SizedBox(height: isSmallPhone ? 10 : 16),
                ...ProfileFilterType.values.map(
                  (type) => Padding(
                    padding: EdgeInsets.only(bottom: isSmallPhone ? 11 : 16),
                    child: _CheckboxTile(
                      label: type.label,
                      dotColor: type.dotColor,
                      selected: _profileFilters.contains(type),
                      onTap: () {
                        setState(() {
                          if (_profileFilters.contains(type)) {
                            _profileFilters.remove(type);
                          } else {
                            _profileFilters.add(type);
                          }
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: isSmallPhone ? 2 : 4),
                _SearchField(
                  controller: _usernameController,
                  hint: 'Search Username...',
                ),
                SizedBox(height: isSmallPhone ? 10 : 16),
                _SearchField(
                  controller: _locationController,
                  hint: 'Search Location...',
                ),
                SizedBox(height: isSmallPhone ? 10 : 16),
                Row(
                  children: [
                    Expanded(
                      child: _DialogButton(
                        label: 'Find',
                        filled: true,
                        onTap: () {
                          Navigator.of(context).pop(
                            _FilterDialogResult(
                              sortType: _sortType,
                              profileFilters: _profileFilters,
                              username: _usernameController.text.trim(),
                              location: _locationController.text.trim(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: isSmallPhone ? 10 : 16),
                    Expanded(
                      child: _DialogButton(
                        label: 'Reset',
                        filled: false,
                        onTap: () {
                          Navigator.of(context).pop(
                            _FilterDialogResult(
                              sortType: FilterSortType.latest,
                              profileFilters: const <ProfileFilterType>{},
                              username: '',
                              location: '',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  const _RadioTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 390;
    final controlSize = compact ? 20.0 : 26.0;
    final innerSize = compact ? 10.0 : 14.0;
    final fontSize = compact ? 20.0 : 25.0;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: controlSize,
            height: controlSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: innerSize,
                      height: innerSize,
                      decoration: const BoxDecoration(
                        color: Color(0xFF69706F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: compact ? 10 : 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  const _CheckboxTile({
    required this.label,
    required this.dotColor,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color dotColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 390;
    final controlSize = compact ? 20.0 : 26.0;
    final fontSize = compact ? 20.0 : 24.0;
    final dotSize = compact ? 16.0 : 20.0;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: controlSize,
            height: controlSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: selected
                ? Icon(
                    Icons.check_rounded,
                    color: _AppColors.cardBottom,
                    size: compact ? 16 : 20,
                  )
                : null,
          ),
          SizedBox(width: compact ? 10 : 12),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: compact ? 8 : 10),
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 390;
    final fieldFontSize = compact ? 18.0 : 22.0;

    return TextField(
      controller: controller,
      style: TextStyle(
        color: Colors.black87,
        fontSize: fieldFontSize,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.55),
          fontSize: fieldFontSize,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: compact ? 11 : 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) {
        // Pressing keyboard search does not close dialog automatically; use Find button.
      },
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 390;

    return SizedBox(
      height: compact ? 56 : 82,
      child: Material(
        color: filled ? Colors.white : Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: filled ? null : Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: filled ? Colors.black : Colors.white,
                fontSize: compact ? 23 : 29,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: _AppColors.hotPink,
              size: 54,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _AppColors.deepPurple,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: _AppColors.hotPink,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people_outline_rounded,
              color: _AppColors.hotPink,
              size: 58,
            ),
            const SizedBox(height: 12),
            const Text(
              'No members found',
              style: TextStyle(
                color: _AppColors.deepPurple,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try changing or resetting your filters.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onReset,
              child: const Text('Reset filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewMembersApi {
  static const String endpoint =
      'https://app.beatflirtevent.com/App/online/get_all_new_user';

  Future<NewMembersResponse> getAllNewUsers({
    required String type,
    required String searchKeyword,
    required String lat,
    required String lng,
    required int distance,
    required int page,
    required List<String> profileTypeArray,
    String locationKeyword = '',
  }) async {
    // The provided API payload has search_keyword only. To make location search work
    // from the same API, this sends username first, then location if username is empty.
    // If your backend supports a separate key such as `location`, keep the extra field below.
    final keyword = searchKeyword.isNotEmpty ? searchKeyword : locationKeyword;

    final token = await AuthService.getToken();

    final payload = <String, dynamic>{
      'type': type,
      'search_keyword': keyword,
      'lat': lat,
      'lng': lng,
      'distance': distance,
      'page': page,
      'profileTypeArray': profileTypeArray,
      if (locationKeyword.isNotEmpty) 'location': locationKeyword,
      if (token != null) 'token': token,
    };

    final headers = ApiService.buildAuthHeaders(token: token);
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Server error ${response.statusCode}. Please try again.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid server response.');
    }

    final apiStatus = decoded['status']?.toString();
    if (apiStatus != null && apiStatus != '200') {
      throw Exception(
        decoded['message']?.toString() ?? 'Unable to load members.',
      );
    }

    return NewMembersResponse.fromJson(decoded);
  }
}

class NewMembersResponse {
  const NewMembersResponse({
    required this.status,
    required this.totalUserCount,
    required this.data,
  });

  final String status;
  final int totalUserCount;
  final List<NewMember> data;

  factory NewMembersResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return NewMembersResponse(
      status: json['status']?.toString() ?? '',
      totalUserCount: _toInt(json['total_user_count']),
      data: rawData is List
          ? rawData
                .whereType<Map>()
                .map((e) => NewMember.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <NewMember>[],
    );
  }
}

class NewMember {
  const NewMember({
    required this.id,
    required this.email,
    required this.username,
    required this.profileType,
    required this.genderProfileType,
    required this.cityName,
    required this.showAge,
    required this.showLocation,
    required this.showGender,
    required this.showOnlineStatus,
    required this.lastLogin,
    required this.totalDistance,
    required this.distanceUnit,
    required this.aiMatchScore,
    required this.aiInsight,
    required this.formattedAddress,
    required this.images,
    required this.videoCount,
    required this.ageText,
    required this.age2Text,
    required this.friendsCount,
    required this.likesCount,
    required this.validationCount,
  });

  final String id;
  final String email;
  final String username;
  final String profileType;
  final String genderProfileType;
  final String cityName;
  final bool showAge;
  final bool showLocation;
  final bool showGender;
  final bool showOnlineStatus;
  final String lastLogin;
  final int totalDistance;
  final String distanceUnit;
  final String aiMatchScore;
  final String aiInsight;
  final String formattedAddress;
  final List<MemberImage> images;
  final int videoCount;
  final String ageText;
  final String age2Text;
  final int friendsCount;
  final int likesCount;
  final int validationCount;

  String get imageUrl {
    if (images.isEmpty) return '';
    final first = images.first;
    if (first.showProfileImage && first.profileImage.isNotEmpty)
      return first.profileImage;
    return first.dummyProfileImage;
  }

  bool get showProfileImage =>
      images.isEmpty ? true : images.first.showProfileImage;

  int get imageCount =>
      images.where((e) => e.profileImage.isNotEmpty && e.status == '1').length;

  factory NewMember.fromJson(Map<String, dynamic> json) {
    final rawImages = json['image'];
    final rawVideos = json['video'];
    return NewMember(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? 'Unknown',
      profileType: json['profile_type']?.toString() ?? '',
      genderProfileType: json['gender_profile_type']?.toString() ?? '',
      cityName: json['city_name']?.toString() ?? '',
      showAge: _toBool(json['show_age'], defaultValue: true),
      showLocation: _toBool(json['show_location'], defaultValue: true),
      showGender: _toBool(json['show_gender'], defaultValue: true),
      showOnlineStatus: _toBool(
        json['show_online_status'],
        defaultValue: false,
      ),
      lastLogin: json['last_login']?.toString() ?? '',
      totalDistance: _toInt(json['total_distance']),
      distanceUnit: json['distance']?.toString() ?? 'km',
      aiMatchScore: json['ai_match_score']?.toString() ?? '0',
      aiInsight: json['ai_insight']?.toString() ?? '',
      formattedAddress: json['formatted_address']?.toString() ?? '',
      images: rawImages is List
          ? rawImages
                .whereType<Map>()
                .map((e) => MemberImage.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <MemberImage>[],
      videoCount: rawVideos is List ? rawVideos.length : 0,
      ageText: json['age']?.toString() ?? '',
      age2Text: json['age2']?.toString() ?? '',
      friendsCount: _toInt(json['friends_count']),
      likesCount: _toInt(json['likes_count']),
      validationCount: _toInt(json['validation_count']),
    );
  }
}

class MemberImage {
  const MemberImage({
    required this.profileImage,
    required this.status,
    required this.dummyProfileImage,
    required this.showProfileImage,
  });

  final String profileImage;
  final String status;
  final String dummyProfileImage;
  final bool showProfileImage;

  factory MemberImage.fromJson(Map<String, dynamic> json) {
    return MemberImage(
      profileImage: json['profile_image']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      dummyProfileImage: json['dummy_profile_image']?.toString() ?? '',
      showProfileImage: _toBool(json['show_profile_image'], defaultValue: true),
    );
  }
}

enum FilterSortType {
  latest('latest'),
  all('all');

  const FilterSortType(this.apiValue);
  final String apiValue;
}

enum ProfileFilterType {
  couples('Couples', 'couple', Color(0xFF52B6DD)),
  females('Females', 'Female', Color(0xFFFF6DB2)),
  males('Males', 'Male', Color(0xFF25B9D9)),
  transgenders('Transgenders', 'Transgender', Color(0xFF5BB3D9));

  const ProfileFilterType(this.label, this.apiValue, this.dotColor);
  final String label;
  final String apiValue;
  final Color dotColor;
}

class _FilterDialogResult {
  const _FilterDialogResult({
    required this.sortType,
    required this.profileFilters,
    required this.username,
    required this.location,
  });

  final FilterSortType sortType;
  final Set<ProfileFilterType> profileFilters;
  final String username;
  final String location;
}

class _AppColors {
  static const Color deepPurple = Color(0xFF1D0030);
  static const Color cardTop = Color(0xFF76002F);
  static const Color cardMid = Color(0xFF360026);
  static const Color cardBottom = Color(0xFF050028);
  static const Color hotPink = Color(0xFFFF147D);
  static const Color purpleBadge = Color(0xFF6F22E7);
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.toInt() ??
      0;
}

bool _toBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  final stringValue = value.toString().toLowerCase().trim();
  if (stringValue == '1' || stringValue == 'true' || stringValue == 'yes')
    return true;
  if (stringValue == '0' || stringValue == 'false' || stringValue == 'no')
    return false;
  return defaultValue;
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/providers/user_list_provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:beatflirt/Api_services/api_service.dart';

// import '../../Api_services/api_services.dart';

// class NewMemberPage extends ConsumerWidget {
//   const NewMemberPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(userListProvider('new_members'));

//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F1A), // AAA Premium Dark Background
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           _buildAppBar(context),
//           _buildHeroSection(),
//           _buildSectionHeader('Spotlight Arrivals', 'See who just landed'),
//           _buildSpotlightList(state.users),
//           _buildSectionHeader('Fresh Faces', 'Explore our newest community members'),
//           _buildMembersGrid(state.users),
//           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 0,
//       floating: true,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: const Color(0xFF0F0F1A),
//       surfaceTintColor: Colors.transparent,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//         onPressed: () => Navigator.pop(context),
//       ),
//       centerTitle: true,
//       title: const Text(
//         'NEW MEMBERS',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w900,
//           fontSize: 16,
//           letterSpacing: 2.0,
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {},
//           icon: const FaIcon(FontAwesomeIcons.sliders, color: Colors.pinkAccent, size: 18),
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }

//   Widget _buildHeroSection() {
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         height: 160,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFF1E56), Color(0xFF0F0F1A)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFFF1E56).withValues(alpha: 0.2),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               right: -20,
//               bottom: -20,
//               child: Opacity(
//                 opacity: 0.1,
//                 child: FaIcon(FontAwesomeIcons.userPlus, size: 150, color: Colors.white),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'The Welcome\nCommittee',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 26,
//                       fontWeight: FontWeight.w900,
//                       height: 1.1,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Be the first to say hello!',
//                     style: TextStyle(
//                       color: Colors.white.withValues(alpha: 0.7),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, String subtitle) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.5),
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSpotlightList(List<UserListItem> users) {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: 120,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.only(left: 20),
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//             return Container(
//               margin: const EdgeInsets.only(right: 20),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.pinkAccent, width: 2),
//                     ),
//                     child: ClipOval(
//                       child: _buildImage(
//                         user.imageUrl,
//                         height: 70,
//                         width: 70,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     user.name.split(' ')[0],
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildMembersGrid(List<UserListItem> users) {
//     if (users.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 20,
//           crossAxisSpacing: 15,
//           childAspectRatio: 0.7,
//         ),
//         delegate: SliverChildBuilderDelegate(
//           (context, index) {
//             final user = users[index % users.length];
//             return _buildMemberCard(user);
//           },
//           childCount: users.length < 10 ? users.length : 10,
//         ),
//       ),
//     );
//   }

//   Widget _buildImage(String path, {double? height, double? width, BoxFit fit = BoxFit.cover}) {
//     if (path.startsWith('http') || path.startsWith('https')) {
//       return Image.network(
//         path,
//         height: height,
//         width: width,
//         fit: fit,
//         errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width),
//       );
//     } else if (path.contains('uploads/')) {
//       final baseUrl = ApiServices.baseUrl;
//       return Image.network(
//         '$baseUrl/$path',
//         height: height,
//         width: width,
//         fit: fit,
//         errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width),
//       );
//     } else {
//       return Image.asset(
//         path,
//         height: height,
//         width: width,
//         fit: fit,
//         errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width),
//       );
//     }
//   }

//   Widget _buildPlaceholder(double? height, double? width) {
//     return Container(
//       height: height,
//       width: width,
//       color: Colors.grey[900],
//       child: const Icon(Icons.person, color: Colors.white24),
//     );
//   }

//   Widget _buildMemberCard(UserListItem user) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(25),
//         child: Column(
//           children: [
//             Expanded(
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   _buildImage(user.imageUrl),
//                   Positioned(
//                     top: 10,
//                     right: 10,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.pinkAccent,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Text(
//                         'NEW',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 9,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withValues(alpha: 0.8),
//                           ],
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.circle, color: Colors.green, size: 8),
//                           const SizedBox(width: 5),
//                           Expanded(
//                             child: Text(
//                               user.isOnline ? 'Online' : user.lastSeen,
//                               style: const TextStyle(color: Colors.white70, fontSize: 10),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     user.name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 32,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFFFF1E56), Color(0xFFFFACAC)],
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'Say Hi',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         height: 32,
//                         width: 32,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(Icons.favorite_border, color: Colors.pinkAccent, size: 18),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
