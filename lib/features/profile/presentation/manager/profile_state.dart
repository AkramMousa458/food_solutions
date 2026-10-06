import 'package:equatable/equatable.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final ProfileSnapshot profile;
  final int selectedEstablishmentIndex;

  const ProfileSuccess({
    required this.profile,
    this.selectedEstablishmentIndex = 0,
  });

  ProfileEstablishmentSnapshot? get selectedEstablishment {
    final items = profile.establishments;
    if (items.isEmpty) return null;
    final index = selectedEstablishmentIndex.clamp(0, items.length - 1);
    return items[index];
  }

  @override
  List<Object?> get props => [profile, selectedEstablishmentIndex];
}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
