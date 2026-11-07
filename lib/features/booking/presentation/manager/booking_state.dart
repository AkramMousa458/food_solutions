import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingFailure extends BookingState {
  final String errorMessage;
  final String errorDetails;

  const BookingFailure({
    required this.errorMessage,
    required this.errorDetails,
  });

  @override
  List<Object> get props => [errorMessage, errorDetails];
}
