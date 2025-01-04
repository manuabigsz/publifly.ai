class CurrentUser {
  final String id;
  final String nome;
  final String email;
  String logoUrl;

  final String uid;
  final String dataCadastro;

  CurrentUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.logoUrl,
    required this.uid,
    required this.dataCadastro,
  });

  CurrentUser.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nome = map['nome'],
        email = map['email'],
        logoUrl = map['logoUrl'],
        uid = map['uid'],
        dataCadastro = map['dataCadastro'];
}
