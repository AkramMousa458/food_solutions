import '../models/service_item_model.dart';

abstract class ServicesRepo {
  /// Emits cached services first (if available), then fresh data from the API.
  Stream<List<ServiceItemModel>> getServices();
}
