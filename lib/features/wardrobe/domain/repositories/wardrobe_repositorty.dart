import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';

abstract class WardrobeRepository {
  Future<Either<Failure, List<WardrobeItem>>> getWardrobe();

  Future<Either<Failure, WardrobeItem>> addItem(WardrobeItem item);

  Future<Either<Failure, void>> updateWardrobe(
    int id,
    Map<String, dynamic> data,
  );

  Future<Either<Failure, void>> deleteItem(int itemId);
}
