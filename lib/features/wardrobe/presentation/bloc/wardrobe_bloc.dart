import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/add_item_usecase.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/get_wardrobe_usecase.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_event.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_state.dart';

class WardrobeBloc extends Bloc<WardrobeEvent, WardrobeState> {
  final GetWardrobeUseCase getWardrobeUseCase;
  final AddWardrobeItemUseCase addItemUseCase;

  WardrobeBloc({required this.getWardrobeUseCase, required this.addItemUseCase})
    : super(WardrobeInitial()) {
    on<LoadWardrobeEvent>(_onLoadWardrobe);
    on<AddItemEvent>(_onAddItem);
  }

  Future<void> _onLoadWardrobe(
    LoadWardrobeEvent event,
    Emitter<WardrobeState> emit,
  ) async {
    emit(WardrobeLoading());

    final result = await getWardrobeUseCase();

    result.fold(
      (failure) => emit(WardrobeError(message: failure.message)),
      (items) => emit(WardrobeLoaded(items: items)),
    );
  }

  Future<void> _onAddItem(
    AddItemEvent event,
    Emitter<WardrobeState> emit,
  ) async {
    final result = await addItemUseCase(event.item);

    result.fold(
      (failure) => emit(WardrobeError(message: failure.message)),
      (_) => add(LoadWardrobeEvent()),
    );
  }
}
