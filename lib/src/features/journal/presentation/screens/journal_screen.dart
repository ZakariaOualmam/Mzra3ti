import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../core/app_icons.dart';
import '../../../../shared/widgets/padded_fab.dart';
import '../../../../core/voice_hints.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/styles.dart';
import '../../../journal/data/journal_repository.dart';
import '../../../journal/domain/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final repo = JournalRepository();

  Future<void> _showAddDialog([JournalEntry? existing]) async {
    final l10n = AppLocalizations.of(context)!;
    final activityController = TextEditingController(text: existing?.activity ?? '');
    DateTime date = existing?.date ?? DateTime.now();
    String? photoBase64 = existing?.photoBase64;

    Future<void> pickPhoto() async {
      final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
      if (res == null) return;
      final bytes = res.files.first.bytes;
      if (bytes == null) return;
      photoBase64 = base64Encode(bytes);
      setState(() {});
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(existing == null ? l10n.addJournal : 'Edit', style: AppStyles.headerTitle),
              const SizedBox(height: 12),
              TextField(controller: activityController, decoration: InputDecoration(labelText: l10n.activity)),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat.yMMMd().format(date)),
                onTap: () async {
                  final d = await showDatePicker(context: ctx, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (d != null) setState(() => date = d);
                },
              ),
              const SizedBox(height: 8),
              Row(children: [
                ElevatedButton.icon(onPressed: pickPhoto, icon: const Icon(Icons.photo), label: Text(l10n.attachPhoto)),
                const SizedBox(width: 12),
                if (photoBase64 != null) GestureDetector(
                  onTap: () {},
                  child: Image.memory(base64Decode(photoBase64!), width: 64, height: 64, fit: BoxFit.cover),
                )
              ]),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final activity = activityController.text.trim();
                  if (activity.isEmpty) return;
                  if (existing == null) {
                    final e = JournalEntry.create(activity: activity, date: date, photoBase64: photoBase64);
                    await repo.addEntry(e);
                  } else {
                    existing.activity = activity;
                    final updated = JournalEntry(id: existing.id, date: date, activity: activity, photoBase64: photoBase64);
                    await repo.updateEntry(updated);
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

  void _showImageFull(String base64) {
    final bytes = base64Decode(base64);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: InteractiveViewer(child: Image.memory(bytes)),
      ),
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
        title: Text(AppLocalizations.of(context)!.journalTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
      body: FutureBuilder<List<JournalEntry>>(
        future: repo.getAll(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final items = snap.data ?? [];
          if (items.isEmpty) return Center(child: Text(AppLocalizations.of(context)!.noJournalEntries));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final e = items[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat.yMMMd().add_jm().format(e.date), style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showAddDialog(e)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () async { await repo.deleteEntry(e.id); setState(() {}); }),
                          ])
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(e.activity, style: const TextStyle(fontSize: 16)),
                      if (e.photoBase64 != null) ...[
                        const SizedBox(height: 8),
                        GestureDetector(onTap: () => _showImageFull(e.photoBase64!), child: Image.memory(base64Decode(e.photoBase64!), height: 160, fit: BoxFit.cover)),
                      ],
                    ],
                  ),
                ),
              );
            },
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
