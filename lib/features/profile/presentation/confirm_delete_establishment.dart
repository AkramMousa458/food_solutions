import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';

Future<void> confirmDeleteEstablishment(
  BuildContext context,
  ProfileEstablishmentSnapshot establishment,
) async {
  final id = establishment.id;
  if (id == null) return;
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(translate('establishment_delete_title')),
        content: Text(
          translate(
            'establishment_delete_message',
          ).replaceAll('{name}', establishment.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(translate('settings_cancel')),
          ),
          TextButton(
            key: const Key('profile-delete-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              translate('establishment_delete_action'),
              style: const TextStyle(color: AppColors.error500),
            ),
          ),
        ],
      );
    },
  );
  if (shouldDelete != true || !context.mounted) return;
  await context.read<ProfileCubit>().deleteEstablishment(id);
}
