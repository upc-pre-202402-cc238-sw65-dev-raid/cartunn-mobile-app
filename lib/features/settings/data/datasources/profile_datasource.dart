import 'package:cartunn/features/settings/data/model/profile_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileDataSource {
  final String baseUrl;

  ProfileDataSource(this.baseUrl);

  Future<ProfileDTO> getProfile(int profileId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/profiles/$profileId'));

    if (response.statusCode == 200) {
      return ProfileDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> updateProfile(ProfileDTO profile) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/v1/profiles/${profile.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}
