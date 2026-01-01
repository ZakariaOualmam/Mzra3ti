import 'package:flutter/material.dart';
import '../../core/styles.dart';

/// PaddedFab keeps the FloatingActionButton raised above bottom bars.
///
/// It adds bottom padding equal to the device's bottom safe area + [bottomOffset]
/// and a small right padding for consistent placement.
class PaddedFab extends StatelessWidget {
  final Widget child;
  final double bottomOffset;
  final double rightOffset;

  const PaddedFab({Key? key, required this.child, double? bottomOffset, double? rightOffset})
      : bottomOffset = bottomOffset ?? AppStyles.fabBottomOffset,
        rightOffset = rightOffset ?? AppStyles.fabRightOffset,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom + bottomOffset;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, right: rightOffset),
      child: child,
    );
  }
}
