library avs_image;

import 'dart:io';

import 'package:avs_image/avs_image_gallery.dart';
import 'package:avs_svg_provider/avs_svg_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

part 'components/_svg_gradient_mask.dart';
part 'functions/_check_local.dart';
part 'functions/_check_svg.dart';

enum ZoomStyle { onTap, onDoubleTap, onLongPress }

class AVSImage extends StatelessWidget {
  /// Image Url or Path
  final String url;

  /// Image height
  final double? height;

  /// Image width
  final double? width;

  /// Image color
  final Color? color;

  /// SVG gradient.
  ///
  /// SVG supported
  final LinearGradient? gradient;

  /// Image radius.
  ///
  /// Default BorderRadius.zero
  final BorderRadiusGeometry? radius;

  /// Image isCircle.
  ///
  /// Default false
  ///
  /// If it's true fit = Boxfit.cover
  final bool? isCircle;

  /// Image fit.
  ///
  /// Default BoxFit.contain
  final BoxFit fit;

  /// Image alignment.
  ///
  /// Default Alignment.center
  final Alignment alignment;

  /// Image error widget.
  ///
  /// SVG NOT SUPPORTED
  final Widget? errorImgWidget;

  /// NETWORK IMAGE cache status.
  ///
  /// SVG NOT SUPPORTED
  ///
  /// Default true
  final bool cachedImage;

  /// Cached Network Image Supported
  ///
  /// SVG NOT SUPPORTED
  ///
  /// Default true
  final bool showProgressIndicator;

  /// Default false
  ///
  final bool zoom;

  //Image zoom start style. Default onTap
  final ZoomStyle zoomStyle;

  /// Image onTap function. if this is not null and zoomStyle.onTap then zoom is false
  ///
  final Function()? onTap;

  /// Image onLongPress function. if this is not null and zoomStyle.onLongPress then zoom is false
  ///
  final Function()? onLongPress;

  /// Image onDoubleTap function. if this is not null and zoomStyle.onDoubleTap then zoom is false
  ///
  final Function()? onDoubleTap;

  /// Loading Progress Indicator
  ///
  final Widget? progressIndicatorWidget;

  final bool isSvg;

  final bool isLocalPosition;

  final BoxFit _defaultFit;

