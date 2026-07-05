import 'package:equatable/equatable.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';

class ReviewModel extends Equatable {
  final int id;
  final int serviceId;
  final String name;
  final double rate;
  final String comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReviewModel({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.rate,
    required this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int? ?? 0,
      serviceId: json['service_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      rate: _parseDouble(json['rate']),
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  factory ReviewModel.fromServiceReviewItem({
    required int serviceId,
    required ServiceReviewItemModel item,
  }) {
    return ReviewModel(
      id: 0,
      serviceId: serviceId,
      name: item.name,
      rate: item.rate,
      comment: item.comment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'name': name,
      'rate': rate,
      'comment': comment,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    serviceId,
    name,
    rate,
    comment,
    createdAt,
    updatedAt,
  ];
}

double _parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
