import 'package:avs_image/avs_image.dart';
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
            AVSImage(
              "https://cdnuploads.aa.com.tr/uploads/Contents/2020/07/19/thumbs_b_c_24ab0f37a2ebc9b694d4c1fceeb2171c.jpg?v=130117",
              radius: 20,
              height: 200,
              alignment: Alignment.center,
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
