import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

abstract class ProfileRepo {
  ProfileSnapshot? readProfile();
}
