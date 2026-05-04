class StatisticsModel {
  final int id;
  final int yearsOfExperience;
  final int clientsCount;
  final int projectsCount;

  const StatisticsModel({
    required this.id,
    required this.yearsOfExperience,
    required this.clientsCount,
    required this.projectsCount,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      id: json['id'] as int,
      yearsOfExperience: json['years_of_experience'] as int,
      clientsCount: json['clients_count'] as int,
      projectsCount: json['projects_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'years_of_experience': yearsOfExperience,
      'clients_count': clientsCount,
      'projects_count': projectsCount,
    };
  }
}
