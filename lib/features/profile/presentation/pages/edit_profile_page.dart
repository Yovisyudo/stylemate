import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/profile_bloc.dart';
import '../../data/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  final String token;
  const EditProfilePage({super.key, required this.user, required this.token});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  File? _imageFile;
  String? _selectedStyle;
  bool _isSaving = false;

  final List<String> _styles = ['casual', 'formal', 'sport', 'elegan'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _selectedStyle = widget.user.stylePreference?.toLowerCase();
  }

  // Fungsi pembantu untuk memperbaiki URL localhost secara otomatis di UI
  String _fixUrl(String? url) {
    if (url == null) return "";
    return url.replaceAll("localhost", "10.175.170.203");
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded && _isSaving) {
          setState(() => _isSaving = false);
          Navigator.pop(context, true);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Profil diperbarui!")));
        } else if (state is ProfileError) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Edit Profil")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _imageFile != null
                            ? FileImage(_imageFile!)
                            : (widget.user.avatarUrl != null
                                    ? CachedNetworkImageProvider(
                                      _fixUrl(widget.user.avatarUrl),
                                    )
                                    : null)
                                as ImageProvider?,
                    child:
                        (_imageFile == null && widget.user.avatarUrl == null)
                            ? const Icon(Icons.camera_alt, size: 40)
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Gaya",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 8,
                children:
                    _styles
                        .map(
                          (style) => ChoiceChip(
                            label: Text(style),
                            selected: _selectedStyle == style,
                            onSelected:
                                (val) => setState(
                                  () => _selectedStyle = val ? style : null,
                                ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                  ),
                  onPressed:
                      _isSaving
                          ? null
                          : () {
                            setState(() => _isSaving = true);
                            context.read<ProfileBloc>().add(
                              UpdateProfileRequested(
                                token: widget.token,
                                name: _nameController.text,
                                image: _imageFile,
                                style: _selectedStyle,
                              ),
                            );
                          },
                  child:
                      _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Simpan",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
