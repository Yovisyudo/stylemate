import 'package:stylemate/core/error/failures.dart';
// Tambahkan ini agar ServerException dikenali
import 'package:stylemate/core/network/network_info.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';

// Import yang benar (sesuaikan dengan struktur folder Anda)

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
        // Cast atau Map Model ke Entity agar tipe data cocok
        return Right(models.cast<WardrobeItem>());
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  // wardrobe_repository_impl.dart
  @override
  Future<Either<Failure, WardrobeItem>> addItem(WardrobeItem item) async {
    // Samakan return type
    if (await networkInfo.isConnected) {
      try {
        final data = {
          'name': item.name,
          'category_id': 1,
          'color': item.color,
          'style': item.style,
          'image_path': item.imageUrl,
        };

        // Pastikan remoteDataSource.addWardrobe mengembalikan data yang bisa dikonversi ke WardrobeItem
        final result = await remoteDataSource.addWardrobe(data);
        return Right(
          item,
        ); // Atau Right(result) jika addWardrobe mengembalikan model
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
