// // // import 'package:flutter/material.dart';

// // // // void main() {
// // // //   runApp(const BeatFlirtApp());
// // // // }

// // // // class BeatFlirtApp extends StatelessWidget {
// // // //   const BeatFlirtApp({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       title: 'Beat Flirt',
// // // //       debugShowCheckedModeBanner: false,
// // // //       theme: ThemeData(
// // // //         brightness: Brightness.dark,
// // // //         scaffoldBackgroundColor: const Color(0xFF0D0D0D),
// // // //         colorScheme: const ColorScheme.dark(
// // // //           primary: Color(0xFFE91E8C),
// // // //           secondary: Color(0xFF9B27AF),
// // // //           surface: Color(0xFF1A1A2E),
// // // //         ),
// // // //         fontFamily: 'Poppins',
// // // //       ),
// // // //       home: const BeatFlirtLandingPage(),
// // // //     );
// // // //   }
// // // // }

// // // // ─── COLORS ───────────────────────────────────────────────────────────────────
// // // const kBg = Color(0xFF0D0D0D);
// // // const kCard = Color(0xFF1A1A2E);
// // // const kPink = Color(0xFFE91E8C);
// // // const kPurple = Color(0xFF9B27AF);
// // // const kAccent = Color(0xFFFF4081);
// // // const kText = Color(0xFFFFFFFF);
// // // const kSubText = Color(0xFFB0B0C3);
// // // const kDivider = Color(0xFF2A2A3E);

// // // // ─── LANDING PAGE ─────────────────────────────────────────────────────────────
// // // class BeatFlirtLandingPage extends StatefulWidget {
// // //   const BeatFlirtLandingPage({super.key});

// // //   @override
// // //   State<BeatFlirtLandingPage> createState() => _BeatFlirtLandingPageState();
// // // }

// // // class _BeatFlirtLandingPageState extends State<BeatFlirtLandingPage> {
// // //   final PageController _pageController = PageController();
// // //   int _currentPage = 0;

// // //   final List<String> _pageTitles = [
// // //     'Home',
// // //     'How It Works',
// // //     'Features',
// // //     'Pricing',
// // //     'Testimonials',
// // //     'FAQ',
// // //     'Register',
// // //   ];

// // //   void _goToPage(int index) {
// // //     _pageController.animateToPage(
// // //       index,
// // //       duration: const Duration(milliseconds: 500),
// // //       curve: Curves.easeInOut,
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: kBg,
// // //       drawer: _buildDrawer(),
// // //       body: Stack(
// // //         children: [
// // //           PageView(
// // //             controller: _pageController,
// // //             scrollDirection: Axis.vertical,
// // //             onPageChanged: (i) => setState(() => _currentPage = i),
// // //             children: const [
// // //               HeroSection(),
// // //               HowItWorksSection(),
// // //               FeaturesSection(),
// // //               PricingSection(),
// // //               TestimonialsSection(),
// // //               FAQSection(),
// // //               RegistrationSection(),
// // //             ],
// // //           ),

// // //           // ── Top Nav Bar ──
// // //           Positioned(
// // //             top: 0,
// // //             left: 0,
// // //             right: 0,
// // //             child: _buildNavBar(context),
// // //           ),

// // //           // ── Page Indicator dots (right side) ──
// // //           Positioned(
// // //             right: 12,
// // //             top: 0,
// // //             bottom: 0,
// // //             child: Center(
// // //               child: Column(
// // //                 mainAxisSize: MainAxisSize.min,
// // //                 children: List.generate(_pageTitles.length, (i) {
// // //                   final isActive = _currentPage == i;
// // //                   return GestureDetector(
// // //                     onTap: () => _goToPage(i),
// // //                     child: AnimatedContainer(
// // //                       duration: const Duration(milliseconds: 300),
// // //                       margin: const EdgeInsets.symmetric(vertical: 4),
// // //                       width: isActive ? 10 : 6,
// // //                       height: isActive ? 10 : 6,
// // //                       decoration: BoxDecoration(
// // //                         shape: BoxShape.circle,
// // //                         color: isActive ? kPink : kSubText.withOpacity(0.4),
// // //                       ),
// // //                     ),
// // //                   );
// // //                 }),
// // //               ),
// // //             ),
// // //           ),

// // //           // ── Scroll Down hint on Hero ──
// // //           if (_currentPage == 0)
// // //             Positioned(
// // //               bottom: 24,
// // //               left: 0,
// // //               right: 0,
// // //               child: GestureDetector(
// // //                 onTap: () => _goToPage(1),
// // //                 child: Column(
// // //                   children: [
// // //                     Text('Scroll Down',
// // //                         style: TextStyle(
// // //                             color: kSubText.withOpacity(0.6), fontSize: 12)),
// // //                     const SizedBox(height: 4),
// // //                     const Icon(Icons.keyboard_arrow_down,
// // //                         color: kPink, size: 28),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildNavBar(BuildContext context) {
// // //     return Container(
// // //       padding:
// // //           EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16, bottom: 12),
// // //       decoration: BoxDecoration(
// // //         gradient: LinearGradient(
// // //           begin: Alignment.topCenter,
// // //           end: Alignment.bottomCenter,
// // //           colors: [kBg, kBg.withOpacity(0)],
// // //         ),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           // Logo
// // //           Row(
// // //             children: [
// // //               Container(
// // //                 width: 36,
// // //                 height: 36,
// // //                 decoration: BoxDecoration(
// // //                   gradient: const LinearGradient(
// // //                     colors: [kPink, kPurple],
// // //                   ),
// // //                   borderRadius: BorderRadius.circular(8),
// // //                 ),
// // //                 child: const Icon(Icons.music_note, color: Colors.white, size: 20),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               const Text(
// // //                 'Beat Flirt',
// // //                 style: TextStyle(
// // //                   color: kText,
// // //                   fontSize: 18,
// // //                   fontWeight: FontWeight.bold,
// // //                   letterSpacing: 1,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           const Spacer(),
// // //           // Nav items (visible on wider screens, hidden on small)
// // //           if (MediaQuery.of(context).size.width > 600) ...[
// // //             for (int i = 0; i < _pageTitles.length; i++)
// // //               GestureDetector(
// // //                 onTap: () => _goToPage(i),
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 10),
// // //                   child: Text(
// // //                     _pageTitles[i],
// // //                     style: TextStyle(
// // //                       color: _currentPage == i ? kPink : kSubText,
// // //                       fontSize: 13,
// // //                       fontWeight: _currentPage == i
// // //                           ? FontWeight.bold
// // //                           : FontWeight.normal,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //           ],
// // //           const SizedBox(width: 8),
// // //           _GradientButton(
// // //             label: 'Get Started',
// // //             onTap: () => _goToPage(6),
// // //             compact: true,
// // //           ),
// // //           const SizedBox(width: 8),
// // //           // Hamburger
// // //           Builder(
// // //             builder: (ctx) => IconButton(
// // //               icon: const Icon(Icons.menu, color: kText),
// // //               onPressed: () => Scaffold.of(ctx).openDrawer(),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDrawer() {
// // //     return Drawer(
// // //       backgroundColor: kCard,
// // //       child: SafeArea(
// // //         child: Column(
// // //           children: [
// // //             const SizedBox(height: 24),
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 Container(
// // //                   width: 44,
// // //                   height: 44,
// // //                   decoration: BoxDecoration(
// // //                     gradient: const LinearGradient(colors: [kPink, kPurple]),
// // //                     borderRadius: BorderRadius.circular(10),
// // //                   ),
// // //                   child:
// // //                       const Icon(Icons.music_note, color: Colors.white, size: 24),
// // //                 ),
// // //                 const SizedBox(width: 10),
// // //                 const Text('Beat Flirt',
// // //                     style: TextStyle(
// // //                         color: kText,
// // //                         fontSize: 20,
// // //                         fontWeight: FontWeight.bold)),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 32),
// // //             for (int i = 0; i < _pageTitles.length; i++)
// // //               ListTile(
// // //                 leading: Icon(_pageIcons[i],
// // //                     color: _currentPage == i ? kPink : kSubText),
// // //                 title: Text(
// // //                   _pageTitles[i],
// // //                   style: TextStyle(
// // //                     color: _currentPage == i ? kPink : kText,
// // //                     fontWeight: _currentPage == i
// // //                         ? FontWeight.bold
// // //                         : FontWeight.normal,
// // //                   ),
// // //                 ),
// // //                 onTap: () {
// // //                   Navigator.pop(context);
// // //                   _goToPage(i);
// // //                 },
// // //               ),
// // //             const Spacer(),
// // //             Padding(
// // //               padding: const EdgeInsets.all(16),
// // //               child: _GradientButton(
// // //                   label: 'Book Now', onTap: () => _goToPage(6)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   final List<IconData> _pageIcons = [
// // //     Icons.home,
// // //     Icons.how_to_reg,
// // //     Icons.star,
// // //     Icons.attach_money,
// // //     Icons.format_quote,
// // //     Icons.help_outline,
// // //     Icons.app_registration,
// // //   ];
// // // }

// // // // ─── SECTION 1 : HERO ─────────────────────────────────────────────────────────
// // // class HeroSection extends StatelessWidget {
// // //   const HeroSection({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       decoration: const BoxDecoration(
// // //         gradient: RadialGradient(
// // //           center: Alignment(0, -0.3),
// // //           radius: 1.2,
// // //           colors: [Color(0xFF2D0A3E), kBg],
// // //         ),
// // //       ),
// // //       child: SafeArea(
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.center,
// // //             children: [
// // //               const SizedBox(height: 40),
// // //               Container(
// // //                 padding:
// // //                     const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// // //                 decoration: BoxDecoration(
// // //                   border: Border.all(color: kPink.withOpacity(0.5)),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                   color: kPink.withOpacity(0.08),
// // //                 ),
// // //                 child: const Text(
// // //                   '🎉  The All-in-One Platform for Events, Nightlife & Dating',
// // //                   style: TextStyle(color: kPink, fontSize: 12),
// // //                   textAlign: TextAlign.center,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 28),
// // //               const Text(
// // //                 'EVENT\nMANAGEMENT\nSOFTWARE',
// // //                 textAlign: TextAlign.center,
// // //                 style: TextStyle(
// // //                   color: kText,
// // //                   fontSize: 40,
// // //                   fontWeight: FontWeight.w900,
// // //                   height: 1.1,
// // //                   letterSpacing: 2,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 16),
// // //               ShaderMask(
// // //                 shaderCallback: (bounds) => const LinearGradient(
// // //                   colors: [kPink, kPurple],
// // //                 ).createShader(bounds),
// // //                 child: const Text(
// // //                   'Beat Flirt',
// // //                   style: TextStyle(
// // //                     color: Colors.white,
// // //                     fontSize: 36,
// // //                     fontWeight: FontWeight.w900,
// // //                     letterSpacing: 3,
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 20),
// // //               const Text(
// // //                 'Manage your events easily with our smart software solution.\nSecure bookings, smart scheduling & seamless engagement.',
// // //                 textAlign: TextAlign.center,
// // //                 style: TextStyle(color: kSubText, fontSize: 14, height: 1.7),
// // //               ),
// // //               const SizedBox(height: 36),
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   const _GradientButton(label: 'Get Started'),
// // //                   const SizedBox(width: 16),
// // //                   OutlinedButton(
// // //                     onPressed: () {},
// // //                     style: OutlinedButton.styleFrom(
// // //                       side: const BorderSide(color: kPink),
// // //                       shape: RoundedRectangleBorder(
// // //                           borderRadius: BorderRadius.circular(30)),
// // //                       padding: const EdgeInsets.symmetric(
// // //                           horizontal: 24, vertical: 14),
// // //                     ),
// // //                     child: const Text('Request Demo',
// // //                         style: TextStyle(color: kPink)),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 60),
// // //               // Stats row
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //                 children: const [
// // //                   _StatChip(value: '50+', label: 'Events/mo'),
// // //                   _StatChip(value: '5K+', label: 'Attendees'),
// // //                   _StatChip(value: '99%', label: 'Uptime'),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 40),
// // //               // Feature pills
// // //               Wrap(
// // //                 spacing: 10,
// // //                 runSpacing: 10,
// // //                 alignment: WrapAlignment.center,
// // //                 children: const [
// // //                   _Pill(icon: Icons.confirmation_number, label: 'Secure Ticketing'),
// // //                   _Pill(icon: Icons.qr_code_scanner, label: 'QR Check-In'),
// // //                   _Pill(icon: Icons.star, label: 'VIP Memberships'),
// // //                   _Pill(icon: Icons.favorite, label: 'Speed Dating'),
// // //                   _Pill(icon: Icons.analytics, label: 'Live Analytics'),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _StatChip extends StatelessWidget {
// // //   final String value, label;
// // //   const _StatChip({required this.value, required this.label});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         ShaderMask(
// // //           shaderCallback: (b) =>
// // //               const LinearGradient(colors: [kPink, kPurple]).createShader(b),
// // //           child: Text(value,
// // //               style: const TextStyle(
// // //                   color: Colors.white,
// // //                   fontSize: 28,
// // //                   fontWeight: FontWeight.w900)),
// // //         ),
// // //         Text(label, style: const TextStyle(color: kSubText, fontSize: 12)),
// // //       ],
// // //     );
// // //   }
// // // }

// // // class _Pill extends StatelessWidget {
// // //   final IconData icon;
// // //   final String label;
// // //   const _Pill({required this.icon, required this.label});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // //       decoration: BoxDecoration(
// // //         color: kCard,
// // //         borderRadius: BorderRadius.circular(20),
// // //         border: Border.all(color: kDivider),
// // //       ),
// // //       child: Row(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Icon(icon, color: kPink, size: 16),
// // //           const SizedBox(width: 6),
// // //           Text(label, style: const TextStyle(color: kText, fontSize: 12)),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ─── SECTION 2 : HOW IT WORKS ─────────────────────────────────────────────────
// // // class HowItWorksSection extends StatelessWidget {
// // //   const HowItWorksSection({super.key});

