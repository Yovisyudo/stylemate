import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/features/wardrobe/domain/repositories/wardrobe_repositorty.dart';

class DeleteWardrobeItemUseCase {
  final WardrobeRepository repository;

  DeleteWardrobeItemUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteItem(id);
  }
}
