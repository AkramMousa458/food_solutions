import 'package:equatable/equatable.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsReady extends SettingsState {
  final ProfileSnapshot? profile;
  final SettingsPreferences preferences;

  const SettingsReady({required this.profile, required this.preferences});

  SettingsReady copyWith({SettingsPreferences? preferences}) {
    return SettingsReady(
      profile: profile,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [profile, preferences];
}

class SettingsSessionEnded extends SettingsState {
  const SettingsSessionEnded();
}
