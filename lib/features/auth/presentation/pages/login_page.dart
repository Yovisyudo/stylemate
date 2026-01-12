import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/auth/presentation/pages/login_form.dart';
import 'package:stylemate/features/auth/presentation/pages/page_indicators.dart';
import 'package:stylemate/features/auth/presentation/pages/welcome_page_content.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'register_page.dart';
import 'home_page.dart'; // Pastikan path ini benar

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  int _currentPage = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      LoginEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _handleForgotPassword(String email) {
    // context.read<AuthBloc>().add(ForgotPasswordEvent(email: email)); // Un-comment jika event sudah ada
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link reset password telah dikirim ke email Anda'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

  // --- REVISI LISTENER LOGIN ---
  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      // 1. Login Sukses & Verified -> Masuk Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const StyleMateHome()),
        (route) =>
            false, // Hapus semua stack ke belakang agar user ga bisa 'back' ke login
      );
    } else if (state is AuthError) {
      // 2. Cek apakah errornya karena belum verifikasi?
      bool isVerifyError = state.message.toLowerCase().contains('diverifikasi');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isVerifyError ? Icons.mark_email_unread : Icons.error_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          // Warna Orange jika cuma masalah verifikasi, Merah jika error lain
          backgroundColor: isVerifyError ? Colors.orange[800] : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildBody(AuthState state) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _buildPageView(state)),
          if (_currentPage == 0)
            PageIndicators(
              currentPage: _currentPage,
              pageCount: 3, // Sesuaikan jumlah page intro kamu
            ),
        ],
      ),
    );
  }

  Widget _buildPageView(AuthState state) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) => setState(() => _currentPage = index),
      children: [
        // Intro Page 1, 2, 3 (opsional, sesuaikan kode kamu)
        WelcomePageContent(
          onLogin: () => _navigateToPage(1),
          onCreateAccount:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              ),
        ),
        // Halaman Login ada di index berikutnya
        LoginForm(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          authState: state,
          onLogin: _handleLogin,
          onBack: () => _navigateToPage(0),
          onForgotPassword: _handleForgotPassword,
          onCreateAccount:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              ),
        ),
      ],
    );
  }
}
