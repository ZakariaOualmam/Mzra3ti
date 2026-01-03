/// Analytics Data Model for Charts and Statistics
class AnalyticsData {
  final DateTime date;
  final double expenses;
  final double revenue;
  final int irrigations;

  AnalyticsData({
    required this.date,
    required this.expenses,
    required this.revenue,
    required this.irrigations,
  });

  double get profit => revenue - expenses;
}

/// Monthly Summary for Analytics
class MonthlySummary {
  final String month;
  final double totalExpenses;
  final double totalRevenue;
  final double totalProfit;
  final int totalIrrigations;
  final int totalHarvests;

  MonthlySummary({
    required this.month,
    required this.totalExpenses,
    required this.totalRevenue,
    required this.totalProfit,
    required this.totalIrrigations,
    required this.totalHarvests,
  });
}

/// Expense Category Breakdown
class ExpenseCategory {
  final String name;
  final double amount;
  final double percentage;

  ExpenseCategory({
    required this.name,
    required this.amount,
    required this.percentage,
  });
}
