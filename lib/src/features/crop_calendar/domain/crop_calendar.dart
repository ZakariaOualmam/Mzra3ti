/// Crop Calendar Entry
class CropCalendarEntry {
  final int? id;
  final String cropName;
  final String cropType; // Vegetables, Grains, Fruits, etc.
  final DateTime plantingDate;
  final DateTime? expectedHarvestDate;
  final int growthDaysEstimate;
  final String season; // Spring, Summer, Fall, Winter
  final bool reminderEnabled;
  final String? notes;

  CropCalendarEntry({
    this.id,
    required this.cropName,
    required this.cropType,
    required this.plantingDate,
    this.expectedHarvestDate,
    required this.growthDaysEstimate,
    required this.season,
    this.reminderEnabled = true,
    this.notes,
  });

  DateTime get calculatedHarvestDate =>
      expectedHarvestDate ?? plantingDate.add(Duration(days: growthDaysEstimate));

  int get daysUntilHarvest => calculatedHarvestDate.difference(DateTime.now()).inDays;
  
  bool get isReadyToHarvest => daysUntilHarvest <= 0;
  bool get harvestSoon => daysUntilHarvest > 0 && daysUntilHarvest <= 7;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropName': cropName,
      'cropType': cropType,
      'plantingDate': plantingDate.toIso8601String(),
      'expectedHarvestDate': expectedHarvestDate?.toIso8601String(),
      'growthDaysEstimate': growthDaysEstimate,
      'season': season,
      'reminderEnabled': reminderEnabled ? 1 : 0,
      'notes': notes,
    };
  }

  factory CropCalendarEntry.fromMap(Map<String, dynamic> map) {
    return CropCalendarEntry(
      id: map['id'],
      cropName: map['cropName'],
      cropType: map['cropType'],
      plantingDate: DateTime.parse(map['plantingDate']),
      expectedHarvestDate: map['expectedHarvestDate'] != null
          ? DateTime.parse(map['expectedHarvestDate'])
          : null,
      growthDaysEstimate: map['growthDaysEstimate'],
      season: map['season'],
      reminderEnabled: map['reminderEnabled'] == 1,
      notes: map['notes'],
    );
  }
}

/// Crop Information Template
class CropTemplate {
  final String name;
  final String type;
  final int typicalGrowthDays;
  final List<String> bestSeasons;
  final String icon;

  CropTemplate({
    required this.name,
    required this.type,
    required this.typicalGrowthDays,
    required this.bestSeasons,
    required this.icon,
  });
}

/// Predefined crop templates
class CropTemplates {
  static final List<CropTemplate> templates = [
    CropTemplate(name: 'طماطم', type: 'خضروات', typicalGrowthDays: 75, bestSeasons: ['الربيع', 'الصيف'], icon: '🍅'),
    CropTemplate(name: 'خيار', type: 'خضروات', typicalGrowthDays: 60, bestSeasons: ['الربيع', 'الصيف'], icon: '🥒'),
    CropTemplate(name: 'بطاطس', type: 'خضروات', typicalGrowthDays: 90, bestSeasons: ['الربيع', 'الخريف'], icon: '🥔'),
    CropTemplate(name: 'قمح', type: 'حبوب', typicalGrowthDays: 120, bestSeasons: ['الشتاء', 'الربيع'], icon: '🌾'),
    CropTemplate(name: 'ذرة', type: 'حبوب', typicalGrowthDays: 85, bestSeasons: ['الصيف'], icon: '🌽'),
    CropTemplate(name: 'فلفل', type: 'خضروات', typicalGrowthDays: 70, bestSeasons: ['الربيع', 'الصيف'], icon: '🌶️'),
    CropTemplate(name: 'بصل', type: 'خضروات', typicalGrowthDays: 100, bestSeasons: ['الخريف', 'الشتاء'], icon: '🧅'),
    CropTemplate(name: 'جزر', type: 'خضروات', typicalGrowthDays: 70, bestSeasons: ['الربيع', 'الخريف'], icon: '🥕'),
    CropTemplate(name: 'بطيخ', type: 'فواكه', typicalGrowthDays: 90, bestSeasons: ['الصيف'], icon: '🍉'),
    CropTemplate(name: 'فراولة', type: 'فواكه', typicalGrowthDays: 60, bestSeasons: ['الربيع'], icon: '🍓'),
  ];
}
