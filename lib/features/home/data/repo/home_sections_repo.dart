import '../models/home_section_model.dart';

abstract class HomeSectionsRepo {
  Stream<List<HomeSectionModel>> getHomeSections();
}
