import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/network/network_info.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';
import '../../data/models/wardrobe_model.dart';
import '../../data/datasources/wardrobe_remote_data_source.dart';
import 'wardrobe_repositorty.dart';

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
        final List<WardrobeItemModel> models =
            await remoteDataSource.getWardrobe();
        return Right(models.cast<WardrobeItem>());
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
        final data = {
          'name': item.name,
          'category_id': 1,
          'color': item.color,
          'style': item.style,
          'image_path': item.imageUrl,
        };

        await remoteDataSource.addWardrobe(data);
        return Right(item);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWardrobe(
    int id,
    Map<String, dynamic> data,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateWardrobe(id, data);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(int itemId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteWardrobe(itemId);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
