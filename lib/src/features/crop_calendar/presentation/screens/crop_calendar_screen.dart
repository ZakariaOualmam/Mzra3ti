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
  
  List<String> _seasons = [];
  List<String> _cropTypes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _seasons = [
      AppLocalizations.of(context)!.spring,
      AppLocalizations.of(context)!.summer,
      AppLocalizations.of(context)!.autumn,
      AppLocalizations.of(context)!.winter,
    ];
    _cropTypes = [
      AppLocalizations.of(context)!.vegetables,
      AppLocalizations.of(context)!.grains,
      AppLocalizations.of(context)!.fruits,
      AppLocalizations.of(context)!.other,
    ];
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
                            Text(AppLocalizations.of(context)!.popularCrops, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                              labelText: AppLocalizations.of(context)!.cropName,
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
                                hint: Text(AppLocalizations.of(context)!.cropType),
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
                                hint: Text(AppLocalizations.of(context)!.season),
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
                              helperText: AppLocalizations.of(context)!.averageDaysToHarvest,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 12),
                          
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            leading: Icon(Icons.event_rounded, color: AppStyles.primaryGreen),
                            title: Text(AppLocalizations.of(context)!.plantingDate),
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
                                      Text(AppLocalizations.of(context)!.expectedHarvestDate, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
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
                            title: Text(AppLocalizations.of(context)!.enableReminders),
                            subtitle: Text(AppLocalizations.of(context)!.sendReminderBeforeHarvest),
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
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
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
    if (month >= 3 && month <= 5) return AppLocalizations.of(context)!.spring;
    if (month >= 6 && month <= 8) return AppLocalizations.of(context)!.summer;
    if (month >= 9 && month <= 11) return AppLocalizations.of(context)!.autumn;
    return AppLocalizations.of(context)!.winter;
  }

  IconData _getSeasonIcon(String season) {
    if (season == AppLocalizations.of(context)!.spring) return Icons.local_florist;
    if (season == AppLocalizations.of(context)!.summer) return Icons.wb_sunny;
    if (season == AppLocalizations.of(context)!.autumn) return Icons.nature;
    if (season == AppLocalizations.of(context)!.winter) return Icons.ac_unit;
    return Icons.event_rounded;
  }

  Color _getSeasonColor(String season) {
    if (season == AppLocalizations.of(context)!.spring) return Colors.pink;
    if (season == AppLocalizations.of(context)!.summer) return Colors.orange;
    if (season == AppLocalizations.of(context)!.autumn) return Colors.brown;
    if (season == AppLocalizations.of(context)!.winter) return Colors.blue;
    return Colors.grey;
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
            Tab(text: AppLocalizations.of(context)!.allCrops),
            Tab(text: AppLocalizations.of(context)!.readyForHarvest),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Calculate progress percentage
    final totalDays = crop.growthDaysEstimate;
    final daysPassed = DateTime.now().difference(crop.plantingDate).inDays;
    final progress = (daysPassed / totalDays).clamp(0.0, 1.0);
    
    // Get status color
    Color statusColor;
    String statusText;
    if (isReady) {
      statusColor = AppStyles.statusGood;
      statusText = 'جاهز للحصاد!';
    } else if (harvestSoon) {
      statusColor = AppStyles.statusWarning;
      statusText = 'قريباً';
    } else {
      statusColor = AppStyles.blueGradient[1];
      statusText = 'في النمو';
    }
    
    // Get crop emoji from template if available
    final template = CropTemplates.templates.firstWhere(
      (t) => t.name == crop.cropName,
      orElse: () => CropTemplates.templates[0],
    );
    
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Color(0xFF2C2C2E), Color(0xFF1C1C1E)]
              : [Colors.white, Color(0xFFF9FAFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: AppStyles.deepShadow,
      ),
      child: Material(
        color: Colors.transparent,
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
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Crop Name and Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large Crop Emoji/Icon - Centered
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withOpacity(0.2),
                            statusColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          template.icon,
                          style: TextStyle(fontSize: 48),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            crop.cropName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              letterSpacing: 0.5,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${crop.cropType} • ${crop.season}',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    // Status Badge
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              statusColor,
                              statusColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'نمو المحصول',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      statusColor,
                                      statusColor.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                width: constraints.maxWidth * progress,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Days Remaining - Large Display
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withOpacity(0.15),
                        statusColor.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Responsive layout: stack on small screens, row on larger
                      final isSmallScreen = constraints.maxWidth < 300;
                      if (isSmallScreen) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDateColumn(
                              Icons.event_rounded,
                              'زراعة',
                              DateFormat('dd/MM').format(crop.plantingDate),
                              statusColor,
                              isDarkMode,
                            ),
                            SizedBox(height: 16),
                            _buildDaysRemainingColumn(
                              isReady ? '0' : '${crop.daysUntilHarvest}',
                              statusColor,
                              isDarkMode,
                            ),
                            SizedBox(height: 16),
                            _buildDateColumn(
                              Icons.event_available,
                              'حصاد',
                              DateFormat('dd/MM').format(crop.calculatedHarvestDate),
                              statusColor,
                              isDarkMode,
                            ),
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildDateColumn(
                              Icons.event_rounded,
                              'زراعة',
                              DateFormat('dd/MM').format(crop.plantingDate),
                              statusColor,
                              isDarkMode,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 60,
                            color: statusColor.withOpacity(0.3),
                          ),
                          Expanded(
                            child: _buildDaysRemainingColumn(
                              isReady ? '0' : '${crop.daysUntilHarvest}',
                              statusColor,
                              isDarkMode,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 60,
                            color: statusColor.withOpacity(0.3),
                          ),
                          Expanded(
                            child: _buildDateColumn(
                              Icons.event_available,
                              'حصاد',
                              DateFormat('dd/MM').format(crop.calculatedHarvestDate),
                              statusColor,
                              isDarkMode,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for date column
  Widget _buildDateColumn(
    IconData icon,
    String label,
    String date,
    Color color,
    bool isDarkMode,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black87,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper widget for days remaining column
  Widget _buildDaysRemainingColumn(
    String days,
    Color color,
    bool isDarkMode,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          days,
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: -2,
            height: 1.0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          'يوم متبقي',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
