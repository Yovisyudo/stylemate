import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';
import 'package:stylemate/features/wardrobe/domain/repositories/wardrobe_repositorty.dart';

class AddWardrobeItemUseCase {
  final WardrobeRepository repository;

  AddWardrobeItemUseCase(this.repository);

  Future<Either<Failure, WardrobeItem>> call(WardrobeItem item) async {
    return await repository.addItem(item);
  }
}