import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/add_item_usecase.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/get_wardrobe_usecase.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/update_wardrobe_usecase.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/delete_wardrobe_usecase.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_event.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_state.dart';

class WardrobeBloc extends Bloc<WardrobeEvent, WardrobeState> {
  final GetWardrobeUseCase getWardrobeUseCase;
  final AddWardrobeItemUseCase addItemUseCase;
  final UpdateWardrobeItemUseCase updateItemUseCase;
  final DeleteWardrobeItemUseCase deleteItemUseCase;

  WardrobeBloc({
    required this.getWardrobeUseCase,
    required this.addItemUseCase,
    required this.updateItemUseCase,
    required this.deleteItemUseCase,
  }) : super(WardrobeInitial()) {
    on<LoadWardrobeEvent>(_onLoadWardrobe);
    on<AddItemEvent>(_onAddItem);
    on<UpdateWardrobeEvent>(_onUpdateItem);
    on<DeleteWardrobeEvent>(_onDeleteItem);
  }

  Future<void> _onLoadWardrobe(
    LoadWardrobeEvent event,
    Emitter<WardrobeState> emit,
  ) async {
    emit(WardrobeLoading());

    final result = await getWardrobeUseCase();

    result.fold(
      (failure) => emit(WardrobeError(message: failure.toString())),
      (items) => emit(WardrobeLoaded(items: items)),
    );
  }

  Future<void> _onAddItem(
    AddItemEvent event,
    Emitter<WardrobeState> emit,
  ) async {
    // Konversi Map ke WardrobeItem
    final item = WardrobeItem(
      id: 0, // ID akan di-generate oleh backend
      name: event.item['name'] as String,
      categoryId: event.item['category_id'] as int,
      color: event.item['color'] as String?,
      style: event.item['style'] as String?,
      imageUrl: event.item['image_path'] as String? ?? '',
    );

    final result = await addItemUseCase(item);

    result.fold(
      (failure) => emit(WardrobeError(message: failure.toString())),
      (_) => add(const LoadWardrobeEvent()),
    );
  }

  Future<void> _onUpdateItem(
    UpdateWardrobeEvent event,
    Emitter<WardrobeState> emit,
  ) async {
    final result = await updateItemUseCase(event.id, event.data);

    result.fold(
      (failure) => emit(WardrobeError(message: failure.toString())),
      (_) => add(const LoadWardrobeEvent()), // Reload wardrobe setelah update
    );
  }

  Future<void> _onDeleteItem(
    DeleteWardrobeEvent event,
    Emitter<WardrobeState> emit,
  ) async {
    final result = await deleteItemUseCase(event.id);

    result.fold(
      (failure) => emit(WardrobeError(message: failure.toString())),
      (_) => add(const LoadWardrobeEvent()), // Reload wardrobe setelah delete
    );
  }
}
