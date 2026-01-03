import 'package:intl/intl.dart';
import '../domain/analytics_data.dart';
import '../../expenses/data/expense_repository.dart';
import '../../harvest/data/harvest_repository.dart';
import '../../irrigation/data/irrigation_repository.dart';

/// Repository for analytics data aggregation
class AnalyticsRepository {
  final _expenseRepo = ExpenseRepository();
  final _harvestRepo = HarvestRepository();
  final _irrigationRepo = IrrigationRepository();

  /// Get last N days of analytics data
  Future<List<AnalyticsData>> getLast7DaysData() async {
    final List<AnalyticsData> data = [];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(Duration(days: 1));

      // Get data for this day
      final expenses = await _expenseRepo.getAll();
      final harvests = await _harvestRepo.getAll();
      final irrigations = await _irrigationRepo.getAll();

      double dayExpenses = 0.0;
      double dayRevenue = 0.0;
      int dayIrrigations = 0;

      // Calculate expenses
      for (var expense in expenses) {
        if (expense.date.isAfter(dayStart) && expense.date.isBefore(dayEnd)) {
          dayExpenses += expense.amount;
        }
      }

      // Calculate revenue
      for (var harvest in harvests) {
        if (harvest.date.isAfter(dayStart) && harvest.date.isBefore(dayEnd)) {
          dayRevenue += harvest.revenue;
        }
      }

      // Count irrigations
      for (var irrigation in irrigations) {
        if (irrigation.date.isAfter(dayStart) && irrigation.date.isBefore(dayEnd)) {
          dayIrrigations++;
        }
      }

      data.add(AnalyticsData(
        date: date,
        expenses: dayExpenses,
        revenue: dayRevenue,
        irrigations: dayIrrigations,
      ));
    }

    return data;
  }

  /// Get monthly summary for last 6 months
  Future<List<MonthlySummary>> getLast6MonthsSummary() async {
    final List<MonthlySummary> summaries = [];
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final nextMonth = DateTime(now.year, now.month - i + 1, 1);

      final expenses = await _expenseRepo.getAll();
      final harvests = await _harvestRepo.getAll();
      final irrigations = await _irrigationRepo.getAll();

      double totalExpenses = 0.0;
      double totalRevenue = 0.0;
      int totalIrrigations = 0;
      int totalHarvests = 0;

      for (var expense in expenses) {
        if (expense.date.isAfter(month) && expense.date.isBefore(nextMonth)) {
          totalExpenses += expense.amount;
        }
      }

      for (var harvest in harvests) {
        if (harvest.date.isAfter(month) && harvest.date.isBefore(nextMonth)) {
          totalRevenue += harvest.revenue;
          totalHarvests++;
        }
      }

      for (var irrigation in irrigations) {
        if (irrigation.date.isAfter(month) && irrigation.date.isBefore(nextMonth)) {
          totalIrrigations++;
        }
      }

      summaries.add(MonthlySummary(
        month: DateFormat('MMM').format(month),
        totalExpenses: totalExpenses,
        totalRevenue: totalRevenue,
        totalProfit: totalRevenue - totalExpenses,
        totalIrrigations: totalIrrigations,
        totalHarvests: totalHarvests,
      ));
    }

    return summaries;
  }

  /// Get expense breakdown by category
  Future<List<ExpenseCategory>> getExpenseBreakdown() async {
    final expenses = await _expenseRepo.getAll();
    final Map<String, double> categoryTotals = {};
    double total = 0.0;

    for (var expense in expenses) {
      categoryTotals[expense.type] = 
          (categoryTotals[expense.type] ?? 0.0) + expense.amount;
      total += expense.amount;
    }

    final List<ExpenseCategory> breakdown = [];
    categoryTotals.forEach((name, amount) {
      breakdown.add(ExpenseCategory(
        name: name,
        amount: amount,
        percentage: total > 0 ? (amount / total * 100) : 0,
      ));
    });

    breakdown.sort((a, b) => b.amount.compareTo(a.amount));
    return breakdown;
  }

  /// Get overall statistics
  Future<Map<String, dynamic>> getOverallStats() async {
    final expenses = await _expenseRepo.getAll();
    final harvests = await _harvestRepo.getAll();
    final irrigations = await _irrigationRepo.getAll();

    double totalExpenses = 0.0;
    double totalRevenue = 0.0;

    for (var expense in expenses) {
      totalExpenses += expense.amount;
    }

    for (var harvest in harvests) {
      totalRevenue += harvest.revenue;
    }

    return {
      'totalExpenses': totalExpenses,
      'totalRevenue': totalRevenue,
      'totalProfit': totalRevenue - totalExpenses,
      'totalIrrigations': irrigations.length,
      'totalHarvests': harvests.length,
      'avgDailyExpense': expenses.isNotEmpty ? totalExpenses / 30 : 0.0,
      'avgDailyRevenue': harvests.isNotEmpty ? totalRevenue / 30 : 0.0,
    };
  }
}