// // //   static const _steps = [
// // //     _Step(
// // //       icon: Icons.add_circle_outline,
// // //       title: 'Create Events',
// // //       desc:
// // //           'Set up your event in minutes — add details, set capacity, ticket pricing, and publish instantly.',
// // //       color: kPink,
// // //     ),
// // //     _Step(
// // //       icon: Icons.payment,
// // //       title: 'Accept Payments',
// // //       desc:
// // //           'Collect payments seamlessly via Card, UPI, and multiple payment gateways with full security.',
// // //       color: Color(0xFF9B27AF),
// // //     ),
// // //     _Step(
// // //       icon: Icons.people_outline,
// // //       title: 'Guest Management',
// // //       desc:
// // //           'Manage guest lists, check-ins, VIP tables, and attendee data from one smart dashboard.',
// // //       color: Color(0xFF1565C0),
// // //     ),
// // //     _Step(
// // //       icon: Icons.bar_chart,
// // //       title: 'Track Revenue',
// // //       desc:
// // //           'Monitor ticket sales, revenue, and attendance in real time with powerful analytics tools.',
// // //       color: Color(0xFF00897B),
// // //     ),
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return _SectionWrapper(
// // //       tag: 'HOW IT WORKS',
// // //       title: 'Launch, Manage & Grow\nYour Events',
// // //       subtitle:
// // //           'From ticket creation to real-time insights — Beat Flirt handles everything.',
// // //       child: Column(
// // //         children: List.generate(_steps.length, (i) {
// // //           final s = _steps[i];
// // //           return Container(
// // //             margin: const EdgeInsets.only(bottom: 16),
// // //             padding: const EdgeInsets.all(20),
// // //             decoration: BoxDecoration(
// // //               color: kCard,
// // //               borderRadius: BorderRadius.circular(16),
// // //               border: Border.all(color: kDivider),
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Container(
// // //                   width: 52,
// // //                   height: 52,
// // //                   decoration: BoxDecoration(
// // //                     color: s.color.withOpacity(0.15),
// // //                     borderRadius: BorderRadius.circular(14),
// // //                   ),
// // //                   child: Icon(s.icon, color: s.color, size: 26),
// // //                 ),
// // //                 const SizedBox(width: 16),
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(s.title,
// // //                           style: const TextStyle(
// // //                               color: kText,
// // //                               fontSize: 15,
// // //                               fontWeight: FontWeight.bold)),
// // //                       const SizedBox(height: 4),
// // //                       Text(s.desc,
// // //                           style: const TextStyle(
// // //                               color: kSubText, fontSize: 13, height: 1.5)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 Container(
// // //                   width: 28,
// // //                   height: 28,
// // //                   decoration: BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     border: Border.all(color: s.color),
// // //                   ),
// // //                   child: Center(
// // //                     child: Text('${i + 1}',
// // //                         style: TextStyle(
// // //                             color: s.color,
// // //                             fontWeight: FontWeight.bold,
// // //                             fontSize: 12)),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           );
// // //         }),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _Step {
// // //   final IconData icon;
// // //   final String title, desc;
// // //   final Color color;
// // //   const _Step(
// // //       {required this.icon,
// // //       required this.title,
// // //       required this.desc,
// // //       required this.color});
// // // }

// // // // ─── SECTION 3 : FEATURES ─────────────────────────────────────────────────────
// // // class FeaturesSection extends StatelessWidget {
// // //   const FeaturesSection({super.key});

// // //   static const _features = [
// // //     _Feature(Icons.confirmation_number, 'Secure Ticketing',
// // //         'Sell tickets with full fraud protection and QR validation at entry.'),
// // //     _Feature(Icons.star_border, 'VIP Memberships',
// // //         'Create exclusive VIP tiers with premium perks and table reservations.'),
// // //     _Feature(Icons.account_balance_wallet, 'Integrated Payments',
// // //         'Accept Card, UPI, and global payment methods with instant payouts.'),
// // //     _Feature(Icons.forum_outlined, 'Customer Engagement',
// // //         'Send campaigns, push notifications, and keep your audience connected.'),
// // //     _Feature(Icons.calendar_today, 'Event Management',
// // //         'Manage schedules, vendors, and operations all from one dashboard.'),
// // //     _Feature(Icons.hotel, 'Hotel Booking',
// // //         'Offer multi-day event packages with integrated hotel accommodations.'),
// // //     _Feature(Icons.branding_watermark, 'Custom Branding',
// // //         'White-label the platform with your logo, colors, and custom domain.'),
// // //     _Feature(Icons.favorite, 'Speed Dating Module',
// // //         'Run structured speed dating rounds with smart matchmaking algorithms.'),
// // //     _Feature(Icons.campaign, 'Marketing & Promos',
// // //         'Run targeted promotions, discount codes, and influencer campaigns.'),
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return _SectionWrapper(
// // //       tag: 'FEATURES',
// // //       title: 'Everything You Need\nIn One Platform',
// // //       subtitle: 'Powerful tools built for modern event organizers.',
// // //       child: GridView.builder(
// // //         shrinkWrap: true,
// // //         physics: const NeverScrollableScrollPhysics(),
// // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //           crossAxisCount: 2,
// // //           crossAxisSpacing: 12,
// // //           mainAxisSpacing: 12,
// // //           childAspectRatio: 0.95,
// // //         ),
// // //         itemCount: _features.length,
// // //         itemBuilder: (_, i) => _FeatureCard(feature: _features[i]),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _Feature {
// // //   final IconData icon;
// // //   final String title, desc;
// // //   const _Feature(this.icon, this.title, this.desc);
// // // }

// // // class _FeatureCard extends StatelessWidget {
// // //   final _Feature feature;
// // //   const _FeatureCard({required this.feature, super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       decoration: BoxDecoration(
// // //         color: kCard,
// // //         borderRadius: BorderRadius.circular(16),
// // //         border: Border.all(color: kDivider),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Container(
// // //             padding: const EdgeInsets.all(10),
// // //             decoration: BoxDecoration(
// // //               gradient: const LinearGradient(
// // //                   colors: [kPink, kPurple],
// // //                   begin: Alignment.topLeft,
// // //                   end: Alignment.bottomRight),
// // //               borderRadius: BorderRadius.circular(12),
// // //             ),
// // //             child: Icon(feature.icon, color: Colors.white, size: 22),
// // //           ),
// // //           const SizedBox(height: 12),
// // //           Text(feature.title,
// // //               style: const TextStyle(
// // //                   color: kText, fontSize: 13, fontWeight: FontWeight.bold)),
// // //           const SizedBox(height: 6),
// // //           Text(feature.desc,
// // //               style: const TextStyle(
// // //                   color: kSubText, fontSize: 11, height: 1.5)),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ─── SECTION 4 : PRICING ──────────────────────────────────────────────────────
// // // class PricingSection extends StatefulWidget {
// // //   const PricingSection({super.key});

// // //   @override
// // //   State<PricingSection> createState() => _PricingSectionState();
// // // }

// // // class _PricingSectionState extends State<PricingSection> {
// // //   int _selected = 1;

// // //   static const _plans = [
// // //     _Plan(
// // //       name: 'Starter\nNightlife',
// // //       price: '\$99',
// // //       period: '/month',
// // //       tag: 'Best for small clubs',
// // //       fee: 'Platform Fee: 5% per ticket',
// // //       features: [
// // //         '50 Events / Month',
// // //         '1,000 Attendees / Month',
// // //         'Club Page & Website',
// // //         'Ticket Sales & QR Check-In',
// // //         'Door Payments (Card / UPI)',
// // //         'Guest List Management',
// // //         'Speed Dating Module',
// // //         'User Profiles & Interests',
// // //         'Who\'s Attending View',
// // //         '3,000 Messages / Month',
// // //         'Basic Analytics & Reports',
// // //       ],
// // //       missing: [
// // //         'Private Chat & Ice-Breakers',
// // //         'VIP Table Reservations',
// // //         'Community Groups & Feeds',
// // //         'Paid Memberships',
// // //       ],
// // //       color: Color(0xFF1565C0),
// // //       popular: false,
// // //     ),
// // //     _Plan(
// // //       name: 'Social\nClub Pro',
// // //       price: '\$199',
// // //       period: '/month',
// // //       tag: 'Premium clubs & mixers',
// // //       fee: 'Platform Fee: 3% per ticket',
// // //       features: [
// // //         'Everything in Starter Plan',
// // //         '80 Events / Month',
// // //         '5,000 Attendees / Month',
// // //         'Advanced Analytics',
// // //         'Private Chat & Ice-Breakers',
// // //         'VIP Table Reservations',
// // //         'Community Groups & Feeds',
// // //         '15,000 Messages / Month',
// // //         'Priority Support',
// // //       ],
// // //       missing: [
// // //         'Paid Memberships',
// // //         'Multi-Day / Hotel Takeovers',
// // //         'Custom Branding',
// // //         'Celebrity Panel & Media',
// // //       ],
// // //       color: kPink,
// // //       popular: true,
// // //     ),
// // //     _Plan(
// // //       name: 'Lifestyle\nElite',
// // //       price: '\$399',
// // //       period: '/month',
// // //       tag: 'Resorts & lifestyle communities',
// // //       fee: 'Platform Fee: 1.5% per ticket',
// // //       features: [
// // //         'Everything in Social Club Pro',
// // //         'Unlimited Events',
// // //         'Unlimited Attendees',
// // //         'Paid Memberships',
// // //         'Multi-Day / Hotel Takeovers',
// // //         'Custom Branding',
// // //         'Celebrity Panel & Media',
// // //         '50,000 Messages / Month',
// // //       ],
// // //       missing: [],
// // //       color: Color(0xFF9B27AF),
// // //       popular: false,
// // //     ),
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final plan = _plans[_selected];
// // //     return _SectionWrapper(
// // //       tag: 'PRICING',
// // //       title: 'Choose the Perfect\nPlan for You',
// // //       subtitle: 'Flexible plans for every organizer — from first-timers to elite brands.',
// // //       child: Column(
// // //         children: [
// // //           // Plan selector tabs
// // //           Container(
// // //             decoration: BoxDecoration(
// // //               color: kCard,
// // //               borderRadius: BorderRadius.circular(30),
// // //               border: Border.all(color: kDivider),
// // //             ),
// // //             padding: const EdgeInsets.all(4),
// // //             child: Row(
// // //               children: List.generate(_plans.length, (i) {
// // //                 final isSelected = _selected == i;
// // //                 return Expanded(
// // //                   child: GestureDetector(
// // //                     onTap: () => setState(() => _selected = i),
// // //                     child: AnimatedContainer(
// // //                       duration: const Duration(milliseconds: 250),
// // //                       padding: const EdgeInsets.symmetric(vertical: 10),
// // //                       decoration: BoxDecoration(
// // //                         gradient: isSelected
// // //                             ? LinearGradient(
// // //                                 colors: [_plans[i].color, kPurple])
// // //                             : null,
// // //                         borderRadius: BorderRadius.circular(26),
// // //                       ),
// // //                       child: Text(
// // //                         _plans[i].name.replaceAll('\n', ' '),
// // //                         textAlign: TextAlign.center,
// // //                         style: TextStyle(
// // //                           color: isSelected ? kText : kSubText,
// // //                           fontSize: 11,
// // //                           fontWeight: isSelected
// // //                               ? FontWeight.bold
// // //                               : FontWeight.normal,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 );
// // //               }),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 20),

// // //           // Plan card
// // //           AnimatedSwitcher(
// // //             duration: const Duration(milliseconds: 300),
// // //             child: _PlanCard(plan: plan, key: ValueKey(_selected)),
// // //           ),

// // //           const SizedBox(height: 16),
// // //           // White-label teaser
// // //           Container(
// // //             padding: const EdgeInsets.all(16),
// // //             decoration: BoxDecoration(
// // //               color: kCard,
// // //               borderRadius: BorderRadius.circular(16),
// // //               border: Border.all(color: kPink.withOpacity(0.3)),
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 const Icon(Icons.business, color: kPink, size: 28),
// // //                 const SizedBox(width: 12),
// // //                 const Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text('White-Label',
// // //                           style: TextStyle(
// // //                               color: kText,
// // //                               fontWeight: FontWeight.bold,
// // //                               fontSize: 14)),
// // //                       Text('Custom pricing for large brands & international expansion.',
// // //                           style: TextStyle(color: kSubText, fontSize: 12)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 OutlinedButton(
// // //                   onPressed: () {},
// // //                   style: OutlinedButton.styleFrom(
// // //                     side: const BorderSide(color: kPink),
// // //                     shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(20)),
// // //                     padding:
// // //                         const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // //                   ),
// // //                   child: const Text('Contact Us',
// // //                       style: TextStyle(color: kPink, fontSize: 12)),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _Plan {
// // //   final String name, price, period, tag, fee;
// // //   final List<String> features, missing;
// // //   final Color color;
// // //   final bool popular;
// // //   const _Plan({
// // //     required this.name,
// // //     required this.price,
// // //     required this.period,
// // //     required this.tag,
// // //     required this.fee,
// // //     required this.features,
// // //     required this.missing,
// // //     required this.color,
// // //     required this.popular,
// // //   });
// // // }

// // // class _PlanCard extends StatelessWidget {
// // //   final _Plan plan;
// // //   const _PlanCard({required this.plan, super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: BoxDecoration(
// // //         color: kCard,
// // //         borderRadius: BorderRadius.circular(20),
// // //         border: Border.all(
// // //           color: plan.popular ? kPink : kDivider,
// // //           width: plan.popular ? 2 : 1,
// // //         ),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           if (plan.popular)
// // //             Container(
// // //               margin: const EdgeInsets.only(bottom: 12),
// // //               padding:
// // //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// // //               decoration: BoxDecoration(
// // //                 gradient: const LinearGradient(colors: [kPink, kPurple]),
// // //                 borderRadius: BorderRadius.circular(20),
// // //               ),
// // //               child: const Text('MOST POPULAR',
// // //                   style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 11,
// // //                       fontWeight: FontWeight.bold)),
// // //             ),
// // //           Text(plan.name,
// // //               style: const TextStyle(
// // //                   color: kText, fontSize: 18, fontWeight: FontWeight.bold)),
// // //           const SizedBox(height: 4),
// // //           Text(plan.tag,
// // //               style: const TextStyle(color: kSubText, fontSize: 12)),
// // //           const SizedBox(height: 16),
// // //           Row(
// // //             crossAxisAlignment: CrossAxisAlignment.end,
// // //             children: [
// // //               Text(plan.price,
// // //                   style: TextStyle(
// // //                       color: plan.color,
// // //                       fontSize: 40,
// // //                       fontWeight: FontWeight.w900)),
// // //               Text(plan.period,
// // //                   style: const TextStyle(color: kSubText, fontSize: 14)),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 4),
// // //           Text(plan.fee,
// // //               style: const TextStyle(color: kPink, fontSize: 12)),
// // //           const SizedBox(height: 16),
// // //           const Divider(color: kDivider),
// // //           const SizedBox(height: 12),
// // //           for (final f in plan.features)
// // //             Padding(
// // //               padding: const EdgeInsets.only(bottom: 8),
// // //               child: Row(
// // //                 children: [
// // //                   const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
// // //                   const SizedBox(width: 8),
// // //                   Expanded(
// // //                       child: Text(f,
// // //                           style: const TextStyle(
// // //                               color: kText, fontSize: 13))),
// // //                 ],
// // //               ),
// // //             ),
// // //           if (plan.missing.isNotEmpty) ...[
// // //             const SizedBox(height: 4),
// // //             for (final m in plan.missing)
// // //               Padding(
// // //                 padding: const EdgeInsets.only(bottom: 8),
// // //                 child: Row(
// // //                   children: [
// // //                     const Icon(Icons.cancel_outlined,
// // //                         color: Colors.redAccent, size: 16),
// // //                     const SizedBox(width: 8),
// // //                     Expanded(
// // //                         child: Text(m,
// // //                             style: const TextStyle(
// // //                                 color: kSubText, fontSize: 13))),
// // //                   ],
// // //                 ),
// // //               ),
// // //           ],
// // //           const SizedBox(height: 20),
// // //           SizedBox(
// // //             width: double.infinity,
// // //             child: ElevatedButton(
// // //               onPressed: () {},
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: plan.color,
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(30)),
// // //                 padding: const EdgeInsets.symmetric(vertical: 14),
// // //               ),
// // //               child: const Text('Get Started',
// // //                   style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontWeight: FontWeight.bold,
// // //                       fontSize: 15)),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ─── SECTION 5 : TESTIMONIALS ─────────────────────────────────────────────────
// // // class TestimonialsSection extends StatelessWidget {
// // //   const TestimonialsSection({super.key});

// // //   static const _testimonials = [
// // //     _Testimonial(
// // //       name: 'Elcia Petty',
// // //       role: 'Event Manager',
// // //       quote:
// // //           'Managing events has never been easier. This software provides all the tools we need to handle registrations, payments, and schedules without any hassle.',
// // //       initials: 'EP',
// // //       color: kPink,
// // //     ),
// // //     _Testimonial(
// // //       name: 'Enderson Will',
// // //       role: 'Club Owner',
// // //       quote:
// // //           'We improved our event operations and customer experience using this software. It is reliable, easy to use, and helps us manage bookings efficiently.',
// // //       initials: 'EW',
// // //       color: Color(0xFF9B27AF),
// // //     ),
// // //     _Testimonial(
// // //       name: 'Sushi Vega',
// // //       role: 'Party Host',
// // //       quote:
// // //           'A powerful solution for event organizers. The system is fast, secure, and user-friendly, helping us deliver successful events while keeping everything organized.',
// // //       initials: 'SV',
// // //       color: Color(0xFF1565C0),
// // //     ),
// // //     _Testimonial(
// // //       name: 'Ferry Bush',
// // //       role: 'Venue Director',
// // //       quote:
// // //           'This platform made managing our events simple and stress-free. From ticket bookings to attendee management, everything runs smoothly and saves valuable time.',
// // //       initials: 'FB',
// // //       color: Color(0xFF00897B),
// // //     ),
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return _SectionWrapper(
// // //       tag: 'TESTIMONIALS',
// // //       title: 'What Our Customers\nAre Saying',
// // //       subtitle: 'Trusted by event organizers and nightlife professionals worldwide.',
// // //       child: Column(
// // //         children: _testimonials
// // //             .map((t) => Padding(
// // //                   padding: const EdgeInsets.only(bottom: 16),
// // //                   child: _TestimonialCard(t: t),
// // //                 ))
// // //             .toList(),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _Testimonial {
// // //   final String name, role, quote, initials;
// // //   final Color color;
// // //   const _Testimonial({
// // //     required this.name,
// // //     required this.role,
// // //     required this.quote,
// // //     required this.initials,
// // //     required this.color,
// // //   });
// // // }

// // // class _TestimonialCard extends StatelessWidget {
// // //   final _Testimonial t;
// // //   const _TestimonialCard({required this.t, super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: BoxDecoration(
// // //         color: kCard,
// // //         borderRadius: BorderRadius.circular(16),
// // //         border: Border.all(color: kDivider),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               CircleAvatar(
// // //                 backgroundColor: t.color.withOpacity(0.2),
// // //                 radius: 22,
// // //                 child: Text(t.initials,
// // //                     style: TextStyle(
// // //                         color: t.color,
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 14)),
// // //               ),
// // //               const SizedBox(width: 12),
// // //               Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(t.name,
// // //                       style: const TextStyle(
// // //                           color: kText,
// // //                           fontWeight: FontWeight.bold,
// // //                           fontSize: 14)),
// // //                   Text(t.role,
// // //                       style: const TextStyle(color: kSubText, fontSize: 12)),
// // //                 ],
// // //               ),
// // //               const Spacer(),
// // //               Row(
// // //                 children: List.generate(
// // //                     5,
// // //                     (_) => const Icon(Icons.star,
// // //                         color: Color(0xFFFFC107), size: 14)),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 14),
// // //           Text(
// // //             '"${t.quote}"',
// // //             style: const TextStyle(
// // //                 color: kSubText, fontSize: 13, height: 1.6, fontStyle: FontStyle.italic),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ─── SECTION 6 : FAQ ──────────────────────────────────────────────────────────
// // // class FAQSection extends StatefulWidget {
// // //   const FAQSection({super.key});

// // //   @override
// // //   State<FAQSection> createState() => _FAQSectionState();
// // // }

// // // class _FAQSectionState extends State<FAQSection> {
// // //   int? _openIndex;

// // //   static const _faqs = [
// // //     _FAQ('What is Beat Flirt?',
// // //         'Beat Flirt is an all-in-one event management platform designed to help organizers manage bookings, schedules, guest lists, and event operations seamlessly from a single dashboard.'),
// // //     _FAQ('Who can use Beat Flirt?',
// // //         'Beat Flirt is ideal for event organizers, club & venue owners, DJs and party hosts, nightlife and social event planners.'),
// // //     _FAQ('Can I manage multiple events at once?',
// // //         'Yes, Beat Flirt allows you to manage multiple events simultaneously, including scheduling, attendee limits, and different event categories from one platform.'),
// // //     _FAQ('Can I customize the platform for my brand?',
// // //         'Yes, Beat Flirt supports customization such as branding, UI changes, and feature integrations based on your business needs.'),
// // //     _FAQ('Is there a free trial available?',
// // //         'Yes! We offer a demo session and trial period. Click "Request Demo" and our team will walk you through everything.'),
// // //     _FAQ('How secure are payments on Beat Flirt?',
// // //         'All payments are processed through industry-standard encrypted gateways. Your data and your customers\' data are always protected.'),
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return _SectionWrapper(
// // //       tag: 'FAQ',
// // //       title: 'Frequently Asked\nQuestions',
// // //       subtitle: 'Everything you need to know about using Beat Flirt.',
// // //       child: Column(
// // //         children: List.generate(_faqs.length, (i) {
// // //           final faq = _faqs[i];
// // //           final isOpen = _openIndex == i;
// // //           return GestureDetector(
// // //             onTap: () => setState(() => _openIndex = isOpen ? null : i),
// // //             child: AnimatedContainer(
// // //               duration: const Duration(milliseconds: 250),
// // //               margin: const EdgeInsets.only(bottom: 12),
// // //               padding: const EdgeInsets.all(16),
// // //               decoration: BoxDecoration(
// // //                 color: isOpen ? kPink.withOpacity(0.08) : kCard,
// // //                 borderRadius: BorderRadius.circular(14),
// // //                 border: Border.all(
// // //                     color: isOpen ? kPink.withOpacity(0.4) : kDivider),
// // //               ),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: Text(faq.question,
// // //                             style: TextStyle(
// // //                                 color: isOpen ? kPink : kText,
// // //                                 fontWeight: FontWeight.bold,
// // //                                 fontSize: 14)),
// // //                       ),
// // //                       Icon(
// // //                           isOpen
// // //                               ? Icons.keyboard_arrow_up
// // //                               : Icons.keyboard_arrow_down,
// // //                           color: isOpen ? kPink : kSubText),
// // //                     ],
// // //                   ),
// // //                   if (isOpen) ...[
// // //                     const SizedBox(height: 12),
// // //                     Text(faq.answer,
// // //                         style: const TextStyle(
// // //                             color: kSubText, fontSize: 13, height: 1.6)),
// // //                   ],
// // //                 ],
// // //               ),
// // //             ),
// // //           );
// // //         }),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _FAQ {
// // //   final String question, answer;
// // //   const _FAQ(this.question, this.answer);
// // // }

// // // // ─── SECTION 7 : EVENT REGISTRATION ──────────────────────────────────────────
// // // class RegistrationSection extends StatefulWidget {
// // //   const RegistrationSection({super.key});

// // //   @override
// // //   State<RegistrationSection> createState() => _RegistrationSectionState();
// // // }

// // // class _RegistrationSectionState extends State<RegistrationSection> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   final _nameCtrl = TextEditingController();
// // //   final _emailCtrl = TextEditingController();
// // //   final _phoneCtrl = TextEditingController();
// // //   final _eventCtrl = TextEditingController();
// // //   String _selectedCountry = 'India (+91)';
// // //   bool _subscribeNewsletter = false;
// // //   bool _submitted = false;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return _SectionWrapper(
// // //       tag: 'RESERVATION',
// // //       title: 'Event Registration',
// // //       subtitle: 'Register easily and manage your events seamlessly.',
// // //       child: _submitted
// // //           ? _buildSuccess()
// // //           : Form(
// // //               key: _formKey,
// // //               child: Column(
// // //                 children: [
// // //                   // Newsletter subscribe bar
// // //                   Container(
// // //                     padding: const EdgeInsets.all(16),
// // //                     decoration: BoxDecoration(
// // //                       gradient: const LinearGradient(
// // //                           colors: [Color(0xFF1A0A2E), Color(0xFF0D1A2E)]),
// // //                       borderRadius: BorderRadius.circular(16),
// // //                       border: Border.all(color: kDivider),
// // //                     ),
// // //                     child: Row(
// // //                       children: [
// // //                         const Expanded(
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: [
// // //                               Text('GET WEEKLY NEWSLETTERS',
// // //                                   style: TextStyle(
// // //                                       color: kText,
// // //                                       fontSize: 13,
// // //                                       fontWeight: FontWeight.bold,
// // //                                       letterSpacing: 1)),
// // //                               Text('Stay updated with upcoming events & offers.',
// // //                                   style:
// // //                                       TextStyle(color: kSubText, fontSize: 11)),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                         Switch(
// // //                           value: _subscribeNewsletter,
// // //                           onChanged: (v) =>
// // //                               setState(() => _subscribeNewsletter = v),
// // //                           activeColor: kPink,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 20),

// // //                   _buildField('Full Name', _nameCtrl, Icons.person_outline,
// // //                       validator: (v) =>
// // //                           v!.isEmpty ? 'Please enter your name' : null),
// // //                   const SizedBox(height: 14),
// // //                   _buildField(
// // //                       'Email Address', _emailCtrl, Icons.email_outlined,
// // //                       keyboardType: TextInputType.emailAddress,
// // //                       validator: (v) =>
// // //                           v!.contains('@') ? null : 'Enter a valid email'),
// // //                   const SizedBox(height: 14),

// // //                   // Country + Phone row
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         flex: 2,
// // //                         child: _buildDropdown(),
// // //                       ),
// // //                       const SizedBox(width: 10),
// // //                       Expanded(
// // //                         flex: 3,
// // //                         child: _buildField(
// // //                             'Phone Number', _phoneCtrl, Icons.phone_outlined,
// // //                             keyboardType: TextInputType.phone,
// // //                             validator: (v) =>
// // //                                 v!.isEmpty ? 'Enter phone number' : null),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 14),
// // //                   _buildField(
// // //                       'Event Name / Type', _eventCtrl, Icons.event_outlined,
// // //                       validator: (v) =>
// // //                           v!.isEmpty ? 'Please enter event name' : null),
// // //                   const SizedBox(height: 24),

// // //                   SizedBox(
// // //                     width: double.infinity,
// // //                     child: ElevatedButton(
// // //                       onPressed: () {
// // //                         if (_formKey.currentState!.validate()) {
// // //                           setState(() => _submitted = true);
// // //                         }
// // //                       },
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: kPink,
// // //                         shape: RoundedRectangleBorder(
// // //                             borderRadius: BorderRadius.circular(30)),
// // //                         padding: const EdgeInsets.symmetric(vertical: 16),
// // //                       ),
// // //                       child: const Text('BOOK NOW',
// // //                           style: TextStyle(
// // //                               color: Colors.white,
// // //                               fontWeight: FontWeight.bold,
// // //                               fontSize: 16,
// // //                               letterSpacing: 1.5)),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //     );
// // //   }

// // //   Widget _buildSuccess() {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           const SizedBox(height: 40),
// // //           Container(
// // //             width: 80,
// // //             height: 80,
// // //             decoration: BoxDecoration(
// // //               gradient: const LinearGradient(colors: [kPink, kPurple]),
// // //               shape: BoxShape.circle,
// // //             ),
// // //             child: const Icon(Icons.check, color: Colors.white, size: 44),
// // //           ),
// // //           const SizedBox(height: 24),
// // //           const Text('Registration Successful!',
// // //               style: TextStyle(
// // //                   color: kText, fontSize: 22, fontWeight: FontWeight.bold)),
// // //           const SizedBox(height: 12),
// // //           const Text(
// // //             'Thank you for registering!\nWe\'ll send confirmation details to your email.',
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(color: kSubText, fontSize: 14, height: 1.6),
// // //           ),
// // //           const SizedBox(height: 32),
// // //           _GradientButton(
// // //             label: 'Register Another',
// // //             onTap: () => setState(() => _submitted = false),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildField(
// // //     String hint,
// // //     TextEditingController ctrl,
// // //     IconData icon, {
// // //     TextInputType keyboardType = TextInputType.text,
// // //     String? Function(String?)? validator,
// // //   }) {
// // //     return TextFormField(
// // //       controller: ctrl,
// // //       keyboardType: keyboardType,
// // //       validator: validator,
// // //       style: const TextStyle(color: kText, fontSize: 14),
// // //       decoration: InputDecoration(
// // //         hintText: hint,
// // //         hintStyle: const TextStyle(color: kSubText),
// // //         prefixIcon: Icon(icon, color: kSubText, size: 20),
// // //         filled: true,
// // //         fillColor: kCard,
// // //         border: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(12),
// // //             borderSide: const BorderSide(color: kDivider)),
// // //         enabledBorder: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(12),
// // //             borderSide: const BorderSide(color: kDivider)),
// // //         focusedBorder: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(12),
// // //             borderSide: const BorderSide(color: kPink, width: 2)),
// // //         errorBorder: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(12),
// // //             borderSide: const BorderSide(color: Colors.redAccent)),
// // //         focusedErrorBorder: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(12),
// // //             borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDropdown() {
// // //     final countries = [
// // //       'India (+91)',
// // //       'USA (+1)',
// // //       'UK (+44)',
// // //       'UAE (+971)',
// // //       'Australia (+61)',
// // //       'Canada (+1)',
// // //       'Singapore (+65)',
// // //     ];
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 10),
// // //       decoration: BoxDecoration(
// // //         color: kCard,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: kDivider),
// // //       ),
// // //       child: DropdownButtonHideUnderline(
// // //         child: DropdownButton<String>(
// // //           value: _selectedCountry,
// // //           dropdownColor: kCard,
// // //           style: const TextStyle(color: kText, fontSize: 12),
// // //           icon: const Icon(Icons.arrow_drop_down, color: kSubText),
// // //           isExpanded: true,
// // //           items: countries
// // //               .map((c) =>
// // //                   DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
// // //               .toList(),
// // //           onChanged: (v) => setState(() => _selectedCountry = v!),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ─── SHARED WIDGETS ───────────────────────────────────────────────────────────

// // // class _SectionWrapper extends StatelessWidget {
// // //   final String tag, title, subtitle;
// // //   final Widget child;
// // //   const _SectionWrapper({
// // //     required this.tag,
// // //     required this.title,
// // //     required this.subtitle,
// // //     required this.child,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       color: kBg,
// // //       child: SafeArea(
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Container(
// // //                 padding:
// // //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
// // //                 decoration: BoxDecoration(
// // //                   color: kPink.withOpacity(0.1),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                   border: Border.all(color: kPink.withOpacity(0.3)),
// // //                 ),
// // //                 child: Text(tag,
// // //                     style: const TextStyle(
// // //                         color: kPink,
// // //                         fontSize: 11,
// // //                         fontWeight: FontWeight.bold,
// // //                         letterSpacing: 1.5)),
// // //               ),
// // //               const SizedBox(height: 14),
// // //               Text(title,
// // //                   style: const TextStyle(
// // //                       color: kText,
// // //                       fontSize: 26,
// // //                       fontWeight: FontWeight.w900,
// // //                       height: 1.2)),
// // //               const SizedBox(height: 10),
// // //               Text(subtitle,
// // //                   style:
// // //                       const TextStyle(color: kSubText, fontSize: 13, height: 1.6)),
// // //               const SizedBox(height: 28),
// // //               child,
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _GradientButton extends StatelessWidget {
// // //   final String label;
// // //   final VoidCallback? onTap;
// // //   final bool compact;
// // //   const _GradientButton(
// // //       {required this.label, this.onTap, this.compact = false});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return GestureDetector(
// // //       onTap: onTap ?? () {},
// // //       child: Container(
// // //         padding: compact
// // //             ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
// // //             : const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
// // //         decoration: BoxDecoration(
// // //           gradient: const LinearGradient(colors: [kPink, kPurple]),
// // //           borderRadius: BorderRadius.circular(30),
// // //           boxShadow: [
// // //             BoxShadow(
// // //                 color: kPink.withOpacity(0.4),
// // //                 blurRadius: 12,
// // //                 offset: const Offset(0, 4))
// // //           ],
// // //         ),
// // //         child: Text(label,
// // //             style: TextStyle(
// // //                 color: Colors.white,
// // //                 fontWeight: FontWeight.bold,
// // //                 fontSize: compact ? 13 : 15)),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:beatflirt/screens/login_page.dart';
// // import 'package:beatflirt/screens/register_page.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // // ─────────────────────────────────────────────────────────────────────────────
// // // ENTRY POINT
// // // ─────────────────────────────────────────────────────────────────────────────

// // // ─────────────────────────────────────────────────────────────────────────────
// // // COLORS
// // // ─────────────────────────────────────────────────────────────────────────────

// // const kBg      = Color(0xFF0D0D0D);
// // const kCard    = Color(0xFF1A1A2E);
// // const kPink    = Color(0xFFE91E8C);
// // const kPurple  = Color(0xFF9B27AF);
// // const kText    = Color(0xFFFFFFFF);
// // const kSubText = Color(0xFFB0B0C3);
// // const kDivider = Color(0xFF2A2A3E);
// // const kGreen   = Color(0xFF4CAF50);
// // const kRed     = Color(0xFFEF5350);
// // const kAmber   = Color(0xFFFFC107);

// // // ─────────────────────────────────────────────────────────────────────────────
// // // MODELS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class PlanModel {
// //   final String name, price, period, tag, fee;
// //   final List<String> features, missing;
// //   final Color color;
// //   final bool popular;
// //   const PlanModel({
// //     required this.name, required this.price, required this.period,
// //     required this.tag, required this.fee, required this.features,
// //     required this.missing, required this.color, required this.popular,
// //   });
// // }

// // class RegistrationFormState {
// //   final String name, email, phone, eventName, country;
// //   final bool subscribeNewsletter, isSubmitted, isLoading;
// //   const RegistrationFormState({
// //     this.name = '', this.email = '', this.phone = '',
// //     this.eventName = '', this.country = 'India (+91)',
// //     this.subscribeNewsletter = false,
// //     this.isSubmitted = false, this.isLoading = false,
// //   });
// //   RegistrationFormState copyWith({
// //     String? name, String? email, String? phone, String? eventName,
// //     String? country, bool? subscribeNewsletter, bool? isSubmitted, bool? isLoading,
// //   }) => RegistrationFormState(
// //     name: name ?? this.name, email: email ?? this.email,
// //     phone: phone ?? this.phone, eventName: eventName ?? this.eventName,
// //     country: country ?? this.country,
// //     subscribeNewsletter: subscribeNewsletter ?? this.subscribeNewsletter,
// //     isSubmitted: isSubmitted ?? this.isSubmitted,
// //     isLoading: isLoading ?? this.isLoading,
// //   );
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // RIVERPOD PROVIDERS
// // // ─────────────────────────────────────────────────────────────────────────────

// // final currentPageProvider    = StateProvider<int>((ref) => 0);
// // final selectedPlanProvider   = StateProvider<int>((ref) => 1);
// // final openFaqIndexProvider   = StateProvider<int?>((ref) => null);

// // // PageController as a provider so it persists and can be disposed cleanly
// // final pageControllerProvider = Provider.autoDispose<PageController>((ref) {
// //   final c = PageController();
// //   ref.onDispose(c.dispose);
// //   return c;
// // });

// // final registrationFormProvider =
// //     StateNotifierProvider<RegistrationFormNotifier, RegistrationFormState>(
// //       (ref) => RegistrationFormNotifier(),
// //     );

// // class RegistrationFormNotifier extends StateNotifier<RegistrationFormState> {
// //   RegistrationFormNotifier() : super(const RegistrationFormState());

// //   void updateName(String v)      => state = state.copyWith(name: v);
// //   void updateEmail(String v)     => state = state.copyWith(email: v);
// //   void updatePhone(String v)     => state = state.copyWith(phone: v);
// //   void updateEventName(String v) => state = state.copyWith(eventName: v);
// //   void updateCountry(String v)   => state = state.copyWith(country: v);
// //   void toggleNewsletter()        => state = state.copyWith(subscribeNewsletter: !state.subscribeNewsletter);
// //   void reset()                   => state = const RegistrationFormState();

// //   Future<void> submit(GlobalKey<FormState> formKey) async {
// //     if (!(formKey.currentState?.validate() ?? false)) return;
// //     state = state.copyWith(isLoading: true);
// //     await Future.delayed(const Duration(seconds: 2));
// //     state = state.copyWith(isLoading: false, isSubmitted: true);
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // STATIC DATA
// // // ─────────────────────────────────────────────────────────────────────────────

// // const List<PlanModel> kPlans = [
// //   PlanModel(
// //     name: 'Starter Nightlife', price: '\$99', period: '/month',
// //     tag: 'Best for small clubs & first-time organizers',
// //     fee: 'Platform Fee: 5% per ticket',
// //     features: ['Up to 50 Events / Month','Up to 1,000 Attendees / Month',
// //       'Club Page & Website','Ticket Sales & QR Check-In',
// //       'Door Payments (Card / UPI)','Guest List Management',
// //       'Speed Dating Module','User Profiles & Interests',
// //       "Who's Attending View",'3,000 Messages / Month','Basic Analytics & Reports'],
// //     missing: ['Private Chat & Ice-Breakers','VIP Table Reservations',
// //       'Community Groups & Feeds','Paid Memberships',
// //       'Multi-Day / Hotel Takeovers','Custom Branding','Priority Support','Celebrity Panel & Media'],
// //     color: Color(0xFF1565C0), popular: false,
// //   ),
// //   PlanModel(
// //     name: 'Social Club Pro', price: '\$199', period: '/month',
// //     tag: 'For premium clubs, mixers & speed dating events',
// //     fee: 'Platform Fee: 3% per ticket',
// //     features: ['Everything in Starter Plan','Up to 80 Events / Month',
// //       'Up to 5,000 Attendees / Month','Advanced Analytics',
// //       'Private Chat & Ice-Breakers','VIP Table Reservations',
// //       'Community Groups & Feeds','15,000 Messages / Month','Priority Support'],
// //     missing: ['Paid Memberships','Multi-Day / Hotel Takeovers','Custom Branding','Celebrity Panel & Media'],
// //     color: kPink, popular: true,
// //   ),
// //   PlanModel(
// //     name: 'Lifestyle Elite', price: '\$399', period: '/month',
// //     tag: 'For premium clubs, resorts & lifestyle communities',
// //     fee: 'Platform Fee: 1.5% per ticket',
// //     features: ['Everything in Social Club Pro','Unlimited Events','Unlimited Attendees',
// //       'Paid Memberships','Multi-Day / Hotel Takeovers','Custom Branding',
// //       'Celebrity Panel & Media','50,000 Messages / Month'],
// //     missing: [],
// //     color: kPurple, popular: false,
// //   ),
// // ];

// // const List<String> kCountries = [
// //   'India (+91)','USA (+1)','UK (+44)','UAE (+971)',
// //   'Australia (+61)','Canada (+1)','Singapore (+65)',
// //   'Germany (+49)','France (+33)','Japan (+81)','Brazil (+55)','South Africa (+27)',
// // ];

// // const List<Map<String, String>> kFaqs = [
// //   {'q':'What is Beat Flirt?','a':'Beat Flirt is an all-in-one event management platform designed to help organizers manage bookings, schedules, guest lists, and event operations seamlessly from a single dashboard.'},
// //   {'q':'Who can use Beat Flirt?','a':'Beat Flirt is ideal for event organizers, club & venue owners, DJs and party hosts, and nightlife / social event planners of all sizes.'},
// //   {'q':'Can I manage multiple events at once?','a':'Yes! Beat Flirt allows you to manage multiple events simultaneously — including scheduling, attendee limits, and different event categories — all from one platform.'},
// //   {'q':'Can I customize the platform for my brand?','a':'Absolutely. Beat Flirt supports full customization including branding, UI changes, white-label options, and feature integrations based on your business needs.'},
// //   {'q':'Is there a free trial available?','a':'Yes! We offer a demo session and a trial period. Click "Request Demo" and our team will walk you through the platform at no cost.'},
// //   {'q':'How secure are payments on Beat Flirt?','a':'All payments are processed through industry-standard encrypted gateways (PCI-DSS compliant). Your data and your customers\' data are always fully protected.'},
// // ];

// // const List<Map<String, dynamic>> kTestimonials = [
// //   {'name':'Elcia Petty','role':'Event Manager','initials':'EP','color':kPink,
// //     'quote':'Managing events has never been easier. This software provides all the tools we need to handle registrations, payments, and schedules without any hassle.'},
// //   {'name':'Enderson Will','role':'Club Owner','initials':'EW','color':kPurple,
// //     'quote':'We improved our event operations and customer experience significantly. It is reliable, easy to use, and helps us manage bookings efficiently.'},
// //   {'name':'Sushi Vega','role':'Party Host','initials':'SV','color':Color(0xFF1565C0),
// //     'quote':'A powerful solution for event organizers. The system is fast, secure, and user-friendly — helping us deliver successful events every single time.'},
// //   {'name':'Ferry Bush','role':'Venue Director','initials':'FB','color':Color(0xFF00897B),
// //     'quote':'This platform made managing our events simple and stress-free. From ticket bookings to attendee management, everything runs smoothly.'},
// // ];

// // const List<Map<String, dynamic>> kNavItems = [
// //   {'title': 'Home',         'icon': Icons.home_rounded},
// //   {'title': 'How It Works', 'icon': Icons.play_circle_outline_rounded},
// //   {'title': 'Features',     'icon': Icons.star_rounded},
// //   {'title': 'Pricing',      'icon': Icons.attach_money_rounded},
// //   {'title': 'Testimonials', 'icon': Icons.format_quote_rounded},
// //   {'title': 'FAQ',          'icon': Icons.help_outline_rounded},
// //   {'title': 'Register',     'icon': Icons.app_registration_rounded},
// // ];

// // // ─────────────────────────────────────────────────────────────────────────────
// // // MAIN LANDING PAGE
// // // ─────────────────────────────────────────────────────────────────────────────

// // // class BeatFlirtLandingPage extends ConsumerWidget {
// // //   const BeatFlirtLandingPage({super.key});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     return Scaffold(
// // //       backgroundColor: kBg,
// // //       drawer: const _BFDrawer(onNavigate: null),
// // //       body: Stack(
// // //         children: [
// // //           // ── Single scrollable view with all sections ────────────
// // //           SingleChildScrollView(
// // //             physics: const BouncingScrollPhysics(),
// // //             child: Column(
// // //               children: [
// // //                 HeroSection(onGetStarted: () {}),
// // //                 AboutUsSection(
// // //                   onBookNow: () {
// // //       // Scrolls smoothly to the Registration section
// // //       // You can improve this later with GlobalKey + ScrollController
// // //       // For now, this is a simple functional approach:
// // //       Scrollable.ensureVisible(
// // //         context,
// // //         duration: const Duration(milliseconds: 600),
// // //         curve: Curves.easeInOut,
// // //       );
// // //     },
// // //                 ),
// // //                 // const HowItWorksSection(),
// // //                 HowBeatFlirtWorksSection(
// // //                   onCreateEvents: () => _scrollToSection(context, featuresKey),
// // //                   onAcceptPayments: () => _scrollToSection(context, pricingKey),
// // //                   onGuestManagement: () => _scrollToSection(context, featuresKey),
// // //                   onTrackRevenue: () => _scrollToSection(context, pricingKey),
// // //                 ),
// // //                 // const FeaturesSection(),
// // //                 // const PricingSection(),
// // //                 // const TestimonialsSection(),
// // //                 // const FAQSection(),
// // //                 // const RegistrationSection(),
// // //                 FeaturesSection(key: featuresKey),
// // //                 PricingSection(key: pricingKey),
// // //                 TestimonialsSection(),
// // //                 FAQSection(),
// // //                 RegistrationSection(key: registrationKey),
// // //               ],
// // //             ),
// // //           ),

// // //           // ── Top Nav Bar ────────────────────────────────────────────
// // //           Positioned(
// // //             top: 0,
// // //             left: 0,
// // //             right: 0,
// // //             child: _BFNavBar(
// // //               currentPage: 0,
// // //               onNavigate: (_) {},
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // class BeatFlirtLandingPage extends ConsumerWidget {
// //   const BeatFlirtLandingPage({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     // === ADD THESE 3 LINES HERE ===
// //     final featuresKey = GlobalKey();
// //     final pricingKey = GlobalKey();
// //     final registrationKey = GlobalKey();

// //     // Helper function to scroll to a section
// //     void scrollToSection(GlobalKey key) {
// //       final ctx = key.currentContext;
// //       if (ctx != null) {
// //         Scrollable.ensureVisible(
// //           ctx,
// //           duration: const Duration(milliseconds: 700),
// //           curve: Curves.easeInOutCubic,
// //           alignment: 0.1,
// //         );
// //       }
// //     }

// //     return Scaffold(

// //       backgroundColor: kBg,

// //       // drawer: const _BFDrawer(onNavigate: null),
// //       body: Stack(
// //         children: [
// //           SingleChildScrollView(
// //             physics: const BouncingScrollPhysics(),
// //             child: Column(
// //               children: [
// //                 HeroSection(onGetStarted: () {}),

// //                 AboutUsSection(
// //                   onBookNow: () => scrollToSection(registrationKey),
// //                 ),

// //                 HowBeatFlirtWorksSection(
// //                   onCreateEvents: () => scrollToSection(featuresKey),
// //                   onAcceptPayments: () => scrollToSection(pricingKey),
// //                   onGuestManagement: () => scrollToSection(featuresKey),
// //                   onTrackRevenue: () => scrollToSection(pricingKey),
// //                 ),

// //                 FeaturesSection(key: featuresKey),
// //                 PricingSection(key: pricingKey),
// //                 TestimonialsSection(),
// //                 FAQSection(),
// //                 RegistrationSection(key: registrationKey),
// //               ],
// //             ),
// //           ),

// //           Positioned(
// //             top: 0,
// //             left: 0,
// //             right: 0,
// //             child: _BFNavBar(
// //               currentPage: 0,
// //               onNavigate: (_) {},
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // void _scrollToSection(BuildContext context, GlobalKey key) {
// //     final context = key.currentContext;
// //     if (context != null) {
// //       Scrollable.ensureVisible(
// //         context,
// //         duration: const Duration(milliseconds: 700),
// //         curve: Curves.easeInOutCubic,
// //         alignment: 0.1,
// //       );
// //     }
// //   }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SCROLLABLE PAGE WRAPPER
// // // Each page fills the screen.  The inner content is a SingleChildScrollView.
// // // When the user overscrolls past the bottom-edge → next page.
// // // When the user overscrolls past the top-edge    → previous page.
// // // We detect this via a NotificationListener on the ScrollController.
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ScrollablePage extends StatefulWidget {
// //   final int pageIndex;
// //   final Widget child;
// //   final VoidCallback? onScrolledToBottom;
// //   final VoidCallback? onScrolledToTop;

// //   const _ScrollablePage({
// //     required this.pageIndex,
// //     required this.child,
// //     required this.onScrolledToBottom,
// //     required this.onScrolledToTop,
// //   });

// //   @override
// //   State<_ScrollablePage> createState() => _ScrollablePageState();
// // }

// // class _ScrollablePageState extends State<_ScrollablePage> {
// //   late final ScrollController _sc;
// //   bool _bottomFired = false;
// //   bool _topFired    = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _sc = ScrollController();
// //     _sc.addListener(_onScroll);
// //   }

// //   @override
// //   void dispose() {
// //     _sc.removeListener(_onScroll);
// //     _sc.dispose();
// //     super.dispose();
// //   }

// //   void _onScroll() {
// //     if (!_sc.hasClients) return;
// //     final pos = _sc.position;
// //     final atBottom = pos.pixels >= pos.maxScrollExtent - 10;
// //     final atTop = pos.pixels <= pos.minScrollExtent + 10;

// //     // ── BOTTOM DETECTION ───────────────────────────────────────────
// //     if (atBottom && widget.onScrolledToBottom != null) {
// //       if (!_bottomFired) {
// //         _bottomFired = true;
// //         _topFired = false;
// //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //           if (mounted) widget.onScrolledToBottom!();
// //         });
// //       }
// //     } else if (!atBottom) {
// //       _bottomFired = false;
// //     }

// //     // ── TOP DETECTION ──────────────────────────────────────────────
// //     if (atTop && widget.onScrolledToTop != null) {
// //       // Trigger when at top AND (scrolling up OR overscrolling)
// //       final scrollingUp = pos.userScrollDirection == ScrollDirection.forward;
// //       final overscrolling = pos.outOfRange && pos.pixels < 0;

// //       if ((scrollingUp || overscrolling) && !_topFired) {
// //         _topFired = true;
// //         _bottomFired = false;
// //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //           if (mounted) widget.onScrolledToTop!();
// //         });
// //       }
// //     } else if (!atTop) {
// //       _topFired = false;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox.expand(
// //       child: NotificationListener<ScrollNotification>(
// //         onNotification: (notification) {
// //           // Trigger scroll detection on any scroll notification
// //           if (notification is ScrollUpdateNotification ||
// //               notification is OverscrollNotification) {
// //             _onScroll();
// //           }
// //           return false;
// //         },
// //         child: SingleChildScrollView(
// //           controller: _sc,
// //           physics: const BouncingScrollPhysics(
// //             parent: AlwaysScrollableScrollPhysics(),
// //           ),
// //           child: widget.child,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // NAV BAR
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _BFNavBar extends StatelessWidget {
// //   final int currentPage;
// //   final void Function(int) onNavigate;
// //   const _BFNavBar({required this.currentPage, required this.onNavigate});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.only(
// //         top: MediaQuery.of(context).padding.top,
// //         left: 16, right: 16, bottom: 12,
// //       ),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //           colors: [kBg, kBg.withOpacity(0)],
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           const _BFLogo(),
// //           const Spacer(),
// //           // // Login Button
// //           // TextButton(
// //           //   onPressed: () {},
// //           //   child: const Text(
// //           //     'Login',
// //           //     style: TextStyle(color: kText, fontSize: 14),
// //           //   ),
// //           // ),
// //           // const SizedBox(width: 12),
// //           // // Signup Button
// //           // _GradientButton(label: 'Sign Up', onTap: () {}, compact: true),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DRAWER
// // // ─────────────────────────────────────────────────────────────────────────────

// // // class _BFDrawer extends ConsumerWidget {
// // //   final void Function(int)? onNavigate;
// // //   const _BFDrawer({this.onNavigate});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     return Drawer(
// // //       backgroundColor: kCard,
// // //       child: SafeArea(
// // //         child: Column(
// // //           children: [
// // //             const SizedBox(height: 24),
// // //             const _BFLogo(large: true),
// // //             const SizedBox(height: 32),
// // //             Expanded(
// // //               child: ListView.builder(
// // //                 itemCount: kNavItems.length,
// // //                 itemBuilder: (_, i) {
// // //                   return ListTile(
// // //                     leading: Icon(kNavItems[i]['icon'] as IconData, color: kSubText),
// // //                     title: Text(kNavItems[i]['title'] as String,
// // //                         style: const TextStyle(color: kText)),
// // //                     onTap: onNavigate != null
// // //                         ? () {
// // //                             Navigator.pop(context);
// // //                             onNavigate!(i);
// // //                           }
// // //                         : null,
// // //                   );
// // //                 },
// // //               ),
// // //             ),
// // //             Padding(
// // //               padding: const EdgeInsets.all(16),
// // //               child: _GradientButton(
// // //                 label: 'Book Now',
// // //                 onTap: onNavigate != null ? () => onNavigate!(6) : null,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION 1 — HERO
// // // ─────────────────────────────────────────────────────────────────────────────

// // class HeroSection extends StatelessWidget {
// //   final VoidCallback onGetStarted;
// //   const HeroSection({super.key, required this.onGetStarted});

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenHeight = MediaQuery.of(context).size.height;
// //     return Container(
// //       constraints: BoxConstraints(minHeight: screenHeight),
// //       decoration: const BoxDecoration(
// //         gradient: RadialGradient(
// //           center: Alignment(0, -0.3),
// //           radius: 1.2,
// //           colors: [Color(0xFF2D0A3E), kBg],
// //         ),
// //       ),
// //       child: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.fromLTRB(24, 80, 24, 60),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               // const SizedBox(height: 24),
// //               const SizedBox(height: 12),
// //               Text('Beat Flirt',
// //             style: TextStyle(color: kText, fontSize: 30,
// //                 fontWeight: FontWeight.bold, letterSpacing: 1,
// //                 shadows: [
// //               const Shadow(
// //                 blurRadius: 8,
// //                 color: Colors.pink,
// //                 offset: Offset(0, 0),
// //               ),
// //               const Shadow(
// //                 blurRadius: 16,
// //                 color: Colors.pink,
// //                 offset: Offset(0, 0),
// //               ),
// //               Shadow(
// //                 blurRadius: 24,
// //                 color: Colors.pink.withValues(alpha: 0.7),
// //                 offset: const Offset(0, 0),
// //               ),
// //               Shadow(
// //                 blurRadius: 32,
// //                 color: Colors.pink.withValues(alpha: 0.8),
// //                 offset: const Offset(0, 0),
// //               ),
// //               Shadow(
// //                 blurRadius: 40,
// //                 color: Colors.pink.withValues(alpha: 0.8),
// //                 offset: const Offset(0, 0),
// //               ),Shadow(
// //                 blurRadius: 48,
// //                 color: Colors.pink.withValues(alpha: 0.8),
// //                 offset: const Offset(0, 0),
// //               ),

// //             ],)

// //                 ),
// //                 const SizedBox(height: 20),
// //               // Badge
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: kPink.withOpacity(0.5)),
// //                   borderRadius: BorderRadius.circular(20),
// //                   color: kPink.withOpacity(0.08),
// //                 ),
// //                 child: const Text(
// //                   '🎉  The All-in-One Platform for Events, Nightlife & Dating',
// //                   style: TextStyle(color: kPink, fontSize: 12),
// //                   textAlign: TextAlign.center,
// //                 ),
// //               ),
// //               const SizedBox(height: 28),
// //               const FittedBox(
// //                 child: Text(
// //                 'EVENT\nMANAGEMENT\nSOFTWARE',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(color: kText, fontSize: 40,
// //                     fontWeight: FontWeight.w900, height: 1.1, letterSpacing: 2),
// //               ),
// //               ),
// //               // const SizedBox(height: 12),
// //               // ShaderMask(
// //               //   shaderCallback: (b) =>
// //               //       const LinearGradient(colors: [kPink, kPurple]).createShader(b),
// //               //   child: const Text('Beat Flirt',
// //               //       style: TextStyle(color: Colors.white, fontSize: 36,
// //               //           fontWeight: FontWeight.w900, letterSpacing: 3)),
// //               // ),
// //               const SizedBox(height: 20),
// //               // const Text(
// //               //   'Manage your events easily with our smart software solution.\nSecure bookings, smart scheduling & seamless engagement.',
// //               //   textAlign: TextAlign.center,
// //               //   style: TextStyle(color: kSubText, fontSize: 14, height: 1.7),
// //               // ),
// //               const Text(
// //                 'Manage your events easily with our smart software solution.',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(color: kSubText, fontSize: 14, height: 1.7),
// //               ),
// //               const SizedBox(height: 36),
// //               Wrap(
// //                 alignment: WrapAlignment.center,
// //                 spacing: 16, runSpacing: 12,
// //                 children: [
// //                   _GradientButton(label: 'Get Started', onTap: onGetStarted),
// //                   OutlinedButton(
// //                     onPressed: () => _showDemoDialog(context),
// //                     style: OutlinedButton.styleFrom(
// //                       side: const BorderSide(color: kPink),
// //                       shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(30)),
// //                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
// //                     ),
// //                     child: const Text('Request Demo', style: TextStyle(color: kPink)),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 56),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: const [
// //                   _StatChip(value: '50+',  label: 'Events/mo'),
// //                   _StatChip(value: '5K+',  label: 'Attendees'),
// //                   _StatChip(value: '99%',  label: 'Uptime'),
// //                   _StatChip(value: '24/7', label: 'Support'),
// //                 ],
// //               ),
// //               const SizedBox(height: 40),
// //               Wrap(
// //                 spacing: 10, runSpacing: 10,
// //                 alignment: WrapAlignment.center,
// //                 children: const [
// //                   _Pill(icon: Icons.confirmation_number_rounded, label: 'Secure Ticketing'),
// //                   _Pill(icon: Icons.qr_code_scanner_rounded,     label: 'QR Check-In'),
// //                   _Pill(icon: Icons.star_rounded,                 label: 'VIP Memberships'),
// //                   _Pill(icon: Icons.favorite_rounded,             label: 'Speed Dating'),
// //                   _Pill(icon: Icons.analytics_rounded,            label: 'Live Analytics'),
// //                   _Pill(icon: Icons.hotel_rounded,                label: 'Hotel Booking'),
// //                 ],
// //               ),
// //               const SizedBox(height: 40),
// //               // Visual scroll-more hint at the bottom of hero content
// //               Column(
// //                 children: [
// //                   Text('Scroll to explore',
// //                       style: TextStyle(color: kSubText.withOpacity(0.5), fontSize: 11)),
// //                   const SizedBox(height: 6),
// //                   const Icon(Icons.keyboard_arrow_down_rounded, color: kPink, size: 24),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void _showDemoDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         backgroundColor: kCard,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: const Text('Request a Demo',
// //             style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
// //         content: const Text(
// //           'Our team will reach out to you within 24 hours to schedule a personalized demo.\n\nPlease register below and we\'ll contact you!',
// //           style: TextStyle(color: kSubText, height: 1.6),
// //         ),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context),
// //               child: const Text('Cancel', style: TextStyle(color: kSubText))),
// //           _GradientButton(label: 'OK, Got It',
// //               onTap: () => Navigator.pop(context), compact: true),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION 2 — HOW IT WORKS
// // // ─────────────────────────────────────────────────────────────────────────────

// // // class HowItWorksSection extends StatelessWidget {
// // //   const HowItWorksSection({super.key});

// // //   static const _steps = [
// // //     _StepData(icon: Icons.add_circle_outline_rounded, title: 'Create Events',
// // //         desc: 'Set up your event in minutes — add details, set capacity, ticket pricing, and publish instantly.', color: kPink),
// // //     _StepData(icon: Icons.payment_rounded, title: 'Accept Payments',
// // //         desc: 'Collect payments seamlessly via Card, UPI, and multiple payment gateways with full security.', color: kPurple),
// // //     _StepData(icon: Icons.people_outline_rounded, title: 'Guest Management',
// // //         desc: 'Manage guest lists, check-ins, VIP tables, and attendee data from one smart dashboard.', color: Color(0xFF1565C0)),
// // //     _StepData(icon: Icons.bar_chart_rounded, title: 'Track Revenue',
// // //         desc: 'Monitor ticket sales, revenue, and attendance in real time with powerful analytics tools.', color: Color(0xFF00897B)),
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return _SectionContent(
// // //       tag: 'HOW IT WORKS',
// // //       title: 'Launch, Manage & Grow\nYour Events',
// // //       subtitle: 'From ticket creation to real-time insights — Beat Flirt handles everything.',
// // //       child: Column(
// // //         children: List.generate(_steps.length, (i) {
// // //           final s = _steps[i];
// // //           return Container(
// // //             margin: const EdgeInsets.only(bottom: 16),
// // //             padding: const EdgeInsets.all(20),
// // //             decoration: BoxDecoration(
// // //               color: kCard, borderRadius: BorderRadius.circular(16),
// // //               border: Border.all(color: kDivider),
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Container(
// // //                   width: 52, height: 52,
// // //                   decoration: BoxDecoration(
// // //                     color: s.color.withOpacity(0.15),
// // //                     borderRadius: BorderRadius.circular(14),
// // //                   ),
// // //                   child: Icon(s.icon, color: s.color, size: 26),
// // //                 ),
// // //                 const SizedBox(width: 16),
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(s.title,
// // //                           style: const TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.bold)),
// // //                       const SizedBox(height: 4),
// // //                       Text(s.desc,
// // //                           style: const TextStyle(color: kSubText, fontSize: 13, height: 1.5)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 12),
// // //                 Container(
// // //                   width: 30, height: 30,
// // //                   decoration: BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     border: Border.all(color: s.color, width: 2),
// // //                   ),
// // //                   child: Center(
// // //                     child: Text('${i + 1}',
// // //                         style: TextStyle(color: s.color, fontWeight: FontWeight.bold, fontSize: 13)),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           );
// // //         }),
// // //       ),
// // //     );
// // //   }
// // // }

// // class _StepData {
// //   final IconData icon;
// //   final String title, desc;
// //   final Color color;
// //   const _StepData({required this.icon, required this.title, required this.desc, required this.color});
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION 3 — FEATURES
// // // ─────────────────────────────────────────────────────────────────────────────

// // class FeaturesSection extends StatelessWidget {
// //   const FeaturesSection({super.key});

// //   static const _features = [
// //     _FeatureData(Icons.confirmation_number_rounded, 'Secure Ticketing',
// //         'Sell tickets with full fraud protection and QR validation at entry.'),
// //     _FeatureData(Icons.star_border_rounded, 'VIP Memberships',
// //         'Create exclusive VIP tiers with premium perks and table reservations.'),
// //     _FeatureData(Icons.account_balance_wallet_rounded, 'Integrated Payments',
// //         'Accept Card, UPI, and global payment methods with instant payouts.'),
// //     _FeatureData(Icons.forum_outlined, 'Customer Engagement',
// //         'Send campaigns, push notifications, and keep your audience connected.'),
// //     _FeatureData(Icons.calendar_today_rounded, 'Event Management',
// //         'Manage schedules, vendors, and operations all from one dashboard.'),
// //     _FeatureData(Icons.hotel_rounded, 'Hotel Booking',
// //         'Offer multi-day event packages with integrated hotel accommodations.'),
// //     _FeatureData(Icons.branding_watermark_rounded, 'Custom Branding',
// //         'White-label the platform with your logo, colors, and custom domain.'),
// //     _FeatureData(Icons.favorite_rounded, 'Speed Dating',
// //         'Run structured speed dating rounds with smart matchmaking algorithms.'),
// //     _FeatureData(Icons.campaign_rounded, 'Marketing & Promos',
// //         'Run targeted promotions, discount codes, and influencer campaigns.'),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return _SectionContent(

// //       tag: 'FEATURES',
// //       title: 'Everything You Need\nIn One Platform',
// //       subtitle: 'Powerful tools built for modern event organizers.',
// //       child: GridView.builder(
// //         shrinkWrap: true,
// //         physics: const NeverScrollableScrollPhysics(),
// //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2, crossAxisSpacing: 12,
// //           mainAxisSpacing: 12, childAspectRatio: 0.92,
// //         ),
// //         itemCount: _features.length,
// //         itemBuilder: (_, i) => _FeatureCard(feature: _features[i]),
// //       ),
// //     );
// //   }
// // }

// // class _FeatureData {
// //   final IconData icon;
// //   final String title, desc;
// //   const _FeatureData(this.icon, this.title, this.desc);
// // }

// // class _FeatureCard extends StatelessWidget {
// //   final _FeatureData feature;
// //   const _FeatureCard({required this.feature, super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: kCard, borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: kDivider),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               gradient: const LinearGradient(
// //                   colors: [kPink, kPurple],
// //                   begin: Alignment.topLeft, end: Alignment.bottomRight),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Icon(feature.icon, color: Colors.white, size: 22),
// //           ),
// //           const SizedBox(height: 12),
// //           Text(feature.title,
// //               maxLines: 2,
// //               overflow: TextOverflow.ellipsis,
// //               style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 6),
// //           Expanded(
// //             child: Text(feature.desc,
// //                 maxLines: 3,
// //                 overflow: TextOverflow.ellipsis,
// //                 style: const TextStyle(color: kSubText, fontSize: 11, height: 1.5)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION 4 — PRICING
// // // ─────────────────────────────────────────────────────────────────────────────

// // class PricingSection extends ConsumerWidget {
// //   const PricingSection({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final selected = ref.watch(selectedPlanProvider);
// //     final plan     = kPlans[selected];

// //     return _SectionContent(
// //       tag: 'PRICING',
// //       title: 'Choose the Perfect\nPlan for You',
// //       subtitle: 'Flexible plans for every organizer — from first-timers to elite brands.',
// //       child: Column(
// //         children: [
// //           // Plan tabs
// //           Container(
// //             decoration: BoxDecoration(
// //               color: kCard, borderRadius: BorderRadius.circular(30),
// //               border: Border.all(color: kDivider),
// //             ),
// //             padding: const EdgeInsets.all(4),
// //             child: Row(
// //               children: List.generate(kPlans.length, (i) {
// //                 final isSelected = selected == i;
// //                 return Expanded(
// //                   child: GestureDetector(
// //                     onTap: () => ref.read(selectedPlanProvider.notifier).state = i,
// //                     child: AnimatedContainer(
// //                       duration: const Duration(milliseconds: 250),
// //                       padding: const EdgeInsets.symmetric(vertical: 10),
// //                       decoration: BoxDecoration(
// //                         gradient: isSelected
// //                             ? LinearGradient(colors: [kPlans[i].color, kPurple])
// //                             : null,
// //                         borderRadius: BorderRadius.circular(26),
// //                       ),
// //                       child: Text(
// //                         kPlans[i].name,
// //                         textAlign: TextAlign.center,
// //                         style: TextStyle(
// //                           color: isSelected ? kText : kSubText,
// //                           fontSize: 10,
// //                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               }),
// //             ),
// //           ),
// //           const SizedBox(height: 20),

// //           // Plan card
// //           AnimatedSwitcher(
// //             duration: const Duration(milliseconds: 300),
// //             transitionBuilder: (child, anim) => FadeTransition(
// //               opacity: anim,
// //               child: SlideTransition(
// //                 position: Tween<Offset>(
// //                     begin: const Offset(0, 0.04), end: Offset.zero)
// //                     .animate(anim),
// //                 child: child,
// //               ),
// //             ),
// //             child: _PlanCard(plan: plan, key: ValueKey(selected)),
// //           ),

// //           const SizedBox(height: 16),

// //           // White-label teaser
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: kCard, borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: kPink.withOpacity(0.3)),
// //             ),
// //             child: Row(
// //               children: [
// //                 const Icon(Icons.business_rounded, color: kPink, size: 28),
// //                 const SizedBox(width: 12),
// //                 const Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text('White-Label',
// //                           style: TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
// //                       Text('Custom pricing for large brands & international expansion.',
// //                           style: TextStyle(color: kSubText, fontSize: 12)),
// //                     ],
// //                   ),
// //                 ),
// //                 OutlinedButton(
// //                   onPressed: () => _showContactDialog(context),
// //                   style: OutlinedButton.styleFrom(
// //                     side: const BorderSide(color: kPink),
// //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //                   ),
// //                   child: const Text('Contact Us', style: TextStyle(color: kPink, fontSize: 12)),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(height: 16),

// //           // Add-ons
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: kCard, borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: kDivider),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text('Optional Add-On Modules',
// //                     style: TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
// //                 const SizedBox(height: 12),
// //                 ...[
// //                   ('Speed Dating Add-On (per event)', '\$49'),
// //                   ('Featured Event Listing', '\$29 / event'),
// //                   ('Extra Messaging Pack (10k messages)', '\$25'),
// //                   ('SMS + WhatsApp Campaign Pack', '\$39'),
// //                   ('Advanced Matchmaking AI', '\$79 / month'),
// //                 ].map((e) => Padding(
// //                   padding: const EdgeInsets.only(bottom: 8),
// //                   child: Row(
// //                     children: [
// //                       const Icon(Icons.add_circle_outline_rounded, color: kPink, size: 16),
// //                       const SizedBox(width: 8),
// //                       Expanded(child: Text(e.$1, style: const TextStyle(color: kSubText, fontSize: 12))),
// //                       Text(e.$2, style: const TextStyle(color: kPink, fontSize: 12, fontWeight: FontWeight.bold)),
// //                     ],
// //                   ),
// //                 )),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showContactDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         backgroundColor: kCard,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: const Text('White-Label Enquiry',
// //             style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
// //         content: const Text(
// //           'For custom white-label pricing and enterprise solutions, please reach out to our sales team.\n\n📧 sales@beatflirtevent.com\n📞 +1 (800) BEAT-FLT',
// //           style: TextStyle(color: kSubText, height: 1.7),
// //         ),
// //         actions: [
// //           _GradientButton(label: 'Got It',
// //               onTap: () => Navigator.pop(context), compact: true),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _PlanCard extends StatelessWidget {
// //   final PlanModel plan;
// //   const _PlanCard({required this.plan, super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: kCard, borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: plan.popular ? kPink : kDivider,
// //             width: plan.popular ? 2 : 1),
// //         boxShadow: plan.popular
// //             ? [BoxShadow(color: kPink.withOpacity(0.15), blurRadius: 20)]
// //             : null,
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           if (plan.popular)
// //             Container(
// //               margin: const EdgeInsets.only(bottom: 12),
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(colors: [kPink, kPurple]),
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: const Text('MOST POPULAR',
// //                   style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
// //             ),
// //           Text(plan.name,
// //               style: const TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 4),
// //           Text(plan.tag, style: const TextStyle(color: kSubText, fontSize: 12)),
// //           const SizedBox(height: 16),
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Text(plan.price,
// //                   style: TextStyle(color: plan.color, fontSize: 40, fontWeight: FontWeight.w900)),
// //               Padding(
// //                 padding: const EdgeInsets.only(bottom: 6),
// //                 child: Text(plan.period, style: const TextStyle(color: kSubText, fontSize: 14)),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 4),
// //           Text(plan.fee, style: const TextStyle(color: kPink, fontSize: 12)),
// //           const SizedBox(height: 16),
// //           const Divider(color: kDivider),
// //           const SizedBox(height: 12),
// //           ...plan.features.map((f) => Padding(
// //             padding: const EdgeInsets.only(bottom: 9),
// //             child: Row(
// //               children: [
// //                 const Icon(Icons.check_circle_rounded, color: kGreen, size: 16),
// //                 const SizedBox(width: 8),
// //                 Expanded(child: Text(f, style: const TextStyle(color: kText, fontSize: 13))),
// //               ],
// //             ),
// //           )),
// //           if (plan.missing.isNotEmpty) ...[
// //             const SizedBox(height: 4),
// //             ...plan.missing.map((m) => Padding(
// //               padding: const EdgeInsets.only(bottom: 9),
// //               child: Row(
// //                 children: [
// //                   const Icon(Icons.cancel_rounded, color: kRed, size: 16),
// //                   const SizedBox(width: 8),
// //                   Expanded(child: Text(m, style: const TextStyle(color: kSubText, fontSize: 13))),
// //                 ],
// //               ),
// //             )),
// //           ],
// //           const SizedBox(height: 20),
// //           SizedBox(
// //             width: double.infinity,
// //             child: ElevatedButton(
// //               onPressed: () {},
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: plan.color,
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// //                 padding: const EdgeInsets.symmetric(vertical: 14),
// //                 elevation: 4,
// //               ),
// //               child: const Text('Get Started',
// //                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION 5 — TESTIMONIALS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class TestimonialsSection extends StatelessWidget {
// //   const TestimonialsSection({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return _SectionContent(
// //       tag: 'TESTIMONIALS',
// //       title: 'What Our Customers\nAre Saying',
// //       subtitle: 'Trusted by event organizers and nightlife professionals worldwide.',
// //       child: Column(
// //         children: kTestimonials.map((t) => Padding(
// //           padding: const EdgeInsets.only(bottom: 16),
// //           child: _TestimonialCard(data: t),
// //         )).toList(),
// //       ),
// //     );
// //   }
// // }

// // class _TestimonialCard extends StatelessWidget {
// //   final Map<String, dynamic> data;
// //   const _TestimonialCard({required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: kCard, borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: kDivider),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               CircleAvatar(
// //                 backgroundColor: (data['color'] as Color).withOpacity(0.2),
// //                 radius: 22,
// //                 child: Text(data['initials'] as String,
// //                     style: TextStyle(
// //                         color: data['color'] as Color,
// //                         fontWeight: FontWeight.bold, fontSize: 14)),
// //               ),
// //               const SizedBox(width: 12),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(data['name'] as String,
// //                         style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
// //                     Text(data['role'] as String,
// //                         style: const TextStyle(color: kSubText, fontSize: 12)),
// //                   ],
// //                 ),
// //               ),
// //               Row(children: List.generate(5,
// //                   (_) => const Icon(Icons.star_rounded, color: kAmber, size: 14))),
// //             ],
// //           ),
// //           const SizedBox(height: 14),
// //           Text('"${data['quote']}"',
// //               style: const TextStyle(color: kSubText, fontSize: 13,
// //                   height: 1.6, fontStyle: FontStyle.italic)),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION 6 — FAQ
// // // ─────────────────────────────────────────────────────────────────────────────

// // class FAQSection extends ConsumerWidget {
// //   const FAQSection({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final openIndex = ref.watch(openFaqIndexProvider);

// //     return _SectionContent(
// //       tag: 'FAQ',
// //       title: 'Frequently Asked\nQuestions',
// //       subtitle: 'Everything you need to know about using Beat Flirt.',
// //       child: Column(
// //         children: List.generate(kFaqs.length, (i) {
// //           final faq    = kFaqs[i];
// //           final isOpen = openIndex == i;
// //           return GestureDetector(
// //             onTap: () =>
// //                 ref.read(openFaqIndexProvider.notifier).state = isOpen ? null : i,
// //             child: AnimatedContainer(
// //               duration: const Duration(milliseconds: 250),
// //               margin: const EdgeInsets.only(bottom: 12),
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: isOpen ? kPink.withOpacity(0.08) : kCard,
// //                 borderRadius: BorderRadius.circular(14),
// //                 border: Border.all(
// //                     color: isOpen ? kPink.withOpacity(0.4) : kDivider),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: Text(faq['q']!,
// //                             style: TextStyle(
// //                                 color: isOpen ? kPink : kText,
// //                                 fontWeight: FontWeight.bold, fontSize: 14)),
// //                       ),
// //                       AnimatedRotation(
// //                         turns: isOpen ? 0.5 : 0,
// //                         duration: const Duration(milliseconds: 250),
// //                         child: Icon(Icons.keyboard_arrow_down_rounded,
// //                             color: isOpen ? kPink : kSubText),
// //                       ),
// //                     ],
// //                   ),
// //                   AnimatedCrossFade(
// //                     firstChild: const SizedBox.shrink(),
// //                     secondChild: Padding(
// //                       padding: const EdgeInsets.only(top: 12),
// //                       child: Text(faq['a']!,
// //                           style: const TextStyle(
// //                               color: kSubText, fontSize: 13, height: 1.6)),
// //                     ),
// //                     crossFadeState: isOpen
// //                         ? CrossFadeState.showSecond
// //                         : CrossFadeState.showFirst,
// //                     duration: const Duration(milliseconds: 250),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         }),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION 7 — REGISTRATION
// // // ─────────────────────────────────────────────────────────────────────────────

// // class RegistrationSection extends ConsumerStatefulWidget {
// //   const RegistrationSection({super.key});

// //   @override
// //   ConsumerState<RegistrationSection> createState() => _RegistrationSectionState();
// // }

// // class _RegistrationSectionState extends ConsumerState<RegistrationSection> {
// //   final _formKey = GlobalKey<FormState>();
// //   late final TextEditingController _nameCtrl, _emailCtrl, _phoneCtrl, _eventCtrl;

// //   @override
// //   void initState() {
// //     super.initState();
// //     final fs = ref.read(registrationFormProvider);
// //     _nameCtrl  = TextEditingController(text: fs.name);
// //     _emailCtrl = TextEditingController(text: fs.email);
// //     _phoneCtrl = TextEditingController(text: fs.phone);
// //     _eventCtrl = TextEditingController(text: fs.eventName);

// //     final n = ref.read(registrationFormProvider.notifier);
// //     _nameCtrl .addListener(() => n.updateName(_nameCtrl.text));
// //     _emailCtrl.addListener(() => n.updateEmail(_emailCtrl.text));
// //     _phoneCtrl.addListener(() => n.updatePhone(_phoneCtrl.text));
// //     _eventCtrl.addListener(() => n.updateEventName(_eventCtrl.text));
// //   }

// //   @override
// //   void dispose() {
// //     _nameCtrl.dispose(); _emailCtrl.dispose();
// //     _phoneCtrl.dispose(); _eventCtrl.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final form     = ref.watch(registrationFormProvider);
// //     final notifier = ref.read(registrationFormProvider.notifier);

// //     return _SectionContent(
// //       tag: 'RESERVATION',
// //       title: 'Event Registration',
// //       subtitle: 'Register easily and manage your events seamlessly.',
// //       child: form.isSubmitted ? _buildSuccess(notifier) : _buildForm(form, notifier),
// //     );
// //   }

// //   Widget _buildSuccess(RegistrationFormNotifier notifier) {
// //     return Center(
// //       child: Column(
// //         children: [
// //           const SizedBox(height: 32),
// //           Container(
// //             width: 90, height: 90,
// //             decoration: const BoxDecoration(
// //                 gradient: LinearGradient(colors: [kPink, kPurple]),
// //                 shape: BoxShape.circle),
// //             child: const Icon(Icons.check_rounded, color: Colors.white, size: 50),
// //           ),
// //           const SizedBox(height: 24),
// //           const Text('Registration Successful!',
// //               style: TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold),
// //               textAlign: TextAlign.center),
// //           const SizedBox(height: 12),
// //           const Text(
// //             "Thank you for registering!\nWe'll send confirmation details to your email shortly.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(color: kSubText, fontSize: 14, height: 1.6),
// //           ),
// //           const SizedBox(height: 32),
// //           _GradientButton(
// //             label: 'Register Another',
// //             onTap: () {
// //               notifier.reset();
// //               _nameCtrl.clear(); _emailCtrl.clear();
// //               _phoneCtrl.clear(); _eventCtrl.clear();
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildForm(RegistrationFormState form, RegistrationFormNotifier notifier) {
// //     return Form(
// //       key: _formKey,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Newsletter toggle
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               gradient: const LinearGradient(
// //                   colors: [Color(0xFF1A0A2E), Color(0xFF0D1A2E)]),
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: kDivider),
// //             ),
// //             child: Row(
// //               children: [
// //                 const Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text('GET WEEKLY NEWSLETTERS',
// //                           style: TextStyle(color: kText, fontSize: 13,
// //                               fontWeight: FontWeight.bold, letterSpacing: 1)),
// //                       SizedBox(height: 4),
// //                       Text('Stay updated with upcoming events & special offers.',
// //                           style: TextStyle(color: kSubText, fontSize: 11)),
// //                     ],
// //                   ),
// //                 ),
// //                 Switch(
// //                   value: form.subscribeNewsletter,
// //                   onChanged: (_) => notifier.toggleNewsletter(),
// //                   activeColor: kPink,
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 20),

// //           _buildField(controller: _nameCtrl, hint: 'Full Name',
// //               icon: Icons.person_outline_rounded, keyboardType: TextInputType.name,
// //               validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your full name' : null),
// //           const SizedBox(height: 14),

// //           _buildField(controller: _emailCtrl, hint: 'Email Address',
// //               icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
// //               validator: (v) {
// //                 if (v == null || v.trim().isEmpty) return 'Email is required';
// //                 if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim()))
// //                   return 'Enter a valid email address';
// //                 return null;
// //               }),
// //           const SizedBox(height: 14),

// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(flex: 2, child: _buildCountryDropdown(form, notifier)),
// //               const SizedBox(width: 10),
// //               Expanded(flex: 3,
// //                 child: _buildField(controller: _phoneCtrl, hint: 'Phone Number',
// //                     icon: Icons.phone_outlined, keyboardType: TextInputType.phone,
// //                     validator: (v) {
// //                       if (v == null || v.trim().isEmpty) return 'Phone required';
// //                       if (v.trim().length < 7) return 'Invalid phone number';
// //                       return null;
// //                     }),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 14),

// //           _buildField(controller: _eventCtrl, hint: 'Event Name / Type',
// //               icon: Icons.event_rounded,
// //               validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter event name' : null),
// //           const SizedBox(height: 28),

// //           SizedBox(
// //             width: double.infinity, height: 54,
// //             child: form.isLoading
// //                 ? Container(
// //                     decoration: BoxDecoration(
// //                       gradient: const LinearGradient(colors: [kPink, kPurple]),
// //                       borderRadius: BorderRadius.circular(30),
// //                     ),
// //                     child: const Center(child: CircularProgressIndicator(color: Colors.white)),
// //                   )
// //                 : ElevatedButton(
// //                     onPressed: () => notifier.submit(_formKey),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: kPink,
// //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// //                       elevation: 6, shadowColor: kPink.withOpacity(0.4),
// //                     ),
// //                     child: const Text('BOOK NOW',
// //                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
// //                             fontSize: 16, letterSpacing: 1.5)),
// //                   ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildField({
// //     required TextEditingController controller, required String hint,
// //     required IconData icon, TextInputType keyboardType = TextInputType.text,
// //     String? Function(String?)? validator,
// //   }) {
// //     return TextFormField(
// //       controller: controller, keyboardType: keyboardType, validator: validator,
// //       style: const TextStyle(color: kText, fontSize: 14),
// //       decoration: InputDecoration(
// //         hintText: hint, hintStyle: const TextStyle(color: kSubText),
// //         prefixIcon: Icon(icon, color: kSubText, size: 20),
// //         filled: true, fillColor: kCard,
// //         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: kDivider)),
// //         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: kDivider)),
// //         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: kPink, width: 2)),
// //         errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: kRed)),
// //         focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: kRed, width: 2)),
// //         errorStyle: const TextStyle(color: kRed, fontSize: 11),
// //       ),
// //     );
// //   }

// //   Widget _buildCountryDropdown(RegistrationFormState form, RegistrationFormNotifier notifier) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 8),
// //       decoration: BoxDecoration(
// //         color: kCard, borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: kDivider),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           value: form.country, dropdownColor: kCard,
// //           style: const TextStyle(color: kText, fontSize: 12),
// //           icon: const Icon(Icons.arrow_drop_down_rounded, color: kSubText),
// //           isExpanded: true,
// //           items: kCountries.map((c) => DropdownMenuItem(
// //             value: c,
// //             child: Text(c, overflow: TextOverflow.ellipsis,
// //                 style: const TextStyle(fontSize: 12)),
// //           )).toList(),
// //           onChanged: (v) { if (v != null) notifier.updateCountry(v); },
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SHARED CONTENT WRAPPER  (replaces the old _SectionWrapper)
// // // Does NOT wrap in SingleChildScrollView — the _ScrollablePage does that.
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SectionContent extends StatelessWidget {
// //   final String tag, title, subtitle;
// //   final Widget child;
// //   const _SectionContent({
// //     required this.tag, required this.title,
// //     required this.subtitle, required this.child,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: kBg,
// //       padding: const EdgeInsets.fromLTRB(20, 80, 20, 60),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Tag badge
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
// //             decoration: BoxDecoration(
// //               color: kPink.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(20),
// //               border: Border.all(color: kPink.withOpacity(0.3)),
// //             ),
// //             child: Text(tag,
// //                 style: const TextStyle(color: kPink, fontSize: 11,
// //                     fontWeight: FontWeight.bold, letterSpacing: 1.5)),
// //           ),
// //           const SizedBox(height: 14),
// //           Text(title,
// //               style: const TextStyle(color: kText, fontSize: 26,
// //                   fontWeight: FontWeight.w900, height: 1.2)),
// //           const SizedBox(height: 10),
// //           Text(subtitle,
// //               style: const TextStyle(color: kSubText, fontSize: 13, height: 1.6)),
// //           const SizedBox(height: 28),
// //           child,
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SHARED SMALL WIDGETS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _BFLogo extends StatelessWidget {
// //   final bool large;
// //   const _BFLogo({this.large = false});

// //   @override
// //   Widget build(BuildContext context) {
// //     final size      = large ? 44.0 : 36.0;
// //     final fontSize  = large ? 20.0 : 18.0;
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Container(
// //           width: size, height: size,
// //           decoration: BoxDecoration(
// //             gradient: const LinearGradient(colors: [kPink, kPurple]),
// //             borderRadius: BorderRadius.circular(size * 0.22),
// //           ),
// //           // child: Icon(Icons.music_note_rounded, color: Colors.white, size: size * 0.55),
// //           child: Image.asset('assets/logo/logo.png', width: size * 0.55),
// //         ),
// //         // const SizedBox(width: 8),
// //         // Text('Beat Flirt',
// //         //     style: TextStyle(color: kText, fontSize: fontSize,
// //         //         fontWeight: FontWeight.bold, letterSpacing: 1)),
// //         SizedBox(width: MediaQuery.of(context).size.width * 0.39),
// //         TextButton(
// //           onPressed: () {
// //             Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
// //           },
// //           child: Text('Login',
// //               style: TextStyle(color: kText, fontSize: 14,
// //                   fontWeight: FontWeight.bold, letterSpacing: 1)),
// //         ),
// //         TextButton(
// //           onPressed: () {
// //             Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));

// //           },
// //           child: Text('Sign Up',
// //               style: TextStyle(color: kText, fontSize: 14,
// //                   fontWeight: FontWeight.bold, letterSpacing: 1)),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _StatChip extends StatelessWidget {
// //   final String value, label;
// //   const _StatChip({required this.value, required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         ShaderMask(
// //           shaderCallback: (b) =>
// //               const LinearGradient(colors: [kPink, kPurple]).createShader(b),
// //           child: Text(value,
// //               style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
// //         ),
// //         Text(label, style: const TextStyle(color: kSubText, fontSize: 11)),
// //       ],
// //     );
// //   }
// // }

// // class _Pill extends StatelessWidget {
// //   final IconData icon;
// //   final String label;
// //   const _Pill({required this.icon, required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: kCard, borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: kDivider),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, color: kPink, size: 16),
// //           const SizedBox(width: 6),
// //           Text(label, style: const TextStyle(color: kText, fontSize: 12)),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _GradientButton extends StatelessWidget {
// //   final String label;
// //   final VoidCallback? onTap;
// //   final bool compact;
// //   const _GradientButton({required this.label, this.onTap, this.compact = false});

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: compact
// //             ? const EdgeInsets.symmetric(horizontal: 16, vertical: 9)
// //             : const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
// //         decoration: BoxDecoration(
// //           gradient: const LinearGradient(colors: [kPink, kPurple]),
// //           borderRadius: BorderRadius.circular(30),
// //           boxShadow: [
// //             BoxShadow(color: kPink.withOpacity(0.4), blurRadius: 12,
// //                 offset: const Offset(0, 4)),
// //           ],
// //         ),
// //         child: Text(label,
// //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
// //                 fontSize: compact ? 13 : 15)),
// //       ),
// //     );
// //   }
// // }

// // class AboutUsSection extends StatelessWidget {
// //   final VoidCallback onBookNow;

// //   const AboutUsSection({super.key, required this.onBookNow});

// //   @override
// //   Widget build(BuildContext context) {
// //     return _SectionContent(
// //       tag: 'ABOUT US',
// //       title: 'Effortless Event Control',
// //       subtitle:
// //           'Beat Flirt simplifies event management with secure bookings, smart scheduling, and seamless customer engagement in one powerful platform.',
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // About Image with loading & error handling
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(20),
// //             child: Image.network(
// //               'https://beatflirtevent.com/assets/img/home/about.png',
// //               height: 220,
// //               width: double.infinity,
// //               fit: BoxFit.cover,
// //               loadingBuilder: (context, child, loadingProgress) {
// //                 if (loadingProgress == null) return child;
// //                 return Container(
// //                   height: 220,
// //                   color: kCard,
// //                   child: const Center(
// //                     child: CircularProgressIndicator(color: kPink),
// //                   ),
// //                 );
// //               },
// //               errorBuilder: (context, error, stackTrace) {
// //                 return Container(
// //                   height: 220,
// //                   decoration: BoxDecoration(
// //                     color: kCard,
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   child: const Center(
// //                     child: Icon(Icons.image_not_supported_outlined,
// //                         color: kSubText, size: 48),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),

// //           const SizedBox(height: 24),

// //           const Text(
// //             'It helps organizers increase revenue, while delivering smooth, efficient, and memorable event experiences.',
// //             style: TextStyle(
// //               color: kSubText,
// //               fontSize: 14,
// //               height: 1.65,
// //             ),
// //           ),

// //           const SizedBox(height: 28),

// //           // Functional Book Now Button
// //           SizedBox(
// //             width: double.infinity,
// //             child: _GradientButton(
// //               label: 'Book Now',
// //               onTap: onBookNow,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class HowBeatFlirtWorksSection extends StatelessWidget {
// //   final VoidCallback onCreateEvents;
// //   final VoidCallback onAcceptPayments;
// //   final VoidCallback onGuestManagement;
// //   final VoidCallback onTrackRevenue;

// //   const HowBeatFlirtWorksSection({
// //     super.key,
// //     required this.onCreateEvents,
// //     required this.onAcceptPayments,
// //     required this.onGuestManagement,
// //     required this.onTrackRevenue,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final steps = [
// //       {
// //         'title': 'Create Events',
// //         'desc': 'Set up your event in minutes — add details, set capacity, ticket pricing, and publish instantly.',
// //         'image': 'https://beatflirtevent.com/assets/img/home/feature/img1.jpg',
// //         'onTap': onCreateEvents,
// //       },
// //       {
// //         'title': 'Accept Payments',
// //         'desc': 'Collect payments seamlessly via Card, UPI, and multiple payment gateways with full security.',
// //         'image': 'https://beatflirtevent.com/assets/img/home/feature/img2.jpg',
// //         'onTap': onAcceptPayments,
// //       },
// //       {
// //         'title': 'Guest Management',
// //         'desc': 'Manage guest lists, check-ins, VIP tables, and attendee data from one smart dashboard.',
// //         'image': 'https://beatflirtevent.com/assets/img/home/feature/img3.jpg',
// //         'onTap': onGuestManagement,
// //       },
// //       {
// //         'title': 'Track Revenue',
// //         'desc': 'Monitor ticket sales, revenue, and attendance in real time with powerful analytics tools.',
// //         'image': 'https://beatflirtevent.com/assets/img/home/feature/img4.jpg',
// //         'onTap': onTrackRevenue,
// //       },
// //     ];

// //     return _SectionContent(
// //       tag: 'HOW BEAT FLIRT WORKS',
// //       title: 'Launch, Manage & Grow\nYour Events',
// //       subtitle: 'From ticket creation to real-time insights — Beat Flirt handles everything.',
// //       child: Column(
// //         children: steps.map((step) {
// //           return GestureDetector(
// //             onTap: step['onTap'] as VoidCallback,
// //             child: Container(
// //               margin: const EdgeInsets.only(bottom: 20),
// //               decoration: BoxDecoration(
// //                 color: kCard,
// //                 borderRadius: BorderRadius.circular(20),
// //                 border: Border.all(color: kDivider),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   ClipRRect(
// //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// //                     child: Image.network(
// //                       step['image'] as String,
// //                       height: 180,
// //                       width: double.infinity,
// //                       fit: BoxFit.cover,
// //                       loadingBuilder: (context, child, progress) {
// //                         if (progress == null) return child;
// //                         return Container(
// //                           height: 180,
// //                           color: kCard,
// //                           child: const Center(child: CircularProgressIndicator(color: kPink)),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.all(20),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           step['title'] as String,
// //                           style: const TextStyle(
// //                             color: kText,
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         Text(
// //                           step['desc'] as String,
// //                           style: const TextStyle(color: kSubText, fontSize: 14, height: 1.5),
// //                         ),
// //                         const SizedBox(height: 12),
// //                         Row(
// //                           children: [
// //                             const Text('Learn more', style: TextStyle(color: kPink, fontWeight: FontWeight.w600)),
// //                             const SizedBox(width: 6),
// //                             const Icon(Icons.arrow_forward_rounded, color: kPink, size: 18),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }
// // }

// // ─────────────────────────────────────────────────────────────────────────────
// // BEAT FLIRT — LANDING PAGE  (full corrected single file)
// //
// // What changed vs. your original:
// //  1. Real backend wired up (matches https://beatflirtevent.com exactly):
// //       • Booking / Register  → POST add_beatflirt_event_query
// //       • Newsletter          → POST add_beatflirt_event_newsletter
// //       • Country auto-detect  → GET https://ipapi.co/json/
// //     All via the `http` package, driven through Riverpod.
// //  2. Prices corrected to match the live site:
// //       Starter $49 (2% fee) · Social Club Pro $99 (1.5%) · Lifestyle Elite $149 (1.5%)
// //  3. Spacing / gaps tightened (section padding + card margins reduced) so the
// //     page is more compact like the website.  See `kSectionPadding` /
// //     `kCardGap` constants — change in ONE place to retune all gaps.
// //  4. Booking form now sends the exact field names the API expects
// //     (note: the backend literally uses the typo `coutry_code`).
// //
// // Dependencies (pubspec.yaml):
// //   flutter_riverpod: ^2.5.0
// //   http: ^1.2.0
// //
// // Make sure your app is wrapped in a ProviderScope() at the root.
// // ─────────────────────────────────────────────────────────────────────────────

// import 'dart:convert';

// import 'package:beatflirt/screens/login_page.dart';
// import 'package:beatflirt/screens/register_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

// // ─────────────────────────────────────────────────────────────────────────────
// // COLORS
// // ─────────────────────────────────────────────────────────────────────────────
// const kBg      = Color(0xFF0D0D0D);
// const kCard    = Color(0xFF1A1A2E);
// const kPink    = Color(0xFFE91E8C);
// const kPurple  = Color(0xFF9B27AF);
// const kText    = Color(0xFFFFFFFF);
// const kSubText = Color(0xFFB0B0C3);
// const kDivider = Color(0xFF2A2A3E);
// const kGreen   = Color(0xFF4CAF50);
// const kRed     = Color(0xFFEF5350);
// const kAmber   = Color(0xFFFFC107);

// // ─────────────────────────────────────────────────────────────────────────────
// // SPACING — tune ALL gaps here
// // ─────────────────────────────────────────────────────────────────────────────
// // Each section now uses ONLY top padding (no bottom) so adjacent sections don't
// // stack 32+48px of empty space between them. This kills the big black voids.
// const double kSectionPadTop    = 36; // single gap that separates one section from the previous
// const double kSectionPadBottom = 0;  // no bottom padding → next section's top is the only gap
// const double kCardGap          = 12; // gap between stacked cards

// // ─────────────────────────────────────────────────────────────────────────────
// // API CONFIG  (reverse-engineered from the live beatflirtevent.com Angular app)
// // ─────────────────────────────────────────────────────────────────────────────
// class BeatFlirtApi {
//   static const String _base =
//       'https://crm.technoderivation.com/api/App/admin/user';
//   static const String newsletterUrl = '$_base/add_beatflirt_event_newsletter';
//   static const String queryUrl      = '$_base/add_beatflirt_event_query';
//   static const String ipApiUrl      = 'https://ipapi.co/json/';

//   /// Subscribe an email to the newsletter.
//   /// Body: { "email": "..." }
//   static Future<bool> subscribeNewsletter(String email) async {
//     final res = await http.post(
//       Uri.parse(newsletterUrl),
//       headers: const {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email}),
//     );
//     return _ok(res);
//   }

//   /// Send a booking / registration query.
//   /// NOTE: the backend field is literally spelled `coutry_code` (their typo).
//   static Future<bool> submitBooking({
//     required String name,
//     required String email,
//     required String countryCode, // e.g. "+91"
//     required String phone,
//     required String message,
//   }) async {
//     final res = await http.post(
//       Uri.parse(queryUrl),
//       headers: const {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'email': email,
//         'coutry_code': countryCode,
//         'phone': phone,
//         'message': message,
//       }),
//     );
//     return _ok(res);
//   }

//   /// Auto-detect the visitor's dialing code (e.g. "+91"). Returns null on failure.
//   static Future<String?> detectCountryCode() async {
//     try {
//       final res = await http.get(Uri.parse(ipApiUrl));
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body) as Map<String, dynamic>;
//         return data['country_calling_code'] as String?;
//       }
//     } catch (_) {/* ignore — fall back to default */}
//     return null;
//   }

//   static bool _ok(http.Response res) {
//     if (res.statusCode < 200 || res.statusCode >= 300) return false;
//     try {
//       final body = jsonDecode(res.body);
//       if (body is Map && body['status'] != null) {
//         return body['status'].toString() == '200';
//       }
//     } catch (_) {/* non-JSON 2xx → treat as success */}
//     return true;
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MODELS
// // ─────────────────────────────────────────────────────────────────────────────
// class PlanModel {
//   final String name, price, period, tag, fee;
//   final List<String> features, missing;
//   final Color color;
//   final bool popular;
//   const PlanModel({
//     required this.name, required this.price, required this.period,
//     required this.tag, required this.fee, required this.features,
//     required this.missing, required this.color, required this.popular,
//   });
// }

// class CountryCode {
//   final String name, code;
//   const CountryCode(this.name, this.code);
// }

// class RegistrationFormState {
//   final String name, email, phone, message, countryCode;
//   final bool isSubmitted, isLoading;
//   final String? error;
//   const RegistrationFormState({
//     this.name = '', this.email = '', this.phone = '',
//     this.message = '', this.countryCode = '+91',
//     this.isSubmitted = false, this.isLoading = false, this.error,
//   });

//   RegistrationFormState copyWith({
//     String? name, String? email, String? phone, String? message,
//     String? countryCode, bool? isSubmitted, bool? isLoading,
//     Object? error = _sentinel,
//   }) => RegistrationFormState(
//     name: name ?? this.name, email: email ?? this.email,
//     phone: phone ?? this.phone, message: message ?? this.message,
//     countryCode: countryCode ?? this.countryCode,
//     isSubmitted: isSubmitted ?? this.isSubmitted,
//     isLoading: isLoading ?? this.isLoading,
//     error: error == _sentinel ? this.error : error as String?,
//   );

//   static const Object _sentinel = Object();
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // RIVERPOD PROVIDERS
// // ─────────────────────────────────────────────────────────────────────────────
// final selectedPlanProvider = StateProvider<int>((ref) => 1);
// final openFaqIndexProvider = StateProvider<int?>((ref) => null);

// // Newsletter submit state: null = idle, true = sending
// final newsletterLoadingProvider = StateProvider<bool>((ref) => false);

// final registrationFormProvider =
//     StateNotifierProvider<RegistrationFormNotifier, RegistrationFormState>(
//   (ref) => RegistrationFormNotifier()..autoDetectCountry(),
// );

// class RegistrationFormNotifier extends StateNotifier<RegistrationFormState> {
//   RegistrationFormNotifier() : super(const RegistrationFormState());

//   void updateName(String v)    => state = state.copyWith(name: v);
//   void updateEmail(String v)   => state = state.copyWith(email: v);
//   void updatePhone(String v)   => state = state.copyWith(phone: v);
//   void updateMessage(String v) => state = state.copyWith(message: v);
//   void updateCountry(String v) => state = state.copyWith(countryCode: v);
//   void reset()                 => state = const RegistrationFormState();

//   Future<void> autoDetectCountry() async {
//     final code = await BeatFlirtApi.detectCountryCode();
//     if (code != null && kCountries.any((c) => c.code == code)) {
//       state = state.copyWith(countryCode: code);
//     }
//   }

//   Future<void> submit(GlobalKey<FormState> formKey) async {
//     if (!(formKey.currentState?.validate() ?? false)) return;
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final ok = await BeatFlirtApi.submitBooking(
//         name: state.name.trim(),
//         email: state.email.trim(),
//         countryCode: state.countryCode,
//         phone: state.phone.trim(),
//         message: state.message.trim().isEmpty
//             ? 'Event registration request'
//             : state.message.trim(),
//       );
//       state = ok
//           ? state.copyWith(isLoading: false, isSubmitted: true)
//           : state.copyWith(
//               isLoading: false, error: 'Failed to send. Please try again.');
//     } catch (e) {
//       state = state.copyWith(
//           isLoading: false, error: 'Network error. Please try again.');
//     }
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STATIC DATA  (prices corrected to match the live website)
// // ─────────────────────────────────────────────────────────────────────────────
// const List<PlanModel> kPlans = [
//   PlanModel(
//     name: 'Starter Nightlife', price: '\$49', period: '/month',
//     tag: 'Best for small clubs & first-time organizers',
//     fee: 'Platform Fee: 2% per ticket',
//     features: ['Up to 50 Events / Month','Up to 1,000 Attendees / Month',
//       'Club Page & Website','Ticket Sales & QR Check-In',
//       'Door Payments (Card / UPI)','Guest List Management',
//       'Speed Dating Module','User Profiles & Interests',
//       "Who's Attending View",'3,000 Messages / Month','Basic Analytics & Reports'],
//     missing: ['Private Chat & Ice-Breakers','VIP Table Reservations',
//       'Community Groups & Feeds','Paid Memberships',
//       'Multi-Day / Hotel Takeovers','Custom Branding','Priority Support','Celebrity Panel & Media'],
//     color: Color(0xFF1565C0), popular: false,
//   ),
//   PlanModel(
//     name: 'Social Club Pro', price: '\$99', period: '/month',
//     tag: 'For premium clubs, mixers & speed dating events',
//     fee: 'Platform Fee: 1.5% per ticket',
//     features: ['Everything in Starter Plan','Up to 80 Events / Month',
//       'Up to 5,000 Attendees / Month','Advanced Analytics',
//       'Private Chat & Ice-Breakers','VIP Table Reservations',
//       'Community Groups & Feeds','15,000 Messages / Month','Priority Support'],
//     missing: ['Paid Memberships','Multi-Day / Hotel Takeovers','Custom Branding','Celebrity Panel & Media'],
//     color: kPink, popular: true,
//   ),
//   PlanModel(
//     name: 'Lifestyle Elite', price: '\$149', period: '/month',
//     tag: 'For premium clubs, resorts & lifestyle communities',
//     fee: 'Platform Fee: 1.5% per ticket',
//     features: ['Everything in Social Club Pro','Unlimited Events','Unlimited Attendees',
//       'Paid Memberships','Multi-Day / Hotel Takeovers','Custom Branding',
//       'Celebrity Panel & Media','50,000 Messages / Month'],
//     missing: [],
//     color: kPurple, popular: false,
//   ),
// ];

// // Subset of the site's full country list (the API accepts any valid dialing code).
// const List<CountryCode> kCountries = [
//   CountryCode('India', '+91'),
//   CountryCode('USA', '+1'),
//   CountryCode('UK', '+44'),
//   CountryCode('UAE', '+971'),
//   CountryCode('Australia', '+61'),
//   CountryCode('Canada', '+1'),
//   CountryCode('Singapore', '+65'),
//   CountryCode('Germany', '+49'),
//   CountryCode('France', '+33'),
//   CountryCode('Japan', '+81'),
//   CountryCode('Brazil', '+55'),
//   CountryCode('South Africa', '+27'),
// ];

// const List<Map<String, String>> kFaqs = [
//   {'q':'What is Beat Flirt?','a':'Beat Flirt is an all-in-one event management platform designed to help organizers manage bookings, schedules, guest lists, and event operations seamlessly from a single dashboard.'},
//   {'q':'Who can use Beat Flirt?','a':'Beat Flirt is ideal for event organizers, club & venue owners, DJs and party hosts, and nightlife / social event planners of all sizes.'},
//   {'q':'Can I manage multiple events at once?','a':'Yes! Beat Flirt allows you to manage multiple events simultaneously — including scheduling, attendee limits, and different event categories — all from one platform.'},
//   {'q':'Can I customize the platform for my brand?','a':'Absolutely. Beat Flirt supports full customization including branding, UI changes, white-label options, and feature integrations based on your business needs.'},
// ];

// const List<Map<String, dynamic>> kTestimonials = [
//   {'name':'Elcia Petty','role':'Event Manager','initials':'EP','color':kPink,
//     'quote':'Managing events has never been easier. This software provides all the tools we need to handle registrations, payments, and schedules without any hassle.'},
//   {'name':'Enderson Will','role':'Club Owner','initials':'EW','color':kPurple,
//     'quote':'We improved our event operations and customer experience significantly. It is reliable, easy to use, and helps us manage bookings efficiently.'},
//   {'name':'Sushi Vega','role':'Party Host','initials':'SV','color':Color(0xFF1565C0),
//     'quote':'A powerful solution for event organizers. The system is fast, secure, and user-friendly — helping us deliver successful events every single time.'},
//   {'name':'Ferry Bush','role':'Venue Director','initials':'FB','color':Color(0xFF00897B),
//     'quote':'This platform made managing our events simple and stress-free. From ticket bookings to attendee management, everything runs smoothly.'},
// ];

// // Additional services list (from the live site).
// const List<String> kAdditionalServices = [
//   'Secure Ticketing','VIP Memberships','Integrated Payments','Customer Engagement',
//   'Event Management','Hotel Booking Integration','Branding Support','White-Label Support',
//   'Marketing & Promotions','Various Payment Solutions',
// ];

// // ─────────────────────────────────────────────────────────────────────────────
// // MAIN LANDING PAGE
// // ─────────────────────────────────────────────────────────────────────────────
// class BeatFlirtLandingPage extends ConsumerWidget {
//   const BeatFlirtLandingPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final featuresKey     = GlobalKey();
//     final pricingKey      = GlobalKey();
//     final registrationKey = GlobalKey();

//     void scrollToSection(GlobalKey key) {
//       final ctx = key.currentContext;
//       if (ctx != null) {
//         Scrollable.ensureVisible(
//           ctx,
//           duration: const Duration(milliseconds: 700),
//           curve: Curves.easeInOutCubic,
//           alignment: 0.05,
//         );
//       }
//     }

//     return Scaffold(
//       backgroundColor: kBg,
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 HeroSection(onGetStarted: () => scrollToSection(registrationKey)),
//                 AboutUsSection(onBookNow: () => scrollToSection(registrationKey)),
//                 HowBeatFlirtWorksSection(
//                   onCreateEvents:    () => scrollToSection(featuresKey),
//                   onAcceptPayments:  () => scrollToSection(pricingKey),
//                   onGuestManagement: () => scrollToSection(featuresKey),
//                   onTrackRevenue:    () => scrollToSection(pricingKey),
//                 ),
//                 const AdditionalServicesSection(),
//                 FeaturesSection(key: featuresKey),
//                 PricingSection(key: pricingKey),
//                 const TestimonialsSection(),
//                 const NewsletterSection(),
//                 const FAQSection(),
//                 RegistrationSection(key: registrationKey),
//               ],
//             ),
//           ),
//           const Positioned(
//             top: 0, left: 0, right: 0,
//             child: BFNavBar(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // NAV BAR
// // ─────────────────────────────────────────────────────────────────────────────
// class BFNavBar extends StatelessWidget {
//   const BFNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top,
//         left: 16, right: 8, bottom: 10,
//       ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter, end: Alignment.bottomCenter,
//           colors: [kBg, kBg.withOpacity(0)],
//         ),
//       ),
//       child: Row(
//         children: [
//           const BFLogo(),
//           const Spacer(),
//           TextButton(
//             onPressed: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => const LoginPage())),
//             child: const Text('Login',
//                 style: TextStyle(color: kText, fontSize: 14,
//                     fontWeight: FontWeight.bold, letterSpacing: 0.5)),
//           ),
//           GradientButton(
//             label: 'Sign Up', compact: true,
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => const RegisterPage())),
//           ),
//           const SizedBox(width: 4),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION 1 — HERO
// // ─────────────────────────────────────────────────────────────────────────────
// class HeroSection extends StatelessWidget {
//   final VoidCallback onGetStarted;
//   const HeroSection({super.key, required this.onGetStarted});

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Container(
//       constraints: BoxConstraints(minHeight: screenHeight),
//       decoration: const BoxDecoration(
//         gradient: RadialGradient(
//           center: Alignment(0, -0.3), radius: 1.2,
//           colors: [Color(0xFF2D0A3E), kBg],
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(24, 80, 24, 48),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 12),
//               Text('Beat Flirt',
//                 style: TextStyle(
//                   color: kText, fontSize: 30, fontWeight: FontWeight.bold,
//                   letterSpacing: 1,
//                   shadows: [
//                     const Shadow(blurRadius: 8, color: Colors.pink),
//                     const Shadow(blurRadius: 16, color: Colors.pink),
//                     Shadow(blurRadius: 24, color: Colors.pink.withOpacity(0.7)),
//                     Shadow(blurRadius: 32, color: Colors.pink.withOpacity(0.8)),
//                     Shadow(blurRadius: 40, color: Colors.pink.withOpacity(0.8)),
//                     Shadow(blurRadius: 48, color: Colors.pink.withOpacity(0.8)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 18),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: kPink.withOpacity(0.5)),
//                   borderRadius: BorderRadius.circular(20),
//                   color: kPink.withOpacity(0.08),
//                 ),
//                 child: const Text(
//                   '🎉  The All-in-One Platform for Events, Nightlife & Dating',
//                   style: TextStyle(color: kPink, fontSize: 12),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const FittedBox(
//                 child: Text('EVENT\nMANAGEMENT\nSOFTWARE',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: kText, fontSize: 40,
//                       fontWeight: FontWeight.w900, height: 1.1, letterSpacing: 2),
//                 ),
//               ),
//               const SizedBox(height: 18),
//               const Text(
//                 'Manage your events easily with our smart software solution.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: kSubText, fontSize: 14, height: 1.7),
//               ),
//               const SizedBox(height: 28),
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 spacing: 16, runSpacing: 12,
//                 children: [
//                   GradientButton(label: 'Get Started', onTap: onGetStarted),
//                   OutlinedButton(
//                     onPressed: () => _showDemoDialog(context),
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: kPink),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30)),
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                     ),
//                     child: const Text('Request Demo', style: TextStyle(color: kPink)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: const [
//                   StatChip(value: '50+',  label: 'Events/mo'),
//                   StatChip(value: '5K+',  label: 'Attendees'),
//                   StatChip(value: '99%',  label: 'Uptime'),
//                   StatChip(value: '24/7', label: 'Support'),
//                 ],
//               ),
//               const SizedBox(height: 28),
//               const Wrap(
//                 spacing: 10, runSpacing: 10,
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Pill(icon: Icons.confirmation_number_rounded, label: 'Secure Ticketing'),
//                   Pill(icon: Icons.qr_code_scanner_rounded,     label: 'QR Check-In'),
//                   Pill(icon: Icons.star_rounded,                label: 'VIP Memberships'),
//                   Pill(icon: Icons.favorite_rounded,            label: 'Speed Dating'),
//                   Pill(icon: Icons.analytics_rounded,           label: 'Live Analytics'),
//                   Pill(icon: Icons.hotel_rounded,               label: 'Hotel Booking'),
//                 ],
//               ),
//               const SizedBox(height: 28),
//               Column(
//                 children: [
//                   Text('Scroll to explore',
//                       style: TextStyle(color: kSubText.withOpacity(0.5), fontSize: 11)),
//                   const SizedBox(height: 6),
//                   const Icon(Icons.keyboard_arrow_down_rounded, color: kPink, size: 24),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDemoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: kCard,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Request a Demo',
//             style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
//         content: const Text(
//           'Our team will reach out to you within 24 hours to schedule a personalized demo.\n\nPlease register below and we\'ll contact you!',
//           style: TextStyle(color: kSubText, height: 1.6),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel', style: TextStyle(color: kSubText))),
//           GradientButton(label: 'OK, Got It',
//               onTap: () => Navigator.pop(context), compact: true),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION 2 — ABOUT US
// // ─────────────────────────────────────────────────────────────────────────────
// class AboutUsSection extends StatelessWidget {
//   final VoidCallback onBookNow;
//   const AboutUsSection({super.key, required this.onBookNow});

//   @override
//   Widget build(BuildContext context) {
//     return SectionContent(
//       tag: 'ABOUT US',
//       title: 'Effortless Event Control',
//       subtitle:
//           'Beat Flirt simplifies event management with secure bookings, smart scheduling, and seamless customer engagement in one powerful platform.',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Image.network(
//               'https://beatflirtevent.com/assets/img/home/about.png',
//               height: 220, width: double.infinity, fit: BoxFit.cover,
//               loadingBuilder: (c, child, p) =>
//                   p == null ? child : const _ImagePlaceholder(height: 220),
//               errorBuilder: (c, e, s) => const _ImageError(height: 220),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'It helps organizers increase revenue, while delivering smooth, efficient, and memorable event experiences.',
//             style: TextStyle(color: kSubText, fontSize: 14, height: 1.65),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: double.infinity,
//             child: GradientButton(label: 'Book Now', onTap: onBookNow),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION 3 — HOW BEAT FLIRT WORKS  (gaps between cards reduced)
// // ─────────────────────────────────────────────────────────────────────────────
// class HowBeatFlirtWorksSection extends StatelessWidget {
//   final VoidCallback onCreateEvents, onAcceptPayments, onGuestManagement, onTrackRevenue;
//   const HowBeatFlirtWorksSection({
//     super.key,
//     required this.onCreateEvents,
//     required this.onAcceptPayments,
//     required this.onGuestManagement,
//     required this.onTrackRevenue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final steps = [
//       {'title': 'Create Events',
//        'desc': 'Set up your event in minutes — add details, set capacity, ticket pricing, and publish instantly.',
//        'image': 'https://beatflirtevent.com/assets/img/home/feature/img1.jpg',
//        'onTap': onCreateEvents},
//       {'title': 'Accept Payments',
//        'desc': 'Collect payments seamlessly via Card, UPI, and multiple payment gateways with full security.',
//        'image': 'https://beatflirtevent.com/assets/img/home/feature/img2.jpg',
//        'onTap': onAcceptPayments},
//       {'title': 'Guest Management',
//        'desc': 'Manage guest lists, check-ins, VIP tables, and attendee data from one smart dashboard.',
//        'image': 'https://beatflirtevent.com/assets/img/home/feature/img3.jpg',
//        'onTap': onGuestManagement},
//       {'title': 'Track Revenue',
//        'desc': 'Monitor ticket sales, revenue, and attendance in real time with powerful analytics tools.',
//        'image': 'https://beatflirtevent.com/assets/img/home/feature/img4.jpg',
//        'onTap': onTrackRevenue},
//     ];

//     return SectionContent(
//       tag: 'HOW BEAT FLIRT WORKS',
//       title: 'Launch, Manage & Grow\nYour Events',
//       subtitle: 'From ticket creation to real-time insights — Beat Flirt handles everything.',
//       child: Column(
//         children: List.generate(steps.length, (i) {
//           final step = steps[i];
//           return GestureDetector(
//             onTap: step['onTap'] as VoidCallback,
//             child: Container(
//               // ↓ gap reduced from 20 → kCardGap, and no gap after the last card
//               margin: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : kCardGap),
//               decoration: BoxDecoration(
//                 color: kCard,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: kDivider),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                     child: Image.network(
//                       step['image'] as String,
//                       height: 160, width: double.infinity, fit: BoxFit.cover,
//                       loadingBuilder: (c, child, p) =>
//                           p == null ? child : const _ImagePlaceholder(height: 160),
//                       errorBuilder: (c, e, s) => const _ImageError(height: 160),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(step['title'] as String,
//                             style: const TextStyle(color: kText, fontSize: 17,
//                                 fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 6),
//                         Text(step['desc'] as String,
//                             style: const TextStyle(color: kSubText, fontSize: 13, height: 1.5)),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: const [
//                             Text('Learn more',
//                                 style: TextStyle(color: kPink, fontWeight: FontWeight.w600)),
//                             SizedBox(width: 6),
//                             Icon(Icons.arrow_forward_rounded, color: kPink, size: 18),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION — ADDITIONAL SERVICES  (from the live site)
// // ─────────────────────────────────────────────────────────────────────────────
// class AdditionalServicesSection extends StatelessWidget {
//   const AdditionalServicesSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SectionContent(
//       tag: 'ADDITIONAL SERVICES',
//       title: 'Best Event Management\nSoftware',
//       subtitle:
//           'A seamless event management experience designed for modern organizers — secure bookings, smart automation, and easy tools.',
//       child: Wrap(
//         spacing: 10, runSpacing: 10,
//         children: kAdditionalServices
//             .map((s) => Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: kCard, borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kDivider),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.check_circle_rounded, color: kGreen, size: 16),
//                       const SizedBox(width: 8),
//                       Text(s, style: const TextStyle(color: kText, fontSize: 12)),
//                     ],
//                   ),
//                 ))
//             .toList(),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION 4 — FEATURES
// // ─────────────────────────────────────────────────────────────────────────────
// class FeaturesSection extends StatelessWidget {
//   const FeaturesSection({super.key});

//   static const features = [
//     FeatureData(Icons.confirmation_number_rounded, 'Secure Ticketing',
//         'Sell tickets with full fraud protection and QR validation at entry.'),
//     FeatureData(Icons.star_border_rounded, 'VIP Memberships',
//         'Create exclusive VIP tiers with premium perks and table reservations.'),
//     FeatureData(Icons.account_balance_wallet_rounded, 'Integrated Payments',
//         'Accept Card, UPI, and global payment methods with instant payouts.'),
//     FeatureData(Icons.forum_outlined, 'Customer Engagement',
//         'Send campaigns, push notifications, and keep your audience connected.'),
//     FeatureData(Icons.calendar_today_rounded, 'Event Management',
//         'Manage schedules, vendors, and operations all from one dashboard.'),
//     FeatureData(Icons.hotel_rounded, 'Hotel Booking',
//         'Offer multi-day event packages with integrated hotel accommodations.'),
//     FeatureData(Icons.branding_watermark_rounded, 'Custom Branding',
//         'White-label the platform with your logo, colors, and custom domain.'),
//     FeatureData(Icons.favorite_rounded, 'Speed Dating',
//         'Run structured speed dating rounds with smart matchmaking algorithms.'),
//     FeatureData(Icons.campaign_rounded, 'Marketing & Promos',
//         'Run targeted promotions, discount codes, and influencer campaigns.'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SectionContent(
//       tag: 'FEATURES',
//       title: 'Everything You Need\nIn One Platform',
//       subtitle: 'Powerful tools built for modern event organizers.',
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, crossAxisSpacing: 12,
//           mainAxisSpacing: 12, childAspectRatio: 0.92,
//         ),
//         itemCount: features.length,
//         itemBuilder: (_, i) => FeatureCard(feature: features[i]),
//       ),
//     );
//   }
// }

// class FeatureData {
//   final IconData icon;
//   final String title, desc;
//   const FeatureData(this.icon, this.title, this.desc);
// }

// class FeatureCard extends StatelessWidget {
//   final FeatureData feature;
//   const FeatureCard({required this.feature, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: kCard, borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: kDivider),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                   colors: [kPink, kPurple],
//                   begin: Alignment.topLeft, end: Alignment.bottomRight),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(feature.icon, color: Colors.white, size: 22),
//           ),
//           const SizedBox(height: 12),
//           Text(feature.title,
//               maxLines: 2, overflow: TextOverflow.ellipsis,
//               style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 6),
//           Expanded(
//             child: Text(feature.desc,
//                 maxLines: 3, overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(color: kSubText, fontSize: 11, height: 1.5)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION 5 — PRICING
// // ─────────────────────────────────────────────────────────────────────────────
// class PricingSection extends ConsumerWidget {
//   const PricingSection({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selected = ref.watch(selectedPlanProvider);
//     final plan     = kPlans[selected];
//     return SectionContent(
//       tag: 'PRICING',
//       title: 'Choose the Perfect\nPlan for You',
//       subtitle: 'Flexible plans for every organizer — from first-timers to elite brands.',
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: kCard, borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: kDivider),
//             ),
//             padding: const EdgeInsets.all(4),
//             child: Row(
//               children: List.generate(kPlans.length, (i) {
//                 final isSelected = selected == i;
//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: () => ref.read(selectedPlanProvider.notifier).state = i,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 250),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       decoration: BoxDecoration(
//                         gradient: isSelected
//                             ? LinearGradient(colors: [kPlans[i].color, kPurple])
//                             : null,
//                         borderRadius: BorderRadius.circular(26),
//                       ),
//                       child: Text(
//                         kPlans[i].name,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: isSelected ? kText : kSubText,
//                           fontSize: 10,
//                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//           const SizedBox(height: 16),
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             transitionBuilder: (child, anim) => FadeTransition(
//               opacity: anim,
//               child: SlideTransition(
//                 position: Tween<Offset>(
//                         begin: const Offset(0, 0.04), end: Offset.zero)
//                     .animate(anim),
//                 child: child,
//               ),
//             ),
//             child: PlanCard(plan: plan, key: ValueKey(selected)),
//           ),
//           const SizedBox(height: kCardGap),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: kCard, borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: kPink.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.business_rounded, color: kPink, size: 28),
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('White-Label',
//                           style: TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
//                       Text('Custom pricing for large brands & international expansion.',
//                           style: TextStyle(color: kSubText, fontSize: 12)),
//                     ],
//                   ),
//                 ),
//                 OutlinedButton(
//                   onPressed: () => _showContactDialog(context),
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: kPink),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                   ),
//                   child: const Text('Contact Us', style: TextStyle(color: kPink, fontSize: 12)),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: kCardGap),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: kCard, borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: kDivider),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Optional Add-On Modules',
//                     style: TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
//                 const SizedBox(height: 12),
//                 ...[
//                   ('Speed Dating Add-On (per event)', '\$49'),
//                   ('Featured Event Listing', '\$29 / event'),
//                   ('Extra Messaging Pack (10k messages)', '\$25'),
//                   ('SMS + WhatsApp Campaign Pack', '\$39'),
//                   ('Advanced Matchmaking AI', '\$79 / month'),
//                 ].map((e) => Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.add_circle_outline_rounded, color: kPink, size: 16),
//                       const SizedBox(width: 8),
//                       Expanded(child: Text(e.$1, style: const TextStyle(color: kSubText, fontSize: 12))),
//                       Text(e.$2, style: const TextStyle(color: kPink, fontSize: 12, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 )),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showContactDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: kCard,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('White-Label Enquiry',
//             style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
//         content: const Text(
//           'For custom white-label pricing and enterprise solutions, please reach out to our sales team.\n\n📧 sales@beatflirtevent.com\n📞 +1 (800) BEAT-FLT',
//           style: TextStyle(color: kSubText, height: 1.7),
//         ),
//         actions: [
//           GradientButton(label: 'Got It',
//               onTap: () => Navigator.pop(context), compact: true),
//         ],
//       ),
//     );
//   }
// }

// class PlanCard extends StatelessWidget {
//   final PlanModel plan;
//   const PlanCard({required this.plan, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: kCard, borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: plan.popular ? kPink : kDivider,
//             width: plan.popular ? 2 : 1),
//         boxShadow: plan.popular
//             ? [BoxShadow(color: kPink.withOpacity(0.15), blurRadius: 20)]
//             : null,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (plan.popular)
//             Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(colors: [kPink, kPurple]),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text('MOST POPULAR',
//                   style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
//             ),
//           Text(plan.name,
//               style: const TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(plan.tag, style: const TextStyle(color: kSubText, fontSize: 12)),
//           const SizedBox(height: 16),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(plan.price,
//                   style: TextStyle(color: plan.color, fontSize: 40, fontWeight: FontWeight.w900)),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 6),
//                 child: Text(plan.period, style: const TextStyle(color: kSubText, fontSize: 14)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(plan.fee, style: const TextStyle(color: kPink, fontSize: 12)),
//           const SizedBox(height: 16),
//           const Divider(color: kDivider),
//           const SizedBox(height: 12),
//           ...plan.features.map((f) => Padding(
//             padding: const EdgeInsets.only(bottom: 9),
//             child: Row(
//               children: [
//                 const Icon(Icons.check_circle_rounded, color: kGreen, size: 16),
//                 const SizedBox(width: 8),
//                 Expanded(child: Text(f, style: const TextStyle(color: kText, fontSize: 13))),
//               ],
//             ),
//           )),
//           if (plan.missing.isNotEmpty) ...[
//             const SizedBox(height: 4),
//             ...plan.missing.map((m) => Padding(
//               padding: const EdgeInsets.only(bottom: 9),
//               child: Row(
//                 children: [
//                   const Icon(Icons.cancel_rounded, color: kRed, size: 16),
//                   const SizedBox(width: 8),
//                   Expanded(child: Text(m, style: const TextStyle(color: kSubText, fontSize: 13))),
//                 ],
//               ),
//             )),
//           ],
//           const SizedBox(height: 20),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: plan.color,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 elevation: 4,
//               ),
//               child: const Text('Get Started',
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION 6 — TESTIMONIALS
// // ─────────────────────────────────────────────────────────────────────────────
// class TestimonialsSection extends StatelessWidget {
//   const TestimonialsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SectionContent(
//       tag: 'TESTIMONIALS',
//       title: 'What Our Customers\nAre Saying',
//       subtitle: 'Trusted by event organizers and nightlife professionals worldwide.',
//       child: Column(
//         children: List.generate(kTestimonials.length, (i) => Padding(
//           padding: EdgeInsets.only(bottom: i == kTestimonials.length - 1 ? 0 : kCardGap),
//           child: TestimonialCard(data: kTestimonials[i]),
//         )),
//       ),
//     );
//   }
// }

// class TestimonialCard extends StatelessWidget {
//   final Map<String, dynamic> data;
//   const TestimonialCard({required this.data, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: kCard, borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: kDivider),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: (data['color'] as Color).withOpacity(0.2),
//                 radius: 22,
//                 child: Text(data['initials'] as String,
//                     style: TextStyle(color: data['color'] as Color,
//                         fontWeight: FontWeight.bold, fontSize: 14)),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(data['name'] as String,
//                         style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
//                     Text(data['role'] as String,
//                         style: const TextStyle(color: kSubText, fontSize: 12)),
//                   ],
//                 ),
//               ),
//               Row(children: List.generate(5,
//                   (_) => const Icon(Icons.star_rounded, color: kAmber, size: 14))),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Text('"${data['quote']}"',
//               style: const TextStyle(color: kSubText, fontSize: 13,
//                   height: 1.6, fontStyle: FontStyle.italic)),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION — NEWSLETTER  (wired to real API)
// // ─────────────────────────────────────────────────────────────────────────────
// class NewsletterSection extends ConsumerStatefulWidget {
//   const NewsletterSection({super.key});
//   @override
//   ConsumerState<NewsletterSection> createState() => _NewsletterSectionState();
// }

// class _NewsletterSectionState extends ConsumerState<NewsletterSection> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailCtrl = TextEditingController();

//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//     ref.read(newsletterLoadingProvider.notifier).state = true;
//     bool ok;
//     try {
//       ok = await BeatFlirtApi.subscribeNewsletter(_emailCtrl.text.trim());
//     } catch (_) {
//       ok = false;
//     }
//     ref.read(newsletterLoadingProvider.notifier).state = false;
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       backgroundColor: ok ? kGreen : kRed,
//       content: Text(ok
//           ? 'Subscribed to newsletter successfully!'
//           : 'Failed to subscribe. Please try again.'),
//     ));
//     if (ok) _emailCtrl.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loading = ref.watch(newsletterLoadingProvider);
//     return SectionContent(
//       tag: 'STAY UPDATED',
//       title: 'Get Weekly Newsletters',
//       subtitle: 'Stay updated with upcoming events & special offers.',
//       child: Form(
//         key: _formKey,
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(colors: [Color(0xFF1A0A2E), Color(0xFF0D1A2E)]),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: kDivider),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: _emailCtrl,
//                   keyboardType: TextInputType.emailAddress,
//                   style: const TextStyle(color: kText, fontSize: 14),
//                   validator: (v) {
//                     if (v == null || v.trim().isEmpty) return 'Email required';
//                     if (!RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v.trim())) {
//                       return 'Enter a valid email';
//                     }
//                     return null;
//                   },
//                   decoration: const InputDecoration(
//                     hintText: 'Your email address',
//                     hintStyle: TextStyle(color: kSubText),
//                     prefixIcon: Icon(Icons.email_outlined, color: kSubText, size: 20),
//                     border: InputBorder.none,
//                     errorStyle: TextStyle(color: kRed, fontSize: 11),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               loading
//                   ? const SizedBox(
//                       width: 40, height: 40,
//                       child: Center(child: CircularProgressIndicator(color: kPink, strokeWidth: 2)))
//                   : GradientButton(label: 'Subscribe', onTap: _submit, compact: true),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION 7 — FAQ
// // ─────────────────────────────────────────────────────────────────────────────
// class FAQSection extends ConsumerWidget {
//   const FAQSection({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final openIndex = ref.watch(openFaqIndexProvider);
//     return SectionContent(
//       tag: 'FAQ',
//       title: 'Frequently Asked\nQuestions',
//       subtitle: 'Everything you need to know about using Beat Flirt.',
//       child: Column(
//         children: List.generate(kFaqs.length, (i) {
//           final faq    = kFaqs[i];
//           final isOpen = openIndex == i;
//           return GestureDetector(
//             onTap: () =>
//                 ref.read(openFaqIndexProvider.notifier).state = isOpen ? null : i,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 250),
//               margin: EdgeInsets.only(bottom: i == kFaqs.length - 1 ? 0 : kCardGap),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: isOpen ? kPink.withOpacity(0.08) : kCard,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: isOpen ? kPink.withOpacity(0.4) : kDivider),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(faq['q']!,
//                             style: TextStyle(color: isOpen ? kPink : kText,
//                                 fontWeight: FontWeight.bold, fontSize: 14)),
//                       ),
//                       AnimatedRotation(
//                         turns: isOpen ? 0.5 : 0,
//                         duration: const Duration(milliseconds: 250),
//                         child: Icon(Icons.keyboard_arrow_down_rounded,
//                             color: isOpen ? kPink : kSubText),
//                       ),
//                     ],
//                   ),
//                   AnimatedCrossFade(
//                     firstChild: const SizedBox.shrink(),
//                     secondChild: Padding(
//                       padding: const EdgeInsets.only(top: 12),
//                       child: Text(faq['a']!,
//                           style: const TextStyle(color: kSubText, fontSize: 13, height: 1.6)),
//                     ),
//                     crossFadeState: isOpen
//                         ? CrossFadeState.showSecond
//                         : CrossFadeState.showFirst,
//                     duration: const Duration(milliseconds: 250),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION 8 — REGISTRATION  (wired to real booking API)
// // ─────────────────────────────────────────────────────────────────────────────
// class RegistrationSection extends ConsumerStatefulWidget {
//   const RegistrationSection({super.key});
//   @override
//   ConsumerState<RegistrationSection> createState() => _RegistrationSectionState();
// }

// class _RegistrationSectionState extends ConsumerState<RegistrationSection> {
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController nameCtrl, emailCtrl, phoneCtrl, messageCtrl;

//   @override
//   void initState() {
//     super.initState();
//     final fs = ref.read(registrationFormProvider);
//     nameCtrl    = TextEditingController(text: fs.name);
//     emailCtrl   = TextEditingController(text: fs.email);
//     phoneCtrl   = TextEditingController(text: fs.phone);
//     messageCtrl = TextEditingController(text: fs.message);

//     final n = ref.read(registrationFormProvider.notifier);
//     nameCtrl.addListener(()    => n.updateName(nameCtrl.text));
//     emailCtrl.addListener(()   => n.updateEmail(emailCtrl.text));
//     phoneCtrl.addListener(()   => n.updatePhone(phoneCtrl.text));
//     messageCtrl.addListener(() => n.updateMessage(messageCtrl.text));
//   }

//   @override
//   void dispose() {
//     nameCtrl.dispose(); emailCtrl.dispose();
//     phoneCtrl.dispose(); messageCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final form     = ref.watch(registrationFormProvider);
//     final notifier = ref.read(registrationFormProvider.notifier);

//     // surface API errors as a snackbar
//     ref.listen(registrationFormProvider, (prev, next) {
//       if (next.error != null && next.error != prev?.error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(backgroundColor: kRed, content: Text(next.error!)),
//         );
//       }
//     });

//     return SectionContent(
//       tag: 'RESERVATION',
//       title: 'Event Registration',
//       subtitle: 'Register easily and manage your events seamlessly.',
//       child: form.isSubmitted ? _buildSuccess(notifier) : _buildForm(form, notifier),
//     );
//   }

//   Widget _buildSuccess(RegistrationFormNotifier notifier) {
//     return Center(
//       child: Column(
//         children: [
//           const SizedBox(height: 24),
//           Container(
//             width: 90, height: 90,
//             decoration: const BoxDecoration(
//                 gradient: LinearGradient(colors: [kPink, kPurple]),
//                 shape: BoxShape.circle),
//             child: const Icon(Icons.check_rounded, color: Colors.white, size: 50),
//           ),
//           const SizedBox(height: 20),
//           const Text('Registration Successful!',
//               style: TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center),
//           const SizedBox(height: 12),
//           const Text(
//             "Thank you for registering!\nWe'll send confirmation details to your email shortly.",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: kSubText, fontSize: 14, height: 1.6),
//           ),
//           const SizedBox(height: 24),
//           GradientButton(
//             label: 'Register Another',
//             onTap: () {
//               notifier.reset();
//               nameCtrl.clear(); emailCtrl.clear();
//               phoneCtrl.clear(); messageCtrl.clear();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildForm(RegistrationFormState form, RegistrationFormNotifier notifier) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildField(controller: nameCtrl, hint: 'Full Name',
//               icon: Icons.person_outline_rounded, keyboardType: TextInputType.name,
//               validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your full name' : null),
//           const SizedBox(height: 14),
//           _buildField(controller: emailCtrl, hint: 'Email Address',
//               icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
//               validator: (v) {
//                 if (v == null || v.trim().isEmpty) return 'Email is required';
//                 if (!RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v.trim())) {
//                   return 'Enter a valid email address';
//                 }
//                 return null;
//               }),
//           const SizedBox(height: 14),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(flex: 2, child: _buildCountryDropdown(form, notifier)),
//               const SizedBox(width: 10),
//               Expanded(flex: 3,
//                 child: _buildField(controller: phoneCtrl, hint: 'Phone Number',
//                     icon: Icons.phone_outlined, keyboardType: TextInputType.phone,
//                     validator: (v) {
//                       if (v == null || v.trim().isEmpty) return 'Phone required';
//                       if (!RegExp(r'^[0-9]{8,15}$').hasMatch(v.trim())) {
//                         return 'Enter 8–15 digits';
//                       }
//                       return null;
//                     }),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           _buildField(controller: messageCtrl, hint: 'Event Name / Message',
//               icon: Icons.event_rounded, maxLines: 3,
//               validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter event name / message' : null),
//           const SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity, height: 54,
//             child: form.isLoading
//                 ? Container(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(colors: [kPink, kPurple]),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: const Center(child: CircularProgressIndicator(color: Colors.white)),
//                   )
//                 : ElevatedButton(
//                     onPressed: () => notifier.submit(_formKey),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: kPink,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                       elevation: 6, shadowColor: kPink.withOpacity(0.4),
//                     ),
//                     child: const Text('BOOK NOW',
//                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
//                             fontSize: 16, letterSpacing: 1.5)),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildField({
//     required TextEditingController controller, required String hint,
//     required IconData icon, TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1, String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller, keyboardType: keyboardType, validator: validator,
//       maxLines: maxLines,
//       style: const TextStyle(color: kText, fontSize: 14),
//       decoration: InputDecoration(
//         hintText: hint, hintStyle: const TextStyle(color: kSubText),
//         prefixIcon: Icon(icon, color: kSubText, size: 20),
//         filled: true, fillColor: kCard,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: kDivider)),
//         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: kDivider)),
//         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: kPink, width: 2)),
//         errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: kRed)),
//         focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: kRed, width: 2)),
//         errorStyle: const TextStyle(color: kRed, fontSize: 11),
//       ),
//     );
//   }

//   Widget _buildCountryDropdown(RegistrationFormState form, RegistrationFormNotifier notifier) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       height: 52,
//       decoration: BoxDecoration(
//         color: kCard, borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kDivider),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: kCountries.any((c) => c.code == form.countryCode)
//               ? form.countryCode : null,
//           dropdownColor: kCard,
//           style: const TextStyle(color: kText, fontSize: 12),
//           icon: const Icon(Icons.arrow_drop_down_rounded, color: kSubText),
//           isExpanded: true,
//           items: kCountries.map((c) => DropdownMenuItem(
//             value: c.code,
//             child: Text('${c.name} (${c.code})', overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 12)),
//           )).toList(),
//           onChanged: (v) { if (v != null) notifier.updateCountry(v); },
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED CONTENT WRAPPER  (reduced padding → smaller gaps between sections)
// // ─────────────────────────────────────────────────────────────────────────────
// class SectionContent extends StatelessWidget {
//   final String tag, title, subtitle;
//   final Widget child;
//   const SectionContent({
//     super.key,
//     required this.tag, required this.title,
//     required this.subtitle, required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: kBg,
//       padding: EdgeInsets.fromLTRB(20, kSectionPadTop, 20, kSectionPadBottom),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//             decoration: BoxDecoration(
//               color: kPink.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: kPink.withOpacity(0.3)),
//             ),
//             child: Text(tag,
//                 style: const TextStyle(color: kPink, fontSize: 11,
//                     fontWeight: FontWeight.bold, letterSpacing: 1.5)),
//           ),
//           const SizedBox(height: 12),
//           Text(title,
//               style: const TextStyle(color: kText, fontSize: 26,
//                   fontWeight: FontWeight.w900, height: 1.2)),
//           const SizedBox(height: 8),
//           Text(subtitle,
//               style: const TextStyle(color: kSubText, fontSize: 13, height: 1.6)),
//           const SizedBox(height: 20),
//           child,
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED SMALL WIDGETS
// // ─────────────────────────────────────────────────────────────────────────────
// class BFLogo extends StatelessWidget {
//   final bool large;
//   const BFLogo({super.key, this.large = false});

//   @override
//   Widget build(BuildContext context) {
//     final size = large ? 44.0 : 36.0;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: size, height: size,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(colors: [kPink, kPurple]),
//             borderRadius: BorderRadius.circular(size * 0.22),
//           ),
//           alignment: Alignment.center,
//           // Use a bundled asset; falls back to a music icon if missing.
//           child: Image.asset('assets/logo/logo.png',
//               width: size * 0.55,
//               errorBuilder: (_, __, ___) =>
//                   Icon(Icons.music_note_rounded, color: Colors.white, size: size * 0.55)),
//         ),
//         const SizedBox(width: 8),
//         Text('Beat Flirt',
//             style: TextStyle(color: kText, fontSize: large ? 20 : 18,
//                 fontWeight: FontWeight.bold, letterSpacing: 1)),
//       ],
//     );
//   }
// }

// class StatChip extends StatelessWidget {
//   final String value, label;
//   const StatChip({super.key, required this.value, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ShaderMask(
//           shaderCallback: (b) =>
//               const LinearGradient(colors: [kPink, kPurple]).createShader(b),
//           child: Text(value,
//               style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
//         ),
//         Text(label, style: const TextStyle(color: kSubText, fontSize: 11)),
//       ],
//     );
//   }
// }

// class Pill extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const Pill({super.key, required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: kCard, borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: kDivider),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: kPink, size: 16),
//           const SizedBox(width: 6),
//           Text(label, style: const TextStyle(color: kText, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }

// class GradientButton extends StatelessWidget {
//   final String label;
//   final VoidCallback? onTap;
//   final bool compact;
//   const GradientButton({super.key, required this.label, this.onTap, this.compact = false});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: compact
//             ? const EdgeInsets.symmetric(horizontal: 16, vertical: 9)
//             : const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(colors: [kPink, kPurple]),
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(color: kPink.withOpacity(0.4), blurRadius: 12,
//                 offset: const Offset(0, 4)),
//           ],
//         ),
//         child: Text(label,
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
//                 fontSize: compact ? 13 : 15)),
//       ),
//     );
//   }
// }

// // Small reusable image loading / error placeholders.
// class _ImagePlaceholder extends StatelessWidget {
//   final double height;
//   const _ImagePlaceholder({required this.height});
//   @override
//   Widget build(BuildContext context) => Container(
//         height: height, color: kCard,
//         child: const Center(child: CircularProgressIndicator(color: kPink)),
//       );
// }

// class _ImageError extends StatelessWidget {
//   final double height;
//   const _ImageError({required this.height});
//   @override
//   Widget build(BuildContext context) => Container(
//         height: height,
//         decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(20)),
//         child: const Center(
//             child: Icon(Icons.image_not_supported_outlined, color: kSubText, size: 48)),
//       );
// }

// ─────────────────────────────────────────────────────────────────────────────
// BEAT FLIRT — LANDING PAGE  (full corrected single file)
//
// What changed vs. your original:
//  1. Real backend wired up (matches https://beatflirtevent.com exactly):
//       • Booking / Register  → POST add_beatflirt_event_query
//       • Newsletter          → POST add_beatflirt_event_newsletter
//       • Country auto-detect  → GET https://ipapi.co/json/
//     All via the `http` package, driven through Riverpod.
//  2. Prices corrected to match the live site:
//       Starter $49 (2% fee) · Social Club Pro $99 (1.5%) · Lifestyle Elite $149 (1.5%)
//  3. Spacing / gaps tightened (section padding + card margins reduced) so the
//     page is more compact like the website.  See `kSectionPadding` /
//     `kCardGap` constants — change in ONE place to retune all gaps.
//  4. Booking form now sends the exact field names the API expects
//     (note: the backend literally uses the typo `coutry_code`).
//
// Dependencies (pubspec.yaml):
//   flutter_riverpod: ^2.5.0
//   http: ^1.2.0
//
// Make sure your app is wrapped in a ProviderScope() at the root.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';

import 'package:beatflirt/screens/login_page.dart';
import 'package:beatflirt/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get/get.dart' hide StateNotifier, StateProvider;
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────────────────────────────────────
const kBg = Color(0xFF0D0D0D);
const kCard = Color(0xFF1A1A2E);
const kPink = Color(0xFFE91E8C);
const kPurple = Color(0xFF9B27AF);
const kText = Color(0xFFFFFFFF);
const kSubText = Color(0xFFB0B0C3);
const kDivider = Color(0xFF2A2A3E);
const kGreen = Color(0xFF4CAF50);
const kRed = Color(0xFFEF5350);
const kAmber = Color(0xFFFFC107);

// ─────────────────────────────────────────────────────────────────────────────
// SPACING — tune ALL gaps here
// ─────────────────────────────────────────────────────────────────────────────
// Each section now uses ONLY top padding (no bottom) so adjacent sections don't
// stack 32+48px of empty space between them. This kills the big black voids.
const double kSectionPadTop =
    36; // single gap that separates one section from the previous
const double kSectionPadBottom =
    0; // no bottom padding → next section's top is the only gap
const double kCardGap = 12; // gap between stacked cards

// ─────────────────────────────────────────────────────────────────────────────
// API CONFIG  (reverse-engineered from the live beatflirtevent.com Angular app)
// ─────────────────────────────────────────────────────────────────────────────
class BeatFlirtApi {
  static const String _base =
      'https://crm.technoderivation.com/api/App/admin/user';
  static const String newsletterUrl = '$_base/add_beatflirt_event_newsletter';
  static const String queryUrl = '$_base/add_beatflirt_event_query';
  static const String ipApiUrl = 'https://ipapi.co/json/';

  static const String _tag = '[BeatFlirtApi]';

  /// Subscribe an email to the newsletter.
  /// Body: { "email": "..." }
  static Future<bool> subscribeNewsletter(String email) async {
    final body = jsonEncode({'email': email});
    print('$_tag → POST $newsletterUrl');
    print('$_tag   request body: $body');
    try {
      final res = await http.post(
        Uri.parse(newsletterUrl),
        headers: const {'Content-Type': 'application/json'},
        body: body,
      );
      print('$_tag ← status: ${res.statusCode}');
      print('$_tag   response body: ${res.body}');
      final ok = _ok(res);
      print('$_tag   subscribeNewsletter result: $ok');
      return ok;
    } catch (e, st) {
      print('$_tag ✖ subscribeNewsletter error: $e');
      print('$_tag   stacktrace: $st');
      rethrow;
    }
  }

  /// Send a booking / registration query.
  /// NOTE: the backend field is literally spelled `coutry_code` (their typo).
  static Future<bool> submitBooking({
    required String name,
    required String email,
    required String countryCode, // e.g. "+91"
    required String phone,
    required String message,
  }) async {
    final body = jsonEncode({
      'name': name,
      'email': email,
      'coutry_code': countryCode,
      'phone': phone,
      'message': message,
    });
    print('$_tag → POST $queryUrl');
    print('$_tag   request body: $body');
    try {
      final res = await http.post(
        Uri.parse(queryUrl),
        headers: const {'Content-Type': 'application/json'},
        body: body,
      );
      print('$_tag ← status: ${res.statusCode}');
      print('$_tag   response body: ${res.body}');
      final ok = _ok(res);
      print('$_tag   submitBooking result: $ok');
      return ok;
    } catch (e, st) {
      print('$_tag ✖ submitBooking error: $e');
      print('$_tag   stacktrace: $st');
      rethrow;
    }
  }

  /// Auto-detect the visitor's dialing code (e.g. "+91"). Returns null on failure.
  static Future<String?> detectCountryCode() async {
    print('$_tag → GET $ipApiUrl');
    try {
      final res = await http.get(Uri.parse(ipApiUrl));
      print('$_tag ← status: ${res.statusCode}');
      print('$_tag   response body: ${res.body}');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final code = data['country_calling_code'] as String?;
        print('$_tag   detected country_calling_code: $code');
        return code;
      }
      print('$_tag   detectCountryCode: non-200, returning null');
    } catch (e, st) {
      print('$_tag ✖ detectCountryCode error: $e');
      print('$_tag   stacktrace: $st');
    }
    return null;
  }

  static bool _ok(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      print('$_tag   _ok: status ${res.statusCode} not 2xx → false');
      return false;
    }
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map && decoded['status'] != null) {
        final ok = decoded['status'].toString() == '200';
        print(
          '$_tag   _ok: status field = ${decoded['status']} → $ok'
          '${decoded['message'] != null ? " (message: ${decoded['message']})" : ""}',
        );
        return ok;
      }
    } catch (_) {
      print('$_tag   _ok: non-JSON 2xx body → treating as success');
    }
    return true;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────
class PlanModel {
  final String name, price, period, tag, fee;
  final List<String> features, missing;
  final Color color;
  final bool popular;
  const PlanModel({
    required this.name,
    required this.price,
    required this.period,
    required this.tag,
    required this.fee,
    required this.features,
    required this.missing,
    required this.color,
    required this.popular,
  });
}

class CountryCode {
  final String name, code;
  const CountryCode(this.name, this.code);
}

class RegistrationFormState {
  final String name, email, phone, message, countryCode;
  final bool isSubmitted, isLoading;
  final String? error;
  const RegistrationFormState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.message = '',
    this.countryCode = '+91',
    this.isSubmitted = false,
    this.isLoading = false,
    this.error,
  });

  RegistrationFormState copyWith({
    String? name,
    String? email,
    String? phone,
    String? message,
    String? countryCode,
    bool? isSubmitted,
    bool? isLoading,
    Object? error = _sentinel,
  }) => RegistrationFormState(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    message: message ?? this.message,
    countryCode: countryCode ?? this.countryCode,
    isSubmitted: isSubmitted ?? this.isSubmitted,
    isLoading: isLoading ?? this.isLoading,
    error: error == _sentinel ? this.error : error as String?,
  );

  static const Object _sentinel = Object();
}

// ─────────────────────────────────────────────────────────────────────────────
// RIVERPOD PROVIDERS
// ─────────────────────────────────────────────────────────────────────────────
final selectedPlanProvider = StateProvider<int>((ref) => 1);
final openFaqIndexProvider = StateProvider<int?>((ref) => null);

// Newsletter submit state: null = idle, true = sending
final newsletterLoadingProvider = StateProvider<bool>((ref) => false);

final registrationFormProvider =
    StateNotifierProvider<RegistrationFormNotifier, RegistrationFormState>(
      (ref) => RegistrationFormNotifier()..autoDetectCountry(),
    );

class RegistrationFormNotifier extends StateNotifier<RegistrationFormState> {
  RegistrationFormNotifier() : super(const RegistrationFormState());

  void updateName(String v) => state = state.copyWith(name: v);
  void updateEmail(String v) => state = state.copyWith(email: v);
  void updatePhone(String v) => state = state.copyWith(phone: v);
  void updateMessage(String v) => state = state.copyWith(message: v);
  void updateCountry(String v) => state = state.copyWith(countryCode: v);
  void reset() => state = const RegistrationFormState();

  Future<void> autoDetectCountry() async {
    print('[Registration] autoDetectCountry: starting…');
    final code = await BeatFlirtApi.detectCountryCode();
    if (code != null && kCountries.any((c) => c.code == code)) {
      print('[Registration] autoDetectCountry: applying $code');
      state = state.copyWith(countryCode: code);
    } else {
      print(
        '[Registration] autoDetectCountry: keeping default ${state.countryCode}',
      );
    }
  }

  Future<void> submit(GlobalKey<FormState> formKey) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      print('[Registration] submit: form invalid, aborting');
      return;
    }
    print(
      '[Registration] submit: name=${state.name}, email=${state.email}, '
      'country=${state.countryCode}, phone=${state.phone}',
    );
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ok = await BeatFlirtApi.submitBooking(
        name: state.name.trim(),
        email: state.email.trim(),
        countryCode: state.countryCode,
        phone: state.phone.trim(),
        message: state.message.trim().isEmpty
            ? 'Event registration request'
            : state.message.trim(),
      );
      print('[Registration] submit: ok=$ok');
      state = ok
          ? state.copyWith(isLoading: false, isSubmitted: true)
          : state.copyWith(
              isLoading: false,
              error: 'Failed to send. Please try again.',
            );
    } catch (e) {
      print('[Registration] submit: caught error → $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Network error. Please try again.',
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATIC DATA  (prices corrected to match the live website)
// ─────────────────────────────────────────────────────────────────────────────
const List<PlanModel> kPlans = [
  PlanModel(
    name: 'Starter Nightlife',
    price: '\$49',
    period: '/month',
    tag: 'Best for small clubs & first-time organizers',
    fee: 'Platform Fee: 2% per ticket',
    features: [
      'Up to 50 Events / Month',
      'Up to 1,000 Attendees / Month',
      'Club Page & Website',
      'Ticket Sales & QR Check-In',
      'Door Payments (Card / UPI)',
      'Guest List Management',
      'Speed Dating Module',
      'User Profiles & Interests',
      "Who's Attending View",
      '3,000 Messages / Month',
      'Basic Analytics & Reports',
    ],
    missing: [
      'Private Chat & Ice-Breakers',
      'VIP Table Reservations',
      'Community Groups & Feeds',
      'Paid Memberships',
      'Multi-Day / Hotel Takeovers',
      'Custom Branding',
      'Priority Support',
      'Celebrity Panel & Media',
    ],
    color: Color(0xFF1565C0),
    popular: false,
  ),
  PlanModel(
    name: 'Social Club Pro',
    price: '\$99',
    period: '/month',
    tag: 'For premium clubs, mixers & speed dating events',
    fee: 'Platform Fee: 1.5% per ticket',
    features: [
      'Everything in Starter Plan',
      'Up to 80 Events / Month',
      'Up to 5,000 Attendees / Month',
      'Advanced Analytics',
      'Private Chat & Ice-Breakers',
      'VIP Table Reservations',
      'Community Groups & Feeds',
      '15,000 Messages / Month',
      'Priority Support',
    ],
    missing: [
      'Paid Memberships',
      'Multi-Day / Hotel Takeovers',
      'Custom Branding',
      'Celebrity Panel & Media',
    ],
    color: kPink,
    popular: true,
  ),
  PlanModel(
    name: 'Lifestyle Elite',
    price: '\$149',
    period: '/month',
    tag: 'For premium clubs, resorts & lifestyle communities',
    fee: 'Platform Fee: 1.5% per ticket',
    features: [
      'Everything in Social Club Pro',
      'Unlimited Events',
      'Unlimited Attendees',
      'Paid Memberships',
      'Multi-Day / Hotel Takeovers',
      'Custom Branding',
      'Celebrity Panel & Media',
      '50,000 Messages / Month',
    ],
    missing: [],
    color: kPurple,
    popular: false,
  ),
];

// Subset of the site's full country list (the API accepts any valid dialing code).
const List<CountryCode> kCountries = [
  CountryCode('India', '+91'),
  CountryCode('USA', '+1'),
  CountryCode('UK', '+44'),
  CountryCode('UAE', '+971'),
  CountryCode('Australia', '+61'),
  CountryCode('Canada', '+1'),
  CountryCode('Singapore', '+65'),
  CountryCode('Germany', '+49'),
  CountryCode('France', '+33'),
  CountryCode('Japan', '+81'),
  CountryCode('Brazil', '+55'),
  CountryCode('South Africa', '+27'),
];

const List<Map<String, String>> kFaqs = [
  {
    'q': 'What is Beat Flirt?',
    'a':
        'Beat Flirt is an all-in-one event management platform designed to help organizers manage bookings, schedules, guest lists, and event operations seamlessly from a single dashboard.',
  },
  {
    'q': 'Who can use Beat Flirt?',
    'a':
        'Beat Flirt is ideal for event organizers, club & venue owners, DJs and party hosts, and nightlife / social event planners of all sizes.',
  },
  {
    'q': 'Can I manage multiple events at once?',
    'a':
        'Yes! Beat Flirt allows you to manage multiple events simultaneously — including scheduling, attendee limits, and different event categories — all from one platform.',
  },
  {
    'q': 'Can I customize the platform for my brand?',
    'a':
        'Absolutely. Beat Flirt supports full customization including branding, UI changes, white-label options, and feature integrations based on your business needs.',
  },
];

const List<Map<String, dynamic>> kTestimonials = [
  {
    'name': 'Elcia Petty',
    'role': 'Event Manager',
    'initials': 'EP',
    'color': kPink,
    'quote':
        'Managing events has never been easier. This software provides all the tools we need to handle registrations, payments, and schedules without any hassle.',
  },
  {
    'name': 'Enderson Will',
    'role': 'Club Owner',
    'initials': 'EW',
    'color': kPurple,
    'quote':
        'We improved our event operations and customer experience significantly. It is reliable, easy to use, and helps us manage bookings efficiently.',
  },
  {
    'name': 'Sushi Vega',
    'role': 'Party Host',
    'initials': 'SV',
    'color': Color(0xFF1565C0),
    'quote':
        'A powerful solution for event organizers. The system is fast, secure, and user-friendly — helping us deliver successful events every single time.',
  },
  {
    'name': 'Ferry Bush',
    'role': 'Venue Director',
    'initials': 'FB',
    'color': Color(0xFF00897B),
    'quote':
        'This platform made managing our events simple and stress-free. From ticket bookings to attendee management, everything runs smoothly.',
  },
];

// Additional services list (from the live site).
const List<String> kAdditionalServices = [
  'Secure Ticketing',
  'VIP Memberships',
  'Integrated Payments',
  'Customer Engagement',
  'Event Management',
  'Hotel Booking Integration',
  'Branding Support',
  'White-Label Support',
  'Marketing & Promotions',
  'Various Payment Solutions',
];

// ─────────────────────────────────────────────────────────────────────────────
// MAIN LANDING PAGE
// ─────────────────────────────────────────────────────────────────────────────
class BeatFlirtLandingPage extends ConsumerWidget {
  const BeatFlirtLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuresKey = GlobalKey();
    final pricingKey = GlobalKey();
    final registrationKey = GlobalKey();

    void scrollToSection(GlobalKey key) {
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
          alignment: 0.05,
        );
      }
    }

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                HeroSection(
                  onGetStarted: () => scrollToSection(registrationKey),
                ),
                AboutUsSection(
                  onBookNow: () => scrollToSection(registrationKey),
                ),
                HowBeatFlirtWorksSection(
                  onCreateEvents: () => scrollToSection(featuresKey),
                  onAcceptPayments: () => scrollToSection(pricingKey),
                  onGuestManagement: () => scrollToSection(featuresKey),
                  onTrackRevenue: () => scrollToSection(pricingKey),
                ),
                const AdditionalServicesSection(),
                FeaturesSection(key: featuresKey),
                PricingSection(key: pricingKey),
                const TestimonialsSection(),
                const NewsletterSection(),
                const FAQSection(),
                RegistrationSection(key: registrationKey),
              ],
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: BFNavBar()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV BAR
// ─────────────────────────────────────────────────────────────────────────────
class BFNavBar extends StatelessWidget {
  const BFNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 8,
        bottom: 10,
      ),
      // Solid background so scrolled content is hidden cleanly behind the
      // navbar instead of bleeding through the old fading gradient.
      decoration: BoxDecoration(
        color: kBg,
        border: Border(bottom: BorderSide(color: kDivider.withOpacity(0.6))),
        boxShadow: [
          BoxShadow(color: kBg, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const BFLogo(),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                color: kText,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          GradientButton(
            label: 'Sign Up',
            compact: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 1 — HERO
// ─────────────────────────────────────────────────────────────────────────────
class HeroSection extends StatelessWidget {
  final VoidCallback onGetStarted;
  const HeroSection({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    // NOTE: do NOT force minHeight: screenHeight — that created a large empty
    // void below the hero content. Let the hero size to its content instead.
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 1.2,
          colors: [Color(0xFF2D0A3E), kBg],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          // top 72 clears the fixed navbar; bottom is small so the next
          // section sits right under the hero (no giant gap).
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Text(
                'Beat Flirt',
                style: TextStyle(
                  color: kText,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  shadows: [
                    const Shadow(blurRadius: 8, color: Colors.pink),
                    const Shadow(blurRadius: 16, color: Colors.pink),
                    Shadow(blurRadius: 24, color: Colors.pink.withOpacity(0.7)),
                    Shadow(blurRadius: 32, color: Colors.pink.withOpacity(0.8)),
                    Shadow(blurRadius: 40, color: Colors.pink.withOpacity(0.8)),
                    Shadow(blurRadius: 48, color: Colors.pink.withOpacity(0.8)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: kPink.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(20),
                  color: kPink.withOpacity(0.08),
                ),
                child: const Text(
                  '🎉  The All-in-One Platform for Events, Nightlife & Dating',
                  style: TextStyle(color: kPink, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              const FittedBox(
                child: Text(
                  'EVENT\nMANAGEMENT\nSOFTWARE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kText,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Manage your events easily with our smart software solution.',
                textAlign: TextAlign.center,
                style: TextStyle(color: kSubText, fontSize: 14, height: 1.7),
              ),
              const SizedBox(height: 28),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  GradientButton(label: 'Get Started', onTap: onGetStarted),
                  OutlinedButton(
                    onPressed: () => _showDemoDialog(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kPink),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      'Request Demo',
                      style: TextStyle(color: kPink),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  StatChip(value: '50+', label: 'Events/mo'),
                  StatChip(value: '5K+', label: 'Attendees'),
                  StatChip(value: '99%', label: 'Uptime'),
                  StatChip(value: '24/7', label: 'Support'),
                ],
              ),
              const SizedBox(height: 28),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  Pill(
                    icon: Icons.confirmation_number_rounded,
                    label: 'Secure Ticketing',
                  ),
                  Pill(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'QR Check-In',
                  ),
                  Pill(icon: Icons.star_rounded, label: 'VIP Memberships'),
                  Pill(icon: Icons.favorite_rounded, label: 'Speed Dating'),
                  Pill(icon: Icons.analytics_rounded, label: 'Live Analytics'),
                  Pill(icon: Icons.hotel_rounded, label: 'Hotel Booking'),
                ],
              ),
              const SizedBox(height: 28),
              Column(
                children: [
                  Text(
                    'Scroll to explore',
                    style: TextStyle(
                      color: kSubText.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: kPink,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDemoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Request a Demo',
          style: TextStyle(color: kText, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Our team will reach out to you within 24 hours to schedule a personalized demo.\n\nPlease register below and we\'ll contact you!',
          style: TextStyle(color: kSubText, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: kSubText)),
          ),
          GradientButton(
            label: 'OK, Got It',
            onTap: () => Navigator.pop(context),
            compact: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 2 — ABOUT US
// ─────────────────────────────────────────────────────────────────────────────
class AboutUsSection extends StatelessWidget {
  final VoidCallback onBookNow;
  const AboutUsSection({super.key, required this.onBookNow});

  @override
  Widget build(BuildContext context) {
    return SectionContent(
      tag: 'ABOUT US',
      title: 'Effortless Event Control',
      subtitle:
          'Beat Flirt simplifies event management with secure bookings, smart scheduling, and seamless customer engagement in one powerful platform.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://beatflirtevent.com/assets/img/home/about.png',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (c, child, p) =>
                  p == null ? child : const _ImagePlaceholder(height: 220),
              errorBuilder: (c, e, s) => const _ImageError(height: 220),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'It helps organizers increase revenue, while delivering smooth, efficient, and memorable event experiences.',
            style: TextStyle(color: kSubText, fontSize: 14, height: 1.65),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GradientButton(label: 'Book Now', onTap: onBookNow),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 3 — HOW BEAT FLIRT WORKS  (gaps between cards reduced)
// ─────────────────────────────────────────────────────────────────────────────
class HowBeatFlirtWorksSection extends StatelessWidget {
  final VoidCallback onCreateEvents,
      onAcceptPayments,
      onGuestManagement,
      onTrackRevenue;
  const HowBeatFlirtWorksSection({
    super.key,
    required this.onCreateEvents,
    required this.onAcceptPayments,
    required this.onGuestManagement,
    required this.onTrackRevenue,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'title': 'Create Events',
        'desc':
            'Set up your event in minutes — add details, set capacity, ticket pricing, and publish instantly.',
        'image': 'https://beatflirtevent.com/assets/img/home/feature/img1.jpg',
        'onTap': onCreateEvents,
      },
      {
        'title': 'Accept Payments',
        'desc':
            'Collect payments seamlessly via Card, UPI, and multiple payment gateways with full security.',
        'image': 'https://beatflirtevent.com/assets/img/home/feature/img2.jpg',
        'onTap': onAcceptPayments,
      },
      {
        'title': 'Guest Management',
        'desc':
            'Manage guest lists, check-ins, VIP tables, and attendee data from one smart dashboard.',
        'image': 'https://beatflirtevent.com/assets/img/home/feature/img3.jpg',
        'onTap': onGuestManagement,
      },
      {
        'title': 'Track Revenue',
        'desc':
            'Monitor ticket sales, revenue, and attendance in real time with powerful analytics tools.',
        'image': 'https://beatflirtevent.com/assets/img/home/feature/img4.jpg',
        'onTap': onTrackRevenue,
      },
    ];

    return SectionContent(
      tag: 'HOW BEAT FLIRT WORKS',
      title: 'Launch, Manage & Grow\nYour Events',
      subtitle:
          'From ticket creation to real-time insights — Beat Flirt handles everything.',
      child: Column(
        children: List.generate(steps.length, (i) {
          final step = steps[i];
          return GestureDetector(
            onTap: step['onTap'] as VoidCallback,
            child: Container(
              // ↓ gap reduced from 20 → kCardGap, and no gap after the last card
              margin: EdgeInsets.only(
                bottom: i == steps.length - 1 ? 0 : kCardGap,
              ),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kDivider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      step['image'] as String,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (c, child, p) => p == null
                          ? child
                          : const _ImagePlaceholder(height: 160),
                      errorBuilder: (c, e, s) => const _ImageError(height: 160),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: const TextStyle(
                            color: kText,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step['desc'] as String,
                          style: const TextStyle(
                            color: kSubText,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Text(
                              'Learn more',
                              style: TextStyle(
                                color: kPink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: kPink,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION — ADDITIONAL SERVICES  (from the live site)
// ─────────────────────────────────────────────────────────────────────────────
class AdditionalServicesSection extends StatelessWidget {
  const AdditionalServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContent(
      tag: 'ADDITIONAL SERVICES',
      title: 'Best Event Management\nSoftware',
      subtitle:
          'A seamless event management experience designed for modern organizers — secure bookings, smart automation, and easy tools.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: kAdditionalServices
            .map(
              (s) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kDivider),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: kGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(s, style: const TextStyle(color: kText, fontSize: 12)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 4 — FEATURES
// ─────────────────────────────────────────────────────────────────────────────
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  static const features = [
    FeatureData(
      Icons.confirmation_number_rounded,
      'Secure Ticketing',
      'Sell tickets with full fraud protection and QR validation at entry.',
    ),
    FeatureData(
      Icons.star_border_rounded,
      'VIP Memberships',
      'Create exclusive VIP tiers with premium perks and table reservations.',
    ),
    FeatureData(
      Icons.account_balance_wallet_rounded,
      'Integrated Payments',
      'Accept Card, UPI, and global payment methods with instant payouts.',
    ),
    FeatureData(
      Icons.forum_outlined,
      'Customer Engagement',
      'Send campaigns, push notifications, and keep your audience connected.',
    ),
    FeatureData(
      Icons.calendar_today_rounded,
      'Event Management',
      'Manage schedules, vendors, and operations all from one dashboard.',
    ),
    FeatureData(
      Icons.hotel_rounded,
      'Hotel Booking',
      'Offer multi-day event packages with integrated hotel accommodations.',
    ),
    FeatureData(
      Icons.branding_watermark_rounded,
      'Custom Branding',
      'White-label the platform with your logo, colors, and custom domain.',
    ),
    FeatureData(
      Icons.favorite_rounded,
      'Speed Dating',
      'Run structured speed dating rounds with smart matchmaking algorithms.',
    ),
    FeatureData(
      Icons.campaign_rounded,
      'Marketing & Promos',
      'Run targeted promotions, discount codes, and influencer campaigns.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContent(
      tag: 'FEATURES',
      title: 'Everything You Need\nIn One Platform',
      subtitle: 'Powerful tools built for modern event organizers.',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.92,
        ),
        itemCount: features.length,
        itemBuilder: (_, i) => FeatureCard(feature: features[i]),
      ),
    );
  }
}

class FeatureData {
  final IconData icon;
  final String title, desc;
  const FeatureData(this.icon, this.title, this.desc);
}

class FeatureCard extends StatelessWidget {
  final FeatureData feature;
  const FeatureCard({required this.feature, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPink, kPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(feature.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            feature.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kText,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              feature.desc,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kSubText,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 5 — PRICING
// ─────────────────────────────────────────────────────────────────────────────
class PricingSection extends ConsumerWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedPlanProvider);
    final plan = kPlans[selected];
    return SectionContent(
      tag: 'PRICING',
      title: 'Choose the Perfect\nPlan for You',
      subtitle:
          'Flexible plans for every organizer — from first-timers to elite brands.',
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: kDivider),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(kPlans.length, (i) {
                final isSelected = selected == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(selectedPlanProvider.notifier).state = i,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(colors: [kPlans[i].color, kPurple])
                            : null,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Text(
                        kPlans[i].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? kText : kSubText,
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: PlanCard(plan: plan, key: ValueKey(selected)),
          ),
          const SizedBox(height: kCardGap),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kPink.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.business_rounded, color: kPink, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'White-Label',
                        style: TextStyle(
                          color: kText,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Custom pricing for large brands & international expansion.',
                        style: TextStyle(color: kSubText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _showContactDialog(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPink),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Contact Us',
                    style: TextStyle(color: kPink, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kCardGap),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kDivider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Optional Add-On Modules',
                  style: TextStyle(
                    color: kText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ...[
                  ('Speed Dating Add-On (per event)', '\$49'),
                  ('Featured Event Listing', '\$29 / event'),
                  ('Extra Messaging Pack (10k messages)', '\$25'),
                  ('SMS + WhatsApp Campaign Pack', '\$39'),
                  ('Advanced Matchmaking AI', '\$79 / month'),
                ].map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline_rounded,
                          color: kPink,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            e.$1,
                            style: const TextStyle(
                              color: kSubText,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          e.$2,
                          style: const TextStyle(
                            color: kPink,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'White-Label Enquiry',
          style: TextStyle(color: kText, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'For custom white-label pricing and enterprise solutions, please reach out to our sales team.\n\n📧 sales@beatflirtevent.com\n📞 +1 (800) BEAT-FLT',
          style: TextStyle(color: kSubText, height: 1.7),
        ),
        actions: [
          GradientButton(
            label: 'Got It',
            onTap: () => Navigator.pop(context),
            compact: true,
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  const PlanCard({required this.plan, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: plan.popular ? kPink : kDivider,
          width: plan.popular ? 2 : 1,
        ),
        boxShadow: plan.popular
            ? [BoxShadow(color: kPink.withOpacity(0.15), blurRadius: 20)]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.popular)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [kPink, kPurple]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            plan.name,
            style: const TextStyle(
              color: kText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(plan.tag, style: const TextStyle(color: kSubText, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.price,
                style: TextStyle(
                  color: plan.color,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  plan.period,
                  style: const TextStyle(color: kSubText, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(plan.fee, style: const TextStyle(color: kPink, fontSize: 12)),
          const SizedBox(height: 16),
          const Divider(color: kDivider),
          const SizedBox(height: 12),
          ...plan.features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: kGreen,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: const TextStyle(color: kText, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (plan.missing.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...plan.missing.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  children: [
                    const Icon(Icons.cancel_rounded, color: kRed, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        m,
                        style: const TextStyle(color: kSubText, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: plan.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 4,
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 6 — TESTIMONIALS
// ─────────────────────────────────────────────────────────────────────────────
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContent(
      tag: 'TESTIMONIALS',
      title: 'What Our Customers\nAre Saying',
      subtitle:
          'Trusted by event organizers and nightlife professionals worldwide.',
      child: Column(
        children: List.generate(
          kTestimonials.length,
          (i) => Padding(
            padding: EdgeInsets.only(
              bottom: i == kTestimonials.length - 1 ? 0 : kCardGap,
            ),
            child: TestimonialCard(data: kTestimonials[i]),
          ),
        ),
      ),
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const TestimonialCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: (data['color'] as Color).withOpacity(0.2),
                radius: 22,
                child: Text(
                  data['initials'] as String,
                  style: TextStyle(
                    color: data['color'] as Color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'] as String,
                      style: const TextStyle(
                        color: kText,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      data['role'] as String,
                      style: const TextStyle(color: kSubText, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (_) =>
                      const Icon(Icons.star_rounded, color: kAmber, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '"${data['quote']}"',
            style: const TextStyle(
              color: kSubText,
              fontSize: 13,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION — NEWSLETTER  (wired to real API)
// ─────────────────────────────────────────────────────────────────────────────
class NewsletterSection extends ConsumerStatefulWidget {
  const NewsletterSection({super.key});
  @override
  ConsumerState<NewsletterSection> createState() => _NewsletterSectionState();
}

class _NewsletterSectionState extends ConsumerState<NewsletterSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      print('[Newsletter] _submit: form invalid, aborting');
      return;
    }
    print('[Newsletter] _submit: email=${_emailCtrl.text.trim()}');
    ref.read(newsletterLoadingProvider.notifier).state = true;
    bool ok;
    try {
      ok = await BeatFlirtApi.subscribeNewsletter(_emailCtrl.text.trim());
    } catch (e) {
      print('[Newsletter] _submit: caught error → $e');
      ok = false;
    }
    print('[Newsletter] _submit: ok=$ok');
    ref.read(newsletterLoadingProvider.notifier).state = false;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ok ? kGreen : kRed,
        content: Text(
          ok
              ? 'Subscribed to newsletter successfully!'
              : 'Failed to subscribe. Please try again.',
        ),
      ),
    );
    if (ok) _emailCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(newsletterLoadingProvider);
    return SectionContent(
      tag: 'STAY UPDATED',
      title: 'Get Weekly Newsletters',
      subtitle: 'Stay updated with upcoming events & special offers.',
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A0A2E), Color(0xFF0D1A2E)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kDivider),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: kText, fontSize: 14),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email required';
                    if (!RegExp(
                      r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
                    ).hasMatch(v.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Your email address',
                    hintStyle: TextStyle(color: kSubText),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: kSubText,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    errorStyle: TextStyle(color: kRed, fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              loading
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: kPink,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : GradientButton(
                      label: 'Subscribe',
                      onTap: _submit,
                      compact: true,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 7 — FAQ
// ─────────────────────────────────────────────────────────────────────────────
class FAQSection extends ConsumerWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openIndex = ref.watch(openFaqIndexProvider);
    return SectionContent(
      tag: 'FAQ',
      title: 'Frequently Asked\nQuestions',
      subtitle: 'Everything you need to know about using Beat Flirt.',
      child: Column(
        children: List.generate(kFaqs.length, (i) {
          final faq = kFaqs[i];
          final isOpen = openIndex == i;
          return GestureDetector(
            onTap: () => ref.read(openFaqIndexProvider.notifier).state = isOpen
                ? null
                : i,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(
                bottom: i == kFaqs.length - 1 ? 0 : kCardGap,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isOpen ? kPink.withOpacity(0.08) : kCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isOpen ? kPink.withOpacity(0.4) : kDivider,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          faq['q']!,
                          style: TextStyle(
                            color: isOpen ? kPink : kText,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isOpen ? kPink : kSubText,
                        ),
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        faq['a']!,
                        style: const TextStyle(
                          color: kSubText,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                    crossFadeState: isOpen
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 8 — REGISTRATION  (wired to real booking API)
// ─────────────────────────────────────────────────────────────────────────────
class RegistrationSection extends ConsumerStatefulWidget {
  const RegistrationSection({super.key});
  @override
  ConsumerState<RegistrationSection> createState() =>
      _RegistrationSectionState();
}

class _RegistrationSectionState extends ConsumerState<RegistrationSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl, emailCtrl, phoneCtrl, messageCtrl;

  @override
  void initState() {
    super.initState();
    final fs = ref.read(registrationFormProvider);
    nameCtrl = TextEditingController(text: fs.name);
    emailCtrl = TextEditingController(text: fs.email);
    phoneCtrl = TextEditingController(text: fs.phone);
    messageCtrl = TextEditingController(text: fs.message);

    final n = ref.read(registrationFormProvider.notifier);
    nameCtrl.addListener(() => n.updateName(nameCtrl.text));
    emailCtrl.addListener(() => n.updateEmail(emailCtrl.text));
    phoneCtrl.addListener(() => n.updatePhone(phoneCtrl.text));
    messageCtrl.addListener(() => n.updateMessage(messageCtrl.text));
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(registrationFormProvider);
    final notifier = ref.read(registrationFormProvider.notifier);

    // surface API errors as a snackbar
    ref.listen(registrationFormProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(backgroundColor: kRed, content: Text(next.error!)),
        // );
        Get.snackbar('Error', next.error!, backgroundColor: kRed, colorText: Colors.white ,snackPosition: SnackPosition.TOP,duration: const Duration(seconds: 3));
      }
    });

    return SectionContent(
      tag: 'RESERVATION',
      title: 'Event Registration',
      subtitle: 'Register easily and manage your events seamlessly.',
      child: form.isSubmitted
          ? _buildSuccess(notifier)
          : _buildForm(form, notifier),
    );
  }

  Widget _buildSuccess(RegistrationFormNotifier notifier) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [kPink, kPurple]),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Registration Successful!',
            style: TextStyle(
              color: kText,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            "Thank you for registering!\nWe'll send confirmation details to your email shortly.",
            textAlign: TextAlign.center,
            style: TextStyle(color: kSubText, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 24),
          GradientButton(
            label: 'Register Another',
            onTap: () {
              notifier.reset();
              nameCtrl.clear();
              emailCtrl.clear();
              phoneCtrl.clear();
              messageCtrl.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm(
    RegistrationFormState form,
    RegistrationFormNotifier notifier,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            controller: nameCtrl,
            hint: 'Full Name',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter your full name'
                : null,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: emailCtrl,
            hint: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!RegExp(
                r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
              ).hasMatch(v.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildCountryDropdown(form, notifier)),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: _buildField(
                  controller: phoneCtrl,
                  hint: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Phone required';
                    if (!RegExp(r'^[0-9]{8,15}$').hasMatch(v.trim())) {
                      return 'Enter 8–15 digits';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: messageCtrl,
            hint: 'Event Name / Message',
            icon: Icons.event_rounded,
            maxLines: 3,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter event name / message'
                : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: form.isLoading
                ? Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [kPink, kPurple]),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => notifier.submit(_formKey),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                      shadowColor: kPink.withOpacity(0.4),
                    ),
                    child: const Text(
                      'BOOK NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: kText, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kSubText),
        prefixIcon: Icon(icon, color: kSubText, size: 20),
        filled: true,
        fillColor: kCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kRed, width: 2),
        ),
        errorStyle: const TextStyle(color: kRed, fontSize: 11),
      ),
    );
  }

  Widget _buildCountryDropdown(
    RegistrationFormState form,
    RegistrationFormNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 52,
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: kCountries.any((c) => c.code == form.countryCode)
              ? form.countryCode
              : null,
          dropdownColor: kCard,
          style: const TextStyle(color: kText, fontSize: 12),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: kSubText),
          isExpanded: true,
          items: kCountries
              .map(
                (c) => DropdownMenuItem(
                  value: c.code,
                  child: Text(
                    '${c.name} (${c.code})',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) notifier.updateCountry(v);
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED CONTENT WRAPPER  (reduced padding → smaller gaps between sections)
// ─────────────────────────────────────────────────────────────────────────────
class SectionContent extends StatelessWidget {
  final String tag, title, subtitle;
  final Widget child;
  const SectionContent({
    super.key,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBg,
      padding: EdgeInsets.fromLTRB(20, kSectionPadTop, 20, kSectionPadBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: kPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPink.withOpacity(0.3)),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: kPink,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: kText,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: kSubText, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SMALL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────
class BFLogo extends StatelessWidget {
  final bool large;
  const BFLogo({super.key, this.large = false});

  @override
  Widget build(BuildContext context) {
    final size = large ? 44.0 : 36.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [kPink, kPurple]),
            borderRadius: BorderRadius.circular(size * 0.22),
          ),
          alignment: Alignment.center,
          // Use a bundled asset; falls back to a music icon if missing.
          child: Image.asset(
            'assets/logo/logo.png',
            width: size * 0.55,
            errorBuilder: (_, __, ___) => Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: size * 0.55,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Beat Flirt',
          style: TextStyle(
            color: kText,
            fontSize: large ? 20 : 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class StatChip extends StatelessWidget {
  final String value, label;
  const StatChip({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (b) =>
              const LinearGradient(colors: [kPink, kPurple]).createShader(b),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(label, style: const TextStyle(color: kSubText, fontSize: 11)),
      ],
    );
  }
}

class Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const Pill({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDivider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kPink, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: kText, fontSize: 12)),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool compact;
  const GradientButton({
    super.key,
    required this.label,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 9)
            : const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kPink, kPurple]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: kPink.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: compact ? 13 : 15,
          ),
        ),
      ),
    );
  }
}

// Small reusable image loading / error placeholders.
class _ImagePlaceholder extends StatelessWidget {
  final double height;
  const _ImagePlaceholder({required this.height});
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    color: kCard,
    child: const Center(child: CircularProgressIndicator(color: kPink)),
  );
}

class _ImageError extends StatelessWidget {
  final double height;
  const _ImageError({required this.height});
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: kSubText,
        size: 48,
      ),
    ),
  );
}
