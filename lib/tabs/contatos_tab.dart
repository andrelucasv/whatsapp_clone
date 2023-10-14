import 'package:flutter/material.dart';

class TabaContatos extends StatefulWidget {
  const TabaContatos({super.key});

  @override
  State<TabaContatos> createState() => _TabaContatosState();
}

class _TabaContatosState extends State<TabaContatos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("Contatos"),
    );
  }
}