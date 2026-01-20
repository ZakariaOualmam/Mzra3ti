import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/styles.dart';
import '../../core/voice_hints.dart';
import '../../services/voice_service.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  final String? voiceHint; // optional short word to speak on tap

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.onTap,
    this.voiceHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final voiceService = Provider.of<VoiceService>(context, listen: false);
    
    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          // Speak full card content
          String speech = '$title. القيمة: $value';
          if (subtitle.isNotEmpty) {
            speech += '. $subtitle';
          }
          voiceService.speak(speech);
          
          // Old voice hint fallback
          if ((voiceHint ?? '').isNotEmpty) VoiceHints.instance.speak(voiceHint!);
          
          // Execute action after speech
          if (onTap != null) {
            Future.delayed(Duration(milliseconds: 500), () {
              onTap!();
            });
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Large top icon
              Container(
                width: AppStyles.largeIconSize + 28,
                height: AppStyles.largeIconSize + 28,
                decoration: BoxDecoration(
                  color: color.withAlpha(28),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: AppStyles.largeIconSize),
              ),
              SizedBox(height: 12),

              // Main value (very large)
              Text(
                value,
                style: AppStyles.bigValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),

              // Small optional label (one word)
              if (subtitle.isNotEmpty) Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
