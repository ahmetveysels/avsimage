import 'package:avs_image/avs_image.dart';
import 'package:avs_image/model/gallery_item_model.dart';
import 'package:flutter/material.dart';

part 'image_gallery/_interactive_page.dart';

class AVSImageGallery {
  final BuildContext context;
  final List<AVSGalleryItemModel> images;
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
  final bool? showTitle;
  final BoxDecoration? titleDecoration;
  final TextStyle? titleTextStyle;
  final AlignmentGeometry? titleAlignment;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? titleMargin;
  final bool? loop;

  ///Secondary Button
  final ButtonPosition secondaryButtonPosition;
  final Widget? secondaryButton;

  final ImageGalleryStyle? imageGalleryStyle;

  AVSImageGallery(
    this.context, {
    required this.images,
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
    this.showTitle = false,
    this.titleTextStyle,
    this.titleAlignment,
    this.titleDecoration,
    this.titlePadding,
    this.titleMargin,
    this.loop = false,
  });
  PageController? pageController;

  Future<void> show() async {
    double opacity = 1;
    int activeIndex = initialIndex ?? 0;
    pageController = PageController(initialPage: initialIndex ?? 0);
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => StatefulBuilder(
        builder: (context, setState) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: closeWithOnTap ? () => Navigator.of(context).pop() : null,
              child: Container(
                decoration: BoxDecoration(color: backgroundColor ?? Colors.black.withValues(alpha: opacity), gradient: backgroundGradient),
                child: SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: images.length + 1,

                        ///initialPage is not working properly with jumpToPage, so we use this workaround
                        controller: pageController,
                        onPageChanged: (index) async {
                          int idx = index;
                          if (idx == images.length) {
                            if (loop == true) {
                              idx = 0;
                              pageController?.jumpToPage(idx);
                            } else {
                              Navigator.of(context).pop();
                            }
                          } else {
                            onSwipe?.call(idx);
                          }
                          Future.microtask(() => setState(() {
                                activeIndex = idx;
                              }));
                        },
                        itemBuilder: (context, index) {
                          if (index == images.length) {
                            return const SizedBox();
                          }
                          return _AVSImageOnePage(
                            setBackgroundOpacity: (p0) {
                              opacity = p0;
                              Future.microtask(() => setState(() {}));
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: AVSImage(
                                    images[index].url,
                                    zoom: false,
                                  ),
                                ),
                                if (images[index].title.isNotEmpty && showTitle == true)
                                  Align(
                                    alignment: titleAlignment ?? Alignment.topCenter,
                                    child: SafeArea(
                                      child: Container(
                                        margin: titleMargin ?? const EdgeInsets.all(20),
                                        padding: titlePadding ?? const EdgeInsets.all(20),
                                        decoration: titleDecoration ?? const BoxDecoration(),
                                        child: Text(
                                          images[index].title,
                                          style: titleTextStyle ??
                                              const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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
                      showBottomBar == false || images.length < 2
                          ? const SizedBox()
                          : Positioned(
                              bottom: 20,
                              child: SizedBox(
                                height: imageGalleryStyle?.slideHeight ?? 9,
                                child: ListView.builder(
                                  itemCount: images.length,
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
