// import 'package:flutter/material.dart';
//
// // Model class for card data
// class CardData {
//   final String imageUrl;
//   final String title;
//   final String description;
//
//   const CardData({
//     required this.imageUrl,
//     required this.title,
//     required this.description,
//   });
//
//   factory CardData.fromJson(Map<String, dynamic> json) {
//     return CardData(
//       imageUrl: (json['imageUrl'] ?? '').toString(),
//       title: (json['title'] ?? '').toString(),
//       description: (json['description'] ?? '').toString(),
//     );
//   }
// }
//
// const List<CardData> appCardsData = [
//   CardData(
//     imageUrl: 'assets/images/notification-image1.jpg',
//     title: 'The Thunder Party',
//     description:
//         '''Get ready for a night of great music, vibrant energy, and an atmosphere designed for unforgettable moments.
// From the first beat to the last drink, this party brings together a lively crowd, curated sounds, and a setting made for letting go and enjoying the night.
//
// Tonight’s party is all about good vibes and even better company.
// A dynamic mix of music, drinks, and social energy sets the tone for a night where conversations flow and memories are made.
// Come dressed to impress and enjoy the experience.''',
//   ),
//
//
//   CardData(
//     imageUrl: 'assets/images/notification-image2.jpg',
//     title: 'The Full Night Party',
//     description:
//         '''Tonight’s Swingers Party is a private, adults-only social event designed for open-minded guests who value respect and discretion.
// Set within a relaxed and welcoming atmosphere, the party focuses on connection, conversation, and shared experiences, allowing everyone to engage at their own comfort level.
//
// This is an exclusive social party for adults seeking a different kind of nightlife experience.
// A balance of elegance, openness, and clear boundaries creates a space where guests can socialize freely and enjoy the evening without pressure.''',
//   ),
//
//
//   CardData(
//     imageUrl: 'assets/images/notification-image3.jpg',
//     title: 'The Party Night',
//     description:
//         '''Tonight’s party is all about good vibes and even better company.
// A dynamic mix of music, drinks, and social energy sets the tone for a night where conversations flow and memories are made.
// Come dressed to impress and enjoy the experience.
// Get ready for a night of great music, vibrant energy, and an atmosphere designed for unforgettable moments.
// From the first beat to the last drink, this party brings together a lively crowd, curated sounds, and a setting made for letting go and enjoying the night.''',
//   ),
//
//
//   CardData(
//     imageUrl: 'assets/images/notification-image4.jpg',
//     title: 'Noir Desire Night',
//     description:
//        '''A modern dating experience designed for people who prefer meeting in person.
// Relaxed conversations, a refined atmosphere, and an open-minded community come together for an engaging night.
// Because the best connections still happen face to face.
// A modern dating experience designed for people who prefer meeting in person.
// Relaxed conversations, a refined atmosphere, and an open-minded community come together for an engaging night.
// Because the best connections still happen face to face.''',
//   ),
//
//
//   CardData(
//     imageUrl: 'assets/images/notification-image5.jpg',
//     title: 'After Dark Soirée',
//     description:
//         '''Step into a thoughtfully curated dating evening created for meaningful conversations and real connections.
// Enjoy a relaxed, welcoming atmosphere where singles and couples can meet naturally, without pressure or distractions.
// With the right mix of music, ambiance, and social energy, the night is designed to let chemistry unfold on its own.''',
//   ),
//
//
//   CardData(
//     imageUrl: 'assets/images/notification-image6.jpg',
//     title: 'The Open Desire Party',
//     description:
//         '''An adults-only social evening created for open-minded guests.
// A relaxed atmosphere, great music, and a respectful community come together for a night of connection and curiosity.
// Consent, privacy, and comfort are always valued.
// Enjoy drinks, music, and meaningful interactions at your own pace.
// Come for the vibe, stay for the experience.''',
//   ),
//
//
//   CardData(
//     imageUrl: 'assets/images/notification-image7.jpg',
//     title: 'Velvet Nights',
//     description:
//         '''Join us tonight for an exclusive after-dark experience designed for open-minded couples and singles.
// Enjoy a sophisticated atmosphere, curated music, premium drinks, and a space to connect freely and respectfully.
// Discretion, consent, and comfort are our top priorities.
// Doors open tonight — step into an unforgettable night of connection and chemistry''',
//   ),
//
//
//   CardData(
//     imageUrl: 'assets/images/notification-image8.jpg',
//     title: 'New Dating Event Alert',
//     description:
//         '''We’re excited to announce a special event on our dating platform designed to help you connect with new and interesting people. This event gives you the opportunity to discover curated profiles, start meaningful conversations, and explore potential matches in a fun and engaging environment.
//
// Whether you’re looking for a genuine connection or simply want to meet someone new, this event is the perfect chance to take your dating journey to the next level. Enjoy real-time interactions, better compatibility insights, and a more personalized experience.
//
// Open the app to view full event details and be part of this exciting experience.''',
//   ),
// ];
//
// class CardListScreen extends StatelessWidget {
//   const CardListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Card List'),
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: appCardsData.length,
//         itemBuilder: (context, index) {
//           return CustomCard(
//             cardData: appCardsData[index],
//             onSeeMore: () {
//               // Handle see more action
//               debugPrint('See more clicked for ${appCardsData[index].title}');
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// // Reusable Card Widget
// class CustomCard extends StatefulWidget {
//   final CardData cardData;
//   final VoidCallback? onSeeMore;
//
//   const CustomCard({
//     super.key,
//     required this.cardData,
//     this.onSeeMore,
//   });
//
//   @override
//   State<CustomCard> createState() => _CustomCardState();
// }
//
// class _CustomCardState extends State<CustomCard> {
//   bool _isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: _buildImage(),
//             ),
//             const SizedBox(height: 12),
//
//             // Title
//             Text(
//               widget.cardData.title,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//
//             // Description
//             Text(
//               widget.cardData.description,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[700],
//               ),
//               maxLines: _isExpanded ? null : 3,
//               overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 12),
//
//             // See More Button
//             Align(
//               alignment: Alignment.centerRight,
//               child: FilledButton(
//                 onPressed: () {
//                   setState(() {
//                     _isExpanded = !_isExpanded;
//                   });
//                   widget.onSeeMore?.call();
//                 },
//                 style: FilledButton.styleFrom(
//                   backgroundColor: Colors.black87,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(_isExpanded ? 'See Less' : 'See More'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     );
//   }
//
//   /// Supports:
//   /// - Local: `assets/...`, `asset/...`, `package:.../assets/...`
//   /// - Remote: `http://...`, `https://...`, or any string that parses as http(s) URI
//   /// Empty / invalid / load failures show a neutral placeholder (no error UI).
//   Widget _buildImage() {
//     const double h = 200;
//     final String raw = widget.cardData.imageUrl.trim();
//     if (raw.isEmpty) {
//       return _neutralImagePlaceholder(height: h);
//     }
//
//     final String lower = raw.toLowerCase();
//
//     if (lower.startsWith('assets/') ||
//         lower.startsWith('asset/') ||
//         lower.startsWith('package:')) {
//       return Image.asset(
//         raw,
//         height: h,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         gaplessPlayback: true,
//         errorBuilder: (context, error, stackTrace) =>
//             _neutralImagePlaceholder(height: h),
//       );
//     }
//
//     final Uri? uri = Uri.tryParse(raw);
//     if (uri != null &&
//         uri.hasScheme &&
//         (uri.scheme == 'http' || uri.scheme == 'https')) {
//       return Image.network(
//         uri.toString(),
//         height: h,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         gaplessPlayback: true,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Container(
//             height: h,
//             color: Colors.grey[200],
//             alignment: Alignment.center,
//             child: const SizedBox(
//               width: 28,
//               height: 28,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             ),
//           );
//         },
//         errorBuilder: (context, error, stackTrace) =>
//             _neutralImagePlaceholder(height: h),
//       );
//     }
//
//     // Ambiguous path: try asset first (many apps pass paths without `assets/` prefix
//     // only if declared in pubspec), then fall back to nothing scary.
//     if (!raw.contains('://')) {
//       return Image.asset(
//         raw,
//         height: h,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         gaplessPlayback: true,
//         errorBuilder: (context, error, stackTrace) =>
//             _neutralImagePlaceholder(height: h),
//       );
//     }
//
//     return _neutralImagePlaceholder(height: h);
//   }
//
//   static Widget _neutralImagePlaceholder({required double height}) {
//     return Container(
//       height: height,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.grey[200]!,
//             Colors.grey[300]!,
//           ],
//         ),
//       ),
//       alignment: Alignment.center,
//       child: Icon(
//         Icons.image_outlined,
//         size: 48,
//         color: Colors.grey[500],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/card_providers.dart';

