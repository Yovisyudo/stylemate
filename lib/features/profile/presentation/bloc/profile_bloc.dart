import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/profile/data/repositories/profile_repository_impl.dart';
import '../../data/models/user_model.dart';

// --- Events ---
abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {
  final String token;
  FetchProfile(this.token);
}

class UpdateProfileRequested extends ProfileEvent {
  final String token;
  final String? name;
  final File? image;
  final String? style;

  UpdateProfileRequested({
    required this.token,
    this.name,
    this.image,
    this.style,
  });
}

// --- States ---
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// --- Bloc ---
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    // Handler untuk mengambil data profil (saat pertama kali buka halaman)
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await repository.getUserProfile(event.token);
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    // Handler untuk update profil (saat klik simpan)
    on<UpdateProfileRequested>((event, emit) async {
      // Catatan: Kita TIDAK melakukan emit(ProfileLoading()) di sini
      // agar UI di EditProfilePage tidak berubah jadi spinner full layar.
      // Loading dikelola oleh local state (_isSaving) di halaman EditProfilePage.

      try {
        // PERBAIKAN: Langsung ambil data user dari hasil fungsi updateProfile
        final updatedUser = await repository.updateProfile(
          event.token,
          name: event.name,
          image: event.image,
          style: event.style,
        );

        // Langsung emit data terbaru tanpa perlu panggil getUserProfile lagi
        // Ini yang bikin aplikasi jadi jauh lebih cepat (instan)
        emit(ProfileLoaded(updatedUser));
      } catch (e) {
        // Jika gagal, kirim error ke UI
        emit(ProfileError("Gagal update: ${e.toString()}"));
      }
    });
  }
}
