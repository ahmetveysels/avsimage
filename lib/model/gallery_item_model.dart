class AVSGalleryItemModel {
  final String title;
  final String url;

  AVSGalleryItemModel({
    required this.title,
    required this.url,
  });

  @override
  String toString() => 'GalleryItemModel(title: $title, url: $url)';
}
