import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/auth/presentation/pages/wardrobe_item.dart';

abstract class WardrobeRepository {
  Future<Either<Failure, List<WardrobeItem>>> getWardrobe();
  Future<Either<Failure, WardrobeItem>> addItem(WardrobeItem item);
  Future<Either<Failure, void>> deleteItem(int itemId);
}