// Model class for card data
class CardData {
  final String imageUrl;
  final String title;
  final String description;

  const CardData({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      imageUrl: (json['imageUrl'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
    );
  }
}

const List<CardData> appCardsData = [
  CardData(
    imageUrl: 'assets/images/notification-image1.jpg',
    title: 'The Thunder Party',
    description:
    '''Get ready for a night of great music, vibrant energy, and an atmosphere designed for unforgettable moments.
From the first beat to the last drink, this party brings together a lively crowd, curated sounds, and a setting made for letting go and enjoying the night.

Tonight's party is all about good vibes and even better company.
A dynamic mix of music, drinks, and social energy sets the tone for a night where conversations flow and memories are made.
Come dressed to impress and enjoy the experience.''',
  ),

  CardData(
    imageUrl: 'assets/images/notification-image2.jpg',
    title: 'The Full Night Party',
    description:
    '''Tonight's Swingers Party is a private, adults-only social event designed for open-minded guests who value respect and discretion.
Set within a relaxed and welcoming atmosphere, the party focuses on connection, conversation, and shared experiences, allowing everyone to engage at their own comfort level.

This is an exclusive social party for adults seeking a different kind of nightlife experience.
A balance of elegance, openness, and clear boundaries creates a space where guests can socialize freely and enjoy the evening without pressure.''',
  ),

  CardData(
    imageUrl: 'assets/images/notification-image3.jpg',
    title: 'The Party Night',
    description:
    '''Tonight's party is all about good vibes and even better company.
A dynamic mix of music, drinks, and social energy sets the tone for a night where conversations flow and memories are made.
Come dressed to impress and enjoy the experience.
Get ready for a night of great music, vibrant energy, and an atmosphere designed for unforgettable moments.
From the first beat to the last drink, this party brings together a lively crowd, curated sounds, and a setting made for letting go and enjoying the night.''',
  ),

  CardData(
    imageUrl: 'assets/images/notification-image4.jpg',
    title: 'Noir Desire Night',
    description:
    '''A modern dating experience designed for people who prefer meeting in person.
Relaxed conversations, a refined atmosphere, and an open-minded community come together for an engaging night.
Because the best connections still happen face to face.
A modern dating experience designed for people who prefer meeting in person.
Relaxed conversations, a refined atmosphere, and an open-minded community come together for an engaging night.
Because the best connections still happen face to face.''',
  ),

  CardData(
    imageUrl: 'assets/images/notification-image5.jpg',
    title: 'After Dark Soirée',
    description:
    '''Step into a thoughtfully curated dating evening created for meaningful conversations and real connections.
Enjoy a relaxed, welcoming atmosphere where singles and couples can meet naturally, without pressure or distractions.
With the right mix of music, ambiance, and social energy, the night is designed to let chemistry unfold on its own.''',
  ),

  CardData(
    imageUrl: 'assets/images/notification-image6.jpg',
    title: 'The Open Desire Party',
    description:
    '''An adults-only social evening created for open-minded guests.
A relaxed atmosphere, great music, and a respectful community come together for a night of connection and curiosity.
Consent, privacy, and comfort are always valued.
Enjoy drinks, music, and meaningful interactions at your own pace.
Come for the vibe, stay for the experience.''',
  ),

  CardData(
    imageUrl: 'assets/images/notification-image7.jpg',
    title: 'Velvet Nights',
    description:
    '''Join us tonight for an exclusive after-dark experience designed for open-minded couples and singles.
Enjoy a sophisticated atmosphere, curated music, premium drinks, and a space to connect freely and respectfully.
Discretion, consent, and comfort are our top priorities.
Doors open tonight — step into an unforgettable night of connection and chemistry''',
  ),

  CardData(
    imageUrl: 'assets/images/notification-image8.jpg',
    title: 'New Dating Event Alert',
    description:
    '''We're excited to announce a special event on our dating platform designed to help you connect with new and interesting people. This event gives you the opportunity to discover curated profiles, start meaningful conversations, and explore potential matches in a fun and engaging environment.

Whether you're looking for a genuine connection or simply want to meet someone new, this event is the perfect chance to take your dating journey to the next level. Enjoy real-time interactions, better compatibility insights, and a more personalized experience.

Open the app to view full event details and be part of this exciting experience.''',
  ),
];

// ✅ Changed to ConsumerWidget
class CardListScreen extends ConsumerWidget {
  const CardListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card List'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appCardsData.length,
        itemBuilder: (context, index) {
          return CustomCard(
            cardData: appCardsData[index],
            cardIndex: index, // ✅ Pass index to identify the card
            onSeeMore: () {
              debugPrint('See more clicked for ${appCardsData[index].title}');
            },
          );
        },
      ),
    );
  }
}

