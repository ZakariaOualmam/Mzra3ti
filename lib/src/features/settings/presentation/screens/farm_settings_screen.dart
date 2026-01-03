import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';

import '../../../../core/styles.dart';

class FarmSettingsScreen extends StatefulWidget {
  const FarmSettingsScreen({Key? key}) : super(key: key);

  @override
  State<FarmSettingsScreen> createState() => _FarmSettingsScreenState();
}

class _FarmSettingsScreenState extends State<FarmSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Farm data
  String _farmName = 'مزرعتي';
  String _farmArea = '10';
  String _location = 'المغرب';
  String _soilType = 'طينية';
  String _cropTypes = 'خضروات، فواكه';
  String _contactPerson = 'أحمد';
  String _phoneNumber = '0600000000';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        scrolledUnderElevation: 3,
        shadowColor: theme.colorScheme.primary.withOpacity(0.3),
        centerTitle: true,
        title: Text(
          'معلومات المزرعة',
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
            icon: Icon(Icons.arrow_back, color: AppStyles.brandWhite, size: 24),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: l10n.backTooltip,
            padding: EdgeInsets.zero,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppStyles.brandIconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.save, color: AppStyles.brandWhite, size: 24),
              onPressed: _saveFarmData,
              tooltip: l10n.save,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Farm Icon
                Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.agriculture,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Basic Information
                _buildSectionHeader('المعلومات الأساسية', Icons.info_outline, theme),
                SizedBox(height: 12),
                _buildCard(
                  theme,
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'اسم المزرعة',
                        icon: Icons.landscape,
                        initialValue: _farmName,
                        onSaved: (value) => _farmName = value ?? '',
                      ),
                      Divider(height: 1),
                      _buildTextField(
                        label: 'المساحة (هكتار)',
                        icon: Icons.square_foot,
                        initialValue: _farmArea,
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _farmArea = value ?? '',
                      ),
                      Divider(height: 1),
                      _buildTextField(
                        label: 'الموقع/المدينة',
                        icon: Icons.location_on,
                        initialValue: _location,
                        onSaved: (value) => _location = value ?? '',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Agricultural Information
                _buildSectionHeader('المعلومات الزراعية', Icons.grass, theme),
                SizedBox(height: 12),
                _buildCard(
                  theme,
                  child: Column(
                    children: [
                      _buildDropdownField(
                        label: 'نوع التربة',
                        icon: Icons.terrain,
                        value: _soilType,
                        items: ['طينية', 'رملية', 'صخرية', 'خصبة', 'مختلطة'],
                        onChanged: (value) {
                          setState(() => _soilType = value ?? 'طينية');
                        },
                      ),
                      Divider(height: 1),
                      _buildTextField(
                        label: 'أنواع المحاصيل',
                        icon: Icons.eco,
                        initialValue: _cropTypes,
                        maxLines: 2,
                        onSaved: (value) => _cropTypes = value ?? '',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Contact Information
                _buildSectionHeader('معلومات الاتصال', Icons.contact_phone, theme),
                SizedBox(height: 12),
                _buildCard(
                  theme,
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'اسم المسؤول',
                        icon: Icons.person,
                        initialValue: _contactPerson,
                        onSaved: (value) => _contactPerson = value ?? '',
                      ),
                      Divider(height: 1),
                      _buildTextField(
                        label: 'رقم الهاتف',
                        icon: Icons.phone,
                        initialValue: _phoneNumber,
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => _phoneNumber = value ?? '',
                      ),
                      Divider(height: 1),
                      _buildTextField(
                        label: 'البريد الإلكتروني (اختياري)',
                        icon: Icons.email,
                        initialValue: _email,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => _email = value ?? '',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Save Button
                ElevatedButton.icon(
                  onPressed: _saveFarmData,
                  icon: Icon(Icons.save, size: 24),
                  label: Text(
                    l10n.saveSettings,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                ),

                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(ThemeData theme, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String initialValue,
    TextInputType? keyboardType,
    int maxLines = 1,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onSaved: onSaved,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  void _saveFarmData() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      // Save to database or shared preferences
      // TODO: Implement saving logic
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text(AppLocalizations.of(context)!.farmSavedSuccess),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
