import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import '../models/service_item_model.dart';

abstract class ServicesLocalDataSource {
  List<ServiceItemModel>? getCachedServices();
  Future<void> cacheServices(List<ServiceItemModel> services);
}

class ServicesLocalDataSourceImpl implements ServicesLocalDataSource {
  final LocalStorage _localStorage;

  ServicesLocalDataSourceImpl(this._localStorage);

  @override
  List<ServiceItemModel>? getCachedServices() {
    final jsonString = _localStorage.getString(AppConstants.servicesKey);
    if (jsonString == null) return null;
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => ServiceItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheServices(List<ServiceItemModel> services) async {
    final jsonString = jsonEncode(
      services.map((service) => service.toJson()).toList(),
    );
    await _localStorage.setString(AppConstants.servicesKey, jsonString);
  }
}
