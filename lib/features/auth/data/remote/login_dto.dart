class LoginDto {
  final int id;
  final String firstName;
  final String lastName;
  final String token;

  const LoginDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.token,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      token: json['token'] ?? '', // Captura el token desde el JSON
    );
  }
}
