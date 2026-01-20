import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles.dart';
import '../../../../core/app_icons.dart';
import '../../data/weather_service.dart';

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
  final WeatherService _weatherService = WeatherService();

  // Weather forecast data
  late List<DayForecast> _week;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final forecast = await _weatherService.getWeatherForecast();
      setState(() {
        _week = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _week = [];
      });
    }
  }

  String _conditionLabel(String cond, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (cond) {
      case 'sunny':
        return l10n.weatherSunny;
      case 'cloudy':
        return l10n.weatherCloudy;
      case 'rainy':
        return l10n.weatherRainy;
      case 'partly':
      default:
        return l10n.weatherPartly;
    }
  }

  IconData _conditionIcon(String cond) {
    switch (cond) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.grain;
      case 'partly':
      default:
        return Icons.wb_cloudy;
    }
  }

  Color _conditionColor(String cond) {
    switch (cond) {
      case 'sunny':
        return Color(0xFFF59E0B); // Amber
      case 'cloudy':
        return Color(0xFF6B7280); // Gray
      case 'rainy':
        return AppStyles.blueGradient[1]; // Blue
      case 'partly':
      default:
        return Color(0xFF94A3B8); // Light gray
    }
  }

  String _irrigationAdvice(DayForecast f, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Simple rule: if rainy -> skip, if high temp and no rain -> water
    if (f.condition == 'rainy') return l10n.adviceSkipWatering;
    final avg = (f.tempHigh + f.tempLow) / 2.0;
    if (avg >= 25) return l10n.adviceWaterToday;
    return l10n.adviceMonitor;
  }

  Color _getAdviceColor(String advice, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (advice == l10n.adviceSkipWatering) return AppStyles.statusGood; // Green - skip watering
    if (advice == l10n.adviceWaterToday) return AppStyles.statusWarning; // Yellow - water today
    return AppStyles.blueGradient[1]; // Blue - monitor
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1C1C1E) : Color(0xFFF0FDF4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppStyles.blueGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: AppStyles.premiumCardShadow,
          ),
        ),
        leading: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: l10n.backTooltip,
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          l10n.weather,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadWeather,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF1C1C1E), Color(0xFF2C2C2E)]
                : AppStyles.whiteGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppStyles.blueGradient[1]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading weather data...',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text(
                            'Error loading weather',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _loadWeather,
                            icon: Icon(Icons.refresh),
                            label: Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.blueGradient[1],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      child: _buildWeatherContent(context, l10n, isDarkMode),
                    ),
        ),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context, AppLocalizations l10n, bool isDarkMode) {
    if (_week.isEmpty) {
      return Center(child: Text('No weather data available'));
    }

    final today = _week[0];
    final avgTemp = (today.tempHigh + today.tempLow) / 2.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
                // Large Current Temperature Card
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppStyles.blueGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: AppStyles.deepShadow,
                  ),
                  child: Column(
                    children: [
                      // Large Weather Icon - Centered
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _conditionIcon(today.condition),
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Very Large Temperature
                      Center(
                        child: Text(
                          '${avgTemp.toStringAsFixed(0)}°',
                          style: TextStyle(
                            fontSize: 96,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -4,
                            height: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 12),
                      // Condition Label
                      Center(
                        child: Text(
                          _conditionLabel(today.condition, context),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: 1,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                      // High/Low
                      Center(
                        child: Text(
                          '${today.tempHigh.toStringAsFixed(0)}° / ${today.tempLow.toStringAsFixed(0)}°',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Farming Tip Card
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getAdviceColor(_irrigationAdvice(today, context), context).withOpacity(0.15),
                        _getAdviceColor(_irrigationAdvice(today, context), context).withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _getAdviceColor(_irrigationAdvice(today, context), context).withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: AppStyles.premiumCardShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Centered icon container
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getAdviceColor(_irrigationAdvice(today, context), context).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: _getAdviceColor(_irrigationAdvice(today, context), context),
                            size: 40,
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
                              l10n.todayAdvice,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDarkMode ? Colors.white : Colors.black87,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              _irrigationAdvice(today, context),
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // 7-Day Forecast Title
                Text(
                  l10n.forecastTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 16),

                // 7-Day Forecast Cards
                ..._week.asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  final isToday = index == 0;
                  final dayLabel = isToday
                      ? l10n.today
                      : DateFormat.E(Localizations.localeOf(context).languageCode).format(day.date);

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Color(0xFF2C2C2E), Color(0xFF1C1C1E)]
                            : [Colors.white, Color(0xFFF9FAFB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: isToday
                          ? Border.all(
                              color: AppStyles.blueGradient[1].withOpacity(0.5),
                              width: 2,
                            )
                          : Border.all(
                              color: Colors.grey.shade200.withOpacity(0.5),
                              width: 1,
                            ),
                      boxShadow: AppStyles.premiumCardShadow,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Large Weather Icon - Centered
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _conditionColor(day.condition).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _conditionColor(day.condition).withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _conditionIcon(day.condition),
                              color: _conditionColor(day.condition),
                              size: 48,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      dayLabel,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isToday) ...[
                                    SizedBox(width: 12),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppStyles.blueGradient[1].withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'اليوم',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppStyles.blueGradient[1],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                _conditionLabel(day.condition, context),
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
                        // Large Temperature Display - Centered
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${day.tempHigh.toStringAsFixed(0)}°',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: isDarkMode ? Colors.white : Colors.black87,
                                letterSpacing: -1,
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${day.tempLow.toStringAsFixed(0)}°',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
    );
  }
}
