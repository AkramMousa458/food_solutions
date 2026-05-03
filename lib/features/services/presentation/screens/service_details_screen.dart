import 'package:flutter/material.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import '../widgets/service_details_body.dart';

class ServiceDetailsScreen extends StatelessWidget {
  static const String routeName = '/service-details';

  final ServiceItemModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ServiceDetailsBody(service: service));
  }
}
