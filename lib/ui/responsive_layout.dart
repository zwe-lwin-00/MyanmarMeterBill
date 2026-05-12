import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Max readable width for form-like content on large screens (web / tablet).
const double kAppMaxContentWidth = 720;

/// Whether scrollbars should show a draggable thumb (desktop web + desktop OS).
bool scrollbarThumbInteractive() {
  if (kIsWeb) return true;
  return switch (defaultTargetPlatform) {
    TargetPlatform.windows ||
    TargetPlatform.macOS ||
    TargetPlatform.linux =>
      true,
    _ => false,
  };
}

/// Padding for scrollable tab bodies: enforces comfortable minimum insets on
/// phones, tablets, and narrow web windows.
EdgeInsets responsiveScrollPadding(double base) {
  final h = (base < 16 ? 16.0 : base).clamp(16.0, 32.0);
  final v = (base < 12 ? 12.0 : base).clamp(12.0, 28.0);
  return EdgeInsets.fromLTRB(h, v, h, v);
}

/// Centers content and caps width on wide viewports (web, landscape tablet).
class ResponsiveContentPane extends StatelessWidget {
  const ResponsiveContentPane({
    super.key,
    required this.child,
    this.maxWidth = kAppMaxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (!w.isFinite || w <= 0) {
          return child;
        }
        final cap = maxWidth.clamp(320.0, kAppMaxContentWidth);
        if (w <= cap + 1) {
          return child;
        }
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: cap),
            child: child,
          ),
        );
      },
    );
  }
}
