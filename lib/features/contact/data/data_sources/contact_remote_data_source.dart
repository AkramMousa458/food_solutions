import 'package:food_solutions/core/services/api_service.dart';
import '../models/contact_model.dart';

abstract class ContactRemoteDataSource {
  Future<ContactResponseModel> fetchContacts();
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final ApiService _apiService;

  ContactRemoteDataSourceImpl(this._apiService);

  @override
  Future<ContactResponseModel> fetchContacts() async {
    final response = await _apiService.get(endPoint: '/api/contacts');
    return ContactResponseModel.fromJson(response);
  }
}
