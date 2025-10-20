import 'package:avs_image/avs_image.dart';
import 'package:avs_image/avs_image_gallery.dart';
import 'package:avs_image/model/gallery_item_model.dart';
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),

              TextButton(
                onPressed: () {
                  AVSImageGallery(
                    context,
                    titleTextStyle: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                    titleDecoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    showTitle: true,
                    initialIndex: 2,
                    titleAlignment: Alignment.topCenter,
                    titleMargin: const EdgeInsets.all(44),
                    titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    imageGalleryStyle: ImageGalleryStyle(
                      activeSlideColor: Colors.red,
                      inActiveSlideColor: Colors.blue,
                    ),
                    loop: true,
                    images: [
                      AVSGalleryItemModel(title: "Image 1", url: "assets/image1.png"),
                      AVSGalleryItemModel(title: "Image 2", url: "assets/image2.png"),
                      AVSGalleryItemModel(title: "Image 3", url: "assets/image3.png"),
                      AVSGalleryItemModel(title: "Image 4", url: "assets/image4.png"),
                      AVSGalleryItemModel(title: "Image 5", url: "assets/image5.png"),
                    ],
                  ).show();
                },
                child: const Text("Open Gallery"),
              ),

              AVSImage(
                "https://images.pexels.com/photos/378570/pexels-photo-378570.jpeg?auto=compress&cs=tinysrgb&w=1260&h=2750&dpr=2",
                radius: BorderRadius.circular(20),
                height: 200,
                zoom: true,
                zoomCloseType: ZoomCloseType.dragAndTap,
                cachedImage: false,
                zoomStyle: ZoomStyle.onTap,
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
                    image: AVSImageProvider("https://www.svgrepo.com/show/530440/machine-vision.svg", scale: 9),
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
      ),
    );
  }
}
