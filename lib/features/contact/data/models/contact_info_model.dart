import 'package:flutter/material.dart';

class ContactInfoModel {
  final String titleKey;
  final String valueKey;
  final String url;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBgColor;

  const ContactInfoModel({
    required this.titleKey,
    required this.valueKey,
    required this.url,
    required this.icon,
    this.iconColor,
    this.iconBgColor,
  });
}
