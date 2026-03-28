import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Career Compass Services Pvt. Ltd. — Logo widget.
///
/// Use [compact] = true for AppBar (horizontal, single-height).
/// Use [compact] = false (default) for Splash / full-page use (3-line vertical).
class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({
    super.key,
    this.width,
    this.isDark = false,
    this.compact = false,
  });

  final double? width;
  final bool isDark;

  /// Compact mode: compass icon + "CAREER / COMPASS" side-by-side.
  /// Fits inside a standard AppBar height (~56 dp).
  final bool compact;

  static const _navyBlue = Color(0xFF1B2A8C);
  static const _navyBlueDark = Color(0xFF7986CB);
  static const _red = Color(0xFFCC0000);

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? _navyBlueDark : _navyBlue;

    if (compact) {
      return _CompactLogo(titleColor: titleColor);
    }

    // Full 3-line logo — wrapped in FittedBox so it scales to any screen width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            (width ?? constraints.maxWidth).clamp(0.0, double.infinity);
        return SizedBox(
          width: availableWidth,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
            child: _FullLogo(titleColor: titleColor),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Full 3-line logo  (Splash Screen, etc.)
// ---------------------------------------------------------------------------
class _FullLogo extends StatelessWidget {
  const _FullLogo({required this.titleColor});
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w700,
      fontSize: 52,
      letterSpacing: 6,
      height: 1.15,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CAREER', style: titleStyle.copyWith(color: titleColor)),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('C', style: titleStyle.copyWith(color: titleColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SvgPicture.asset(
                'assets/svg/ic_compass.svg',
                width: 56,
                height: 56,
              ),
            ),
            Text('MPASS', style: titleStyle.copyWith(color: titleColor)),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'SERVICES PVT.LTD.',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppLogoWidget._red,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Compact logo  (AppBar)
//  ┌────────────────────────┐
//  │  [⊕]  CAREER           │
//  │       COMPASS          │
//  └────────────────────────┘
// ---------------------------------------------------------------------------
class _CompactLogo extends StatelessWidget {
  const _CompactLogo({required this.titleColor});
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w700,
      fontSize: 17,
      letterSpacing: 2.5,
      height: 1.2,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/ic_compass.svg',
          width: 36,
          height: 36,
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CAREER',
                style: textStyle.copyWith(color: titleColor)),
            Text('COMPASS',
                style: textStyle.copyWith(color: titleColor)),
          ],
        ),
      ],
    );
  }
}
