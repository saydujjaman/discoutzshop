import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../utils/constants/colors.dart'; // For Image.network


// CustomPainter to draw a dotted border
class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final BorderRadius borderRadius;

  DottedBorderPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dash = 4.0,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect outerRect = borderRadius.toRRect(Offset.zero & size);

    // Draw the top border
    _drawDashedLine(canvas, paint, outerRect.outerRect.topLeft, outerRect.outerRect.topRight, dash, gap);
    // Draw the bottom border
    _drawDashedLine(canvas, paint, outerRect.outerRect.bottomLeft, outerRect.outerRect.bottomRight, dash, gap);
    // Draw the left border
    _drawDashedLine(canvas, paint, outerRect.outerRect.topLeft, outerRect.outerRect.bottomLeft, dash, gap);
    // Draw the right border
    _drawDashedLine(canvas, paint, outerRect.outerRect.topRight, outerRect.outerRect.bottomRight, dash, gap);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset p1, Offset p2, double dash, double gap) {
    final double totalLength = (p2 - p1).distance;
    double currentLength = 0.0;
    while (currentLength < totalLength) {
      final double nextDash = currentLength + dash;
      if (nextDash > totalLength) {
        canvas.drawLine(p1 + (p2 - p1) * (currentLength / totalLength), p2, paint);
      } else {
        canvas.drawLine(p1 + (p2 - p1) * (currentLength / totalLength), p1 + (p2 - p1) * (nextDash / totalLength), paint);
      }
      currentLength += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DottedCustomContainer extends StatelessWidget {
  final String imageString;
  final String offerPercentage;

  const DottedCustomContainer({super.key, required this.imageString, required this.offerPercentage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          // color: Colors.white, // Inner background color
          borderRadius: BorderRadius.circular(8.0),
          // We'll draw the dotted border using CustomPaint outside this decoration
        ),
        child: CustomPaint(
          painter: DottedBorderPainter(
            color: Colors.grey,
            strokeWidth: 1.0,
            dash: 4.0, // Length of each dash
            gap: 4.0,  // Length of the gap between dashes
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 20), // Padding inside the dotted border
            child: Row(
              mainAxisSize: MainAxisSize.min, // To make the row only take necessary space
              children: [
                Expanded(
                  child: Image.network(
                    imageString,
                    fit: BoxFit.cover, // Ensure the image covers the space
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Iconsax.emoji_sad);
                    },
                  ),
                ),
                SizedBox(width: 4.0), // Use width for horizontal spacing in a Row
                Text(
                  '30% OFF',
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// A simple main function to run the DottedLinedContainer for demonstration
