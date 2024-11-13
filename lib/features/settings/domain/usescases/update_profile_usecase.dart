import 'package:cartunn/features/settings/domain/entities/profile.dart';
import 'package:cartunn/features/settings/domain/repositories/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<void> call(Profile profile) async {
    await repository.updateProfile(profile);
  }
}