import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

void main() {
  test('reads the signed-in user and current establishment', () {
    final inputJson = <String, dynamic>{
      'name': 'Abdullah Al Saeed',
      'role': 'owner',
      'phone': '+966 50 123 4567',
      'email': 'abdullah@foodsolutions.sa',
      'phone_verified_at': '2024-01-01T00:00:00Z',
      'email_verified_at': '',
      'establishments': [
        {
          'name': 'Nirvana Cafe',
          'city': 'Riyadh',
          'activity': 'Bakeries',
          'age_in_months': 24,
          'is_active': true,
        },
      ],
    };
    final actualProfile = ProfileSnapshot.fromJson(inputJson);
    expect(actualProfile.name, 'Abdullah Al Saeed');
    expect(actualProfile.initials, 'AS');
    expect(actualProfile.isPhoneVerified, isTrue);
    expect(actualProfile.isEmailVerified, isFalse);
    expect(actualProfile.establishments.single.headquarters, 'Riyadh');
    expect(actualProfile.establishments.single.activity, 'Bakeries');
    expect(actualProfile.establishments.single.ageInMonths, 24);
    expect(actualProfile.establishments.single.isActive, isTrue);
    final expectedProfile = ProfileSnapshot.fromJson(actualProfile.toJson());
    expect(actualProfile, expectedProfile);
  });

  test('ignores an establishment that has no name', () {
    final inputJson = <String, dynamic>{
      'name': 'Abdullah',
      'establishments': [
        {'name': '   '},
      ],
    };
    final actualProfile = ProfileSnapshot.fromJson(inputJson);
    expect(actualProfile.initials, 'A');
    expect(actualProfile.establishments, isEmpty);
  });
}
