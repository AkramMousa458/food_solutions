import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/booking/data/models/consultation_request_model.dart';
import 'package:food_solutions/features/booking/data/repo/booking_repo.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo _repo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  BookingCubit(this._repo) : super(BookingInitial());

  Future<void> submitBooking({required int serviceId}) async {
    emit(BookingLoading());
    try {
      final model = ConsultationRequestModel(
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        serviceId: serviceId,
        message: detailsController.text,
      );
      await _repo.submitConsultation(model);
      emit(BookingSuccess());
    } catch (error, stackTrace) {
      emit(
        BookingFailure(
          errorMessage: _bookingErrorMessage(error),
          errorDetails: _bookingErrorDetails(error, stackTrace),
        ),
      );
    }
  }
}

String _bookingErrorMessage(Object error) {
  if (error is DioException) {
    return ServerFailure.fromDioError(error).message;
  }
  return error.toString();
}

String _bookingErrorDetails(Object error, StackTrace stackTrace) {
  final buffer = StringBuffer();
  if (error is DioException) {
    final failure = ServerFailure.fromDioError(error);
    final response = error.response;
    buffer
      ..writeln('message: ${failure.message}')
      ..writeln('status: ${failure.status.name}')
      ..writeln('statusCode: ${failure.statusCode ?? response?.statusCode}')
      ..writeln('type: ${error.type.name}')
      ..writeln('dioMessage: ${error.message}')
      ..writeln('error: ${error.error}')
      ..writeln('method: ${error.requestOptions.method}')
      ..writeln('uri: ${error.requestOptions.uri}')
      ..writeln('requestData: ${error.requestOptions.data}')
      ..writeln('response: ${response?.data}')
      ..writeln('failureData: ${failure.data}');
  } else {
    buffer.writeln('error: $error');
  }
  buffer.writeln('stackTrace: $stackTrace');
  return buffer.toString().trim();
}
