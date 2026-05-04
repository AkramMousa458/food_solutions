import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/service_item_model.dart';
import '../../data/repo/services_repo.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

/// Emitted when services are loaded from local cache or API for the first time.
class ServicesLoaded extends ServicesState {
  final List<ServiceItemModel> services;
  final bool isFromCache;

  ServicesLoaded({required this.services, required this.isFromCache});
}

/// Emitted while a background API refresh is in progress after cache was served.
class ServicesUpdating extends ServicesState {
  final List<ServiceItemModel> cachedServices;

  ServicesUpdating(this.cachedServices);
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
    bool isFirstEmit = true;
    try {
      await for (final services in _servicesRepo.getServices()) {
        if (isFirstEmit) {
          isFirstEmit = false;
          // First yield: may be cache or direct API result
          emit(ServicesLoaded(services: services, isFromCache: true));
        } else {
          // Subsequent yield: fresh data from API
          emit(ServicesLoaded(services: services, isFromCache: false));
        }
      }
    } catch (e) {
      // Only emit an error if we haven't loaded any cached data.
      if (state is! ServicesLoaded) {
        emit(ServicesError(e.toString()));
      }
    }
  }
}
