import 'package:avs_image/avs_image.dart';
import 'package:flutter/material.dart';

part 'image_gallery/_interactive_page.dart';

class AVSImageGallery {
  final BuildContext context;
  final List<String> imagePaths;
  final int? initialIndex;
  final bool? showCloseButton;
  final bool? lastSwipeClose;
  final Function(int index)? onSwipe;
  final bool showBottomBar;
  final Color? backgroundColor;
  final LinearGradient? backgroundGradient;

  AVSImageGallery(
    this.context, {
    required this.imagePaths,
    this.initialIndex = 0,
    this.showCloseButton = true,
    this.lastSwipeClose,
    this.onSwipe,
    this.showBottomBar = true,
    this.backgroundColor,
    this.backgroundGradient,
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
            child: Container(
              decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.black.withOpacity(opacity),
                  gradient: backgroundGradient),
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      itemCount: imagePaths.length + 1,
                      controller:
                          PageController(initialPage: initialIndex ?? 0),
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
                            top: 20,
                            right: 20,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                            ),
                          )
                        : const SizedBox(),

                    // Bottom Bar
                    showBottomBar == false
                        ? const SizedBox()
                        : Positioned(
                            bottom: 20,
                            child: SizedBox(
                              height: 9,
                              child: ListView.builder(
                                itemCount: imagePaths.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 9,
                                    width: 9,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: activeIndex == index
                                          ? Colors.white.withOpacity(opacity)
                                          : Colors.grey.withOpacity(opacity),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
