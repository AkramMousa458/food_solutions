import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/service_item_model.dart';
import '../../data/repo/services_repo.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceItemModel> services;

  ServicesLoaded(this.services);
}

class ServicesError extends ServicesState {
  final String message;

  ServicesError(this.message);
}

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepo _servicesRepo;

  ServicesCubit(this._servicesRepo) : super(ServicesInitial());

  Future<void> fetchServices() async {
    emit(ServicesLoading());
    try {
      final services = await _servicesRepo.getServices();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}
