import '../data_sources/contact_local_data_source.dart';
import '../data_sources/contact_remote_data_source.dart';
import '../models/contact_model.dart';
import 'contact_repo.dart';

class ContactRepoImpl implements ContactRepo {
  final ContactRemoteDataSource _remoteDataSource;
  final ContactLocalDataSource _localDataSource;

  ContactRepoImpl({
    required ContactRemoteDataSource remoteDataSource,
    required ContactLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Stream<ContactResponseModel> getContacts() async* {
    final cached = _localDataSource.getCachedContact();
    if (cached != null) {
      yield cached;
    }
    final fresh = await _remoteDataSource.fetchContacts();
    await _localDataSource.cacheContact(fresh);
    yield fresh;
  }
}
