import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/confirm_delete_establishment.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_state.dart';
import 'package:food_solutions/features/profile/presentation/open_establishment_location.dart';
import 'package:food_solutions/features/profile/presentation/screens/create_establishment_screen.dart';
import 'package:food_solutions/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_branch_sheet.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_establishment_card.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_identity_card.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_loading_shimmer.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_settings_tile.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_status_view.dart';
import 'package:food_solutions/features/settings/presentation/widgets/settings_logout_tile.dart';
import 'package:go_router/go_router.dart';

Future<void> _openCreateEstablishment(BuildContext context) async {
  await context.push(CreateEstablishmentScreen.routeName);
  if (!context.mounted) return;
  await context.read<ProfileCubit>().loadProfile();
}

Future<void> _openEditEstablishment(
  BuildContext context,
  ProfileEstablishmentSnapshot establishment,
) async {
  await context.push(CreateEstablishmentScreen.routeName, extra: establishment);
  if (!context.mounted) return;
  await context.read<ProfileCubit>().loadProfile();
}

Future<void> _openEditProfile(
  BuildContext context,
  ProfileSnapshot profile,
) async {
  final updated = await context.push<bool>(
    EditProfileScreen.routeName,
    extra: profile,
  );
  if (updated != true || !context.mounted) return;
  context.read<ProfileCubit>().applyCachedProfile();
}

VoidCallback? _editEstablishmentAction(
  BuildContext context,
  ProfileEstablishmentSnapshot? establishment,
) {
  if (establishment == null || establishment.id == null) return null;
  final current = establishment;
  return () => _openEditEstablishment(context, current);
}

VoidCallback? _deleteEstablishmentAction(
  BuildContext context,
  ProfileEstablishmentSnapshot? establishment,
) {
  if (establishment == null || establishment.id == null) return null;
  final current = establishment;
  return () => confirmDeleteEstablishment(context, current);
}

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileFailure) {
          return ProfileStatusView(
            message: translate(state.message),
            onRetry: () => context.read<ProfileCubit>().loadProfile(),
          );
        }
        if (state is! ProfileSuccess) {
          return const ProfileLoadingShimmer();
        }
        final profile = state.profile;
        final establishment = state.selectedEstablishment;
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            ProfileIdentityCard(
              profile: profile,
              onEditProfile: () => _openEditProfile(context, profile),
            ),
            SizedBox(height: 14.h),
            ProfileEstablishmentCard(
              establishment: establishment,
              isBusy: state.isBusy,
              onOpenLocation: openEstablishmentLocationAction(establishment),
              onEdit: _editEstablishmentAction(context, establishment),
              onDelete: _deleteEstablishmentAction(context, establishment),
              onSwitchBranch: () {
                openProfileBranches(
                  context: context,
                  establishments: profile.establishments,
                  selectedIndex: state.selectedEstablishmentIndex,
                  onSelected: context.read<ProfileCubit>().selectEstablishment,
                  onCreate: () => _openCreateEstablishment(context),
                );
              },
            ),
            SizedBox(height: 14.h),
            const ProfileSettingsTile(),
            SizedBox(height: 14.h),
            const SettingsLogoutTile(),
            SizedBox(height: 18.h),
          ],
        );
      },
    );
  }
}