// ✅ Changed to ConsumerWidget (no more StatefulWidget)
class CustomCard extends ConsumerWidget {
  final CardData cardData;
  final int cardIndex; // ✅ Add index to uniquely identify card
  final VoidCallback? onSeeMore;

  const CustomCard({
    super.key,
    required this.cardData,
    required this.cardIndex,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch the expansion state for this specific card
    final isExpanded = ref.watch(cardExpansionProvider(cardIndex));

    return RepaintBoundary(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImage(),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                cardData.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                cardData.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: isExpanded ? null : 3,
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // See More Button
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {
                    // ✅ Toggle expansion state using Riverpod
                    ref.read(cardExpansionProvider(cardIndex).notifier).state = !isExpanded;
                    onSeeMore?.call();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isExpanded ? 'See Less' : 'See More'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const double h = 200;
    final String raw = cardData.imageUrl.trim();
    if (raw.isEmpty) {
      return _neutralImagePlaceholder(height: h);
    }

    final String lower = raw.toLowerCase();

    if (lower.startsWith('assets/') ||
        lower.startsWith('asset/') ||
        lower.startsWith('package:')) {
      return Image.asset(
        raw,
        height: h,
        width: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) =>
            _neutralImagePlaceholder(height: h),
      );
    }

    final Uri? uri = Uri.tryParse(raw);
    if (uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https')) {
      return Image.network(
        uri.toString(),
        height: h,
        width: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: h,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            _neutralImagePlaceholder(height: h),
      );
    }

    if (!raw.contains('://')) {
      return Image.asset(
        raw,
        height: h,
        width: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) =>
            _neutralImagePlaceholder(height: h),
      );
    }

    return _neutralImagePlaceholder(height: h);
  }

  static Widget _neutralImagePlaceholder({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[200]!,
            Colors.grey[300]!,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: Colors.grey[500],
      ),
    );
  }
}