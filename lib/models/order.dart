class Order {
  final int id;
  final String status;
  final String statut;
  final double montantTotal;
  final String? deliveryAddress; // Rendu nullable
  final DateTime? estimatedDeliveryTime; // Rendu nullable
  final DateTime createdAt;
  final List<OrderStep> steps;

  Order({
    required this.id,
    this.status = 'PENDING', // Valeur par défaut
    this.statut = 'En attente', // Valeur par défaut
    this.montantTotal = 0.0, // Valeur par défaut
    this.deliveryAddress,
    this.estimatedDeliveryTime,
    required this.createdAt,
    List<OrderStep>? steps, // Rendu nullable
  }) : steps = steps ?? []; // Utilisation d'une liste vide par défaut

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int? ?? 0, // Valeur par défaut si null
      status: json['status'] as String? ?? 'PENDING',
      statut: json['statut'] as String? ?? 'En attente',
      montantTotal: (json['montantTotal'] as num?)?.toDouble() ?? 0.0,
      deliveryAddress: json['deliveryAddress'] as String?,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null 
          ? DateTime.parse(json['estimatedDeliveryTime'])
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      steps: json['steps'] != null
          ? (json['steps'] as List)
              .map((step) => OrderStep.fromJson(step as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'statut': statut,
      'montantTotal': montantTotal,
      'deliveryAddress': deliveryAddress,
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }
}

class OrderStep {
  final String status;
  final DateTime? completedAt;
  final bool isCompleted;

  OrderStep({
    required this.status,
    this.completedAt,
    this.isCompleted = false, // Valeur par défaut
  });

  factory OrderStep.fromJson(Map<String, dynamic> json) {
    return OrderStep(
      status: json['status'] as String? ?? 'PENDING',
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'])
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
