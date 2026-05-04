import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/contact_model.dart';
import '../../data/repo/contact_repo.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final ContactResponseModel contactData;
  final bool isFromCache;

  ContactLoaded({required this.contactData, required this.isFromCache});
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
    bool isFirstEmit = true;
    try {
      await for (final contactData in _contactRepo.getContacts()) {
        if (isFirstEmit) {
          isFirstEmit = false;
          emit(ContactLoaded(contactData: contactData, isFromCache: true));
        } else {
          emit(ContactLoaded(contactData: contactData, isFromCache: false));
        }
      }
    } catch (e) {
      if (state is! ContactLoaded) {
        emit(ContactError(e.toString()));
      }
    }
  }
}
