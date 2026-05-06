import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class LiveChatroomPage extends StatelessWidget {
  const LiveChatroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Live Chatroom', icon: Icons.mark_chat_read_outlined);
  }
}
