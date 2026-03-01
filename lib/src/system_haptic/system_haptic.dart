import 'package:flutter/services.dart';
import 'package:vibrate_button/src/system_haptic/system_haptic_enum.dart';

abstract final class SystemHaptic {
  static Future<void> _normalImpact() async {
    await HapticFeedback.vibrate();
  }

  static Future<void> _lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> _mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  static Future<void> _heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  static Future<void> vibrate(SystemHapticEnum impact) => switch (impact) {
        SystemHapticEnum.normalImpact => _normalImpact(),
        SystemHapticEnum.lightImpact => _lightImpact(),
        SystemHapticEnum.mediumImpact => _mediumImpact(),
        SystemHapticEnum.heavyImpact => _heavyImpact(),
      };
}
