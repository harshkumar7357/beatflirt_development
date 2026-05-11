import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Provider to manage selected subscription plan
final selectedPlanProvider = StateProvider<int>((ref) => 1); // Default to "Gold"

class UpgradePage extends ConsumerWidget {
  const UpgradePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedPlanProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          _buildHeroSection(),
          _buildPlanSelector(ref, selectedIndex),
          _buildBenefitsSection(selectedIndex),
          _buildActionSection(context, selectedIndex),
          const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0F0F1A),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'UPGRADE TO VIP',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A11CB).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            const FaIcon(FontAwesomeIcons.crown, color: Colors.amber, size: 50),
            const SizedBox(height: 20),
            const Text(
              "Unlock Premium Features",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Join the elite community and get 10x more visibility and exclusive filters.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSelector(WidgetRef ref, int selectedIndex) {
    final plans = [
      {'name': 'Basic', 'price': 'Free', 'duration': 'Lifetime'},
      {'name': 'Gold', 'price': '\$9.99', 'duration': 'Monthly'},
      {'name': 'Elite', 'price': '\$79.99', 'duration': 'Yearly'},
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => ref.read(selectedPlanProvider.notifier).state = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 150,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.pinkAccent : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.pinkAccent : Colors.white.withValues(alpha: 0.1),
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: Colors.pinkAccent.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8))]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      plan['name']!,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      plan['price']!,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      plan['duration']!,
                      style: TextStyle(
                        color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBenefitsSection(int selectedIndex) {
    final allBenefits = [
      {'icon': FontAwesomeIcons.bolt, 'text': 'Unlimited Likes & Swipes'},
      {'icon': FontAwesomeIcons.eye, 'text': 'See who liked your profile'},
      {'icon': FontAwesomeIcons.locationDot, 'text': 'Passport to any location'},
      {'icon': FontAwesomeIcons.shieldHalved, 'text': 'Advanced Privacy Controls'},
      {'icon': FontAwesomeIcons.message, 'text': 'Priority Messaging'},
      {'icon': FontAwesomeIcons.rectangleAd, 'text': 'Zero Advertisements'},
    ];

    // Determine how many benefits to show based on plan
    final benefitsToShow = selectedIndex == 0 ? 2 : (selectedIndex == 1 ? 4 : 6);

    return SliverPadding(
      padding: const EdgeInsets.all(25),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final benefit = allBenefits[index];
            final isIncluded = index < benefitsToShow;

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Container(
                    width: 35,
                    alignment: Alignment.center,
                    child: FaIcon(
                      benefit['icon'] as FaIconData,
                      size: 18,
                      color: isIncluded ? Colors.pinkAccent : Colors.white12,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    benefit['text'] as String,
                    style: TextStyle(
                      color: isIncluded ? Colors.white : Colors.white24,
                      fontSize: 15,
                      fontWeight: isIncluded ? FontWeight.w500 : FontWeight.normal,
                      decoration: isIncluded ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  const Spacer(),
                  if (isIncluded)
                    const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20)
                  else
                    const Icon(Icons.cancel, color: Colors.white12, size: 20),
                ],
              ),
            );
          },
          childCount: allBenefits.length,
        ),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, int selectedIndex) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF1E56), Color(0xFFFF4081)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF1E56).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Processing your VIP request...'),
                      backgroundColor: Colors.pinkAccent,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  "GET STARTED NOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Recurring billing. Cancel anytime.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
