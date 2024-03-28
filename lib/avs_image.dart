library avs_image;

import 'package:avs_svg_provider/avs_svg_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
part 'components/_svg_gradient_mask.dart';
part 'functions/_check_local.dart';
part 'functions/_check_svg.dart';

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
  /// Default 0
  final double? radius;

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

  final bool showProgressImage;

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
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.isCircle,
    this.errorImgWidget,
    this.cachedImage = true,
    this.showProgressIndicator = true,
    this.showProgressImage = true,
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
            child: _buildBody(),
          ),
        );
      } else {
        return _buildBody();
      }
    } else {
      return _buildErrorWidget(context);
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
      borderRadius: isCircle == true
          ? BorderRadius.circular(360)
          : radius == null
              ? BorderRadius.zero
              : BorderRadius.circular(radius!),
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
      borderRadius: isCircle == true
          ? BorderRadius.circular(360)
          : radius == null
              ? BorderRadius.zero
              : BorderRadius.circular(radius!),
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
      borderRadius: isCircle == true
          ? BorderRadius.circular(360)
          : radius == null
              ? BorderRadius.zero
              : BorderRadius.circular(radius!),
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
      borderRadius: isCircle == true
          ? BorderRadius.circular(360)
          : radius == null
              ? BorderRadius.zero
              : BorderRadius.circular(radius!),
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
      borderRadius: isCircle == true
          ? BorderRadius.circular(360)
          : radius == null
              ? BorderRadius.zero
              : BorderRadius.circular(radius!),
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
      borderRadius: isCircle == true
          ? BorderRadius.circular(360)
          : radius == null
              ? BorderRadius.zero
              : BorderRadius.circular(radius!),
      child: Image.network(
        url,
        color: color,
        height: height,
        width: width,
        fit: _defaultFit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          _showLog("Network Image NoCache Exploded: $url");
          return _buildErrorWidget(context);
        },
      ),
    );
  }

  Widget _buildNetworkImageWithCache() {
    return ClipRRect(
      borderRadius: isCircle == true
          ? BorderRadius.circular(360)
          : radius == null
              ? BorderRadius.zero
              : BorderRadius.circular(radius!),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        alignment: alignment,
        fit: _defaultFit,
        maxHeightDiskCache: 3000,
        color: color,
        progressIndicatorBuilder: showProgressIndicator ? _buildProgressIndicator : null,
        errorWidget: (context, url, error) {
          _showLog("Network Image With Cache Exploded: $url");

          return _buildErrorWidget(context);
        },
      ),
    );
  }

  Widget _buildProgressIndicator(context, a, b) => Center(
        child: CircularProgressIndicator(
          value: b.downloaded.toDouble(),
        ),
      );

  Widget _buildErrorWidget(context) {
    return errorImgWidget == null
        ? const Icon(
            Icons.error,
            size: 20,
            color: Colors.red,
          )
        : errorImgWidget!;
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
