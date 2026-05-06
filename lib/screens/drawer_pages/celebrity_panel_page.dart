import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class CelebrityPanelPage extends StatelessWidget {
  const CelebrityPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Celebrity Panel', icon: Icons.star_purple500_sharp);
  }
}
