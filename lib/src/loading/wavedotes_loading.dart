import 'package:vibrate_button/src/baral.dart';

/// A loading indicator that displays three dots animating in a wave-like pattern.
///
/// The animation uses a sine wave to create a smooth vertical oscillating motion
/// for each dot, with a staggered phase delay between each dot to produce a
/// continuous wave effect across the group.
///
/// ### How it works:
/// - An [AnimationController] runs on a 1-second loop.
/// - Each of the three dots is offset in phase by `0.2` (i.e., 20% of the cycle),
///   so the wave propagates left to right.
/// - A [sin] function maps the controller's linear progress into a smooth
///   vertical oscillation, scaled by a height factor and pixel amplitude.
///
///
/// This widget is used as the default loading indicator in [VibrateButton].
class WaveDotesLoadingAnimation extends StatefulWidget {
  const WaveDotesLoadingAnimation({super.key});

  @override
  State<WaveDotesLoadingAnimation> createState() =>
      _WaveDotesLoadingAnimationState();
}

/// The mutable state for [WaveDotesLoadingAnimation].
///
/// Uses [SingleTickerProviderStateMixin] to provide a single [Ticker] for the
/// [AnimationController], which is required when a widget drives exactly one
/// animation.
class _WaveDotesLoadingAnimationState extends State<WaveDotesLoadingAnimation>
    with SingleTickerProviderStateMixin {
  /// Controller that drives the continuous wave animation.
  ///
  /// - **Duration:** 1000 ms per full cycle.
  /// - The controller is set to [AnimationController.repeat] immediately after
  ///   creation so the animation loops indefinitely without manual intervention.
  late AnimationController _controller;

  /// The total number of dots rendered in the wave.
  static const int _dotCount = 3;

  /// The phase offset applied between consecutive dots (as a fraction of one
  /// full animation cycle). A value of `0.2` means each dot starts its cycle
  /// 200 ms after the previous one.
  static const double _phaseShift = 0.2;

  /// The amplitude multiplier applied to the sine output before it is scaled
  /// to pixels. Controls how "tall" each wave peak is relative to the base
  /// position.
  static const double _amplitudeMultiplier = 0.4;

  /// The maximum vertical displacement (in logical pixels) a dot can travel
  /// from its resting position.
  static const double _maxDisplacement = 10.0;

  /// The diameter (width and height) of each dot in logical pixels.
  static const double _dotSize = 10.0;

  /// The horizontal spacing between adjacent dots in logical pixels.
  static const double _dotSpacing = 5.0;

  /// The border radius applied to each dot to make it circular.
  /// Set to half of [_dotSize] to produce a perfect circle.
  static const double _dotRadius = _dotSize / 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder rebuilds only this subtree whenever _controller ticks,
    // keeping the rest of the widget tree unaffected.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: _dotSpacing,
          children: List.generate(_dotCount, (index) {
            
            // Each dot's effective progress through the cycle is shifted by
            // `index * _phaseShift`. This staggers the sine wave so that dots
            // animate sequentially rather than in unison.
            final double phase = _controller.value + (index * _phaseShift);

            
            // Multiply phase by 2π to map the [0.0, 1.0+] controller range
            // onto a full sine period. The [sin] function then returns a value
            // in [-1.0, 1.0], which is scaled by [_amplitudeMultiplier] to
            // control wave height.
            final double heightFactor = _amplitudeMultiplier * sin(phase * 2 * pi);

          
            // Multiply by [_maxDisplacement] to convert the normalized factor
            // into a concrete vertical pixel offset. A positive [heightFactor]
            // moves the dot downward; negative moves it upward (screen
            // coordinates).
            final double verticalOffset = _maxDisplacement * heightFactor;

            return Transform.translate(
              offset: Offset(0, verticalOffset),
              child: Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(_dotRadius),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}