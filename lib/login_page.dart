import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/home_page.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/register_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //Controladores
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    //Recuperar dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    RegExp regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");


    if (regex.hasMatch(email)) {

      if (senha.isNotEmpty) {

        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);

      } else {

        setState(() {
          _mensagemErro = "Preencha a senha com mais de 6 caracteres!";
        });

      }
    } else {

      setState(() {
        _mensagemErro = "Preencha o e-mail corretamente";
      });

    }
  }

  _logarUsuario(Usuario usuario) async {

    FirebaseAuth auth = FirebaseAuth.instance;

    try {

      await auth.signInWithEmailAndPassword(
      email: usuario.email!, 
      password: usuario.senha!
      );

      if(context.mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home()
          )
        );

      }

    } on FirebaseAuthException catch (error) {

      setState(() {
        _mensagemErro = "Erro ao autenticar usuário, verifique o e-mail e a senha";
      });
      debugPrint("Erro do app: ${error.toString()}");
      
    }

  }

   Future _verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    //await auth.signOut();

    auth.authStateChanges()
      .listen((User? user) {
        if(user != null) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const Home()
            )
          );
        }
      });

  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        _validarCampos();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.green),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.fromLTRB(32, 16, 32, 16)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)))),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ),
                Center(
                  child: GestureDetector(
                    child: const Text(
                      "Não tem conta? Cadastre-se!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Cadastro()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
