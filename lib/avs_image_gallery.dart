import 'package:avs_image/avs_image.dart';
import 'package:flutter/material.dart';

part 'image_gallery/_interactive_page.dart';

class AVSImageGallery {
  final BuildContext context;
  final List<String> imagePaths;
  final int? initialIndex;
  final bool? showCloseButton;
  final bool closeWithOnTap;
  final bool? lastSwipeClose;
  final Function(int index)? onSwipe;
  final bool showBottomBar;
  final Color? backgroundColor;
  final LinearGradient? backgroundGradient;
  final ButtonPosition closeButtonPosition;
  final Widget? customCloseButton;

  ///Secondary Button
  final ButtonPosition secondaryButtonPosition;
  final Widget? secondaryButton;

  final ImageGalleryStyle? imageGalleryStyle;

  AVSImageGallery(
    this.context, {
    required this.imagePaths,
    this.initialIndex = 0,
    this.showCloseButton = true,
    this.lastSwipeClose,
    this.onSwipe,
    this.showBottomBar = true,
    this.backgroundColor,
    this.closeWithOnTap = false,
    this.backgroundGradient,
    this.closeButtonPosition = ButtonPosition.topRight,
    this.customCloseButton,
    this.imageGalleryStyle,
    this.secondaryButtonPosition = ButtonPosition.topLeft,
    this.secondaryButton,
  });

