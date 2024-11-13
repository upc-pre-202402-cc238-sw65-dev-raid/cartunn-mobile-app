import 'package:cartunn/features/settings/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(int profileId);
  Future<void> updateProfile(Profile profile);
}
