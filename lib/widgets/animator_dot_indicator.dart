import 'package:flutter/material.dart';

class AnimatedDotIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  AnimatedDotIndicator({
    required this.currentIndex,
    required this.itemCount,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.dotSize = 6.0,
    this.spacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: currentIndex == index ? dotSize * 2 : dotSize,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: spacing),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dotSize / 2),
            color: currentIndex == index ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}