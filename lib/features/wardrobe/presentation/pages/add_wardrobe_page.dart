import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/wardrobe_bloc.dart';
import '../bloc/wardrobe_event.dart';
import '../bloc/wardrobe_state.dart';
import '../../domain/entities/wardrobe_item.dart';

class AddWardrobePage extends StatefulWidget {
  const AddWardrobePage({super.key});

  @override
  State<AddWardrobePage> createState() => _AddWardrobePageState();
}

class _AddWardrobePageState extends State<AddWardrobePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _styleController = TextEditingController();

  File? _imageFile;
  String? _selectedCategoryId;

  // 2. Senarai kategori (Anda boleh buat ini dinamik nanti, buat masa ini kita guna hardcoded ikut DB anda)
  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Atasan'},
    {'id': '2', 'name': 'Bawahan'},
    {'id': '3', 'name': 'Sepatu'},
    {'id': '4', 'name': 'Aksesori'},
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Di dalam AddWardrobePage
  void _submitData() {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      // Tukar String ID kepada int untuk dihantar ke MySQL
      final int catId = int.parse(_selectedCategoryId!);

      final newItem = WardrobeItem(
        id: 0, // ID 0 kerana MySQL akan buat Auto Increment (item_id)
        name: _nameController.text.trim(),
        categoryId: catId, // Menggunakan categoryId (int) yang betul
        color: _colorController.text.trim(),
        style: _styleController.text.trim(),
        imageUrl: _imageFile!.path, // Path gambar dari galeri/kamera
      );

      // Hantar event ke Bloc
      context.read<WardrobeBloc>().add(AddItemEvent(newItem));
      Navigator.pop(context);
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila pilih gambar pakaian')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add New Style',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker Area
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child:
                      _imageFile != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tap to upload cloth image',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 30),

              // Input Fields
              _buildLabel('Clothing Name'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('e.g. Vintage Blue Shirt'),
                validator: (v) => v!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),

              _buildLabel('Category'),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Kategori Pakaian',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
                items:
                    _categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat['id'],
                        child: Text(cat['name']),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Sila pilih kategori' : null,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Color'),
                        TextFormField(
                          controller: _colorController,
                          decoration: _inputDecoration('e.g. Navy'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Style'),
                        TextFormField(
                          controller: _styleController,
                          decoration: _inputDecoration('e.g. Casual'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Save to Wardrobe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
