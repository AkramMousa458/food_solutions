import 'package:flutter/material.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_action_button.dart';

class ProfileLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileLocationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ProfileActionButton(
      label: translate('profile_open_location'),
      icon: Icons.location_on_outlined,
      onPressed: onPressed,
    );
  }
}
