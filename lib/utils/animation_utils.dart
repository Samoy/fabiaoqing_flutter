import 'package:flutter/material.dart';

class AnimationUtils {
  static ScaleTransition createScaleTransition(
      Animation<double> animation, Widget child) {
    return new ScaleTransition(
      child: child,
      scale: animation,
    );
  }
}
