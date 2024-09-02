class HealthPractitioner {
  final String name;
  final String speciality;
  final String avatar;
  final bool isOnline;
  final bool isFeatured;
  final String registration;
  final String location;

  HealthPractitioner({
    required this.name,
    required this.speciality,
    required this.avatar,
    required this.registration,
    required this.location,
    required this.isOnline,
    this.isFeatured = false,
  });
}