import 'package:flutter/foundation.dart';
import 'package:food_solutions/core/services/url_launcher_service.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

String? establishmentLocationLink(ProfileEstablishmentSnapshot? establishment) {
  final location = establishment?.location?.trim() ?? '';
  if (location.isEmpty) return null;
  return location;
}

VoidCallback? openEstablishmentLocationAction(
  ProfileEstablishmentSnapshot? establishment,
) {
  final link = establishmentLocationLink(establishment);
  if (link == null) return null;
  return () => UrlLauncherService.launchExternalUrl(link);
}
