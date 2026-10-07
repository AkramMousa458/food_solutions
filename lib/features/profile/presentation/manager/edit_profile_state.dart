import 'package:equatable/equatable.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileReady extends EditProfileState {
  const EditProfileReady();
}

class EditProfileLoading extends EditProfileState {
  const EditProfileLoading();
}

class EditProfileSuccess extends EditProfileState {
  final ProfileSnapshot profile;

  const EditProfileSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class EditProfileFailure extends EditProfileState {
  final String message;
  final ApiFailureStatus status;
  final int? statusCode;

  const EditProfileFailure({
    required this.message,
    required this.status,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, status, statusCode];
}
