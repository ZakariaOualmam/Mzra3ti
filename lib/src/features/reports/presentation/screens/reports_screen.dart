import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/styles.dart';
import '../../../expenses/data/expense_repository.dart';
import '../../../harvest/data/harvest_repository.dart';
import '../../../irrigation/data/irrigation_repository.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _selected = DateTime.now();
  double _expenses = 0.0;
  double _revenue = 0.0;
  int _irrigations = 0;
  bool _loading = true;

  final _expenseRepo = ExpenseRepository();
  final _harvestRepo = HarvestRepository();
  final _irrigationRepo = IrrigationRepository();

  @override
  void initState() {
    super.initState();
    _loadForMonth(_selected);
  }

  Future<void> _loadForMonth(DateTime month) async {
    setState(() => _loading = true);
    final exList = await _expenseRepo.getAll();
    final hvList = await _harvestRepo.getAll();
    final irList = await _irrigationRepo.getAll();

    final year = month.year;
    final m = month.month;

    final monthlyExpenses = exList.where((e) => e.date.year == year && e.date.month == m).fold<double>(0.0, (p, e) => p + e.amount);
    final monthlyRevenue = hvList.where((h) => h.date.year == year && h.date.month == m).fold<double>(0.0, (p, h) => p + h.revenue);
    final monthlyIrr = irList.where((i) => i.date.year == year && i.date.month == m).length;

    setState(() {
      _expenses = monthlyExpenses;
      _revenue = monthlyRevenue;
      _irrigations = monthlyIrr;
      _loading = false;
    });
  }

  void _decMonth() {
    final prev = DateTime(_selected.year, _selected.month - 1, 1);
    _selected = prev;
    _loadForMonth(_selected);
  }

  void _incMonth() {
    final next = DateTime(_selected.year, _selected.month + 1, 1);
    _selected = next;
    _loadForMonth(_selected);
  }

  String _monthLabel() => DateFormat.yMMMM('en_US').format(_selected);

  Future<Uint8List> _generatePdfBytes() async {
    final l10n = AppLocalizations.of(context)!;
    final doc = pw.Document();

    final title = l10n.reportsTitle;
    final monthLabel = DateFormat.yMMMM().format(_selected);

    doc.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('$title - $monthLabel', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Text(l10n.monthlySummary, style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 8),
              pw.Bullet(text: '${l10n.expensesLabel}: ${_expenses.toStringAsFixed(2)} DH'),
              pw.Bullet(text: '${l10n.totalRevenueLong}: ${_revenue.toStringAsFixed(2)} DH'),
              pw.Bullet(text: '${l10n.profitLabel}: ${(_revenue - _expenses).toStringAsFixed(2)} DH'),
              pw.SizedBox(height: 12),
              pw.Text('${l10n.irrigationsCountMonth}: $_irrigations', style: pw.TextStyle(fontSize: 12)),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  Future<void> _exportPdf() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final bytes = await _generatePdfBytes();
      final fileName = 'report_${_selected.year}-${_selected.month.toString().padLeft(2, '0')}.pdf';

      // Use printing package which offers a cross-platform sharer
      await Printing.sharePdf(bytes: bytes, filename: fileName);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.pdfExportFailed}: $e')));
    }
  }

  Future<void> _shareWhatsapp() async {
    final l10n = AppLocalizations.of(context)!;
    final summary = StringBuffer();
    summary.writeln('${l10n.reportsTitle} - ${DateFormat.yMMMM().format(_selected)}');
    summary.writeln('${l10n.monthlySummary}:');
    summary.writeln('${l10n.expensesLabel}: ${_expenses.toStringAsFixed(2)} DH');
    summary.writeln('${l10n.totalRevenueLong}: ${_revenue.toStringAsFixed(2)} DH');
    summary.writeln('${l10n.profitLabel}: ${(_revenue - _expenses).toStringAsFixed(2)} DH');
    summary.writeln('${l10n.irrigationsCount}: $_irrigations');

    final encoded = Uri.encodeComponent(summary.toString());
    final url = Uri.parse('https://wa.me/?text=$encoded');

    try {
      if (!await launchUrl(url)) {
        await Share.share(summary.toString());
      }
    } catch (e) {
      await Share.share(summary.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profit = _revenue - _expenses;
    final green = AppStyles.primaryGreen;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        elevation: 3,
        shadowColor: green.withOpacity(0.5),
        centerTitle: true,
        title: Text(l10n.reportsTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: _decMonth, icon: Icon(Icons.chevron_left)),
                Text(_monthLabel(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                IconButton(onPressed: _incMonth, icon: Icon(Icons.chevron_right)),
              ],
            ),
            SizedBox(height: 12),
            if (_loading) Center(child: CircularProgressIndicator()) else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.monthlySummary, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.expensesLabel, style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('${_expenses.toStringAsFixed(2)} DH')
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.totalRevenueLong, style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('${_revenue.toStringAsFixed(2)} DH')
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.profitLabel, style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('${profit.toStringAsFixed(2)} DH', style: TextStyle(color: profit >= 0 ? Colors.green : Colors.red))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.irrigationsCount, style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('$_irrigations')
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _exportPdf,
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text(l10n.exportPdf),
                      style: ElevatedButton.styleFrom(backgroundColor: AppStyles.primaryGreen),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareWhatsapp,
                      icon: Icon(Icons.share, color: Colors.green),
                      label: Text(l10n.shareWhatsapp),
                      style: OutlinedButton.styleFrom(),
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
