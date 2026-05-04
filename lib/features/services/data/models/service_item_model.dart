class ServiceItemModel {
  final int id;
  final String titleAr;
  final String icon;
  final String shortDescriptionAr;
  final String longDescriptionAr;
  final List<String> points;
  final String? image;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceItemModel({
    required this.id,
    required this.titleAr,
    required this.icon,
    required this.shortDescriptionAr,
    required this.longDescriptionAr,
    required this.points,
    this.image,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id'] as int? ?? 0,
      titleAr: json['title_ar'] as String? ?? '',
      icon: json['icon'] as String? ?? '-',
      shortDescriptionAr: json['short_description_ar'] as String? ?? '',
      longDescriptionAr: json['long_description_ar'] as String? ?? '',
      points:
          (json['points'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      image: json['image'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'icon': icon,
      'short_description_ar': shortDescriptionAr,
      'long_description_ar': longDescriptionAr,
      'points': points,
      'image': image,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
