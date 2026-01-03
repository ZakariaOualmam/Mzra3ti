import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../core/app_icons.dart';
import '../../../../shared/widgets/padded_fab.dart';
import 'package:intl/intl.dart';
import 'package:mzra3ti/src/models/expense.dart';
import '../../../../core/styles.dart';
import '../../../expenses/data/expense_repository.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final repo = ExpenseRepository();
  final List<String> categories = ['Zra3a', 'Traktour', 'S9iya', '3amal', 'Mlli7at', 'Okhr'];

  Future<void> _showAddDialog([Expense? existing]) async {
    final l10n = AppLocalizations.of(context)!;
    String selectedCategory = existing?.type ?? categories.first;
    final amountController = TextEditingController(text: existing != null ? existing.amount.toString() : '');
    DateTime date = existing?.date ?? DateTime.now();

    // Category templates with emojis
    final categoryTemplates = [
      {'name': 'زراعة', 'icon': '🌾', 'key': 'Zra3a'},
      {'name': 'تراكتور', 'icon': '🚜', 'key': 'Traktour'},
      {'name': 'سقي', 'icon': '💧', 'key': 'S9iya'},
      {'name': 'عمال', 'icon': '👷', 'key': '3amal'},
      {'name': 'ملحقات', 'icon': '🔧', 'key': 'Mlli7at'},
      {'name': 'أخرى', 'icon': '📦', 'key': 'Okhr'},
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      existing == null ? l10n.addNewExpense : l10n.editExpense,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Category templates
                          Text(l10n.categories, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: categoryTemplates.map((cat) {
                              final isSelected = selectedCategory == cat['key'];
                              return InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    selectedCategory = cat['key']!;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppStyles.primaryGreen.withOpacity(0.2) : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? AppStyles.primaryGreen : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Text('${cat['icon']} ${cat['name']}', style: TextStyle(fontSize: 13)),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          
                          // Amount field
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: '${l10n.amount} (DH)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.attach_money),
                              helperText: l10n.enterAmount,
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          // Date picker
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            leading: Icon(Icons.calendar_today, color: AppStyles.primaryGreen),
                            title: Text(l10n.expenseDate),
                            subtitle: Text(DateFormat('yyyy-MM-dd').format(date)),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) setDialogState(() => date = picked);
                            },
                          ),
                          SizedBox(height: 12),
                          
                          // Amount preview
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.money_off, color: Colors.red.shade700),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.totalAmount, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                      SizedBox(height: 4),
                                      Text(
                                        '${(double.tryParse(amountController.text) ?? 0).toStringAsFixed(2)} DH',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryGreen,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (amountController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.enterAmount)),
                          );
                          return;
                        }

                        final amt = double.tryParse(amountController.text) ?? 0.0;
                        
                        if (amt <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.fieldRequired)),
                          );
                          return;
                        }

                        if (existing == null) {
                          final e = Expense(type: selectedCategory, amount: amt, date: date);
                          await repo.addExpense(e);
                        } else {
                          existing.type = selectedCategory;
                          existing.amount = amt;
                          existing.date = date;
                          await repo.updateExpense(existing);
                        }
                        
                        if (!mounted) return;
                        Navigator.of(ctx).pop();
                        setState(() {});
                      },
                      child: Text(l10n.save, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final green = AppStyles.primaryGreen;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        elevation: 3,
        shadowColor: green.withOpacity(0.5),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.expenses, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: l10n.backTooltip,
            padding: EdgeInsets.zero,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Expense>>(
        future: repo.getAll(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: green),
                  SizedBox(height: 16),
                  Text('جاري التحميل...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          
          final list = snap.data ?? [];
          
          return Column(
            children: [
              // Total card
              FutureBuilder<double>(
                future: repo.total(),
                builder: (context, s) {
                  final total = s.data ?? 0.0;
                  return Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade400, Colors.red.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.money_off, color: Colors.white, size: 32),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إجمالي المصاريف',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${total.toStringAsFixed(2)} DH',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              // List of expenses
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade300),
                            SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noExpenses,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'اضغط على + لإضافة مصروف جديد',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final e = list[i];
                          
                          // Get category display name
                          final categoryMap = {
                            'Zra3a': {'name': 'زراعة', 'icon': '🌾'},
                            'Traktour': {'name': 'تراكتور', 'icon': '🚜'},
                            'S9iya': {'name': 'سقي', 'icon': '💧'},
                            '3amal': {'name': 'عمال', 'icon': '👷'},
                            'Mlli7at': {'name': 'ملحقات', 'icon': '🔧'},
                            'Okhr': {'name': 'أخرى', 'icon': '📦'},
                          };
                          
                          final catInfo = categoryMap[e.type] ?? {'name': e.type, 'icon': '📦'};
                          
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: InkWell(
                              onTap: () => _showAddDialog(e),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            catInfo['icon']!,
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                catInfo['name']!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    DateFormat('yyyy-MM-dd').format(e.date),
                                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${e.amount.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade700,
                                              ),
                                            ),
                                            Text(
                                              'DH',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Divider(height: 1),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () => _showAddDialog(e),
                                          icon: Icon(Icons.edit, size: 18),
                                          label: Text(l10n.edit),
                                          style: TextButton.styleFrom(foregroundColor: Colors.blue),
                                        ),
                                        SizedBox(width: 8),
                                        TextButton.icon(
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(l10n.deleteExpense),
                                                content: Text(l10n.confirmDeleteExpense),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(ctx, false),
                                                    child: Text(l10n.cancelButton),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(ctx, true),
                                                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                                                    child: Text('حذف'),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              await repo.deleteExpense(e.id);
                                              setState(() {});
                                            }
                                          },
                                          icon: Icon(Icons.delete, size: 18),
                                          label: Text(l10n.delete),
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: green.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddDialog(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}
