import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';
import 'package:food_solutions/features/services/presentation/widgets/service_tile_card.dart';
import '../manager/favorites_cubit.dart';
import '../manager/favorites_state.dart';

class FavoritesScreenBody extends StatelessWidget {
  const FavoritesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favState) {
        if (favState is! FavoritesLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final favoriteIds = favState.favoriteIds;

        if (favoriteIds.isEmpty) {
          return _buildEmptyState(context);
        }

        return BlocBuilder<ServicesCubit, ServicesState>(
          builder: (context, servicesState) {
            if (servicesState is ServicesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (servicesState is! ServicesLoaded) {
              return Center(
                child: Text(
                  translate('error_try_again'),
                  style: TextStyle(color: AppColors.error, fontSize: 14.sp),
                ),
              );
            }

            final favoriteServices = servicesState.services
                .where((s) => favoriteIds.contains(s.id))
                .toList();

            if (favoriteServices.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              itemCount: favoriteServices.length,
              itemBuilder: (context, index) {
                return ServiceTileCard(service: favoriteServices[index]);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 72.sp,
              color: AppColors.grey.withValues(alpha: 0.4),
            ),
            SizedBox(height: 20.h),
            Text(
              translate('favorites_empty_title'),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              translate('favorites_empty_desc'),
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            OutlinedButton.icon(
              onPressed: () => BaseScreen.changeTab(context, 1),
              icon: Icon(Icons.explore_outlined, color: primaryColor),
              label: Text(
                translate('browse_services'),
                style: TextStyle(color: primaryColor),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
