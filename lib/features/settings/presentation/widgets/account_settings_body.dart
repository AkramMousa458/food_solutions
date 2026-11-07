import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_state.dart';
import 'package:food_solutions/features/settings/presentation/widgets/settings_delete_card.dart';
import 'package:food_solutions/features/settings/presentation/widgets/settings_header.dart';
import 'package:food_solutions/features/settings/presentation/widgets/settings_preferences_card.dart';
import 'package:food_solutions/features/settings/presentation/widgets/settings_section_label.dart';

class AccountSettingsBody extends StatelessWidget {
  final SettingsReady settings;

  const AccountSettingsBody({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    // final preferences = settings.preferences;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      children: [
        const SettingsHeader(),
        SizedBox(height: 16.h),
        SettingsSectionLabel(
          title: translate('settings_appearance_language'),
          icon: Icons.palette_outlined,
        ),
        const SettingsPreferencesCard(),
        SizedBox(height: 18.h),
        // SettingsSectionLabel(
        //   title: translate('settings_security'),
        //   icon: Icons.shield_outlined,
        // ),
        // SettingsStatusTile(
        //   key: const Key('settings-sales-alerts'),
        //   icon: Icons.notifications_none_rounded,
        //   title: translate('settings_sales_alerts'),
        //   subtitle: translate('settings_sales_alerts_subtitle'),
        //   isEnabled: preferences.isSalesAlertsEnabled,
        //   onTap: () {
        //     context.read<SettingsCubit>().setSalesAlerts(
        //       !preferences.isSalesAlertsEnabled,
        //     );
        //   },
        // ),
        // SizedBox(height: 10.h),
        // SettingsStatusTile(
        //   key: const Key('settings-biometric'),
        //   icon: Icons.fingerprint_rounded,
        //   title: translate('settings_biometric'),
        //   subtitle: translate('settings_biometric_subtitle'),
        //   isEnabled: preferences.isBiometricLoginEnabled,
        //   onTap: () {
        //     context.read<SettingsCubit>().setBiometricLogin(
        //       !preferences.isBiometricLoginEnabled,
        //     );
        //   },
        // ),
        SizedBox(height: 18.h),
        SettingsSectionLabel(
          title: translate('settings_account_actions'),
          icon: Icons.manage_accounts_outlined,
        ),
        const SettingsDeleteCard(),
      ],
    );
  }
}
