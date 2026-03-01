/// Defines the haptic feedback intensity used for system vibrations.
enum SystemHapticEnum {
  /// A standard vibration with default system intensity.
  normalImpact,

  /// A subtle, soft vibration — best for minor UI feedback.
  lightImpact,

  /// A moderate vibration — suitable for confirmations or warnings.
  mediumImpact,

  /// A strong, prominent vibration — ideal for errors or critical alerts.
  heavyImpact,
}