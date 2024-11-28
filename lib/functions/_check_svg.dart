part of "../avs_image.dart";

Future<bool> _isSvgCheck(String path) async {
  if (_getImageType(path) == AVSImageType.network &&
      path[path.length - 1] == "/") {
    return await _isSVGNetworkUrl(path);
  } else {
    String img = path;
    List<String> imgList = img.split(".");
    bool isSVG = imgList.last == "svg" ? true : false;
    return isSVG;
  }
}

bool _isSvgCheckisProvider(String path) {
  String img = path;
  List<String> imgList = img.split(".");
  bool isSVG = imgList.last == "svg" ? true : false;
  return isSVG;
}

Future<bool> _isSVGNetworkUrl(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    debugPrint('Content-Type: ${response.headers['content-type']}');
    if (response.statusCode == 200 &&
        response.headers['content-type']?.startsWith('image/svg') == true) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
