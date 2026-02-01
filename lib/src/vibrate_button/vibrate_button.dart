import 'package:button/src/baral.dart';
import 'package:button/src/loading/wavedotes_loading.dart';

/// A customizable button widget that vibrates (shakes) horizontally when form validation fails.
/// 
/// This button integrates with Flutter's form validation system and provides visual feedback
/// through a shake animation when validation fails. It also supports a loading state with
/// an animated indicator.
/// 
/// Example:
/// ```dart
/// final formKey = GlobalKey<FormState>();
/// 
/// VibrateButton(
///   loading: isLoading,
///   formState: formKey,
///   text: 'Submit',
///   onTap: () {
///     // Handle button tap
///   },
/// )
/// ```
class VibrateButton extends StatefulWidget {
  /// Whether the button is in a loading state.
  /// 
  /// When true, displays [LoadingAnimationWaveDotes] instead of the child/text
  /// and prevents user interaction.
  final bool loading;

  /// The form state key used for validation.
  /// 
  /// When the button is tapped, it validates the form. If validation fails,
  /// the button shakes. If validation passes, [onTap] is called.
  final GlobalKey<FormState> formState;

  /// The height of the button.
  /// 
  /// Defaults to 45.
  final double height;

  /// The width of the button.
  /// 
  /// If null, the button will expand to fit its parent's constraints.
  final double? width;

  /// The background color of the button.
  /// 
  /// Cannot be provided if [decoration] is also provided.
  /// Defaults to the theme's primary color if both [color] and [decoration] are null.
  final Color? color;

  /// Custom decoration for the button container.
  /// 
  /// Cannot be provided if [color] is also provided.
  /// If null, a default [BoxDecoration] with [color] and [radius] is used.
  final Decoration? decoration;

  /// The maximum distance in pixels the button moves during the shake animation.
  /// 
  /// Defaults to 12.
  final double movePixels;

  /// The number of complete shake cycles during the animation.
  /// 
  /// Defaults to 4.
  final double shakeCount;

  /// The duration of the shake animation.
  /// 
  /// Defaults to 450 milliseconds.
  final Duration duration;

  /// The border radius of the button.
  /// 
  /// Only used when [decoration] is not provided.
  /// Defaults to 8.
  final double radius;

  /// The text to display on the button.
  /// 
  /// Either [text] or [child] must be provided, but not both.
  final String? text;

  /// The text style for the button text.
  /// 
  /// If null, uses the theme's titleLarge text style with onPrimary color.
  final TextStyle? textStyle;

  /// Custom child widget to display on the button.
  /// 
  /// Either [text] or [child] must be provided, but not both.
  final Widget? child;

  /// Callback function executed when the button is tapped and form validation passes.
  final VoidCallback onTap;

  /// The margin around the button.
  /// 
  /// Defaults to symmetric horizontal margin of 0.
  final EdgeInsetsGeometry margin;

  /// Creates a [VibrateButton].
  /// 
  /// The [loading], [onTap], and [formState] parameters are required.
  /// Either [text] or [child] must be provided.
  /// [color] and [decoration] cannot both be provided.
  const VibrateButton({
    super.key,
    required this.loading,
    this.height = 45,
    this.width,
    this.color,
    this.decoration,
    this.movePixels = 12,
    this.shakeCount = 4,
    this.duration = const Duration(milliseconds: 450),
    this.text,
    this.textStyle,
    this.child,
    this.radius = 8,
    required this.onTap,
    required this.formState,
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
  })  : assert(
          color == null || decoration == null,
          'Cannot provide both a color and a decoration',
        ),
        assert(
          text != null || child != null,
          'Must provide either text or child',
        ),
        assert(height > 0, 'Height must be positive'),
        assert(width == null || width > 0, 'Width must be positive');

  @override
  State<VibrateButton> createState() => _VibrateButtonState();
}

class _VibrateButtonState extends State<VibrateButton>
    with SingleTickerProviderStateMixin {
  /// Animation controller for the shake animation.
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handles button tap events.
  /// 
  /// If [loading] is true, the tap is ignored.
  /// If form validation passes, calls [onTap].
  /// If form validation fails, triggers the shake animation.
  void _onTap() {
    if (widget.loading) return;

    if (widget.formState.currentState?.validate() ?? false) {
      widget.onTap();
    } else {
      _controller.forward().then((_) => _controller.reset());
    }
  }

  /// Calculates the horizontal offset for the shake animation.
  /// 
  /// Uses a sine wave function to create a smooth oscillating motion.
  /// 
  /// Parameters:
  /// - [t]: Animation progress value between 0.0 and 1.0
  /// - [shakeCount]: Number of complete oscillations
  /// - [movePixels]: Maximum displacement in pixels
  /// 
  /// Returns the horizontal offset value.
  double _shakeCal(double t, double shakeCount, double movePixels) {
    return sin(t * 1 * pi * shakeCount) * movePixels;
  }

  @override
  Widget build(BuildContext context) {
    // Build the decoration, using custom decoration or default with color and radius
    final Decoration decoration = widget.decoration ??
        BoxDecoration(
          color: widget.color ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(widget.radius),
        );

    // Build the child widget, using custom child or text with style
    final Widget child = widget.child ??
        Text(
          widget.text ?? "",
          style: widget.textStyle ??
              Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
        );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Calculate the current shake offset based on animation progress
        final double shake = _shakeCal(
          _controller.value,
          widget.shakeCount,
          widget.movePixels,
        );

        return GestureDetector(
          onTap: _onTap,
          child: Transform.translate(
            offset: Offset(shake, 0),
            child: Container(
              margin: widget.margin,
              height: widget.height,
              width: widget.width,
              decoration: decoration,
              child: Center(
                child: widget.loading
                    ? const WaveDotesLoadingAnimation()
                    : child,
              ),
            ),
          ),
        );
      },
    );
  }
}