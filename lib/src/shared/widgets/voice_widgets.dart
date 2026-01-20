import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/voice_service.dart';

/// Floating voice button that appears on screens to help users
class VoiceAssistantButton extends StatelessWidget {
  final VoidCallback? onHelp;
  final String? helpText;
  
  const VoiceAssistantButton({
    Key? key,
    this.onHelp,
    this.helpText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context);
    
    if (!voiceService.isEnabled) return SizedBox.shrink();

    return Positioned(
      top: 80,
      right: 16,
      child: Material(
        elevation: 8,
        shape: CircleBorder(),
        color: Colors.blue.shade600,
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: () {
            if (onHelp != null) {
              onHelp!();
            } else if (helpText != null) {
              voiceService.speak(helpText!);
            }
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              voiceService.isSpeaking ? Icons.volume_up : Icons.record_voice_over,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

/// Voice input button for text fields
class VoiceInputButton extends StatefulWidget {
  final Function(String) onResult;
  final String? locale;
  final String? hint;

  const VoiceInputButton({
    Key? key,
    required this.onResult,
    this.locale,
    this.hint,
  }) : super(key: key);

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context);

    return IconButton(
      icon: voiceService.isListening
          ? ScaleTransition(
              scale: _animation,
              child: Icon(Icons.mic, color: Colors.red),
            )
          : Icon(Icons.mic, color: Colors.grey.shade600),
      onPressed: () async {
        if (voiceService.isListening) {
          await voiceService.stopListening();
        } else {
          if (widget.hint != null) {
            await voiceService.speak(widget.hint!);
          }
          final result = await voiceService.listen(locale: widget.locale);
          if (result != null && result.isNotEmpty) {
            widget.onResult(result);
          }
        }
      },
    );
  }
}

/// Tappable card that speaks its content
class VoiceCard extends StatelessWidget {
  final String label;
  final String? description;
  final Widget child;
  final VoidCallback? onTap;

  const VoiceCard({
    Key? key,
    required this.label,
    this.description,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context, listen: false);

    return GestureDetector(
      onLongPress: () {
        String text = label;
        if (description != null) {
          text += '. $description';
        }
        voiceService.speak(text);
      },
      onTap: onTap,
      child: child,
    );
  }
}

/// Voice settings widget for settings screen
class VoiceSettingsWidget extends StatelessWidget {
  const VoiceSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.accessibility_new, color: Colors.blue, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'المساعد الصوتي',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                value: voiceService.isEnabled,
                onChanged: (value) async {
                  await voiceService.toggleVoiceAssistance(value);
                },
                activeColor: Colors.blue,
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            voiceService.isEnabled 
              ? '✅ المساعد الصوتي مفعل. اضغط على أي عنصر لسماعه.'
              : 'المساعد الصوتي موقوف. فعله للاستماع للعناصر.',
            style: TextStyle(
              fontSize: 14,
              color: voiceService.isEnabled ? Colors.green : Colors.grey,
            ),
          ),
          if (voiceService.isEnabled) ...[
            SizedBox(height: 20),
            Text(
              'سرعة الصوت',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Icon(Icons.speed, color: Colors.grey),
                Expanded(
                  child: Slider(
                    value: voiceService.speechRate,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(voiceService.speechRate * 100).round()}%',
                    onChanged: (value) {
                      voiceService.setSpeechRate(value);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'مستوى الصوت',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Icon(Icons.volume_up, color: Colors.grey),
                Expanded(
                  child: Slider(
                    value: voiceService.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(voiceService.volume * 100).round()}%',
                    onChanged: (value) {
                      voiceService.setVolume(value);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'طبقة الصوت',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Icon(Icons.graphic_eq, color: Colors.grey),
                Expanded(
                  child: Slider(
                    value: voiceService.pitch,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    label: voiceService.pitch.toStringAsFixed(1),
                    onChanged: (value) {
                      voiceService.setPitch(value);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                voiceService.speak(
                  'هذا مثال على صوت المساعد الصوتي. يمكنك تغيير السرعة والمستوى والطبقة.',
                  force: true,
                );
              },
              icon: Icon(Icons.play_arrow),
              label: Text('تجربة الصوت'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
