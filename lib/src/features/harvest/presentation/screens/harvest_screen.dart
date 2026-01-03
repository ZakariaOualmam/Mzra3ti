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
    final cropController = TextEditingController(text: existing?.crop ?? '');
    final qtyController = TextEditingController(text: existing != null ? existing.quantity.toString() : '');
    final priceController = TextEditingController(text: existing != null ? existing.pricePerUnit.toString() : '');
    DateTime date = existing?.date ?? DateTime.now();
    String selectedCrop = existing?.crop ?? crops.first;

    // Common crop templates with emojis
    final commonCrops = [
      {'name': 'قمح', 'icon': '🌾'},
      {'name': 'بطاطس', 'icon': '🥔'},
      {'name': 'خيار', 'icon': '🥒'},
      {'name': 'طماطم', 'icon': '🍅'},
      {'name': 'بصل', 'icon': '🧅'},
      {'name': 'جزر', 'icon': '🥕'},
      {'name': 'فلفل', 'icon': '🌶️'},
      {'name': 'بطيخ', 'icon': '🍉'},
      {'name': 'فراولة', 'icon': '🍓'},
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
                      existing == null ? l10n.addNewHarvest : l10n.editHarvest,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Quick crop templates
                          if (existing == null) ...[
                            Text('محاصيل شائعة:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: commonCrops.map((crop) {
                                final isSelected = cropController.text == crop['name'];
                                return InkWell(
                                  onTap: () {
                                    setDialogState(() {
                                      cropController.text = crop['name']!;
                                      selectedCrop = crop['name']!;
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
                                    child: Text('${crop['icon']} ${crop['name']}', style: TextStyle(fontSize: 13)),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16),
                          ],
                          
                          // Crop name field
                          TextField(
                            controller: cropController,
                            decoration: InputDecoration(
                              labelText: 'نوع المحصول',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.grass),
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          // Quantity field
                          TextField(
                            controller: qtyController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.quantityKg,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.scale),
                              helperText: AppLocalizations.of(context)!.enterQuantityKg,
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          // Price field
                          TextField(
                            controller: priceController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.priceDhKg,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.attach_money),
                              helperText: 'سعر الكيلوغرام الواحد',
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
                            title: Text('تاريخ الحصاد'),
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
                          
                          // Revenue calculation display
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppStyles.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppStyles.primaryGreen.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.monetization_on, color: AppStyles.primaryGreen),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('الإيرادات المتوقعة', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                      SizedBox(height: 4),
                                      Text(
                                        '${((double.tryParse(qtyController.text) ?? 0) * (double.tryParse(priceController.text) ?? 0)).toStringAsFixed(2)} DH',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppStyles.primaryGreen),
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
                        if (cropController.text.isEmpty || qtyController.text.isEmpty || priceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('الرجاء ملء جميع الحقول')),
                          );
                          return;
                        }

                        final qty = double.tryParse(qtyController.text) ?? 0.0;
                        final price = double.tryParse(priceController.text) ?? 0.0;
                        
                        if (qty <= 0 || price <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('الرجاء إدخال قيم صحيحة')),
                          );
                          return;
                        }

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
    final theme = Theme.of(context);
    final green = Colors.green;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: green,
        elevation: 0,
        scrolledUnderElevation: 3,
        shadowColor: green.withOpacity(0.3),
        centerTitle: true,
        title: Text(
          'إدارة المحاصيل والحصاد',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: l10n.backTooltip,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      body: _buildHarvestRecords(l10n, theme, green),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [green.shade400, green.shade600],
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
          onPressed: () {
            VoiceHints.instance.speak(AppLocalizations.of(context)!.addShort);
            _showAddDialog();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }
  
  Widget _buildHarvestRecords(AppLocalizations l10n, ThemeData theme, MaterialColor green) {
    return FutureBuilder<List<Harvest>>(
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
        
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                // Summary Cards
                FutureBuilder<List<dynamic>>(
                  future: Future.wait([
                    repo.totalQuantity(),
                    repo.totalRevenue(),
                    expenseRepo.total(),
                  ]),
                  builder: (context, snapshot) {
                    final qty = (snapshot.data != null && snapshot.data!.isNotEmpty) 
                        ? (snapshot.data![0] as double) : 0.0;
                    final rev = (snapshot.data != null && snapshot.data!.length > 1) 
                        ? (snapshot.data![1] as double) : 0.0;
                    final exp = (snapshot.data != null && snapshot.data!.length > 2) 
                        ? (snapshot.data![2] as double) : 0.0;
                    final profit = rev - exp;
                    
                    return Column(
                      children: [
                        // Main Summary Card
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [green.shade400, green.shade600],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: green.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.agriculture,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ملخص الحصاد',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${list.length} عملية حصاد',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatItem(
                                      icon: Icons.scale,
                                      label: AppLocalizations.of(context)!.totalQuantityLabel,
                                      value: '${qty.toStringAsFixed(1)} كلغ',
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildStatItem(
                                      icon: Icons.monetization_on,
                                      label: 'الإيرادات',
                                      value: '${rev.toStringAsFixed(0)} DH',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Profit Card
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: profit >= 0 ? Colors.teal.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: profit >= 0 ? Colors.teal.shade200 : Colors.red.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: profit >= 0 ? Colors.teal : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  profit >= 0 ? Icons.trending_up : Icons.trending_down,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'صافي الربح',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${profit.toStringAsFixed(2)} DH',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: profit >= 0 ? Colors.teal.shade700 : Colors.red.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                profit >= 0 ? '📈' : '📉',
                                style: TextStyle(fontSize: 32),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                
                SizedBox(height: 24),
                
                // Section Header
                Row(
                  children: [
                    Icon(Icons.list_alt, color: green, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'سجل الحصاد',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    Spacer(),
                    if (list.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${list.length}',
                          style: TextStyle(
                            color: green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Harvest List
                if (list.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),
                        Icon(
                          Icons.agriculture_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noHarvests,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'اضغط على + لإضافة حصاد جديد',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...list.map((h) => _buildHarvestCard(
                    h, 
                    green, 
                    theme, 
                    context,
                    onEdit: () => _showAddDialog(h),
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.deleteHarvest),
                          content: Text(l10n.confirmDeleteHarvest),
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
                        await repo.deleteHarvest(h.id);
                        setState(() {});
                      }
                    },
                  )).toList(),
                
                SizedBox(height: 80),
              ],
            ),
          );
        },
      );
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.9),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildHarvestCard(
    Harvest h, 
    MaterialColor green, 
    ThemeData theme, 
    BuildContext context,
    {required VoidCallback onEdit, required VoidCallback onDelete}
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: green.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [green.withOpacity(0.1), green.withOpacity(0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.grass, color: green, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.crop,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMd('ar').format(h.date),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${h.id}',
                    style: TextStyle(
                      color: green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.scale,
                    label: AppLocalizations.of(context)!.quantityLabel,
                    value: '${h.quantity.toStringAsFixed(1)} كلغ',
                    color: Colors.blue,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade200,
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.attach_money,
                    label: AppLocalizations.of(context)!.priceLabel,
                    value: '${h.pricePerUnit.toStringAsFixed(0)} DH',
                    color: Colors.orange,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade200,
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.monetization_on,
                    label: 'الإيراد',
                    value: '${h.revenue.toStringAsFixed(0)} DH',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.blue),
                          SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context)!.edit,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 44, color: Colors.grey.shade200),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context)!.delete,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
