
import 'package:button/src/baral.dart';

class LoadingAnimationWaveDotes extends StatefulWidget {
  const LoadingAnimationWaveDotes({super.key});

  @override
  State<LoadingAnimationWaveDotes> createState() =>
      _LoadingAnimationWaveDotesState();
}

class _LoadingAnimationWaveDotesState extends State<LoadingAnimationWaveDotes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (c, v) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: List.generate(3, (index) {
            double value = (_controller.value + (index * 0.2));
            double heightFactor = (0.4 * sin(value * 2 * pi));
            return Transform.translate(
              offset: Offset(0, 10 * heightFactor),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
