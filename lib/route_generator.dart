import 'package:flutter/material.dart';
import 'package:whatsapp_clone/configuracoes_menu.dart';
import 'package:whatsapp_clone/home_page.dart';
import 'package:whatsapp_clone/login_page.dart';
import 'package:whatsapp_clone/messages.dart';
import 'package:whatsapp_clone/register_page.dart';

class RouteGenerator {

  static dynamic args;
  static Route<dynamic>? generateRoute(RouteSettings settings) {

    args = settings.arguments;
    
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
      case "/configuracoes" :
        return MaterialPageRoute(
          builder: (_) => const Configuracoes()
        );
        case "/mensagens" :
          return MaterialPageRoute(
            builder: (_) => Mensagens(args)
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