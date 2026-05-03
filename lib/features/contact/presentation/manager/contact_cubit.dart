import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/contact_model.dart';
import '../../data/repo/contact_repo.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final ContactResponseModel contactData;

  ContactLoaded(this.contactData);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);
}

class ContactCubit extends Cubit<ContactState> {
  final ContactRepo _contactRepo;

  ContactCubit(this._contactRepo) : super(ContactInitial());

  Future<void> fetchContacts() async {
    emit(ContactLoading());
    try {
      final contactData = await _contactRepo.getContacts();
      emit(ContactLoaded(contactData));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }
}
