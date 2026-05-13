import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_solutions/core/services/url_launcher_service.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/widgets/custom_button.dart';
import 'package:food_solutions/features/contact/presentation/manager/contact_cubit.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'contact_info_card.dart';
import 'social_media_row.dart';

class ContactScreenBody extends StatelessWidget {
  const ContactScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        if (state is ContactLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContactError) {
          log('contact error: ${state.message}');
          return Center(
            child: Text(
              translate('error_try_again'),
              style: AppStyles.textstyle15.copyWith(color: AppColors.error),
            ),
          );
        } else if (state is ContactLoaded) {
          final data = state.contactData;
          final contacts = data.contacts;
          final socials = data.socials;

          String whatsappNumber = '';
          for (var c in contacts) {
            if (c.title.toLowerCase().contains('whatsapp') ||
                c.title.toLowerCase().contains('واتساب') ||
                c.value.toLowerCase().contains('whatsapp') ||
                c.value.toLowerCase().contains('واتساب')) {
              whatsappNumber = c.value;
              break;
            }
          }
          if (whatsappNumber.isEmpty) {
            for (var s in socials) {
              if (s.value.toLowerCase().contains('whatsapp') ||
                  s.value.toLowerCase().contains('واتساب') ||
                  s.platfrom!.name.toLowerCase().contains('whatsapp') ||
                  s.platfrom!.name.toLowerCase().contains('واتساب')) {
                whatsappNumber = s.link.replaceAll("https://wa.me/", "");
                break;
              }
            }
          }

          int animIndex = 0;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (contacts.isNotEmpty)
                  ...contacts.map((info) {
                    final widget = ContactInfoCard(info: info)
                        .animate()
                        .fade(duration: 400.ms, delay: (animIndex * 100).ms)
                        .slideY(
                          begin: 0.1,
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        );
                    animIndex++;
                    return widget;
                  }),
                if (socials.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  SizedBox(
                        width: double.infinity,
                        child: SocialMediaRow(items: socials),
                      )
                      .animate()
                      .fade(duration: 400.ms, delay: (animIndex * 100).ms)
                      .slideY(
                        begin: 0.1,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      ),
                ],
                if (whatsappNumber.isNotEmpty) ...[
                  SizedBox(height: 50.h),
                  CustomButton(
                        text: translate('contact_whatsapp_btn'),
                        icon: const Icon(
                          FontAwesomeIcons.whatsapp,
                          color: AppColors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          final formattedNumber = whatsappNumber.replaceAll(
                            '+',
                            '',
                          );
                          UrlLauncherService.launchWhatsApp(formattedNumber);
                        },
                      )
                      .animate()
                      .fade(duration: 400.ms, delay: ((animIndex + 1) * 100).ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        curve: Curves.easeOut,
                      ),
                ],
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
