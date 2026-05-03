import '../data_sources/booking_remote_data_source.dart';
import '../models/consultation_request_model.dart';
import 'booking_repo.dart';

class BookingRepoImpl implements BookingRepo {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepoImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> submitConsultation(
    ConsultationRequestModel model,
  ) async {
    try {
      return await _remoteDataSource.submitConsultation(model);
    } catch (e) {
      rethrow;
    }
  }
}
