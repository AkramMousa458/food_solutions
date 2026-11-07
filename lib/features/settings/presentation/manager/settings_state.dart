import 'package:equatable/equatable.dart';
import 'package:food_solutions/core/error/failure.dart';
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

class SettingsFeedback extends Equatable {
  final String message;
  final bool isError;
  final ApiFailureStatus? status;

  const SettingsFeedback({
    required this.message,
    required this.isError,
    this.status,
  });

  @override
  List<Object?> get props => [message, isError, status];
}

class SettingsReady extends SettingsState {
  final ProfileSnapshot? profile;
  final SettingsPreferences preferences;
  final bool isDeleting;
  final SettingsFeedback? feedback;

  const SettingsReady({
    required this.profile,
    required this.preferences,
    this.isDeleting = false,
    this.feedback,
  });

  SettingsReady copyWith({
    SettingsPreferences? preferences,
    bool? isDeleting,
    SettingsFeedback? feedback,
    bool clearFeedback = false,
  }) {
    return SettingsReady(
      profile: profile,
      preferences: preferences ?? this.preferences,
      isDeleting: isDeleting ?? this.isDeleting,
      feedback: clearFeedback ? null : feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [profile, preferences, isDeleting, feedback];
}

class SettingsSessionEnded extends SettingsState {
  final String message;

  const SettingsSessionEnded({this.message = ''});

  @override
  List<Object?> get props => [message];
}
