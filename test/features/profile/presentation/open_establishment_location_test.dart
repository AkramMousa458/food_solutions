import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/open_establishment_location.dart';

void main() {
  test('returns the location link when the establishment has one', () {
    const inputEstablishment = ProfileEstablishmentSnapshot(
      name: 'مقهى ومطعم الأفق',
      isActive: true,
      location: 'https://maps.google.com/?q=24.7136,46.6753',
    );
    final actualLink = establishmentLocationLink(inputEstablishment);
    final actualAction = openEstablishmentLocationAction(inputEstablishment);
    expect(actualLink, 'https://maps.google.com/?q=24.7136,46.6753');
    expect(actualAction, isNotNull);
  });

  test('returns null when the location link is missing', () {
    const inputEstablishment = ProfileEstablishmentSnapshot(
      name: 'test',
      isActive: true,
    );
    final actualLink = establishmentLocationLink(inputEstablishment);
    final actualAction = openEstablishmentLocationAction(inputEstablishment);
    expect(actualLink, isNull);
    expect(actualAction, isNull);
  });

  test('returns null when the location link is blank', () {
    const inputEstablishment = ProfileEstablishmentSnapshot(
      name: 'test',
      isActive: true,
      location: '   ',
    );
    final actualLink = establishmentLocationLink(inputEstablishment);
    expect(actualLink, isNull);
  });
}
