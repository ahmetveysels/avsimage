part of "../avs_image.dart";

bool _isSvgCheck(String path) {
  String img = path;
  List<String> imgList = img.split(".");
  bool isSVG = imgList.last == "svg" ? true : false;
  return isSVG;
}
