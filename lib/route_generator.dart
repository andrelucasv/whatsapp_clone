import 'package:flutter/material.dart';
import 'package:whatsapp_clone/home_page.dart';
import 'package:whatsapp_clone/login_page.dart';
import 'package:whatsapp_clone/register_page.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    
    switch(settings.name) {
      case "/" :
        return MaterialPageRoute(
          builder: (_) => const Login()
        );
      case "/login" :
        return MaterialPageRoute(
          builder: (_) => const Login()
        );
      case "/cadastro" :
        return MaterialPageRoute(
          builder: (_) => const Cadastro()
        );
      case "/home" :
        return MaterialPageRoute(
          builder: (_) => const Home()
        );
      default: _erroRota();
    }
    
    return null;
  
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Tela não encontrada!"),
          ),
          body: const Center(
            child: Text("Tela não encontrada")
          ),
        );
      }
    );
  }

}