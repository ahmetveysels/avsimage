part of "../avs_image.dart";

class _SVGLinearGradientMask extends StatelessWidget {
  final Widget child;
  final LinearGradient gradient;
  const _SVGLinearGradientMask({
    required this.child,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(bounds);
      },
      child: child,
    );
  }
}
