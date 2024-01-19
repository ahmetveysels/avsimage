# AVSImage

AVSImage package. A Flutter package that you can get and use images from local and network. Keep your images in the cache directory. You can also use your svg files with this package. Gradient color SVG is supported. All in one and easy to use.

## Features

![Screenshot](https://ahmetveysel.com/flutterpackages/avsimage/screenshot.png)

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



## Additional information
 
[ahmetveysel.com](https://ahmetveysel.com)
##
<img src='https://ahmetveysel.com/flutterpackages/logo.png' width='125'> 