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
    } catch (e) {
      String errorMessage;
      if (e is DioException) {
        errorMessage = ServerFailure.fromDioError(e).message;
      } else {
        errorMessage = e.toString();
      }
      emit(BookingFailure(errorMessage: errorMessage));
    }
  }
}
