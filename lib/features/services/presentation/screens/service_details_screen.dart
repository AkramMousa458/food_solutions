import 'package:flutter/material.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/reviews/presentation/manager/reviews_cubit.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import '../widgets/service_details_body.dart';

class ServiceDetailsScreen extends StatefulWidget {
  static const String routeName = '/service-details';

  final ServiceItemModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    locator<ReviewsCubit>().seedServiceReviews(
      widget.service.id,
      widget.service.serviceReviews,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ServiceDetailsBody(service: widget.service));
  }
}
