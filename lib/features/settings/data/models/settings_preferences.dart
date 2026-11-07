import 'package:equatable/equatable.dart';

class SettingsPreferences extends Equatable {
  final bool isSalesAlertsEnabled;
  final bool isBiometricLoginEnabled;

  const SettingsPreferences({
    required this.isSalesAlertsEnabled,
    required this.isBiometricLoginEnabled,
  });

  SettingsPreferences copyWith({
    bool? isSalesAlertsEnabled,
    bool? isBiometricLoginEnabled,
  }) {
    return SettingsPreferences(
      isSalesAlertsEnabled: isSalesAlertsEnabled ?? this.isSalesAlertsEnabled,
      isBiometricLoginEnabled:
          isBiometricLoginEnabled ?? this.isBiometricLoginEnabled,
    );
  }

  @override
  List<Object?> get props => [isSalesAlertsEnabled, isBiometricLoginEnabled];
}
