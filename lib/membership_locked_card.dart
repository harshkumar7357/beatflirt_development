import 'package:flutter/material.dart';

/// Reusable Beat Flirt membership lock card + membership dialog.
///
/// This file extracts everything related to the locked membership card from
/// your BlocklistPage so you can use it in any other Dart file/screen.
///
/// Usage:
///
/// if (BeatMembershipLock.isLocked(membershipValue)) {
///   return BeatMembershipLockedCard(
///     onPurchase: () {
///       Navigator.push(context, MaterialPageRoute(builder: (_) => const UpgradePage()));
///     },
///   );
/// }
///
/// Or show only the dialog:
///
/// BeatMembershipLock.showDialogBox(
///   context,
///   onPurchase: () {
///     Navigator.push(context, MaterialPageRoute(builder: (_) => const UpgradePage()));
///   },
/// );


const String beatWebBase = 'https://beatflirtevent.com/';

String beatWebAsset(String path) => '$beatWebBase$path';

class BeatMembershipLock {
  BeatMembershipLock._();

  static const Color lightBg = Color(0xFFFFF4FA);
  static const Color primary = Color(0xFF1D042A);
  static const Color maroon = Color(0xFF560827);
  static const Color pink = Color(0xFFE91E63);
  static const Color navy = Color(0xFF06032C);

  /// The website stores membership_expire as `membership`.
  /// Angular shows real cards when this value is exactly "Yes".
  static bool isLocked(
    String? membershipValue, {
    bool enforceMembershipLock = true,
  }) {
    if (!enforceMembershipLock) return false;
    return membershipValue != 'Yes';
  }

  static Future<void> showDialogBox(
    BuildContext context, {
    VoidCallback? onPurchase,
    String title = 'Beat Flirt Team!',
    String message = '"You have not purchased a Beat Flirt membership plan. Buy membership"',
    String purchaseText = 'Purchase',
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => BeatMembershipDialog(
        title: title,
        message: message,
        purchaseText: purchaseText,
        onPurchase: onPurchase,
      ),
    );
  }
}

class BeatMembershipLockedCard extends StatelessWidget {
  const BeatMembershipLockedCard({
    super.key,
    this.onPurchase,
    this.height = 425,
    this.topMargin = 60,
    this.logoWidth = 240,
    this.logoHeight = 300,
    this.borderRadius = 20,
    this.backgroundImagePath = 'assets/img/celebrity/bg-logo.jpg',
  });

  final VoidCallback? onPurchase;
  final double height;
  final double topMargin;
  final double logoWidth;
  final double logoHeight;
  final double borderRadius;
  final String backgroundImagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BeatMembershipLock.showDialogBox(
          context,
          onPurchase: onPurchase,
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: topMargin),
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              BeatMembershipLock.maroon,
              BeatMembershipLock.navy,
            ],
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x4D000000),
              blurRadius: 40,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: logoWidth,
            height: logoHeight,
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                beatWebAsset(backgroundImagePath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 54,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BeatMembershipDialog extends StatelessWidget {
  const BeatMembershipDialog({
    super.key,
    this.onPurchase,
    this.title = 'Beat Flirt Team!',
    this.message = '"You have not purchased a Beat Flirt membership plan. Buy membership"',
    this.purchaseText = 'Purchase',
  });

  final VoidCallback? onPurchase;
  final String title;
  final String message;
  final String purchaseText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              BeatMembershipLock.maroon,
              BeatMembershipLock.navy,
            ],
          ),
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BeatMembershipLock.maroon,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                onPurchase?.call();
              },
              child: Text(purchaseText),
            ),
          ],
        ),
      ),
    );
  }
}


//It contains:

// BeatMembershipLockedCard
// BeatMembershipDialog
// BeatMembershipLock.isLocked()
// BeatMembershipLock.showDialogBox()
// Required colors
// Required beatWebAsset() helper
// Locked card image:
// https://beatflirtevent.com/assets/img/celebrity/bg-logo.jpg
// Use it in another file like this:

// Then replace your old _lockedCard() usage with:
// BeatMembershipLockedCard(
//   onPurchase: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const UpgradePage()),
//     );
//   },
// )


// For membership check:
// final cardsLocked = BeatMembershipLock.isLocked(_membershipValue);

// Example inside your grid:
// if (BeatMembershipLock.isLocked(_membershipValue)) {
//   return BeatMembershipLockedCard(
//     onPurchase: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const UpgradePage()),
//       );
//     },
//   );
// }

// return _friendCard(user);


// If you only want to show the membership dialog:
// BeatMembershipLock.showDialogBox(
//   context,
//   onPurchase: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const UpgradePage()),
//     );
//   },
// );

// The extracted file is standalone and reusable.


