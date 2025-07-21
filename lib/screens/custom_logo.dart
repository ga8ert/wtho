import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../source/colors.dart';

class CustomLogo extends StatelessWidget {
  final double size;

  const CustomLogo({super.key, this.size = 400});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size / 3,
      height: size / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ), // Transparent background
      child: CustomPaint(
        painter: LogoPainter(
          AppLocalizations.of(context)!.logo1,
          AppLocalizations.of(context)!.logo2,
        ),
        child: Container(
          // Transparent background
          // to allow the CustomPainter to show through
        ),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  final String logo1;
  final String logo2;

  LogoPainter(this.logo1, this.logo2);

  @override
  void paint(Canvas canvas, Size size) {
    final orangePaint = Paint()
      ..color = CustomColors.yelow
      ..style = PaintingStyle.fill;

    final darkBluePaint = Paint()
      ..color = CustomColors.darkblue
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // === THREE HEADS (small circles at top) ===
    final headRadius = size.width * 0.12;
    final centerHeadRadius = size.width * 0.18; // Center head bigger
    final headsY = centerY - size.height * 1.5;
    final headSpacing = size.width * 0.375;

    // Left head
    canvas.drawCircle(
      Offset(centerX - headSpacing, headsY * 0.01),
      headRadius,
      orangePaint,
    );

    // Right head
    canvas.drawCircle(
      Offset(centerX + headSpacing, headsY * 0.01),
      headRadius,
      orangePaint,
    );

    // Center head (bigger, drawn last)
    canvas.drawCircle(
      Offset(centerX, headsY / 10),
      centerHeadRadius,
      orangePaint,
    );

    // === CHAT BUBBLE BODIES (replacing regular bodies) ===
    final bodyY = centerY - size.height * 0.1; // Adjusted for better alignment
    final bodyRadius = size.width * 0.24;
    final centerBodyRadius = size.width * 0.3; // Center body bigger

    // Left chat bubble body (orange circle)
    canvas.drawCircle(
      Offset(centerX - headSpacing, bodyY),
      bodyRadius,
      orangePaint,
    );

    // Left bubble tail (small triangle pointing to head)
    final leftTailPath = Path();
    final leftBodyX = centerX - headSpacing;
    canvas.drawPath(leftTailPath, orangePaint);

    // Right chat bubble body (orange circle)
    canvas.drawCircle(
      Offset(centerX + headSpacing, bodyY),
      bodyRadius,
      orangePaint,
    );

    // Right bubble tail (small triangle pointing down, shifted to the right)
    final rightTailPath = Path();
    final tailCenterX =
        centerX + headSpacing + bodyRadius * 0.4; // right of center
    final tailTopY = bodyY + bodyRadius / 1.2; // top
    final tailHeight = bodyRadius * 0.6;
    final tailWidth = bodyRadius * 0.6;

    rightTailPath.moveTo(
      tailCenterX - tailWidth * 0.7,
      tailTopY + tailHeight * 0.11,
    );
    rightTailPath.lineTo(
      tailCenterX + tailWidth * 0.2,
      tailTopY - tailHeight * 0.05,
    );
    rightTailPath.lineTo(tailCenterX - tailWidth * 0.1, tailTopY + tailHeight);
    rightTailPath.close();

    canvas.drawPath(rightTailPath, orangePaint);

    // Center chat bubble body (dark blue circle, bigger)
    canvas.drawCircle(Offset(centerX, bodyY), centerBodyRadius, darkBluePaint);

    final centerTailPath = Path();
    // Triangle below center circle, base on top, tip down
    final tailOffsetX = centerBodyRadius * 0.9;
    centerTailPath.moveTo(
      centerX - centerBodyRadius * 0.05 - tailOffsetX,
      bodyY + centerBodyRadius * 0.1,
    );
    centerTailPath.lineTo(
      centerX + centerBodyRadius * 0.7 - tailOffsetX,
      bodyY + centerBodyRadius * 0.8,
    );
    centerTailPath.lineTo(
      centerX - tailOffsetX,
      bodyY + centerBodyRadius * 1.35,
    );
    centerTailPath.close();
    canvas.drawPath(centerTailPath, darkBluePaint);

    // === TEXT ===
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: logo1,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.24,
              fontWeight: FontWeight.bold,
              height: 2.5,
              letterSpacing: 2.0,
            ),
          ),
          TextSpan(
            text: logo2,
            style: TextStyle(
              color: CustomColors.white,
              fontSize: size.width * 0.24,
              fontWeight: FontWeight.bold,
              height: 0.5,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY + size.height * 0.1),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
