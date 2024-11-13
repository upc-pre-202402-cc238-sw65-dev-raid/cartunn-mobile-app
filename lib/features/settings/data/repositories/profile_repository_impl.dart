import 'dart:convert';
import 'package:cartunn/features/settings/data/model/profile_dto.dart';
import 'package:cartunn/features/settings/domain/entities/profile.dart';
import 'package:cartunn/features/settings/domain/repositories/profile_repository.dart';
import 'package:http/http.dart' as http;

class ProfileRepositoryImpl implements ProfileRepository {
  final String baseUrl;

  ProfileRepositoryImpl({required this.baseUrl});

  @override
  Future<Profile> getProfile(int profileId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/profiles/$profileId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProfileDTO.fromJson(json).toDomain();
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final dto = ProfileDTO(
      id: profile.id,
      name: profile.name,
      lastName: profile.lastName,
      email: profile.email,
    );

    final response = await http.put(
      Uri.parse('$baseUrl/api/v1/profiles/${profile.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}
