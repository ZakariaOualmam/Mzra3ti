import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/voice_service.dart';
import 'voice_widgets.dart';

/// Wraps text to make it speakable when tapped
class SpeakableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool enabled;

  const SpeakableText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context, listen: false);

    if (!enabled) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return GestureDetector(
      onTap: () {
        voiceService.speak(text);
      },
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// Wraps any widget to make it announce its label when tapped
class SpeakableWidget extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback? onTap;

  const SpeakableWidget({
    Key? key,
    required this.child,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context, listen: false);

    return GestureDetector(
      onTap: () {
        voiceService.speak(label);
        if (onTap != null) {
          Future.delayed(Duration(milliseconds: 500), () {
            onTap!();
          });
        }
      },
      child: child,
    );
  }
}

/// Button that speaks its label when pressed
class SpeakableButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final double? fontSize;

  const SpeakableButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.textColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context, listen: false);

    return ElevatedButton.icon(
      onPressed: () {
        voiceService.speak(label);
        Future.delayed(Duration(milliseconds: 300), () {
          onPressed();
        });
      },
      icon: icon != null ? Icon(icon, color: textColor ?? Colors.white) : SizedBox.shrink(),
      label: Text(
        label,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// ListTile that speaks its title when tapped
class SpeakableListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SpeakableListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context, listen: false);

    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: () {
        String speech = title;
        if (subtitle != null) {
          speech += '. $subtitle';
        }
        voiceService.speak(speech);
        if (onTap != null) {
          Future.delayed(Duration(milliseconds: 500), () {
            onTap!();
          });
        }
      },
    );
  }
}

/// Card that speaks its content when tapped
class SpeakableCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? value;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  const SpeakableCard({
    Key? key,
    required this.title,
    this.description,
    this.value,
    this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        String speech = title;
        if (value != null) {
          speech += '. القيمة: $value';
        }
        if (description != null) {
          speech += '. $description';
        }
        voiceService.speak(speech);
        if (onTap != null) {
          Future.delayed(Duration(milliseconds: 500), () {
            onTap!();
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? (isDarkMode ? Colors.grey.shade900 : Colors.white),
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
                if (icon != null) ...[
                  Icon(icon, color: Colors.blue, size: 32),
                  SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (value != null) ...[
              SizedBox(height: 8),
              Text(
                value!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue,
                ),
              ),
            ],
            if (description != null) ...[
              SizedBox(height: 4),
              Text(
                description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// TextField with voice input support
class SpeakableTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Function(String)? onChanged;

  const SpeakableTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SpeakableTextField> createState() => _SpeakableTextFieldState();
}

class _SpeakableTextFieldState extends State<SpeakableTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceService>(context, listen: false);

    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines ?? 1,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.volume_up, color: Colors.blue),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  voiceService.speak(_controller.text);
                } else {
                  voiceService.speak(widget.label);
                }
              },
            ),
            VoiceInputButton(
              onResult: (result) {
                setState(() {
                  _controller.text = result;
                  if (widget.onChanged != null) {
                    widget.onChanged!(result);
                  }
                });
              },
              hint: widget.hint ?? widget.label,
            ),
          ],
        ),
      ),
      onChanged: widget.onChanged,
      onTap: () {
        voiceService.speak(widget.label);
      },
    );
  }
}
