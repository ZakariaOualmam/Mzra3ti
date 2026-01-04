import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles.dart';
import '../../data/analytics_repository.dart';
import '../../domain/analytics_data.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _repo = AnalyticsRepository();
  bool _loading = true;

  List<AnalyticsData> _weekData = [];
  List<MonthlySummary> _monthlyData = [];
  List<ExpenseCategory> _categories = [];
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    _weekData = await _repo.getLast7DaysData();
    _monthlyData = await _repo.getLast6MonthsSummary();
    _categories = await _repo.getExpenseBreakdown();
    _stats = await _repo.getOverallStats();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final green = AppStyles.primaryGreen;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: green,
        elevation: 3,
        shadowColor: green.withOpacity(0.5),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.analytics,
          style: TextStyle(
            color: AppStyles.brandWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppStyles.brandIconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppStyles.brandWhite),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppStyles.brandWhite),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: green))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: green,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Stats Cards
                    _buildStatsCards(l10n),
                    SizedBox(height: 24),

                    // Weekly Trend Chart
                    _buildSectionTitle(l10n.last7Days, Icons.trending_up),
                    SizedBox(height: 12),
                    _buildWeeklyChart(),
                    SizedBox(height: 24),

                    // Monthly Summary
                    _buildSectionTitle(l10n.monthSummary, Icons.event_rounded),
                    SizedBox(height: 12),
                    _buildMonthlyBars(),
                    SizedBox(height: 24),

                    // Expense Breakdown
                    _buildSectionTitle(l10n.expenseBreakdown, Icons.pie_chart),
                    SizedBox(height: 12),
                    _buildExpenseBreakdown(),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatsCards(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            l10n.totalProfitTitle,
            '${_stats['totalProfit']?.toStringAsFixed(0) ?? '0'} DH',
            Icons.attach_money,
            Colors.green,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.dailyAverage,
            '${_stats['avgDailyRevenue']?.toStringAsFixed(0) ?? '0'} DH',
            Icons.trending_up,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppStyles.primaryGreen, size: 24),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppStyles.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    if (_weekData.isEmpty) {
      return _buildEmptyCard(AppLocalizations.of(context)!.noData);
    }

    final maxValue = _weekData
        .map((d) => d.revenue > d.expenses ? d.revenue : d.expenses)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chart
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _weekData.map((data) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Revenue Bar
                        Tooltip(
                          message: '${AppLocalizations.of(context)!.revenue}: ${data.revenue.toStringAsFixed(0)} DH',
                          child: Container(
                            width: double.infinity,
                            height: maxValue > 0 ? (data.revenue / maxValue * 85) : 0,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.7),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        // Expense Bar
                        Tooltip(
                          message: '${AppLocalizations.of(context)!.expensesChart}: ${data.expenses.toStringAsFixed(0)} DH',
                          child: Container(
                            width: double.infinity,
                            height: maxValue > 0 ? (data.expenses / maxValue * 85) : 0,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.6),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        // Date Label
                        Text(
                          DateFormat('E', 'ar').format(data.date),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(AppLocalizations.of(context)!.revenue, Colors.green),
              SizedBox(width: 16),
              _buildLegendItem(AppLocalizations.of(context)!.expensesChart, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyBars() {
    if (_monthlyData.isEmpty) {
      return _buildEmptyCard(AppLocalizations.of(context)!.noMonthlyData);
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _monthlyData.map((month) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      month.month,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${month.totalProfit.toStringAsFixed(0)} DH',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: month.totalProfit >= 0 ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: month.totalRevenue > 0 
                        ? (month.totalProfit / month.totalRevenue).abs().clamp(0.0, 1.0)
                        : 0.0,
                    backgroundColor: Colors.grey.shade200,
                    color: month.totalProfit >= 0 ? Colors.green : Colors.red,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpenseBreakdown() {
    if (_categories.isEmpty) {
      return _buildEmptyCard(AppLocalizations.of(context)!.noExpensesData);
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _categories.take(5).map((category) {
          final colors = [
            Colors.blue,
            Colors.orange,
            Colors.purple,
            Colors.teal,
            Colors.pink,
          ];
          final color = colors[_categories.indexOf(category) % colors.length];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${category.amount.toStringAsFixed(0)} DH',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${category.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade300),
            SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
