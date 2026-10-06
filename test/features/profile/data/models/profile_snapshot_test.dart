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

  test('reads an account establishment', () {
    final inputJson = <String, dynamic>{
      'name': 'Akram Mousa',
      'role': 'admin',
      'phone': '01097066403',
      'email': 'akrammousa458@gmail.com',
      'email_verified_at': '2026-10-04T23:22:44.000000Z',
      'establishments': [
        {
          'id': 1,
          'name': 'مقهى ومطعم الأفق',
          'age': 'سنتين',
          'image': 'https://example.com/logo.png',
          'address': 'الرياض - طريق الملك فهد',
          'user_position': 'owner',
          'is_active': true,
        },
      ],
    };
    final actualProfile = ProfileSnapshot.fromJson(inputJson);
    final establishment = actualProfile.establishments.single;
    expect(actualProfile.initials, 'AM');
    expect(actualProfile.isEmailVerified, isTrue);
    expect(establishment.id, 1);
    expect(establishment.headquarters, 'الرياض - طريق الملك فهد');
    expect(establishment.ageLabel, 'سنتين');
    expect(establishment.imageUrl, 'https://example.com/logo.png');
    expect(establishment.userPosition, 'owner');
    expect(ProfileSnapshot.fromJson(actualProfile.toJson()), actualProfile);
  });

  test('treats establishment status as listed or closed', () {
    final listed = ProfileEstablishmentSnapshot.fromJson(<String, dynamic>{
      'name': 'Bucharest Cafe',
      'status': 'existing',
    });
    final closed = ProfileEstablishmentSnapshot.fromJson(<String, dynamic>{
      'name': 'Old Branch',
      'status': 'closed',
    });
    final planned = ProfileEstablishmentSnapshot.fromJson(<String, dynamic>{
      'name': 'New Branch',
      'status': 'under_construction',
    });
    expect(listed.isActive, isTrue);
    expect(listed.status, 'existing');
    expect(closed.isActive, isFalse);
    expect(planned.isActive, isFalse);
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
