class LoginDto {
  final int id;
  final String firstName;
  final String lastName;

  const LoginDto({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
        id: json['id'] ?? 0,
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '');
  }
}
