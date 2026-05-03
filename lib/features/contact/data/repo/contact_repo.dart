import '../models/contact_model.dart';

abstract class ContactRepo {
  Future<ContactResponseModel> getContacts();
}
