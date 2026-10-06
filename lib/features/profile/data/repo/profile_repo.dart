import 'package:dartz/dartz.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/delete_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

abstract class ProfileRepo {
  ProfileSnapshot? readProfile();

  Future<Either<ServerFailure, ProfileSnapshot>> fetchAccount();

  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  createEstablishment(CreateEstablishmentRequest request);

  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  updateEstablishment(int id, CreateEstablishmentRequest request);

  Future<Either<ServerFailure, DeleteEstablishmentResponse>>
  deleteEstablishment(int id);
}
