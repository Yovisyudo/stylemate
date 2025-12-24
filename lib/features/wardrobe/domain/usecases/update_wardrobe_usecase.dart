import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/features/wardrobe/domain/repositories/wardrobe_repositorty.dart';

class UpdateWardrobeItemUseCase {
  final WardrobeRepository repository;

  UpdateWardrobeItemUseCase(this.repository);

  Future<Either<Failure, void>> call(int id, Map<String, dynamic> data) async {
    return await repository.updateWardrobe(id, data);
  }
}
