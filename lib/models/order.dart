class Order {
  final int id;
  final double montantTotal;
  final String statut;

  Order({
    required this.id,
    required this.montantTotal,
    required this.statut,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      montantTotal: json['montantTotal']?.toDouble() ?? 0.0,
      statut: json['statut'],
    );
  }
}
