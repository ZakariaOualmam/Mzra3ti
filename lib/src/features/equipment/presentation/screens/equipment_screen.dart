import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles.dart';
import '../../../../core/app_icons.dart';
import '../../../../shared/widgets/padded_fab.dart';
import '../../data/equipment_repository.dart';
import '../../domain/equipment.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({Key? key}) : super(key: key);

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final _repo = EquipmentRepository();
  
  final List<String> _types = [
    'جرار', // Tractor
    'مضخة ماء', // Pump
    'أدوات يدوية', // Hand Tools
    'آلات زراعية', // Farm Machinery
    'نظام ري', // Irrigation System
    'أخرى', // Other
  ];

  Future<void> _showAddDialog([Equipment? existing]) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final priceController = TextEditingController(text: existing?.purchasePrice.toString() ?? '');
    final notesController = TextEditingController(text: existing?.notes ?? '');
    
    String type = existing?.type ?? _types[0];
    String status = existing?.status ?? 'Active';
    DateTime purchaseDate = existing?.purchaseDate ?? DateTime.now();
    DateTime? lastMaintenance = existing?.lastMaintenance;
    DateTime? nextMaintenance = existing?.nextMaintenance;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
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
                      existing == null ? AppLocalizations.of(context)!.addNewEquipment : AppLocalizations.of(context)!.editEquipment,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'اسم المعدة',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.build),
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: type,
                                isExpanded: true,
                                items: _types.map((t) {
                                  return DropdownMenuItem(value: t, child: Text(t));
                                }).toList(),
                                onChanged: (val) => setDialogState(() => type = val!),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          TextField(
                            controller: priceController,
                            decoration: InputDecoration(
                              labelText: 'سعر الشراء (DH)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 12),
                          
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: status,
                                isExpanded: true,
                                items: ['Active', 'Maintenance', 'Broken'].map((s) {
                                  return DropdownMenuItem(
                                    value: s,
                                    child: Row(
                                      children: [
                                        Icon(_getStatusIcon(s), color: _getStatusColor(s), size: 20),
                                        SizedBox(width: 12),
                                        Text(_getStatusText(s)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) => setDialogState(() => status = val!),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          Text('التواريخ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppStyles.primaryGreen)),
                          SizedBox(height: 12),
                          
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            leading: Icon(Icons.calendar_today, color: AppStyles.primaryGreen),
                            title: Text('تاريخ الشراء'),
                            subtitle: Text(DateFormat('yyyy-MM-dd').format(purchaseDate)),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: purchaseDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) setDialogState(() => purchaseDate = picked);
                            },
                          ),
                          SizedBox(height: 12),
                          
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            leading: Icon(Icons.build_circle, color: Colors.orange),
                            title: Text('آخر صيانة'),
                            subtitle: Text(lastMaintenance != null 
                                ? DateFormat('yyyy-MM-dd').format(lastMaintenance!)
                                : 'لم تتم بعد'),
                            trailing: lastMaintenance != null 
                                ? IconButton(
                                    icon: Icon(Icons.clear, size: 20),
                                    onPressed: () => setDialogState(() => lastMaintenance = null),
                                  )
                                : null,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: lastMaintenance ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) setDialogState(() => lastMaintenance = picked);
                            },
                          ),
                          SizedBox(height: 12),
                          
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            leading: Icon(Icons.schedule, color: Colors.blue),
                            title: Text('الصيانة القادمة'),
                            subtitle: Text(nextMaintenance != null 
                                ? DateFormat('yyyy-MM-dd').format(nextMaintenance!)
                                : 'غير محددة'),
                            trailing: nextMaintenance != null 
                                ? IconButton(
                                    icon: Icon(Icons.clear, size: 20),
                                    onPressed: () => setDialogState(() => nextMaintenance = null),
                                  )
                                : null,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: nextMaintenance ?? DateTime.now().add(Duration(days: 90)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) setDialogState(() => nextMaintenance = picked);
                            },
                          ),
                          SizedBox(height: 12),
                          
                          TextField(
                            controller: notesController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.notesLabel,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.note),
                            ),
                            maxLines: 3,
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
                        if (nameController.text.isEmpty || priceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('الرجاء ملء الحقول المطلوبة')),
                          );
                          return;
                        }

                        final equipment = Equipment(
                          id: existing?.id,
                          name: nameController.text,
                          type: type,
                          purchaseDate: purchaseDate,
                          purchasePrice: double.parse(priceController.text),
                          status: status,
                          lastMaintenance: lastMaintenance,
                          nextMaintenance: nextMaintenance,
                          notes: notesController.text.isEmpty ? null : notesController.text,
                        );

                        if (existing == null) {
                          await _repo.add(equipment);
                        } else {
                          await _repo.update(equipment);
                        }

                        if (!mounted) return;
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                      child: Text(AppLocalizations.of(context)!.save, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Active': return Icons.check_circle;
      case 'Maintenance': return Icons.build_circle;
      case 'Broken': return Icons.error;
      default: return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return Colors.green;
      case 'Maintenance': return Colors.orange;
      case 'Broken': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Active': return 'نشط';
      case 'Maintenance': return 'قيد الصيانة';
      case 'Broken': return 'معطل';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = AppStyles.primaryGreen;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: green,
        elevation: 3,
        shadowColor: green.withOpacity(0.5),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.equipmentManagement, style: TextStyle(color: AppStyles.brandWhite, fontSize: 20, fontWeight: FontWeight.bold)),
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
      ),
      body: FutureBuilder<List<Equipment>>(
        future: _repo.list(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: green));
          }

          final equipment = snapshot.data!;
          
          return Column(
            children: [
              // Stats Card
              FutureBuilder<Map<String, dynamic>>(
                future: _repo.getStats(),
                builder: (context, statsSnapshot) {
                  if (!statsSnapshot.hasData) return SizedBox();
                  
                  final stats = statsSnapshot.data!;
                  return Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [green, green.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: green.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('المجموع', '${stats['total']}', Icons.build),
                        _buildStatItem('نشط', '${stats['active']}', Icons.check_circle),
                        _buildStatItem('صيانة', '${stats['maintenance']}', Icons.build_circle),
                        _buildStatItem('تحتاج صيانة', '${stats['needsMaintenance']}', Icons.warning),
                      ],
                    ),
                  );
                },
              ),

              // Equipment List
              if (equipment.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.precision_manufacturing, size: 64, color: Colors.grey.shade300),
                        SizedBox(height: 16),
                        Text(AppLocalizations.of(context)!.noEquipment, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: equipment.length,
                    itemBuilder: (context, i) {
                      final item = equipment[i];
                      final needsMaintenance = item.needsMaintenance();
                      
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Stack(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(12),
                              leading: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(item.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(_getStatusIcon(item.status), color: _getStatusColor(item.status)),
                              ),
                              title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(item.type),
                                  SizedBox(height: 2),
                                  Text(
                                    'شراء: ${DateFormat('yyyy-MM-dd').format(item.purchaseDate)}',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  if (item.nextMaintenance != null)
                                    Text(
                                      'صيانة قادمة: ${DateFormat('yyyy-MM-dd').format(item.nextMaintenance!)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: needsMaintenance ? Colors.red : Colors.blue,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${item.purchasePrice.toStringAsFixed(0)} DH',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _getStatusText(item.status),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _getStatusColor(item.status),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _showAddDialog(item),
                              onLongPress: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.deleteEquipment),
                                    content: Text(AppLocalizations.of(context)!.confirmDeleteEquipment),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: Text(AppLocalizations.of(context)!.cancelButton),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await _repo.delete(item.id!);
                                  setState(() {});
                                }
                              },
                            ),
                            if (needsMaintenance)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'تحتاج صيانة!',
                                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: PaddedFab(
        child: FloatingActionButton(
          onPressed: _showAddDialog,
          backgroundColor: green,
          child: Icon(AppIcons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        SizedBox(height: 4),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10)),
      ],
    );
  }
}
