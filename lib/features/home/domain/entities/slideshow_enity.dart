class SlideshowEntity {
  final int moduleId;
  final String name;
  final int width;
  final int height;
  final String effect;
  final String controls;
  final String indicators;
  final String items;
  final int interval;
  final List<SlideEntity> slides;

  const SlideshowEntity({
    required this.moduleId,
    required this.name,
    required this.width,
    required this.height,
    required this.effect,
    required this.controls,
    required this.indicators,
    required this.items,
    required this.interval,
    required this.slides,
  });
}

class SlideEntity {
  final String title;
  final String link;
  final String image;

  const SlideEntity({
    required this.title,
    required this.link,
    required this.image,
  });
}