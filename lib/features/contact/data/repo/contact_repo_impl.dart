import '../data_sources/contact_remote_data_source.dart';
import '../models/contact_model.dart';
import 'contact_repo.dart';

class ContactRepoImpl implements ContactRepo {
  final ContactRemoteDataSource _remoteDataSource;

  ContactRepoImpl(this._remoteDataSource);

  @override
  Future<ContactResponseModel> getContacts() async {
    try {
      return await _remoteDataSource.fetchContacts();
    } catch (e) {
      rethrow;
    }
  }
}
