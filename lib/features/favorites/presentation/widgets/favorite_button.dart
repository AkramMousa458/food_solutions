import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import '../manager/favorites_cubit.dart';
import '../manager/favorites_state.dart';

class FavoriteButton extends StatelessWidget {
  final int serviceId;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showBackground;

  const FavoriteButton({
    super.key,
    required this.serviceId,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesLoaded
            ? state.favoriteIds.contains(serviceId)
            : context.read<FavoritesCubit>().isFavorite(serviceId);

        final icon = Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: size.sp,
          color: isFavorite
              ? (activeColor ?? AppColors.error)
              : (inactiveColor ?? AppColors.grey),
        );

        if (showBackground) {
          return Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () => context.read<FavoritesCubit>().toggleFavorite(serviceId),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: icon,
              ),
            ),
          );
        }

        return IconButton(
          onPressed: () =>
              context.read<FavoritesCubit>().toggleFavorite(serviceId),
          icon: icon,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: size.sp,
        );
      },
    );
  }
}
