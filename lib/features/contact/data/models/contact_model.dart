import 'package:flutter/material.dart';

class ContactResponseModel {
  final int totalContacts;
  final List<ContactItemModel> contacts;
  final int totalSocials;
  final List<SocialItemModel> socials;

  ContactResponseModel({
    required this.totalContacts,
    required this.contacts,
    required this.totalSocials,
    required this.socials,
  });

  factory ContactResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactResponseModel(
      totalContacts: json['total_contacts'] as int? ?? 0,
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((e) => ContactItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalSocials: json['total_socials'] as int? ?? 0,
      socials:
          (json['socials'] as List<dynamic>?)
              ?.map((e) => SocialItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_contacts': totalContacts,
      'contacts': contacts.map((e) => e.toJson()).toList(),
      'total_socials': totalSocials,
      'socials': socials.map((e) => e.toJson()).toList(),
    };
  }
}

class ContactItemModel {
  final String title;
  final String? iconImage;
  final String value;
  final String link;

  ContactItemModel({
    required this.title,
    required this.iconImage,
    required this.value,
    required this.link,
  });

  factory ContactItemModel.fromJson(Map<String, dynamic> json) {
    return ContactItemModel(
      title: json['title'] as String? ?? '',
      iconImage: json['icon'] as String?,
      value: json['value'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'icon': iconImage, 'value': value, 'link': link};
  }

  // IconData get iconData {
  //   final t = title.toLowerCase();
  //   if (t.contains('whatsapp')) return FontAwesomeIcons.whatsapp;
  //   if (t.contains('email') || t.contains('mail')) return Icons.email_outlined;
  //   if (t.contains('address') || t.contains('location')) {
  //     return Icons.location_on_outlined;
  //   }
  //   if (t.contains('youtube')) return FontAwesomeIcons.youtube;
  //   if (t.contains('twitter') || t.contains('x')) {
  //     return FontAwesomeIcons.xTwitter;
  //   }
  //   if (t.contains('instagram')) return FontAwesomeIcons.instagram;
  //   if (t.contains('facebook')) return FontAwesomeIcons.facebookF;
  //   if (t.contains('phone')) return Icons.phone_outlined;
  //   return Icons.link;
  // }

  Color get color {
    final t = title.toLowerCase();
    if (t.contains('whatsapp')) return const Color(0xFF25D366);
    if (t.contains('youtube')) return const Color(0xFFFF0000);
    if (t.contains('twitter') || t.contains('x')) {
      return const Color(0xFF1DA1F2);
    }
    if (t.contains('instagram')) return const Color(0xFFE1306C);
    if (t.contains('facebook')) return const Color(0xFF1877F2);
    return Colors.grey;
  }
}

class SocialItemModel {
  final PlatformModel? platfrom;
  final String iconImage;
  final String value;
  final String link;

  SocialItemModel({
    required this.platfrom,
    required this.iconImage,
    required this.value,
    required this.link,
  });

  factory SocialItemModel.fromJson(Map<String, dynamic> json) {
    return SocialItemModel(
      platfrom: json['platform'] != null
          ? PlatformModel.fromJson(json['platform'])
          : null,
      iconImage: json['icon'] as String? ?? '',
      value: json['value'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platfrom?.toJson(),
      'icon': iconImage,
      'value': value,
      'link': link,
    };
  }
}

class PlatformModel {
  final int id;
  final String name;
  final Color color;

  PlatformModel({required this.id, required this.name, required this.color});

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      color: json['color'] != null
          ? Color(
              int.parse(
                    (json['color'] as String).toLowerCase().replaceAll('#', ''),
                    radix: 16,
                  ) +
                  0xFF000000,
            )
          : Colors.white,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color':
          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
    };
  }
}
