import 'package:flutter/material.dart';

class SpinModel extends InheritedNotifier<AnimationController> {
  const SpinModel({
    super.key,
    super.notifier,
    required super.child,
  });

  static double of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SpinModel>()!
        .notifier!
        .value;
  }
}
