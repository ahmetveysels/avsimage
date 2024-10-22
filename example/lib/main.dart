import 'package:avs_image/avs_image.dart';
import 'package:avs_image/avs_image_gallery.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AVSImage Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // AVSImage(
            //   "https://cdnuploads.aa.com.tr/uploads/Contents/2020/07/19/thumbs_b_c_24ab0f37a2ebc9b694d4c1fceeb2171c.jpg?v=130117",
            //   isCircle: true,
            //   width: 200,
            //   height: 200,
            //   alignment: Alignment.center,
            //   errorImgWidget: const Icon(
            //     Icons.error,
            //     color: Colors.red,
            //   ),
            // ),
            // const SizedBox(height: 30),

            // TextButton(
            //   onPressed: () {
            //     AVSImageGallery(
            //       context,
            //       imagePaths: [
            //         "assets/image1.png",
            //         "assets/image2.png",
            //         "assets/image3.png",
            //         "assets/image4.png",
            //         "assets/image5.png",
            //       ],
            //     ).show();
            //   },
            //   child: const Text("Open Gallery"),
            // ),

            AVSImage(
              "https://images.pexels.com/photos/378570/pexels-photo-378570.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
              radius: BorderRadius.circular(20),
              onTap: () {
                AVSImageGallery(
                  context,
                  closeButtonPosition: CloseButtonPosition.topLeft,
                  customCloseButton:
                      const Icon(Icons.delete, color: Colors.red),
                  imagePaths: [
                    "assets/image1.png",
                    "https://nightgoes.com/wp-content/uploads/2023/09/pro.gaultier_a_modern_electric_night_train_crossing_the_map_of__8751c62e-5aa0-4af7-8138-dddf21d8141b.png.webp",
                    "https://nightgoes.com/wp-content/uploads/2023/09/paris-berlin-1.png.webp"
                        "assets/image2.png",
                    "assets/image3.png",
                    "assets/image4.png",
                    "assets/image5.png",
                  ],
                  imageGalleryStyle: ImageGalleryStyle(
                    slideHeight: 18,
                    slideWidth: 18,
                    activeSlideColor: Colors.red,
                    inActiveSlideColor: Colors.amber,
                    activeSlideIcon: "assets/star-solid.svg",
                    inActiveSlideIcon: "assets/star-regular.svg",
                  ),

                  // initialIndex: 2,
                  backgroundColor: Colors.red,
                  backgroundGradient: const LinearGradient(
                    colors: [Colors.blue, Color.fromARGB(255, 176, 200, 91)],
                    tileMode: TileMode.clamp,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ).show();
              },
              height: 200,
              zoom: true,
              cachedImage: false,
              zoomStyle: ZoomStyle.onDoubleTap,
              alignment: Alignment.center,
              progressIndicatorWidget: const Text("loading..."),
              errorImgWidget: const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 200,
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AVSImageProvider(
                      "https://www.svgrepo.com/show/530440/machine-vision.svg",
                      scale: 9),
                ),
              ),
              child: const Text("SVG Image Provider"),
            ),
            const SizedBox(height: 30),
            Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AVSImageProvider(
                    "https://cdnuploads.aa.com.tr/uploads/Contents/2020/07/19/thumbs_b_c_24ab0f37a2ebc9b694d4c1fceeb2171c.jpg?v=130117",
                  ),
                ),
              ),
              child: const Text("Network Image Provider"),
            ),
            // AVSImage(
            //   "errorimage",
            //   height: 200,
            //   alignment: Alignment.center,
            //   errorImgWidget: const Column(
            //     children: [
            //       Icon(
            //         Icons.error,
            //         color: Colors.red,
            //         size: 50,
            //       ),
            //       SizedBox(height: 5),
            //       Text("Error Image"),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
