import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_state.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_event.dart';
import '../bloc/profile_bloc.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<ProfileBloc>().add(FetchProfile(authState.token));
    }
  }

  // FUNGSI BARU: Mengubah localhost menjadi IP Laptop agar bisa diakses HP Fisik
  String _fixUrl(String? url) {
    if (url == null || url.isEmpty) return "";
    // Ganti dengan IP yang Anda berikan tadi
    return url.replaceAll("localhost", "10.175.170.203");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              final user = state.user;
              return Column(
                children: [
                  _buildHeader(
                    user,
                  ), // Header sekarang menggunakan _fixUrl di dalamnya
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        _buildStyleCard(user.stylePreference),
                        const SizedBox(height: 24),
                        const Text(
                          "Pengaturan Akun",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _menuTile(
                          icon: Icons.person_outline,
                          title: "Edit Profile",
                          subtitle: "Ubah nama, foto, dan gaya Anda",
                          onTap: () async {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is AuthAuthenticated) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EditProfilePage(
                                        user: user,
                                        token: authState.token,
                                      ),
                                ),
                              );
                              if (result == true) {
                                _loadProfile();
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _menuTile(
                          icon: Icons.logout,
                          title: "Keluar",
                          subtitle: "Keluar dari akun Anda",
                          isRed: true,
                          onTap: () => _showLogoutConfirmation(context),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text("Error: ${state.message}"),
                    ElevatedButton(
                      onPressed: _loadProfile,
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    // Memperbaiki URL dan menambahkan timestamp untuk cache busting
    final String rawUrl = _fixUrl(user.avatarUrl);
    final String imageUrl =
        rawUrl.isNotEmpty
            ? "$rawUrl?t=${DateTime.now().millisecondsSinceEpoch}"
            : "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            key: ValueKey(imageUrl),
            imageUrl: imageUrl,
            useOldImageOnUrlChange: true,
            imageBuilder:
                (context, imageProvider) => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: imageProvider,
                ),
            placeholder:
                (context, url) => const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            errorWidget: (context, url, error) {
              debugPrint("Gagal memuat gambar: $error");
              return const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blue),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(user.email, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildStyleCard(String? style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gaya Terpilih",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 12),
              Text(
                style?.toUpperCase() ?? "BELUM MEMILIH GAYA",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isRed = false,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isRed ? Colors.red : Colors.blue),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isRed ? Colors.red : Colors.black,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Apakah Anda yakin ingin keluar?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                child: const Text(
                  "Ya, Keluar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
