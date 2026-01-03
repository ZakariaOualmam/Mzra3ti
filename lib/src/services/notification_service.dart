import 'package:flutter/material.dart';
import '../features/crop_calendar/data/crop_calendar_repository.dart';
import '../features/equipment/data/equipment_repository.dart';
import '../features/irrigation/data/irrigation_repository.dart';

/// Notification Model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // reminder, alert, info
  final DateTime timestamp;
  final String? actionRoute;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.actionRoute,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case 'reminder':
        return Icons.notifications_active;
      case 'alert':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color get color {
    switch (type) {
      case 'reminder':
        return Colors.blue;
      case 'alert':
        return Colors.orange;
      case 'info':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

/// Notification Service - Generates smart notifications
class NotificationService {
  final _cropRepo = CropCalendarRepository();
  final _equipmentRepo = EquipmentRepository();
  final _irrigationRepo = IrrigationRepository();

  Future<List<AppNotification>> getAllNotifications() async {
    final List<AppNotification> notifications = [];
    
    // Crop Harvest Reminders
    final cropNotifications = await _getCropNotifications();
    notifications.addAll(cropNotifications);
    
    // Equipment Maintenance Alerts
    final equipmentNotifications = await _getEquipmentNotifications();
    notifications.addAll(equipmentNotifications);
    
    // Irrigation Reminders
    final irrigationNotifications = await _getIrrigationNotifications();
    notifications.addAll(irrigationNotifications);
    
    // Sort by timestamp (newest first)
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return notifications;
  }

  Future<List<AppNotification>> _getCropNotifications() async {
    final List<AppNotification> notifications = [];
    final crops = await _cropRepo.list();
    
    for (var crop in crops) {
      if (crop.isReadyToHarvest) {
        notifications.add(AppNotification(
          id: 'crop_ready_${crop.id}',
          title: '🌾 حصاد ${crop.cropName}',
          message: 'حان موعد حصاد ${crop.cropName}! المحصول جاهز الآن.',
          type: 'alert',
          timestamp: crop.calculatedHarvestDate,
          actionRoute: '/crop-calendar',
        ));
      } else if (crop.harvestSoon && crop.reminderEnabled) {
        notifications.add(AppNotification(
          id: 'crop_soon_${crop.id}',
          title: '📅 تذكير: ${crop.cropName}',
          message: 'موعد حصاد ${crop.cropName} خلال ${crop.daysUntilHarvest} أيام.',
          type: 'reminder',
          timestamp: DateTime.now(),
          actionRoute: '/crop-calendar',
        ));
      }
    }
    
    return notifications;
  }

  Future<List<AppNotification>> _getEquipmentNotifications() async {
    final List<AppNotification> notifications = [];
    final equipment = await _equipmentRepo.list();
    
    for (var item in equipment) {
      if (item.needsMaintenance()) {
        notifications.add(AppNotification(
          id: 'equipment_${item.id}',
          title: '🔧 صيانة ${item.name}',
          message: '${item.name} تحتاج لصيانة! الموعد المحدد: ${item.nextMaintenance}',
          type: 'alert',
          timestamp: item.nextMaintenance!,
          actionRoute: '/equipment',
        ));
      }
    }
    
    return notifications;
  }

  Future<List<AppNotification>> _getIrrigationNotifications() async {
    final List<AppNotification> notifications = [];
    final irrigations = await _irrigationRepo.getAll();
    
    // Check if last irrigation was more than 3 days ago
    if (irrigations.isNotEmpty) {
      irrigations.sort((a, b) => b.date.compareTo(a.date));
      final lastIrrigation = irrigations.first;
      final daysSince = DateTime.now().difference(lastIrrigation.date).inDays;
      
      if (daysSince >= 3) {
        notifications.add(AppNotification(
          id: 'irrigation_reminder',
          title: '💧 تذكير بالسقي',
          message: 'آخر عملية سقي كانت منذ $daysSince أيام. هل حان وقت السقي؟',
          type: 'reminder',
          timestamp: DateTime.now(),
          actionRoute: '/irrigations',
        ));
      }
    } else {
      notifications.add(AppNotification(
        id: 'irrigation_first',
        title: '💧 ابدأ تتبع السقي',
        message: 'لم تسجل أي عملية سقي بعد. ابدأ بتتبع مواعيد السقي!',
        type: 'info',
        timestamp: DateTime.now(),
        actionRoute: '/irrigations',
      ));
    }
    
    return notifications;
  }

  Future<int> getUnreadCount() async {
    final notifications = await getAllNotifications();
    return notifications.where((n) => !n.isRead).length;
  }
}
