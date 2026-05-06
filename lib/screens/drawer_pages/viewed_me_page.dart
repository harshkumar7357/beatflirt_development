import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class ViewedMePage extends StatelessWidget {
  const ViewedMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Viewed Me', icon: Icons.history);
  }
}
