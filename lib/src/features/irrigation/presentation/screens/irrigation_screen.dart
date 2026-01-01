import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../core/app_icons.dart';
import '../../../../shared/widgets/padded_fab.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles.dart';
import '../../../irrigation/data/irrigation_repository.dart';
import '../../../irrigation/domain/irrigation.dart';

class IrrigationScreen extends StatefulWidget {
  const IrrigationScreen({Key? key}) : super(key: key);

  @override
  State<IrrigationScreen> createState() => _IrrigationScreenState();
}

class _IrrigationScreenState extends State<IrrigationScreen> {
  final IrrigationRepository repo = IrrigationRepository();

  Future<void> _showAddDialog() async {
    final l10n = AppLocalizations.of(context)!;
    DateTime now = DateTime.now();
    DateTime selectedDate = now;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(now);
    final noteController = TextEditingController();
    bool remind = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.addIrrigation, style: AppStyles.headerTitle),
                const SizedBox(height: 12),
                ListTile(
                  title: Text(DateFormat.yMMMd().format(selectedDate) + ' ' + selectedTime.format(context)),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) {
                      setModalState(() => selectedDate = DateTime(d.year, d.month, d.day, selectedTime.hour, selectedTime.minute));
                    }
                  },
                ),
                ListTile(
                  title: Text(l10n.timeLabel),
                  subtitle: Text(selectedTime.format(context)),
                  leading: const Icon(Icons.access_time),
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (t != null) {
                      setModalState(() => selectedTime = t);
                    }
                  },
                ),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(labelText: l10n.irrigationNote),
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Expanded(child: Text(l10n.remindMe)),
                    Switch(
                      value: remind,
                      onChanged: (v) => setModalState(() => remind = v),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final dt = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                    final irrigation = Irrigation.create(date: dt, note: noteController.text, remindAt: remind ? dt : null);
                    await repo.addIrrigation(irrigation);
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.save),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        });
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
        title: Text(AppLocalizations.of(context)!.irrigationTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
      body: FutureBuilder<List<Irrigation>>(
        future: repo.getAll(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noIrrigations));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final it = items[i];
              return Card(
                child: ListTile(
                  title: Text(DateFormat.yMMMd().add_jm().format(it.date)),
                  subtitle: Text(it.note ?? ''),
                  trailing: Wrap(spacing: 8, children: [
                    if (it.remindAt != null) const Icon(Icons.notifications_active, color: Colors.orange),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await repo.deleteIrrigation(it.id);
                        setState(() {});
                      },
                    )
                  ]),
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppLocalizations.of(context)!.addIrrigation, style: AppStyles.headerTitle),
                              const SizedBox(height: 8),
                              if (it.remindAt != null) ...[
                                ListTile(
                                  leading: const Icon(Icons.notifications_active),
                                  title: Text('${l10n.reminderPrefix}' + DateFormat.yMMMd().add_jm().format(it.remindAt!)),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final updated = Irrigation(id: it.id, date: it.date, note: it.note, remindAt: null);
                                    await repo.updateIrrigation(updated);
                                    Navigator.of(ctx).pop();
                                    setState(() {});
                                  },
                                  child: Text(l10n.clearReminder),
                                )
                              ] else ...[
                                ElevatedButton(
                                  onPressed: () async {
                                    final d = await showDatePicker(context: ctx, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                                    if (d == null) return;
                                    final t = await showTimePicker(context: ctx, initialTime: TimeOfDay.now());
                                    if (t == null) return;
                                    final dt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                                    final updated = Irrigation(id: it.id, date: it.date, note: it.note, remindAt: dt);
                                    await repo.updateIrrigation(updated);
                                    Navigator.of(ctx).pop();
                                    setState(() {});
                                  },
                                  child: Text(l10n.snoozeReminder),
                                ),
                              ],
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () async {
                                  await repo.deleteIrrigation(it.id);
                                  Navigator.of(ctx).pop();
                                  setState(() {});
                                },
                                child: Text(l10n.deleteIrrigation),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: PaddedFab(
        child: FloatingActionButton(
          onPressed: () async {
            await _showAddDialog();
            setState(() {});
          },
          child: const Icon(AppIcons.add),
        ),
      ),
    );
  }
}
