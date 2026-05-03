import '../models/home_section_model.dart';

abstract class HomeSectionsRepo {
  Future<List<HomeSectionModel>> getHomeSections();
}
