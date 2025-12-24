import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';

abstract class WardrobeRepository {
  Future<Either<Failure, List<WardrobeItem>>> getWardrobe();
  // Ubah dari void menjadi WardrobeItem agar sinkron dengan UseCase
  Future<Either<Failure, WardrobeItem>> addItem(WardrobeItem item);
  Future<Either<Failure, void>> deleteItem(int itemId);
}
