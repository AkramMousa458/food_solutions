import '../models/contact_model.dart';

abstract class ContactRepo {
  Stream<ContactResponseModel> getContacts();
}
