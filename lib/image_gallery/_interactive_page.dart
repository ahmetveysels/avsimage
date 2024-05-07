part of '../avs_image_gallery.dart';

class _AVSImageOnePage extends StatefulWidget {
  const _AVSImageOnePage({
    required this.child,
    required this.setBackgroundOpacity,
  });

  final Widget child;
  final void Function(double) setBackgroundOpacity;

  @override
  State<_AVSImageOnePage> createState() => _InteractivePageState();
}

class _InteractivePageState extends State<_AVSImageOnePage>
    with TickerProviderStateMixin {
  final _transformationController = TransformationController();
  late AnimationController _zoomAnimationController;
  late AnimationController _translateToCenterController;
  late AnimationController _zoomOutAnimationController;
  final dismissDragDistance = 160;
  bool _zoomed = false;
  Offset _dragPosition = const Offset(0.0, 0.0);

  void transformListener() {
    final scale = _transformationController.value.row0.r;

    if (scale > 1 && !_zoomed) {
      setState(() => _zoomed = true);
      _zoomOutAnimationController.reset();
    } else if (scale <= 1 && _zoomed) {
      setState(() => _zoomed = false);
      _zoomAnimationController.reset();
    }
  }

  @override
  void initState() {
    _transformationController.addListener(transformListener);
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _zoomOutAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _translateToCenterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _zoomAnimationController.dispose();
    _zoomOutAnimationController.dispose();
    _translateToCenterController.dispose();
    super.dispose();
  }

  void animateDragPosition(double offsetY) {
    final offsetTween = Tween<double>(begin: offsetY, end: 0)
        .animate(_translateToCenterController);
    void animationListener() {
      setState(() {
        _dragPosition = Offset(0, offsetTween.value);
      });
      if (_translateToCenterController.isCompleted) {
        offsetTween.removeListener(animationListener);
      }
    }

    offsetTween.addListener(animationListener);
    _translateToCenterController.forward();
  }

  void animateZoom({
    required Matrix4 end,
    required AnimationController animationController,
  }) {
    final mapAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: end,
    ).animate(animationController);

    void animationListener() {
      _transformationController.value = mapAnimation.value;

      if (_transformationController.value == end) {
        mapAnimation.removeListener(animationListener);
      }
    }

    mapAnimation.addListener(animationListener);

    animationController.forward();
  }

  void doubleTapDownHandler(TapDownDetails details) {
    if (_zoomed) {
      final defaultMatrix = Matrix4.diagonal3Values(1, 1, 1);

      animateZoom(
        animationController: _zoomOutAnimationController,
        end: defaultMatrix,
      );
    } else {
      final x = -details.localPosition.dx;
      final y = -details.localPosition.dy;
      const scaleMultiplier = 2.0;

      final zoomedMatrix = Matrix4(
        scaleMultiplier, 0.0, 0.0, 0, //
        0.0, scaleMultiplier, 0.0, 0, //
        0.0, 0.0, 1.0, 0.0, //
        x, y, 0.0, 1.0, //
      );

      animateZoom(
        animationController: _zoomAnimationController,
        end: zoomedMatrix,
      );
    }
  }

  /// Required for `onDoubleTapDown` to work
  void onDoubleTap() {}

  void onVerticalDragEndHandler(DragEndDetails details) {
    double pixelsPerSecond = _dragPosition.dy.abs();
    if (pixelsPerSecond > (dismissDragDistance)) {
      Navigator.pop(context);
    } else {
      _setOpacity(1);
      animateDragPosition(_dragPosition.dy);
    }
  }

  void _setOpacity(double opacity) {
    widget.setBackgroundOpacity(opacity);
  }

  void onVerticalDragUpdateHandler(DragUpdateDetails details) {
    setState(
        () => _dragPosition = Offset(0.0, _dragPosition.dy + details.delta.dy));

    final ratio = 1 - (_dragPosition.dy.abs() / dismissDragDistance);
    _setOpacity(ratio > 0 ? ratio : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Positioned(
            left: _dragPosition.dx,
            top: _dragPosition.dy,
            bottom: -_dragPosition.dy,
            right: -_dragPosition.dx,
            child: GestureDetector(
              onVerticalDragStart: _zoomed
                  ? null
                  : (_) {
                      _translateToCenterController.reset();
                    },
              onVerticalDragUpdate:
                  !_zoomed ? onVerticalDragUpdateHandler : null,
              onVerticalDragEnd: !_zoomed ? onVerticalDragEndHandler : null,
              onDoubleTapDown: doubleTapDownHandler,
              onDoubleTap: onDoubleTap,
              child: InteractiveViewer(
                maxScale: 8.0,
                transformationController: _transformationController,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
