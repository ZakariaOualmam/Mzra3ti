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
    final catController = TextEditingController(text: existing?.type ?? categories.first);
    final amountController = TextEditingController(text: existing != null ? existing.amount.toString() : '');
    DateTime date = existing?.date ?? DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(existing == null ? l10n.addExpense : 'Edit', style: AppStyles.headerTitle),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: catController.text,
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => catController.text = v ?? categories.first,
                decoration: InputDecoration(labelText: l10n.expenseCategory),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.amount),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat.yMMMd().format(date)),
                onTap: () async {
                  final d = await showDatePicker(context: ctx, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (d != null) setState(() => date = d);
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final amt = double.tryParse(amountController.text) ?? 0.0;
                  if (amt <= 0) return;
                  if (existing == null) {
                    final e = Expense(type: catController.text, amount: amt, date: date);
                    await repo.addExpense(e);
                  } else {
                    existing.type = catController.text;
                    existing.amount = amt;
                    existing.date = date;
                    await repo.updateExpense(existing);
                  }
                  if (!mounted) return;
                  Navigator.of(ctx).pop();
                  setState(() {});
                },
                child: Text(l10n.save),
              ),
              const SizedBox(height: 12),
            ],
          ),
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
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final list = snap.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Totals
                FutureBuilder<double>(
                  future: repo.total(),
                  builder: (context, s) {
                    final total = s.data ?? 0.0;
                    return Card(
                      child: ListTile(
                        leading: const Icon(AppIcons.expenses),
                        title: Text(l10n.total),
                        subtitle: Text('${total.toStringAsFixed(2)} DH'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Simple table-like list
                Expanded(
                  child: list.isEmpty
                      ? Center(child: Text(AppLocalizations.of(context)!.noExpenses))
                      : SingleChildScrollView(
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text(l10n.numberShort)),
                              DataColumn(label: Text(l10n.category)),
                              DataColumn(label: Text(l10n.amount)),
                              DataColumn(label: Text(l10n.date)),
                              DataColumn(label: Text('')),
                            ],
                            rows: list
                                .map(
                                  (e) => DataRow(cells: [
                                    DataCell(Text(e.id?.toString() ?? '')),
                                    DataCell(Text(e.type)),
                                    DataCell(Text('${e.amount.toStringAsFixed(2)} DH')),
                                    DataCell(Text(DateFormat.yMMMd().format(e.date))),
                                    DataCell(Row(children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18),
                                        onPressed: () => _showAddDialog(e),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 18),
                                        onPressed: () async {
                                          await repo.deleteExpense(e.id);
                                          setState(() {});
                                        },
                                      )
                                    ])),
                                  ]),
                                )
                                .toList(),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: PaddedFab(
        child: FloatingActionButton(
          onPressed: () => _showAddDialog(),
          child: const Icon(AppIcons.add),
        ),
      ),
    );
  }
}
