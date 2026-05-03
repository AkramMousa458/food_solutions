class HomeSectionModel {
  final int id;
  final String image;
  final String title;
  final String subtitle;
  final String description;
  final int sortOrder;

  const HomeSectionModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.sortOrder,
  });

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) {
    return HomeSectionModel(
      id: json['id'] as int,
      image: (json['image'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subtitle: (json['subtitle'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      sortOrder: (json['sort_order'] as int?) ?? 0,
    );
  }
}
