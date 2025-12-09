import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/auth/presentation/pages/wardrobe_item.dart';
import 'package:stylemate/features/wardrobe/domain/repositories/wardrobe_repositorty.dart';

class GetWardrobeUseCase {
  final WardrobeRepository repository;

  GetWardrobeUseCase(this.repository);

  Future<Either<Failure, List<WardrobeItem>>> call() async {
    return await repository.getWardrobe();
  }
}