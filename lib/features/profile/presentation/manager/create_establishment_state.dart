import 'package:equatable/equatable.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

abstract class CreateEstablishmentState extends Equatable {
  const CreateEstablishmentState();

  @override
  List<Object?> get props => [];
}

class CreateEstablishmentReady extends CreateEstablishmentState {
  final String status;
  final String userPosition;
  final String? age;
  final String phoneDial;

  const CreateEstablishmentReady({
    this.status = CreateEstablishmentRequest.existingStatus,
    this.userPosition = CreateEstablishmentRequest.ownerPosition,
    this.age,
    this.phoneDial = '966',
  });

  @override
  List<Object?> get props => [status, userPosition, age, phoneDial];
}

class CreateEstablishmentLoading extends CreateEstablishmentState {
  const CreateEstablishmentLoading();
}

class CreateEstablishmentSuccess extends CreateEstablishmentState {
  final String message;
  final ProfileEstablishmentSnapshot establishment;

  const CreateEstablishmentSuccess({
    required this.message,
    required this.establishment,
  });

  @override
  List<Object?> get props => [message, establishment];
}

class CreateEstablishmentFailure extends CreateEstablishmentState {
  final String message;
  final ApiFailureStatus status;
  final int? statusCode;

  const CreateEstablishmentFailure({
    required this.message,
    required this.status,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, status, statusCode];
}
