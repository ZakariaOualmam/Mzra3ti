import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles.dart';
import '../../../../core/app_icons.dart';
import '../../../../utils/darija_texts.dart';

class DayForecast {
  final DateTime date;
  final double tempHigh;
  final double tempLow;
  final String condition; // e.g., 'sunny', 'rainy'

  DayForecast({required this.date, required this.tempHigh, required this.tempLow, required this.condition});
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final DateTime _today = DateTime.now();

  // Mock 7-day forecast for now; we can replace with real API later
  late List<DayForecast> _week;

  @override
  void initState() {
    super.initState();
    _week = _mockWeek(_today);
  }

  List<DayForecast> _mockWeek(DateTime start) {
    final rnd = start.day % 3; // simple variation
    return List.generate(7, (i) {
      final d = start.add(Duration(days: i));
      final cond = (i + rnd) % 4 == 0 ? 'sunny' : (i + rnd) % 4 == 1 ? 'cloudy' : (i + rnd) % 4 == 2 ? 'rainy' : 'partly';
      final high = 20 + ((i + rnd) % 5) + (i.isEven ? 0 : 1);
      final low = high - (2 + (i % 2));
      return DayForecast(date: d, tempHigh: high.toDouble(), tempLow: low.toDouble(), condition: cond);
    });
  }

  String _conditionLabel(String cond) {
    switch (cond) {
      case 'sunny':
        return 'Shms';
      case 'cloudy':
        return 'Mghyem';
      case 'rainy':
        return 'Mtlj';
      case 'partly':
      default:
        return 'M3odhl';
    }
  }

  IconData _conditionIcon(String cond) {
    switch (cond) {
      case 'sunny':
        return AppIcons.sun;
      case 'cloudy':
        return AppIcons.weather;
      case 'rainy':
        return Icons.beach_access; // small umbrella-like icon
      case 'partly':
      default:
        return Icons.wb_cloudy;
    }
  }

  String _irrigationAdvice(DayForecast f) {
    // Simple rule: if rainy -> skip, if high temp and no rain -> water
    if (f.condition == 'rainy') return 'Manshuffsh lma (ghadi tmtl)';
    final avg = (f.tempHigh + f.tempLow) / 2.0;
    if (avg >= 25) return 'Salli lma lyoum (7awel)';
    return 'Chkoun l-7al: b9a 3la lmonitor';
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
        title: Text(l10n.weather, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.forecastTitle, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: _week.length,
                separatorBuilder: (_, __) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final day = _week[index];
                  final dayLabel = DateFormat.E().addPattern(' dd/MM').format(day.date);
                  final advice = _irrigationAdvice(day);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Icon(_conditionIcon(day.condition), size: 36, color: AppStyles.primaryGreen),
                              SizedBox(height: 4),
                              Text(_conditionLabel(day.condition))
                            ],
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dayLabel, style: TextStyle(fontWeight: FontWeight.w700)),
                                SizedBox(height: 4),
                                Text('${day.tempHigh.toStringAsFixed(0)}° / ${day.tempLow.toStringAsFixed(0)}°'),
                                SizedBox(height: 8),
                                Text(advice, style: TextStyle(color: Colors.blueGrey.shade700)),
                              ],
                            ),
                          ),
                          IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
