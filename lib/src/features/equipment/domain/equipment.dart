/// Equipment Model
class Equipment {
  final int? id;
  final String name;
  final String type; // Tractor, Pump, Tools, etc.
  final DateTime purchaseDate;
  final double purchasePrice;
  final String status; // Active, Maintenance, Broken
  final DateTime? lastMaintenance;
  final DateTime? nextMaintenance;
  final String? notes;

  Equipment({
    this.id,
    required this.name,
    required this.type,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.status,
    this.lastMaintenance,
    this.nextMaintenance,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'purchaseDate': purchaseDate.toIso8601String(),
      'purchasePrice': purchasePrice,
      'status': status,
      'lastMaintenance': lastMaintenance?.toIso8601String(),
      'nextMaintenance': nextMaintenance?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      purchasePrice: map['purchasePrice'],
      status: map['status'],
      lastMaintenance: map['lastMaintenance'] != null 
          ? DateTime.parse(map['lastMaintenance']) 
          : null,
      nextMaintenance: map['nextMaintenance'] != null 
          ? DateTime.parse(map['nextMaintenance']) 
          : null,
      notes: map['notes'],
    );
  }

  bool needsMaintenance() {
    if (nextMaintenance == null) return false;
    return DateTime.now().isAfter(nextMaintenance!);
  }
}

/// Maintenance Record Model
class MaintenanceRecord {
  final int? id;
  final int equipmentId;
  final DateTime date;
  final String description;
  final double cost;
  final String performedBy;

  MaintenanceRecord({
    this.id,
    required this.equipmentId,
    required this.date,
    required this.description,
    required this.cost,
    required this.performedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipmentId': equipmentId,
      'date': date.toIso8601String(),
      'description': description,
      'cost': cost,
      'performedBy': performedBy,
    };
  }

  factory MaintenanceRecord.fromMap(Map<String, dynamic> map) {
    return MaintenanceRecord(
      id: map['id'],
      equipmentId: map['equipmentId'],
      date: DateTime.parse(map['date']),
      description: map['description'],
      cost: map['cost'],
      performedBy: map['performedBy'],
    );
  }
}
