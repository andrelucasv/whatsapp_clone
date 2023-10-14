import 'package:flutter/material.dart';

class TabConversas extends StatefulWidget {
  const TabConversas({super.key});

  @override
  State<TabConversas> createState() => _TabConversasState();
}

class _TabConversasState extends State<TabConversas> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("Conversas"),
    );
  }
}