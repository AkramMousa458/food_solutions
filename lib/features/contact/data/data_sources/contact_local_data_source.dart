import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import '../models/contact_model.dart';

abstract class ContactLocalDataSource {
  ContactResponseModel? getCachedContact();
  Future<void> cacheContact(ContactResponseModel contact);
}

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  final LocalStorage _localStorage;

  ContactLocalDataSourceImpl(this._localStorage);

  @override
  ContactResponseModel? getCachedContact() {
    final jsonString = _localStorage.getString(AppConstants.contactKey);
    if (jsonString == null) return null;
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return ContactResponseModel.fromJson(decoded);
  }

  @override
  Future<void> cacheContact(ContactResponseModel contact) async {
    final jsonString = jsonEncode(contact.toJson());
    await _localStorage.setString(AppConstants.contactKey, jsonString);
  }
}
