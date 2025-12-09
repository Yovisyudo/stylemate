import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/network/network_info.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/auth/data/models/wadrobe_item_model.dart';
import 'package:stylemate/features/auth/presentation/pages/wardrobe_item.dart';
import 'package:stylemate/features/wardrobe/data/datasources/wardrobe_remote_data_source.dart';
import 'package:stylemate/features/wardrobe/domain/repositories/wardrobe_repositorty.dart';

class WardrobeRepositoryImpl implements WardrobeRepository {
  final WardrobeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WardrobeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<WardrobeItem>>> getWardrobe() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getWardrobe();
        return Right(items);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, WardrobeItem>> addItem(WardrobeItem item) async {
    if (await networkInfo.isConnected) {
      try {
        final itemModel = WardrobeItemModel(
          id: item.id,
          name: item.name,
          categoryName: item.categoryName,
          color: item.color,
          style: item.style,
          imageUrl: item.imageUrl,
        );
        final result = await remoteDataSource.addItem(itemModel);
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(int itemId) async {
    throw UnimplementedError();
  }
}
