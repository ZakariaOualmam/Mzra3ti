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

  Future<void> _showAddDialog([Irrigation? existing]) async {
    final l10n = AppLocalizations.of(context)!;
    DateTime now = existing?.date ?? DateTime.now();
    DateTime selectedDate = now;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(now);
    final noteController = TextEditingController(text: existing?.note ?? '');
    bool remind = existing?.remindAt != null;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.70,
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
                    existing == null ? l10n.addNewIrrigation : l10n.editIrrigation,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Date picker
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          leading: Icon(Icons.event_rounded, color: AppStyles.primaryGreen),
                          title: Text(AppLocalizations.of(context)!.irrigationDate),
                          subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) {
                              setModalState(() => selectedDate = DateTime(d.year, d.month, d.day, selectedTime.hour, selectedTime.minute));
                            }
                          },
                        ),
                        SizedBox(height: 12),
                        
                        // Time picker
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          leading: Icon(Icons.access_time, color: AppStyles.primaryGreen),
                          title: Text(AppLocalizations.of(context)!.irrigationTime),
                          subtitle: Text(selectedTime.format(context)),
                          onTap: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (t != null) {
                              setModalState(() {
                                selectedTime = t;
                                selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, t.hour, t.minute);
                              });
                            }
                          },
                        ),
                        SizedBox(height: 12),
                        
                        // Notes field
                        TextField(
                          controller: noteController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.notesLabel,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: Icon(Icons.note),
                            helperText: AppLocalizations.of(context)!.additionalIrrigationInfo,
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 12),
                        
                        // Reminder switch
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SwitchListTile(
                            title: Text(AppLocalizations.of(context)!.enableReminder),
                            subtitle: Text(AppLocalizations.of(context)!.sendIrrigationReminder),
                            value: remind,
                            onChanged: (v) => setModalState(() => remind = v),
                            secondary: Icon(
                              remind ? Icons.notifications_active : Icons.notifications_off,
                              color: remind ? AppStyles.primaryGreen : Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        
                        // Info card
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.water_drop_rounded, color: Colors.blue.shade700),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.fullIrrigationTime,
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${DateFormat('yyyy-MM-dd').format(selectedDate)} في ${selectedTime.format(context)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
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
                      final dt = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      
                      if (existing == null) {
                        final irrigation = Irrigation.create(
                          date: dt,
                          note: noteController.text.isEmpty ? null : noteController.text,
                          remindAt: remind ? dt : null,
                        );
                        await repo.addIrrigation(irrigation);
                      } else {
                        final updated = Irrigation(
                          id: existing.id,
                          date: dt,
                          note: noteController.text.isEmpty ? null : noteController.text,
                          remindAt: remind ? dt : null,
                        );
                        await repo.updateIrrigation(updated);
                      }
                      
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text(l10n.save, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
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
          
          final items = snap.data ?? [];
          
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop_outlined, size: 80, color: Colors.grey.shade300),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noIrrigations,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.clickToAddIrrigation,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final it = items[i];
              final hasReminder = it.remindAt != null;
              
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _showAddDialog(it),
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
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.water_drop_rounded, color: Colors.blue.shade700, size: 28),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          DateFormat('yyyy-MM-dd').format(it.date),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (hasReminder)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.notifications_active, size: 14, color: Colors.orange.shade700),
                                              SizedBox(width: 4),
                                              Text(
                                                AppLocalizations.of(context)!.reminder,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.orange.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                                      SizedBox(width: 4),
                                      Text(
                                        TimeOfDay.fromDateTime(it.date).format(context),
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (it.note != null && it.note!.isNotEmpty) ...[
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.note, size: 16, color: Colors.grey.shade600),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    it.note!,
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 12),
                        Divider(height: 1),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showAddDialog(it),
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
                                    title: Text(l10n.deleteIrrigation),
                                    content: Text(l10n.confirmDeleteIrrigation),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: Text(l10n.cancelButton),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                                        child: Text(l10n.delete),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await repo.deleteIrrigation(it.id);
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
