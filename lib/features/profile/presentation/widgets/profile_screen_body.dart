import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_state.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_branch_sheet.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_establishment_card.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_footer.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_identity_card.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_settings_tile.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_status_view.dart';

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
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final profile = state.profile;
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            ProfileIdentityCard(profile: profile, onEditProfile: () {}),
            SizedBox(height: 14.h),
            ProfileEstablishmentCard(
              establishment: state.selectedEstablishment,
              onSwitchBranch: () {
                openProfileBranches(
                  context: context,
                  establishments: profile.establishments,
                  selectedIndex: state.selectedEstablishmentIndex,
                  onSelected: context.read<ProfileCubit>().selectEstablishment,
                );
              },
            ),
            SizedBox(height: 14.h),
            const ProfileSettingsTile(),
            SizedBox(height: 18.h),
            const ProfileFooter(),
          ],
        );
      },
    );
  }
}
