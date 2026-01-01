import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../core/styles.dart';

class AddFarmScreen extends StatefulWidget {
  const AddFarmScreen({Key? key}) : super(key: key);

  @override
  State<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends State<AddFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _areaCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  String? _selectedCrop;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _areaCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState?.validate() ?? false) {
      // For now just show a confirmation and pop
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.farmSavedSuccess)));
      Navigator.pop(context);
    }
  }

  Widget _buildField({required String label, required Widget field}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left),
        SizedBox(height: 8),
        field,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final green = AppStyles.primaryGreen;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addFarmTitle, style: AppStyles.headerTitle.copyWith(color: Colors.white)),
        backgroundColor: green,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildField(
                    label: l10n.farmName,
                    field: TextFormField(
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                      validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),

                  SizedBox(height: 12),

                  _buildField(
                    label: l10n.farmLocation,
                    field: TextFormField(
                      controller: _locationCtrl,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),

                  SizedBox(height: 12),

                  _buildField(
                    label: l10n.cropType,
                    field: DropdownButtonFormField<String>(
                      value: _selectedCrop,
                      items: [
                        DropdownMenuItem(value: 'wheat', child: Text(l10n.wheat, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: 'corn', child: Text(l10n.corn, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: 'vegetables', child: Text(l10n.vegetables, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: 'olives', child: Text(l10n.olives, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                      onChanged: (v) => setState(() => _selectedCrop = v),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
                      hint: Text(l10n.selectOption),
                    ),
                  ),

                  SizedBox(height: 12),

                  _buildField(
                    label: l10n.area,
                    field: TextFormField(
                      controller: _areaCtrl,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),

                  SizedBox(height: 12),

                  _buildField(
                    label: l10n.notes,
                    field: TextFormField(
                      controller: _notesCtrl,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                      maxLines: 3,
                      textAlign: TextAlign.start,
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _save,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(l10n.save, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
