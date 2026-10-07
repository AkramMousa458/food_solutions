class CreateEstablishmentRequest {
  static const String existingStatus = 'existing';
  static const String underConstructionStatus = 'under_construction';
  static const String ideaStatus = 'idea';
  static const String ownerPosition = 'owner';
  static const String managerPosition = 'manager';
  static const String authorizedPosition = 'authorized';
  static const List<String> statuses = [
    existingStatus,
    underConstructionStatus,
    ideaStatus,
  ];
  static const List<String> positions = [
    ownerPosition,
    managerPosition,
    authorizedPosition,
  ];
  static const String ageLessThanSixMonths = 'less_than_6_months';
  static const String ageOneYear = 'one_year';
  static const String ageTwoToThreeYears = 'two_to_three_years';
  static const String ageFourToFiveYears = 'four_to_five_years';
  static const String ageMoreThanFiveYears = 'more_than_five_years';
  static const List<String> ages = [
    ageLessThanSixMonths,
    ageOneYear,
    ageTwoToThreeYears,
    ageFourToFiveYears,
    ageMoreThanFiveYears,
  ];
  static const Map<String, String> ageLabelKeys = {
    ageLessThanSixMonths: 'establishment_age_new',
    ageOneYear: 'establishment_age_one_year',
    ageTwoToThreeYears: 'establishment_age_two_to_three',
    ageFourToFiveYears: 'establishment_age_four_to_five',
    ageMoreThanFiveYears: 'establishment_age_more_than_five',
  };

  final String name;
  final String phone;
  final String age;
  final String image;
  final String location;
  final String address;
  final String status;
  final String userPosition;

  const CreateEstablishmentRequest({
    required this.name,
    required this.phone,
    required this.age,
    required this.image,
    required this.location,
    required this.address,
    required this.status,
    required this.userPosition,
  });

  factory CreateEstablishmentRequest.fromJson(Map<String, dynamic> json) {
    return CreateEstablishmentRequest(
      name: _readText(json['name']),
      phone: _readText(json['phone']),
      age: _readText(json['age']),
      image: _readText(json['image']),
      location: _readText(json['location']),
      address: _readText(json['address']),
      status: _readText(json['status']),
      userPosition: _readText(json['user_position']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'age': age,
      'image': image,
      'location': location,
      'address': address,
      'status': status,
      'user_position': userPosition,
    };
  }
}

String _readText(Object? value) {
  if (value is! String) return '';
  return value.trim();
}
