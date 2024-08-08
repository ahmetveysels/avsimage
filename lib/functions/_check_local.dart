part of "../avs_image.dart";

AVSImageType _getImageType(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return AVSImageType.network;
  } else if (path.startsWith('/') || path.contains('/storage/') || path.contains('/data/')) {
    return AVSImageType.file;
  } else {
    return AVSImageType.asset;
  }
}
