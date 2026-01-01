import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../core/app_icons.dart';
import '../../../../shared/widgets/padded_fab.dart';
import '../../../../core/voice_hints.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles.dart';
import '../../../harvest/data/harvest_repository.dart';
import '../../../harvest/domain/harvest.dart';
import '../../../expenses/data/expense_repository.dart';

class HarvestScreen extends StatefulWidget {
  const HarvestScreen({Key? key}) : super(key: key);

  @override
  State<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends State<HarvestScreen> {
  final repo = HarvestRepository();
  final expenseRepo = ExpenseRepository();
  final List<String> crops = ['Dzayer', 'Khodra', 'Btata', 'Qutn', 'Zra3a Okhra'];

  Future<void> _showAddDialog([Harvest? existing]) async {
    final l10n = AppLocalizations.of(context)!;
    final cropController = TextEditingController(text: existing?.crop ?? crops.first);
    final qtyController = TextEditingController(text: existing != null ? existing.quantity.toString() : '');
    final priceController = TextEditingController(text: existing != null ? existing.pricePerUnit.toString() : '');
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
              Text(existing == null ? l10n.addHarvest : 'Edit Harvest', style: AppStyles.headerTitle),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: cropController.text,
                items: crops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => cropController.text = v ?? crops.first,
                decoration: InputDecoration(labelText: l10n.cropType),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.quantity),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.pricePerUnit),
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
                  final qty = double.tryParse(qtyController.text) ?? 0.0;
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  if (qty <= 0 || price <= 0) return;
                  if (existing == null) {
                    final h = Harvest.create(crop: cropController.text, quantity: qty, pricePerUnit: price, date: date);
                    await repo.addHarvest(h);
                  } else {
                    existing.crop = cropController.text;
                    existing.quantity = qty;
                    existing.pricePerUnit = price;
                    existing.date = date;
                    await repo.updateHarvest(existing);
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
        title: Text(AppLocalizations.of(context)!.harvestTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
      body: FutureBuilder<List<Harvest>>(
        future: repo.getAll(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final list = snap.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Summary card
                FutureBuilder<double>(
                  future: Future.wait([repo.totalQuantity(), repo.totalRevenue(), expenseRepo.total()]).then((l) => l[2] ?? 0.0),
                  builder: (context, s) {
                    final qtyFuture = repo.totalQuantity();
                    final revFuture = repo.totalRevenue();
                    return FutureBuilder<List<dynamic>>(
                      future: Future.wait([qtyFuture, revFuture, expenseRepo.total()]),
                      builder: (context, snapshot) {
                        final qty = (snapshot.data != null && snapshot.data!.isNotEmpty) ? (snapshot.data![0] as double) : 0.0;
                        final rev = (snapshot.data != null && snapshot.data!.length > 1) ? (snapshot.data![1] as double) : 0.0;
                        final exp = (snapshot.data != null && snapshot.data!.length > 2) ? (snapshot.data![2] as double) : 0.0;
                        final profit = rev - exp;
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.emoji_events),
                            title: Text(AppLocalizations.of(context)!.harvestSummaryTitle),
                            subtitle: Text('${AppLocalizations.of(context)!.totalQty}: ${qty.toStringAsFixed(2)} • ${AppLocalizations.of(context)!.totalRevenue}: ${rev.toStringAsFixed(2)} DH\n${AppLocalizations.of(context)!.totalExpenses}: ${exp.toStringAsFixed(2)} DH'),
                            trailing: Text('${AppLocalizations.of(context)!.profit}: ${profit.toStringAsFixed(2)} DH', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Table
                Expanded(
                  child: list.isEmpty
                      ? Center(child: Text(AppLocalizations.of(context)!.noHarvests))
                      : SingleChildScrollView(
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text(l10n.numberShort)),
                              DataColumn(label: Text(l10n.crop)),
                              DataColumn(label: Text(l10n.qtyShort)),
                              DataColumn(label: Text(l10n.price)),
                              DataColumn(label: Text(l10n.revenue)),
                              DataColumn(label: Text(l10n.date)),
                              DataColumn(label: Text('')),
                            ],
                            rows: list
                                .map(
                                  (h) => DataRow(cells: [
                                    DataCell(Text(h.id)),
                                    DataCell(Text(h.crop)),
                                    DataCell(Text(h.quantity.toStringAsFixed(2))),
                                    DataCell(Text('${h.pricePerUnit.toStringAsFixed(2)} DH')),
                                    DataCell(Text('${h.revenue.toStringAsFixed(2)} DH')),
                                    DataCell(Text(DateFormat.yMMMd().format(h.date))),
                                    DataCell(Row(children: [
                                      IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => _showAddDialog(h)),
                                      IconButton(icon: const Icon(Icons.delete, size: 18), onPressed: () async {
                                        await repo.deleteHarvest(h.id);
                                        setState(() {});
                                      }),
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
          onPressed: () { VoiceHints.instance.speak(AppLocalizations.of(context)!.addShort); _showAddDialog(); },
          child: const Icon(AppIcons.add),
        ),
      ),
    );
  }
}
