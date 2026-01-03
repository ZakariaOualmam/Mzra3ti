import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../core/styles.dart';
import '../../../../core/app_icons.dart';
import '../../../../shared/widgets/padded_fab.dart';
import '../../data/crop_calendar_repository.dart';
import '../../domain/crop_calendar.dart';

class CropCalendarScreen extends StatefulWidget {
  const CropCalendarScreen({Key? key}) : super(key: key);

  @override
  State<CropCalendarScreen> createState() => _CropCalendarScreenState();
}

class _CropCalendarScreenState extends State<CropCalendarScreen> with SingleTickerProviderStateMixin {
  final _repo = CropCalendarRepository();
  late TabController _tabController;
  
  final List<String> _seasons = ['الربيع', 'الصيف', 'الخريف', 'الشتاء'];
  final List<String> _cropTypes = ['خضروات', 'حبوب', 'فواكه', 'أخرى'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showAddDialog([CropCalendarEntry? existing]) async {
    final nameController = TextEditingController(text: existing?.cropName ?? '');
    final daysController = TextEditingController(text: existing?.growthDaysEstimate.toString() ?? '75');
    final notesController = TextEditingController(text: existing?.notes ?? '');
    
    String cropType = existing?.cropType ?? _cropTypes[0];
    String season = existing?.season ?? _getCurrentSeason();
    DateTime plantingDate = existing?.plantingDate ?? DateTime.now();
    bool reminderEnabled = existing?.reminderEnabled ?? true;
    CropTemplate? selectedTemplate;

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
                      existing == null ? AppLocalizations.of(context)!.addNewCrop : AppLocalizations.of(context)!.editCrop,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Quick Templates
                          if (existing == null) ...[
                            Text('محاصيل شائعة:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: CropTemplates.templates.map((template) {
                                final isSelected = selectedTemplate == template;
                                return InkWell(
                                  onTap: () {
                                    setDialogState(() {
                                      selectedTemplate = template;
                                      nameController.text = template.name;
                                      cropType = template.type;
                                      daysController.text = template.typicalGrowthDays.toString();
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
                                    child: Text('${template.icon} ${template.name}', style: TextStyle(fontSize: 13)),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16),
                          ],
                          
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'اسم المحصول',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.grass),
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
                                value: cropType,
                                isExpanded: true,
                                hint: Text('نوع المحصول'),
                                items: _cropTypes.map((type) {
                                  return DropdownMenuItem(value: type, child: Text(type));
                                }).toList(),
                                onChanged: (val) => setDialogState(() => cropType = val!),
                              ),
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
                                value: season,
                                isExpanded: true,
                                hint: Text('الموسم'),
                                items: _seasons.map((s) {
                                  return DropdownMenuItem(
                                    value: s,
                                    child: Row(
                                      children: [
                                        Icon(_getSeasonIcon(s), size: 20, color: _getSeasonColor(s)),
                                        SizedBox(width: 8),
                                        Text(s),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) => setDialogState(() => season = val!),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          TextField(
                            controller: daysController,
                            decoration: InputDecoration(
                              labelText: 'مدة النمو (بالأيام)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.timelapse),
                              helperText: 'متوسط الأيام حتى الحصاد',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 12),
                          
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            leading: Icon(Icons.calendar_today, color: AppStyles.primaryGreen),
                            title: Text('تاريخ الزراعة'),
                            subtitle: Text(DateFormat('yyyy-MM-dd').format(plantingDate)),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: plantingDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) setDialogState(() => plantingDate = picked);
                            },
                          ),
                          SizedBox(height: 12),
                          
                          // Expected Harvest Date Display
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppStyles.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppStyles.primaryGreen.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.event_available, color: AppStyles.primaryGreen),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('تاريخ الحصاد المتوقع', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                      SizedBox(height: 4),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(
                                          plantingDate.add(Duration(days: int.tryParse(daysController.text) ?? 0)),
                                        ),
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppStyles.primaryGreen),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          SwitchListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            title: Text('تفعيل التذكيرات'),
                            subtitle: Text('إرسال تذكير قبل موعد الحصاد'),
                            value: reminderEnabled,
                            onChanged: (val) => setDialogState(() => reminderEnabled = val),
                          ),
                          SizedBox(height: 12),
                          
                          TextField(
                            controller: notesController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.notesLabel,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.note),
                            ),
                            maxLines: 2,
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
                        if (nameController.text.isEmpty || daysController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('الرجاء ملء الحقول المطلوبة')),
                          );
                          return;
                        }

                        final entry = CropCalendarEntry(
                          id: existing?.id,
                          cropName: nameController.text,
                          cropType: cropType,
                          plantingDate: plantingDate,
                          growthDaysEstimate: int.parse(daysController.text),
                          season: season,
                          reminderEnabled: reminderEnabled,
                          notes: notesController.text.isEmpty ? null : notesController.text,
                        );

                        if (existing == null) {
                          await _repo.add(entry);
                        } else {
                          await _repo.update(entry);
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

  String _getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return 'الربيع';
    if (month >= 6 && month <= 8) return 'الصيف';
    if (month >= 9 && month <= 11) return 'الخريف';
    return 'الشتاء';
  }

  IconData _getSeasonIcon(String season) {
    switch (season) {
      case 'الربيع': return Icons.local_florist;
      case 'الصيف': return Icons.wb_sunny;
      case 'الخريف': return Icons.nature;
      case 'الشتاء': return Icons.ac_unit;
      default: return Icons.calendar_today;
    }
  }

  Color _getSeasonColor(String season) {
    switch (season) {
      case 'الربيع': return Colors.pink;
      case 'الصيف': return Colors.orange;
      case 'الخريف': return Colors.brown;
      case 'الشتاء': return Colors.blue;
      default: return Colors.grey;
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
        title: Text(AppLocalizations.of(context)!.cropCalendar, style: TextStyle(color: AppStyles.brandWhite, fontSize: 20, fontWeight: FontWeight.bold)),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppStyles.brandWhite,
          labelColor: AppStyles.brandWhite,
          unselectedLabelColor: AppStyles.brandWhite.withOpacity(0.7),
          tabs: [
            Tab(text: 'جميع المحاصيل'),
            Tab(text: 'جاهز للحصاد'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllCrops(),
          _buildReadyToHarvest(),
        ],
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

  Widget _buildAllCrops() {
    return FutureBuilder<List<CropCalendarEntry>>(
      future: _repo.list(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final crops = snapshot.data!;
        
        if (crops.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.eco, size: 64, color: Colors.grey.shade300),
                SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.noCrops, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.addCropsToTrack, style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          );
        }

        // Sort by harvest date
        crops.sort((a, b) => a.daysUntilHarvest.compareTo(b.daysUntilHarvest));

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: crops.length,
          itemBuilder: (context, i) {
            final crop = crops[i];
            return _buildCropCard(crop);
          },
        );
      },
    );
  }

  Widget _buildReadyToHarvest() {
    return FutureBuilder<List<CropCalendarEntry>>(
      future: _repo.getReadyToHarvest(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final crops = snapshot.data!;
        
        if (crops.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey.shade300),
                SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.noReadyCrops, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Text('ستظهر هنا المحاصيل التي حان موعد حصادها', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: crops.length,
          itemBuilder: (context, i) {
            final crop = crops[i];
            return _buildCropCard(crop, showReadyBadge: true);
          },
        );
      },
    );
  }

  Widget _buildCropCard(CropCalendarEntry crop, {bool showReadyBadge = false}) {
    final isReady = crop.isReadyToHarvest;
    final harvestSoon = crop.harvestSoon;
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showAddDialog(crop),
        onLongPress: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.deleteCrop),
              content: Text(AppLocalizations.of(context)!.confirmDeleteCrop),
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
            await _repo.delete(crop.id!);
            setState(() {});
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getSeasonColor(crop.season).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSeasonIcon(crop.season),
                  color: _getSeasonColor(crop.season),
                  size: 32,
                ),
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
                            crop.cropName,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (isReady)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'جاهز!',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          )
                        else if (harvestSoon)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'قريباً',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${crop.cropType} • ${crop.season}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                        SizedBox(width: 4),
                        Text(
                          'زراعة: ${DateFormat('yyyy-MM-dd').format(crop.plantingDate)}',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 14,
                          color: isReady ? Colors.green : (harvestSoon ? Colors.orange : Colors.blue),
                        ),
                        SizedBox(width: 4),
                        Text(
                          isReady
                              ? 'حان موعد الحصاد!'
                              : 'حصاد: ${DateFormat('yyyy-MM-dd').format(crop.calculatedHarvestDate)} (${crop.daysUntilHarvest} يوم)',
                          style: TextStyle(
                            fontSize: 11,
                            color: isReady ? Colors.green : (harvestSoon ? Colors.orange : Colors.grey.shade600),
                            fontWeight: isReady || harvestSoon ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
