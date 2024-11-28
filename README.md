# AVSImage

AVSImage package. All in one. A Flutter package that you can get and use images from local and network. Keep your images in the cache directory. You can also use your SVG files with this package. Gradient color SVG is supported. All in one and easy to use.

- With AVSImageProvider you can easily use images and svg files as ImageProvider.

- With AVSImageGallery you can show your images as a gallery.
 

## 👍 Like us on [pub.dev](https://pub.dev/packages/avs_image) to support us!

## What's new? v1.1.7

- AVSImagaGallery share button supported.
- 
- AVSImage if zoom: true share button supported.

- Slidebar is hidden if the element of the my list is less than 2.
- 
- Customize closeButtonPosition
- 
- customCloseButton Added
- 
- customize slide widget with 'imageGalleryStyle' property
 
## Getting started

No permission is needed.

## Usage 

Please review the example folder

Define the widget,
```dart
AVSImage(
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/About_to_Launch_%2826075320352%29.jpg/1280px-About_to_Launch_%2826075320352%29.jpg",
    isCircle: true,
    width: 100,
    height: 100,
    alignment: Alignment.center,
    errorImgWidget: const Icon(
        Icons.error,
        color: Colors.red,
    ),
),
```

## Using errorImgWidget
Use error widget for your files not working with errorImgWidget
```dart
AVSImage(
    "https://cdnuploads.aa.com.tr/uploads/Contents/2020/07/19/thumbs_b_c_24ab0f37a2ebc9b694d4c1fceeb2171c.jpg?v=130117",
    isCircle: true,
    errorImgWidget: const Icon(
        Icons.error,
        color: Colors.red,
    ),
),
```
## Using AVSImageProvider 
ImageProvider with Image
```dart
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
    child: const Text("Image - SVG Provider"),
),
```

Use AVSImageGallery
```dart
TextButton(
    onPressed: () {
        AVSImageGallery(context, imagePaths: [
            "assets/images/1.jpg",
            "assets/images/2.jpg",
            "assets/images/3.jpg",
            "assets/images/4.jpg",
        ]).show();
    },
    child: const Text("Open Gallery"),
),
```

 

## ScreenShot

![Screenshot](https://ahmetveysel.com/flutterpackages/avsimage/screenshot.png)



## Additional information
 
[ahmetveysel.com](https://ahmetveysel.com)
##
<img src='https://ahmetveysel.com/flutterpackages/logo.png' width='125'> 