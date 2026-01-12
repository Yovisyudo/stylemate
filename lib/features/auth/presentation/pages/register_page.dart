import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/auth/widgets/register_form.dart';
import 'package:stylemate/features/auth/presentation/pages/app_constant.dart'; // Pastikan import ini
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(String stylePreference) {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
          RegisterEvent(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            // Jika butuh stylePreference, pastikan event di AuthBloc menerimanya
            // stylePreference: stylePreference, 
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        builder: (context, state) {
          return RegisterForm(
            formKey: _formKey,
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            authState: state,
            onRegister: _handleRegister,
            onBackToLogin: () => Navigator.pop(context),
          );
        },
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    // 1. LOGIC KHUSUS: Sukses Register tapi butuh Verifikasi (Tadi kita kirim lewat AuthError/Message)
    if (state is AuthError) {
      // Cek apakah pesannya mengandung kata kunci sukses/verifikasi
      if (state.message.toLowerCase().contains('cek email') || 
          state.message.toLowerCase().contains('registrasi berhasil')) {
        
        _showSuccessDialog(context, state.message);
      
      } else {
        // Error biasa (misal email sudah terdaftar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(state.message)),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } 
    // AuthAuthenticated tidak akan dipanggil di Register lagi karena kita Logout paksa di BLoC
  }

  // Widget Dialog Cantik untuk Info Verifikasi
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.mark_email_read, size: 60, color: AppConstants.primaryColor),
            SizedBox(height: 10),
            Text("Registrasi Berhasil!", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          message, 
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(ctx); // Tutup Dialog
                Navigator.pop(context); // Kembali ke Halaman Login
              },
              child: const Text("OK, Saya Cek Email", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}