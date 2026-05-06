import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class OnlinePage extends StatelessWidget {
  const OnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Online', icon: Icons.phone_android_sharp);
  }
}
