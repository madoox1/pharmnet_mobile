class Pharmacy {
  final int id;
  final String nom;
  final String adresse;
  final String status;
  final double latitude;
  final double longitude;

  Pharmacy({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'],
      nom: json['nom'],
      adresse: json['adresse'],
      status: json['status'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
