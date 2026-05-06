import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class EventsPartyPage extends StatelessWidget {
  const EventsPartyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Events & Party', icon: Icons.event_available_outlined);
  }
}
