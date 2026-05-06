import 'package:flutter/material.dart';

import '../Api_services/api_services.dart';
import '../content/app_drawer.dart';
import '../content/card_data.dart';
import '../core/services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiServices _apiServices = ApiServices();
  List<CardData> _cards = appCardsData;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    if (!_isRefreshing && mounted) {
      setState(() {
        _isRefreshing = true;
      });
    }
    try {
      final token = await AuthService.getToken();
      final apiCards = await _apiServices.fetchCards(token: token);
      if (!mounted) return;
      setState(() {
        _cards = apiCards.isEmpty ? appCardsData : apiCards;
        _isRefreshing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cards = appCardsData;
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ),
      drawer: const Drawer(child: AppDrawer()),
      backgroundColor: Colors.pink.withValues(alpha: 0.5),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadCards,
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return CustomCard(
                    cardData: _cards[index],
                  );
                },
              ),
            ),
            if (_isRefreshing)
              const Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
              ),
          ],
        ),
      ),
    );
  }
}