  Future<void> show() async {
    double opacity = 1;
    int activeIndex = initialIndex ?? 0;
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => StatefulBuilder(
        builder: (context, setState) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: closeWithOnTap ? () => Navigator.of(context).pop() : null,
              child: Container(
                decoration: BoxDecoration(color: backgroundColor ?? Colors.black.withOpacity(opacity), gradient: backgroundGradient),
                child: SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: imagePaths.length + 1,
                        controller: PageController(initialPage: initialIndex ?? 0),
                        onPageChanged: (index) {
                          if (index == imagePaths.length) {
                            Navigator.of(context).pop();
                          } else {
                            onSwipe?.call(index);
                          }

                          Future.microtask(() => setState(() {
                                activeIndex = index;
                              }));
                        },
                        itemBuilder: (context, index) {
                          if (index == imagePaths.length) {
                            return const SizedBox();
                          }
                          return _AVSImageOnePage(
                            setBackgroundOpacity: (p0) {
                              opacity = p0;
                              Future.microtask(() => setState(() {}));
                            },
                            child: AVSImage(
                              imagePaths[index],
                              zoom: false,
                            ),
                          );
                        },
                      ),
                      showCloseButton == true
                          ? Positioned(
                              top: closeButtonPosition == ButtonPosition.topLeft || closeButtonPosition == ButtonPosition.topRight ? 20 : null,
                              right: closeButtonPosition == ButtonPosition.topRight || closeButtonPosition == ButtonPosition.bottomRight ? 20 : null,
                              bottom: closeButtonPosition == ButtonPosition.bottomLeft || closeButtonPosition == ButtonPosition.bottomRight ? 20 : null,
                              left: closeButtonPosition == ButtonPosition.topLeft || closeButtonPosition == ButtonPosition.bottomLeft ? 20 : null,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    customCloseButton ?? const Icon(Icons.close, color: Colors.white),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),

                      secondaryButton != null
                          ? Positioned(
                              top: secondaryButtonPosition == ButtonPosition.topLeft || secondaryButtonPosition == ButtonPosition.topRight ? 20 : null,
                              right: secondaryButtonPosition == ButtonPosition.topRight || secondaryButtonPosition == ButtonPosition.bottomRight ? 20 : null,
                              bottom: secondaryButtonPosition == ButtonPosition.bottomLeft || secondaryButtonPosition == ButtonPosition.bottomRight ? 20 : null,
                              left: secondaryButtonPosition == ButtonPosition.topLeft || secondaryButtonPosition == ButtonPosition.bottomLeft ? 20 : null,
                              child: secondaryButton ?? const SizedBox(),
                            )
                          : const SizedBox(),

                      // Bottom Bar
                      showBottomBar == false || imagePaths.length < 2
                          ? const SizedBox()
                          : Positioned(
                              bottom: 20,
                              child: SizedBox(
                                height: imageGalleryStyle?.slideHeight ?? 9,
                                child: ListView.builder(
                                  itemCount: imagePaths.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return activeIndex == index ? activeSlideWidget(opacity: opacity) : inActiveSlideWidget(opacity: opacity);
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget activeSlideWidget({required double opacity}) {
    return (imageGalleryStyle?.activeSlideIcon ?? "").isNotEmpty ? activeCustomWidgetSlideWidget(opacity: opacity) : activeDefaultSlideWidget(opacity: opacity);
  }

  Widget activeDefaultSlideWidget({required double opacity}) {
    return Container(
      height: imageGalleryStyle?.slideHeight ?? 9,
      width: imageGalleryStyle?.slideWidth ?? 9,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: imageGalleryStyle?.activeSlideColor ?? Colors.white,
        borderRadius: BorderRadius.circular(imageGalleryStyle?.radius ?? 360),
      ),
    );
  }

  Widget activeCustomWidgetSlideWidget({required double opacity}) {
    return Container(
      height: imageGalleryStyle?.slideHeight ?? 9,
      width: imageGalleryStyle?.slideWidth ?? 9,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(imageGalleryStyle?.radius ?? 360),
      ),
      child: AVSImage(
        imageGalleryStyle?.activeSlideIcon ?? "",
        color: imageGalleryStyle?.activeSlideColor ?? Colors.white,
      ),
    );
  }

  Widget inActiveSlideWidget({required double opacity}) {
    return (imageGalleryStyle?.inActiveSlideIcon ?? "").isNotEmpty ? inActiveCustomWidgetSlideWidget(opacity: opacity) : inActiveDefaultSlideWidget(opacity: opacity);
  }

  Widget inActiveDefaultSlideWidget({required double opacity}) {
    return Container(
      height: imageGalleryStyle?.slideHeight ?? 9,
      width: imageGalleryStyle?.slideWidth ?? 9,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: imageGalleryStyle?.inActiveSlideColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(imageGalleryStyle?.radius ?? 360),
      ),
    );
  }

  Widget inActiveCustomWidgetSlideWidget({required double opacity}) {
    return Container(
      height: imageGalleryStyle?.slideHeight ?? 9,
      width: imageGalleryStyle?.slideWidth ?? 9,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(imageGalleryStyle?.radius ?? 360),
      ),
      child: AVSImage(
        imageGalleryStyle?.inActiveSlideIcon ?? "",
        color: imageGalleryStyle?.inActiveSlideColor ?? Colors.grey[300],
      ),
    );
  }
}

class ImageGalleryStyle {
  /// Deault activeSlideColor is Colors.white
  final Color? activeSlideColor;

  /// Deault inActiveSlideColor is Colors.grey
  final Color? inActiveSlideColor;

  /// Deault slideWidth is 9
  final double? slideWidth;

  /// Deault slideHeight is 9
  final double? slideHeight;

  /// Deault activeSlideWidget is null
  final String? activeSlideIcon;

  /// Deault inActiveSlideWidget is null
  final String? inActiveSlideIcon;

  /// Deault radius is 360. It means circle use 360
  final double? radius;

  ImageGalleryStyle({
    this.activeSlideColor,
    this.inActiveSlideColor,
    this.slideWidth,
    this.slideHeight,
    this.activeSlideIcon,
    this.inActiveSlideIcon,
    this.radius,
  });

  @override
  String toString() {
    return 'ImageGalleryStyle(activeSlideColor: $activeSlideColor, inActiveSlideColor: $inActiveSlideColor, slideWidth: $slideWidth, slideHeight: $slideHeight, activeSlideIcon: $activeSlideIcon, inActiveSlideIcon: $inActiveSlideIcon, radius: $radius)';
  }
}
