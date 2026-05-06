import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Favorite', icon: Icons.edit);
  }
}
