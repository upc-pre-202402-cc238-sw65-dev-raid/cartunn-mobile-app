import 'package:cartunn/features/settings/domain/entities/profile.dart';
import 'package:cartunn/features/settings/domain/repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<Profile> call(int profileId) async {
    return await repository.getProfile(profileId);
  }
}