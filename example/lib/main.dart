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
            AVSImage(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/About_to_Launch_%2826075320352%29.jpg/1280px-About_to_Launch_%2826075320352%29.jpg",
              isCircle: true,
              width: 200,
              height: 200,
              alignment: Alignment.center,
              errorImgWidget: const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            AVSImage(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/About_to_Launch_%2826075320352%29.jpg/1280px-About_to_Launch_%2826075320352%29.jpg",
              radius: 20,
              height: 200,
              alignment: Alignment.center,
              errorImgWidget: const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            AVSImage(
              "errorimage",
              height: 200,
              alignment: Alignment.center,
              errorImgWidget: const Column(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50,
                  ),
                  SizedBox(height: 5),
                  Text("Error Image"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
