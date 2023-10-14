class Usuario {

  String? nome;
  String? email;
  String? senha;

  Usuario({this.nome, this.email, this.senha});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "nome" : nome,
      "email" : email
    };

    return map;

  }

}