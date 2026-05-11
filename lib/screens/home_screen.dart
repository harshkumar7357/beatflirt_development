// import 'package:flutter/material.dart';
//
// import '../Api_services/api_services.dart';
// import '../content/app_drawer.dart';
// import '../content/card_data.dart';
// import '../core/services/auth_services.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final ApiServices _apiServices = ApiServices();
//   List<CardData> _cards = appCardsData;
//   bool _isRefreshing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCards();
//   }
//
//   Future<void> _loadCards() async {
//     if (!_isRefreshing && mounted) {
//       setState(() {
//         _isRefreshing = true;
//       });
//     }
//     try {
//       final token = await AuthService.getToken();
//       final apiCards = await _apiServices.fetchCards(token: token);
//       if (!mounted) return;
//       setState(() {
//         _cards = apiCards.isEmpty ? appCardsData : apiCards;
//         _isRefreshing = false;
//       });
//     } catch (_) {
//       if (!mounted) return;
//       setState(() {
//         _cards = appCardsData;
//         _isRefreshing = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           "Beat Flirt",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26,
//             shadows: [
//               const Shadow(
//                 blurRadius: 8,
//                 color: Colors.pink,
//                 offset: Offset(0, 0),
//               ),
//               const Shadow(
//                 blurRadius: 16,
//                 color: Colors.pink,
//                 offset: Offset(0, 0),
//               ),
//               Shadow(
//                 blurRadius: 24,
//                 color: Colors.pink.withValues(alpha: 0.7),
//                 offset: const Offset(0, 0),
//               ),
//               Shadow(
//                 blurRadius: 32,
//                 color: Colors.pink.withValues(alpha: 0.8),
//                 offset: const Offset(0, 0),
//               ),
//             ],
//           ),
//         ),
//       ),
//       drawer: const AppDrawer(),
//       backgroundColor: Colors.pink.withValues(alpha: 0.5),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             RefreshIndicator(
//               onRefresh: _loadCards,
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(24),
//                 itemCount: _cards.length,
//                 itemBuilder: (context, index) {
//                   return CustomCard(
//                     cardData: _cards[index],
//                     cardIndex: index,
//                   );
//                 },
//               ),
//             ),
//             if (_isRefreshing)
//               const Positioned(
//                 top: 12,
//                 left: 0,
//                 right: 0,
//                 child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Api_services/api_services.dart';
import '../content/app_drawer.dart';
import '../content/card_data.dart';
import '../core/services/auth_services.dart';

// --- STATE ---
class HomePageState {
  final List<CardData> cards;
  final bool isRefreshing;

  const HomePageState({
    this.cards = const [],
    this.isRefreshing = false,
  });

  HomePageState copyWith({
    List<CardData>? cards,
    bool? isRefreshing,
  }) {
    return HomePageState(
      cards: cards ?? this.cards,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

// --- NOTIFIER ---
class HomePageNotifier extends Notifier<HomePageState> {
  final ApiServices _apiServices = ApiServices();

  @override
  HomePageState build() {
    return HomePageState(cards: appCardsData);
  }

  Future<void> loadCards() async {
    state = state.copyWith(isRefreshing: true);
    try {
      final token = await AuthService.getToken();
      final apiCards = await _apiServices.fetchCards(token: token);
      state = state.copyWith(
        cards: apiCards.isEmpty ? appCardsData : apiCards,
        isRefreshing: false,
      );
    } catch (_) {
      state = state.copyWith(
        cards: appCardsData,
        isRefreshing: false,
      );
    }
  }
}

// --- PROVIDER ---
final homePageProvider =
NotifierProvider<HomePageNotifier, HomePageState>(
  HomePageNotifier.new,
);

// --- WIDGET ---
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homePageProvider.notifier).loadCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homePageProvider);
    final notifier = ref.read(homePageProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Beat Flirt",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            shadows: [
              const Shadow(
                blurRadius: 8,
                color: Colors.pink,
                offset: Offset(0, 0),
              ),
              const Shadow(
                blurRadius: 16,
                color: Colors.pink,
                offset: Offset(0, 0),
              ),
              Shadow(
                blurRadius: 24,
                color: Colors.pink.withValues(alpha: 0.7),
                offset: const Offset(0, 0),
              ),
              Shadow(
                blurRadius: 32,
                color: Colors.pink.withValues(alpha: 0.8),
                offset: const Offset(0, 0),
              ),
              Shadow(
                blurRadius: 40,
                color: Colors.pink.withValues(alpha: 0.8),
                offset: const Offset(0, 0),
              ),Shadow(
                blurRadius: 48,
                color: Colors.pink.withValues(alpha: 0.8),
                offset: const Offset(0, 0),
              ),

            ],
          ),
        ),
      ),
      drawer: const AppDrawer(),
      // backgroundColor: Colors.pink.withValues(alpha: 0.5),
      backgroundColor: Colors.pink.shade900,
      
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: notifier.loadCards,
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: state.cards.length,
                itemBuilder: (context, index) {
                  return CustomCard(
                    cardData: state.cards[index],
                    cardIndex: index,
                  );
                },
              ),
            ),
            if (state.isRefreshing)
              const Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}