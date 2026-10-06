import 'package:dartz/dartz.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

abstract class ProfileRepo {
  ProfileSnapshot? readProfile();

  Future<Either<ServerFailure, ProfileSnapshot>> fetchAccount();
}