  AVSImage(
    String path, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.radius,
    this.gradient,
    this.zoomStyle = ZoomStyle.onTap,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.isCircle,
    this.zoom = false,
    this.errorImgWidget,
    this.cachedImage = true,
    this.showProgressIndicator = true,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.progressIndicatorWidget,
  })  : isSvg = _isSvgCheck(path),
        isLocalPosition = _isLocalImageCheck(path),
        url = path,
        _defaultFit = isCircle == true ? BoxFit.cover : fit;

  @override
  Widget build(BuildContext context) {
    if (url.length > 3) {
      if (isCircle == true) {
        return SizedBox(
          height: height,
          width: width,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
              child: GestureDetector(
                onTap: (onTap == null && zoom == false) ? null : () async => _onTapFunction(context),
                onLongPress: (onLongPress == null && zoom == false) ? null : () async => _onLongPressFunction(context),
                onDoubleTap: (onDoubleTap == null && zoom == false) ? null : () async => onDoubleTapFunction(context),
                child: _buildBody(),
              ),
            ),
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
          child: GestureDetector(
          onTap: (onTap == null && zoom == false) ? null : () async => _onTapFunction(context),
                onLongPress: (onLongPress == null && zoom == false) ? null : () async => _onLongPressFunction(context),
                onDoubleTap: (onDoubleTap == null && zoom == false) ? null : () async => onDoubleTapFunction(context),
            child: _buildBody(),
          ),
        );
      }
    } else {
      return ClipRRect(
        borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
        child: GestureDetector(
       onTap: (onTap == null && zoom == false) ? null : () async => _onTapFunction(context),
                onLongPress: (onLongPress == null && zoom == false) ? null : () async => _onLongPressFunction(context),
                onDoubleTap: (onDoubleTap == null && zoom == false) ? null : () async => onDoubleTapFunction(context),
          child: _buildErrorWidget(context),
        ),
      );
    }
  }

  Widget _buildBody() {
    if (isSvg && isLocalPosition) {
      return _buildLocalSVG();
    } else if (isSvg && !isLocalPosition) {
      return _buildNetworkSVG();
    } else if (isSvg == false && isLocalPosition) {
      return _buildLocalImage();
    } else if (isSvg == false && !isLocalPosition) {
      return _buildNetworkImage();
    } else {
      return Container();
    }
  }

  Widget _buildLocalSVG() {
    return gradient == null ? _buildLocalSVGNoGradient() : _buildLocalSVGWithGradient();
  }

  Widget _buildLocalSVGNoGradient() {
    return ClipRRect(
      borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
      child: SvgPicture.asset(
        url,
        height: height,
        width: width,
        fit: _defaultFit,
        colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
        alignment: alignment,
      ),
    );
  }

  Widget _buildLocalSVGWithGradient() {
    return ClipRRect(
      borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
      child: _SVGLinearGradientMask(
        gradient: gradient ?? const LinearGradient(colors: [Colors.black, Colors.black26]),
        child: SvgPicture.asset(
          url,
          height: height,
          width: width,
          fit: _defaultFit,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          alignment: alignment,
        ),
      ),
    );
  }

  Widget _buildNetworkSVG() {
    return gradient == null ? _buildNetworkSVGNoGradient() : _buildNetworkSVGWithGradient();
  }

  Widget _buildNetworkSVGNoGradient() {
    return ClipRRect(
      borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
      child: SvgPicture.network(
        url,
        height: height,
        width: width,
        fit: _defaultFit,
        colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
        alignment: alignment,
      ),
    );
  }

  Widget _buildNetworkSVGWithGradient() {
    return ClipRRect(
      borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
      child: _SVGLinearGradientMask(
        gradient: gradient ?? const LinearGradient(colors: [Colors.black, Colors.black26]),
        child: SvgPicture.network(
          url,
          height: height,
          width: width,
          fit: _defaultFit,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          alignment: alignment,
        ),
      ),
    );
  }

  Widget _buildLocalImage() {
    return ClipRRect(
      borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
      child: Image.asset(
        url,
        color: color,
        height: height,
        width: width,
        fit: _defaultFit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          _showLog("Local Image Exploded: $url");
          return _buildErrorWidget(context);
        },
      ),
    );
  }

  Widget _buildNetworkImage() {
    return cachedImage == true ? _buildNetworkImageWithCache() : _buildNetworkImageNoCache();
  }

  Widget _buildNetworkImageNoCache() {
    return ClipRRect(
      borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
      child: Image.network(
        url,
        color: color,
        height: height,
        width: width,
        fit: _defaultFit,
        alignment: alignment,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return showProgressIndicator
                ? _buildProgressIndicator(
                    ((loadingProgress.cumulativeBytesLoaded) / (loadingProgress.expectedTotalBytes ?? 1)).toDouble() * 100.toDouble(),
                  )
                : const SizedBox();
          }
        },
        errorBuilder: (context, error, stackTrace) {
          _showLog("Network Image NoCache Exploded: $url");
          return _buildErrorWidget(context);
        },
      ),
    );
  }

  Widget _buildNetworkImageWithCache() {
    return ClipRRect(
      borderRadius: isCircle == true ? BorderRadius.circular(360) : radius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        alignment: alignment,
        fit: _defaultFit,
        maxHeightDiskCache: 3000,
        color: color,
        progressIndicatorBuilder: (context, url, progress) => showProgressIndicator ? _buildProgressIndicator(progress.downloaded.toDouble()) : const SizedBox(),
        errorWidget: (context, url, error) {
          _showLog("Network Image With Cache Exploded: $url");

          return _buildErrorWidget(context);
        },
      ),
    );
  }

  Widget _buildProgressIndicator(double val) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: progressIndicatorWidget ??
            CircularProgressIndicator.adaptive(
              value: Platform.isAndroid ? val : null,
            ),
      ),
    );
  }

  Widget _buildErrorWidget(context) {
    return errorImgWidget == null
        ? const Icon(
            Icons.error,
            size: 20,
            color: Colors.red,
          )
        : errorImgWidget!;
  }

  void _zoomFunc(BuildContext context, String img) {
    AVSImageGallery(context, imagePaths: [img]).show();
  }

  Future<void>? _onTapFunction(BuildContext context) async {
    if (onTap != null) {
      onTap!();
    } else if (zoomStyle == ZoomStyle.onTap && zoom == true) {
      _zoomFunc(context, url);
    }
  }

  Future<void>? _onLongPressFunction(BuildContext context) async {
    if (onLongPress != null) {
      onLongPress!();
    } else if (zoomStyle == ZoomStyle.onLongPress && zoom == true) {
      _zoomFunc(context, url);
    }
  }

  Future<void>? onDoubleTapFunction(BuildContext context) async {
    if (onDoubleTap != null) {
      onDoubleTap!();
    } else if (zoomStyle == ZoomStyle.onDoubleTap && zoom == true) {
      _zoomFunc(context, url);
    }
  }
}

// ignore: non_constant_identifier_names
ImageProvider AVSImageProvider(
  String path, {
  double? height,
  double? width,
  Color? color,
  int scale = 1,
  LinearGradient? gradient,
}) {
  bool isSvg = _isSvgCheck(path);
  bool isLocalPosition = _isLocalImageCheck(path);

  if (isSvg) {
    return AVSSVGProvider(path, color: color, scale: scale, height: height, width: width, gradient: gradient);
  } else if (isSvg == false && isLocalPosition) {
    return AssetImage(path);
  } else if (isSvg == false && !isLocalPosition) {
    return NetworkImage(path, scale: double.parse(scale.toString()));
  } else {
    return const NetworkImage("");
  }
}

void _showLog(String message) {
  var logger = Logger();
  logger.e(message);
}
