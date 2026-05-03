import '../models/service_item_model.dart';

abstract class ServicesRepo {
  Future<List<ServiceItemModel>> getServices();
}
