class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String password; // Ajout du champ password
  final String role;
  final String adresse;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password, // Ajout du champ password dans le constructeur
    required this.role,
    required this.adresse,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['motDePasse'], // Conversion du champ motDePasse en password
      role: json['role'],
      adresse: json['adresse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': password, // Conversion du champ password en motDePasse
      'role': role,
      'adresse': adresse,
    };
  }
}
