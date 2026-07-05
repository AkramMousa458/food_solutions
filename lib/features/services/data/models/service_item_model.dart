class ServiceReviewItemModel {
  final String name;
  final String comment;
  final double rate;

  const ServiceReviewItemModel({
    required this.name,
    required this.comment,
    required this.rate,
  });

  factory ServiceReviewItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceReviewItemModel(
      name: json['name'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      rate: _parseDouble(json['rate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'comment': comment,
      'rate': rate.toStringAsFixed(1),
    };
  }
}

class ServiceReviewsModel {
  final int total;
  final double averageRate;
  final List<ServiceReviewItemModel> reviews;

  const ServiceReviewsModel({
    required this.total,
    required this.averageRate,
    required this.reviews,
  });

  factory ServiceReviewsModel.fromJson(Map<String, dynamic> json) {
    return ServiceReviewsModel(
      total: json['total'] as int? ?? 0,
      averageRate: _parseDouble(json['averageRate']),
      reviews:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => ServiceReviewItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'averageRate': averageRate,
      'data': reviews.map((review) => review.toJson()).toList(),
    };
  }
}

class ServiceItemModel {
  final int id;
  final String titleAr;
  final String icon;
  final String shortDescriptionAr;
  final String longDescriptionAr;
  final List<String> points;
  final String? image;
  final ServiceReviewsModel? serviceReviews;
  final int sortOrder;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceItemModel({
    required this.id,
    required this.titleAr,
    required this.icon,
    required this.shortDescriptionAr,
    required this.longDescriptionAr,
    required this.points,
    this.image,
    this.serviceReviews,
    this.sortOrder = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id'] as int? ?? 0,
      titleAr: json['title_ar'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      shortDescriptionAr: json['short_description_ar'] as String? ?? '',
      longDescriptionAr: json['long_description_ar'] as String? ?? '',
      points:
          (json['points'] as List<dynamic>?)
              ?.map((point) => point.toString())
              .toList() ??
          [],
      image: json['image'] as String?,
      serviceReviews: json['service_reviews'] != null
          ? ServiceReviewsModel.fromJson(
              json['service_reviews'] as Map<String, dynamic>,
            )
          : null,
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
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
      if (serviceReviews != null) 'service_reviews': serviceReviews!.toJson(),
      'sort_order': sortOrder,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
