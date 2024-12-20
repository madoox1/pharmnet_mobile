class Prescription {
  final int id;
  final DateTime dateEnvoi;
  final String imageUrl;
  final String statut;

  Prescription({
    required this.id,
    required this.dateEnvoi,
    required this.imageUrl,
    required this.statut,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      dateEnvoi: DateTime.fromMillisecondsSinceEpoch(json['dateEnvoi'] as int),
      imageUrl: json['imageUrl'],
      statut: json['statut'],
    );
  }
}
