import 'package:flutter/material.dart';
import '../features/crop_calendar/data/crop_calendar_repository.dart';
import '../features/equipment/data/equipment_repository.dart';
import '../features/irrigation/data/irrigation_repository.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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

  Future<List<AppNotification>> getAllNotifications(BuildContext context) async {
    final List<AppNotification> notifications = [];
    
    // Crop Harvest Reminders
    final cropNotifications = await _getCropNotifications(context);
    notifications.addAll(cropNotifications);
    
    // Equipment Maintenance Alerts
    final equipmentNotifications = await _getEquipmentNotifications(context);
    notifications.addAll(equipmentNotifications);
    
    // Irrigation Reminders
    final irrigationNotifications = await _getIrrigationNotifications(context);
    notifications.addAll(irrigationNotifications);
    
    // Sort by timestamp (newest first)
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return notifications;
  }

  Future<List<AppNotification>> _getCropNotifications(BuildContext context) async {
    final List<AppNotification> notifications = [];
    final crops = await _cropRepo.list();
    final l10n = AppLocalizations.of(context)!;
    
    for (var crop in crops) {
      if (crop.isReadyToHarvest) {
        notifications.add(AppNotification(
          id: 'crop_ready_${crop.id}',
          title: l10n.notifCropReady(crop.cropName),
          message: l10n.notifCropReadyMessage(crop.cropName),
          type: l10n.typeAlert,
          timestamp: crop.calculatedHarvestDate,
          actionRoute: '/crop-calendar',
        ));
      } else if (crop.harvestSoon && crop.reminderEnabled) {
        notifications.add(AppNotification(
          id: 'crop_soon_${crop.id}',
          title: l10n.notifCropSoon(crop.cropName),
          message: l10n.notifCropSoonMessage(crop.cropName, crop.daysUntilHarvest),
          type: l10n.typeReminder,
          timestamp: DateTime.now(),
          actionRoute: '/crop-calendar',
        ));
      }
    }
    
    return notifications;
  }

  Future<List<AppNotification>> _getEquipmentNotifications(BuildContext context) async {
    final List<AppNotification> notifications = [];
    final equipment = await _equipmentRepo.list();
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    for (var item in equipment) {
      if (item.needsMaintenance()) {
        final dateStr = dateFormat.format(item.nextMaintenance!);
        notifications.add(AppNotification(
          id: 'equipment_${item.id}',
          title: l10n.notifEquipmentMaintenance(item.name),
          message: l10n.notifEquipmentMaintenanceMessage(item.name, dateStr),
          type: l10n.typeAlert,
          timestamp: item.nextMaintenance!,
          actionRoute: '/equipment',
        ));
      }
    }
    
    return notifications;
  }

  Future<List<AppNotification>> _getIrrigationNotifications(BuildContext context) async {
    final List<AppNotification> notifications = [];
    final irrigations = await _irrigationRepo.getAll();
    final l10n = AppLocalizations.of(context)!;
    
    // Check if last irrigation was more than 3 days ago
    if (irrigations.isNotEmpty) {
      irrigations.sort((a, b) => b.date.compareTo(a.date));
      final lastIrrigation = irrigations.first;
      final daysSince = DateTime.now().difference(lastIrrigation.date).inDays;
      
      if (daysSince >= 3) {
        notifications.add(AppNotification(
          id: 'irrigation_reminder',
          title: l10n.notifIrrigationReminder,
          message: l10n.notifIrrigationReminderMessage(daysSince),
          type: l10n.typeReminder,
          timestamp: DateTime.now(),
          actionRoute: '/irrigations',
        ));
      }
    } else {
      notifications.add(AppNotification(
        id: 'irrigation_first',
        title: l10n.notifIrrigationFirst,
        message: l10n.notifIrrigationFirstMessage,
        type: l10n.typeInfo,
        timestamp: DateTime.now(),
        actionRoute: '/irrigations',
      ));
    }
    
    return notifications;
  }

  Future<int> getUnreadCount(BuildContext context) async {
    final notifications = await getAllNotifications(context);
    return notifications.where((n) => !n.isRead).length;
  }
}
