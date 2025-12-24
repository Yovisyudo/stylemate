import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/wardrobe_bloc.dart';
import '../bloc/wardrobe_event.dart';

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

  // Senarai kategori (sesuai dengan DB)
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

  // PERBAIKAN: Kirim Map, bukan WardrobeItem
  void _submitData() {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final int categoryId = int.parse(_selectedCategoryId!);

      // Kirim sebagai Map<String, dynamic>
      context.read<WardrobeBloc>().add(
        AddItemEvent(
          item: {
            'name': _nameController.text.trim(),
            'category_id': categoryId,
            'color': _colorController.text.trim(),
            'style': _styleController.text.trim(),
            'image_path': _imageFile!.path,
          },
        ),
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item added successfully!')));
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
                decoration: _inputDecoration('Pilih kategori'),
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

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _styleController.dispose();
    super.dispose();
  }
}
