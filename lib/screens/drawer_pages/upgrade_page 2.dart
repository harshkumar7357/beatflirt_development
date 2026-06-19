import 'package:beatflirt/model/membership_model.dart';
import 'package:beatflirt/providers/membership_provider.dart';
import 'package:beatflirt/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// Provider to manage selected subscription plan
class SelectedPlanNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void selectPlan(int index) {
    state = index;
  }
}

final selectedPlanProvider = NotifierProvider<SelectedPlanNotifier, int>(
  SelectedPlanNotifier.new,
);

class UpgradePage extends ConsumerStatefulWidget {
  const UpgradePage({super.key});

  @override
  ConsumerState<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends ConsumerState<UpgradePage> {
  late Razorpay _razorpay;

  MembershipModel? _selectedPlanForPayment;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handlePaymentError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔵 UpgradePage opened — fetching memberships');

      ref.read(membershipProvider.notifier).fetchAllMemberships();
      ref.read(membershipProvider.notifier).fetchUserMembershipPlan();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    final selectedPlan = _selectedPlanForPayment;

    if (selectedPlan == null) return;

    try {
      final amount = selectedPlan.headingTitlePrice;

      await ref.read(membershipProvider.notifier).buyMembership(
            membershipId: selectedPlan.id,
            paymentId: response.paymentId ?? '',
            amount: amount,
          );

      if (!mounted) return;

      Get.snackbar(
        'Payment Successful',
        'Your membership has been upgraded to ${selectedPlan.headingTitleName}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      if (!mounted) return;

      Get.snackbar(
        'Update Failed',
        "Payment was successful but we couldn't update your plan. Please contact support.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      _selectedPlanForPayment = null;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      'Payment Failed',
      response.message?.isNotEmpty == true ? response.message! : 'Try Again',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet: ${response.walletName}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _startPayment(
    MembershipModel plan,
    PaymentState paymentState,
  ) {
    final amount = double.tryParse(plan.headingTitlePrice) ?? 0.0;

    if (amount <= 0) return;

    _selectedPlanForPayment = plan;

    // Razorpay expects smallest currency unit.
    // INR example: rupees * 100 = paise
    final convertedAmount = amount * paymentState.currency.rate * 100;

    final options = {
      // TODO: Replace this with your real Razorpay key.
      'key': 'rzp_test_YOUR_KEY_HERE',
      'amount': convertedAmount.toInt(),
      'name': 'BeatFlirt VIP',
      'description': '${plan.headingTitleName} Subscription',
      'prefill': {
        'contact': '',
        'email': '',
      },
      'external': {
        'wallets': ['paytm'],
      },
      'notes': {
        'membership_id': plan.id,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay open error: $e');

      Get.snackbar(
        'Payment Error',
        'Unable to start payment. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final membershipState = ref.watch(membershipProvider);

    final screenWidth = MediaQuery.of(context).size.width;

    const primaryDark = Color(0xFF2E102E);
    const accentPink = Color(0xFFE91E63);
    const bgColor = Color(0xFFFDF2F7);

    if (membershipState.isLoading && membershipState.memberships.isEmpty) {
      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(
            color: accentPink,
          ),
        ),
      );
    }

    if (membershipState.error != null &&
        membershipState.memberships.isEmpty) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black87,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: accentPink,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  membershipState.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(membershipProvider.notifier)
                        .fetchAllMemberships();
                    ref
                        .read(membershipProvider.notifier)
                        .fetchUserMembershipPlan();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final plans = membershipState.memberships;
    final currentMembershipId = membershipState.userPlan?.membershipId;

    final double titleSize =
        (screenWidth * 0.09).clamp(28.0, 56.0).toDouble();

    final double subtitleSize =
        (screenWidth * 0.04).clamp(12.0, 18.0).toDouble();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primaryDark,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'membership',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Choose the Perfect Plan for Your Business',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w900,
                  color: primaryDark,
                  letterSpacing: -1.2,
                  height: 1.02,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Text(
                "Whether you're just starting or scaling up, we have flexible plans to fit your needs.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: accentPink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (plans.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No membership plans available.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              )
            else
              SizedBox(
                height: 520,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    return _buildPlanCard(
                      plan: plans[index],
                      index: index,
                      currentMembershipId: currentMembershipId,
                      paymentState: paymentState,
                    );
                  },
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required MembershipModel plan,
    required int index,
    required String? currentMembershipId,
    required PaymentState paymentState,
  }) {
    final selectedIndex = ref.watch(selectedPlanProvider);

    final isSelected = selectedIndex == index;
    final isCurrentPlan = currentMembershipId == plan.id;

    final planName = plan.headingTitleName.toUpperCase();

    final bool isDark =
        planName == 'PLATINUM' || planName == 'DIAMOND' || planName == 'GOLD';

    final double priceValue =
        double.tryParse(plan.headingTitlePrice) ?? 0.0;

    final List<String> benefits = [];

    final regExp = RegExp(
      r'<li>(.*?)<\/li>',
      caseSensitive: false,
      dotAll: true,
    );

    final matches = regExp.allMatches(plan.content);

    for (final match in matches) {
      benefits.add(
        match
                .group(1)
                ?.replaceAll('&nbsp;', ' ')
                .replaceAll(RegExp(r'<[^>]*>'), '')
                .trim() ??
            '',
      );
    }

    if (benefits.isEmpty && plan.content.isNotEmpty) {
      benefits.add(
        plan.content
            .replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ')
            .trim(),
      );
    }

    return GestureDetector(
      onTap: () {
        ref.read(selectedPlanProvider.notifier).selectPlan(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 300,
        margin: const EdgeInsets.only(
          right: 20,
          bottom: 24,
          top: 8,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2E102E) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? const Color(0xFFE91E63) : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isDark)
              Positioned(
                top: 18,
                left: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Most Popular',
                    style: TextStyle(
                      color: Color(0xFF2E102E),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                isDark ? 58 : 30,
                20,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${plan.headingTitlePrice} ',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFFE91E63),
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: '/${plan.headingTitlePlan}',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    plan.subHeading1Title.isNotEmpty
                        ? plan.subHeading1Title
                        : 'discount on event',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: priceValue == 0 || isCurrentPlan
                          ? null
                          : () => _startPayment(plan, paymentState),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.white
                            : const Color(0xFFE91E63),
                        foregroundColor: isDark
                            ? const Color(0xFF2E102E)
                            : Colors.white,
                        disabledBackgroundColor: isDark
                            ? Colors.white.withOpacity(0.12)
                            : Colors.grey.shade300,
                        disabledForegroundColor:
                            isDark ? Colors.white70 : Colors.white70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        isCurrentPlan ? 'CURRENT PLAN' : 'Select Plan',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: isCurrentPlan
                              ? const Color(0xFF2E102E)
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: benefits.length,
                      itemBuilder: (context, benefitIndex) {
                        final benefit = benefits[benefitIndex];

                        final isHighlight =
                            benefit.contains('\$') || benefit.contains('%');

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check,
                                size: 18,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFFE91E63),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.9)
                                        : isHighlight
                                            ? const Color(0xFFE91E63)
                                            : const Color(0xFF2E102E),
                                    fontSize: 13,
                                    fontWeight: isHighlight
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:beatflirt/providers/membership_provider.dart';
// import 'package:beatflirt/model/membership_model.dart';

// import '../../providers/payment_provider.dart';

// // Provider to manage selected subscription plan
// final selectedPlanProvider = StateProvider<int>((ref) => 0);

// class UpgradePage extends ConsumerStatefulWidget {
//   const UpgradePage({super.key});

//   @override
//   ConsumerState<UpgradePage> createState() => _UpgradePageState();
// }

// class _UpgradePageState extends ConsumerState<UpgradePage> {
//   late Razorpay _razorpay;
//   MembershipModel? _selectedPlanForPayment;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       debugPrint('🔵 UpgradePage opened — fetching memberships');
//       ref.read(membershipProvider.notifier).fetchAllMemberships();
//       ref.read(membershipProvider.notifier).fetchUserMembershipPlan();
//     });
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     if (_selectedPlanForPayment == null) return;

//     try {
//       final amount = _selectedPlanForPayment!.headingTitlePrice;
//       await ref.read(membershipProvider.notifier).buyMembership(
//             membershipId: _selectedPlanForPayment!.id,
//             paymentId: response.paymentId ?? '',
//             amount: amount,
//           );

//       Get.snackbar(
//         "Payment Successful",
//         "Your membership has been upgraded to ${_selectedPlanForPayment!.headingTitleName}",
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } catch (e) {
//       Get.snackbar(
//         "Update Failed",
//         "Payment was successful but we couldn't update your plan. Please contact support.",
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 5),
//       );
//     } finally {
//       _selectedPlanForPayment = null;
//     }
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   SnackBar(
//     //     content: Text('Payment Failed: ${response.message}'),
//     //     backgroundColor: Colors.red,
//     //   ),
//     // );
//     Get.snackbar("Payment Failed", 
//     // response.message.toString(),
//     "Try Again",
//     snackPosition: SnackPosition.TOP,
//     backgroundColor: Colors.red,
//     colorText: Colors.white,
//     duration: Duration(seconds: 2),
//     );
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('External Wallet: ${response.walletName}'),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }

//   void _startPayment(MembershipModel plan, PaymentState paymentState) {
//     final amount = double.tryParse(plan.headingTitlePrice) ?? 0.0;
//     if (amount <= 0) return;

//     _selectedPlanForPayment = plan;

//     final convertedAmount = amount * paymentState.currency.rate * 100; // Razorpay expects paise/cents

//     var options = {
//       'key': 'rzp_test_YOUR_KEY_HERE', // Replace with your actual key
//       'amount': convertedAmount.toInt(),
//       'name': 'BeatFlirt VIP',
//       'description': '${plan.headingTitleName} Subscription',
//       'prefill': {
//         'contact': '',
//         'email': ''
//       },
//       'external': {
//         'wallets': ['paytm']
//       },
//       'notes': {
//         'membership_id': plan.id,
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paymentState = ref.watch(paymentProvider);
//     final membershipState = ref.watch(membershipProvider);

//     final screenWidth = MediaQuery.of(context).size.width;
//     final primaryDark = const Color(0xFF2E102E);
//     final accentPink = const Color(0xFFE91E63);
//     final bgColor = const Color(0xFFFDF2F7);

//     if (membershipState.isLoading && membershipState.memberships.isEmpty) {
//       return Scaffold(
//         backgroundColor: bgColor,
//         body: Center(child: CircularProgressIndicator(color: accentPink)),
//       );
//     }

//     final plans = membershipState.memberships;
//     final currentMembershipId = membershipState.userPlan?.membershipId;

//     // Reduced multipliers to make the page more compact on smaller screens
//     final double titleSize = (screenWidth * 0.09).clamp(28.0, 56.0).toDouble();
//     final double subtitleSize = (screenWidth * 0.04).clamp(12.0, 18.0).toDouble();

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             const SizedBox(height: 8),
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: primaryDark,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const Text(
//                   "membership",
//                   style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 "Choose the Perfect Plan for Your Business",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: titleSize,
//                   fontWeight: FontWeight.w900,
//                   color: primaryDark,
//                   letterSpacing: -1.2,
//                   height: 1.02,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               child: Text(
//                 "Whether you're just starting or scaling up, we have flexible plans to fit your needs.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: subtitleSize,
//                   color: accentPink,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               height: 520,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 itemCount: plans.length,
//                 itemBuilder: (context, index) {
//                   return _buildPlanCard(plans[index], currentMembershipId, paymentState);
//                 },
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanCard(MembershipModel plan, String? currentMembershipId, PaymentState paymentState) {
//     final isCurrentPlan = currentMembershipId == plan.id;
//     final bool isDark = plan.headingTitleName.toUpperCase() == "PLATINUM" || plan.headingTitleName.toUpperCase() == "DIAMOND" || plan.headingTitleName.toUpperCase() == "GOLD";
//     final double priceValue = double.tryParse(plan.headingTitlePrice) ?? 0.0;
    
//     // Parse benefits
//     final List<String> benefits = [];
//     final regExp = RegExp(r"<li>(.*?)<\/li>");
//     final matches = regExp.allMatches(plan.content);
//     for (var match in matches) {
//       benefits.add(match.group(1)?.replaceAll('&nbsp;', ' ').trim() ?? '');
//     }
//     if (benefits.isEmpty && plan.content.isNotEmpty) {
//       benefits.add(plan.content.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ').trim());
//     }

//     return Container(
//       width: 300,
//       margin: const EdgeInsets.only(right: 20, bottom: 24, top: 8),
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF2E102E) : Colors.white,
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.06),
//             blurRadius: 18,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           if (isDark)
//             Positioned(
//               top: 18,
//               left: 18,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   "Most Popular",
//                   style: TextStyle(
//                     color: Color(0xFF2E102E),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ),
//             ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(20, isDark ? 58 : 30, 20, 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   plan.headingTitleName.toUpperCase(),
//                   style: TextStyle(
//                     color: isDark ? Colors.white70 : Colors.black87,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "\$${plan.headingTitlePrice} ",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : const Color(0xFFE91E63),
//                           fontSize: 40,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       TextSpan(
//                         text: "/${plan.headingTitlePlan}",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   plan.subHeading1Title.isNotEmpty ? plan.subHeading1Title : "discount on event",
//                   style: TextStyle(
//                     color: isDark ? Colors.white70 : Colors.black87,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 44,
//                   child: ElevatedButton(
//                     onPressed: (priceValue == 0 || isCurrentPlan)
//                         ? null
//                         : () => _startPayment(plan, paymentState),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isDark ? Colors.white : const Color(0xFFE91E63),
//                       foregroundColor: isDark ? const Color(0xFF2E102E) : Colors.white,
//                       disabledBackgroundColor: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.grey.shade300,
//                       disabledForegroundColor: isDark ? Colors.white70 : Colors.white70,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: Text(
//                       isCurrentPlan ? "CURRENT PLAN" : "Select Plan",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16,
//                         color: (isCurrentPlan)
//                             ? (isDark ? const Color(0xFF2E102E) : const Color(0xFF2E102E))
//                             : null,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: benefits.length,
//                     itemBuilder: (context, bIndex) {
//                       final benefit = benefits[bIndex];
//                       final isHighlight = benefit.contains("\$") || benefit.contains("%");
                      
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.check,
//                               size: 18,
//                               color: isDark ? Colors.white : const Color(0xFFE91E63),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 benefit,
//                                 style: TextStyle(
//                                   color: isDark 
//                                       ? Colors.white.withValues(alpha: 0.9) 
//                                       : (isHighlight ? const Color(0xFFE91E63) : const Color(0xFF2E102E)),
//                                   fontSize: 13,
//                                   fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
//                                   height: 1.3,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
