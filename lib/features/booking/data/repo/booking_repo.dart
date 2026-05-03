import '../models/consultation_request_model.dart';

abstract class BookingRepo {
  Future<Map<String, dynamic>> submitConsultation(
    ConsultationRequestModel model,
  );
}
