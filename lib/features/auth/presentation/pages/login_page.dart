import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgotEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // State variables
  bool _obscurePassword = true;
  bool _keepSignedIn = false;
  int _currentPage = 0;

  // Constants
  static const _primaryColor = Color(0xFF4D61F4);
  static const _tabletBreakpoint = 600.0;
  static const _maxTabletWidth = 500.0;

  // TODO: Ganti URL ini dengan URL Lottie animation pilihan Anda
  static const String _lottieAnimationUrl =
      'https://lottie.host/179bf746-9a37-4b91-8c45-28eed2eebad2/wx9JLrGXfX.json';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _forgotEmailController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool get _isTablet => MediaQuery.of(context).size.width >= _tabletBreakpoint;
  double get _maxWidth => _isTablet ? _maxTabletWidth : double.infinity;

  void _showForgotPasswordModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => _buildForgotPasswordContent(),
    );
  }

  Widget _buildForgotPasswordContent() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModalHandle(),
          const SizedBox(height: 25),
          const Text(
            "Reset Password",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Masukkan email kamu untuk menerima link pemulihan.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          _buildForgotPasswordTextField(),
          const SizedBox(height: 25),
          _buildResetPasswordButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildModalHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildForgotPasswordTextField() {
    return TextField(
      controller: _forgotEmailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email Address",
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _handleForgotPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "Kirim Link Pemulihan",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void _handleForgotPassword() {
    final email = _forgotEmailController.text.trim();
    if (email.isEmpty) return;

    context.read<AuthBloc>().add(ForgotPasswordEvent(email: email));
    Navigator.pop(context);
    _showResetPasswordSnackbar();
  }

  void _showResetPasswordSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link reset password telah dikirim ke email Anda'),
      ),
    );
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

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StyleMateHome()),
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildBody(AuthState state) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _buildPageView(state)),
          if (_currentPage == 0) _buildPageIndicators(),
        ],
      ),
    );
  }

  Widget _buildPageView(AuthState state) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) => setState(() => _currentPage = index),
      children: [_buildWelcomePage(), _buildLoginPage(state)],
    );
  }

  Widget _buildPageIndicators() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, _buildIndicatorDot),
      ),
    );
  }

  Widget _buildIndicatorDot(int index) {
    final isActive = index == _currentPage;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? _primaryColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _isTablet ? 48.0 : 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildWelcomeIllustration(),
              SizedBox(height: _isTablet ? 50 : 40),
              _buildWelcomeTitle(),
              const SizedBox(height: 12),
              _buildWelcomeSubtitle(),
              const Spacer(),
              _buildWelcomeLoginButton(),
              const SizedBox(height: 16),
              _buildCreateAccountButton(),
              SizedBox(height: _isTablet ? 40 : 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeIllustration() {
    final size = _isTablet ? 320.0 : 280.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackgroundShape(top: 40, left: 40, size: 80),
          _buildBackgroundShape(bottom: 40, right: 40, size: 60),
          _buildCenterIcon(),
        ],
      ),
    );
  }

  Widget _buildBackgroundShape({
    double? top,
    double? left,
    double? bottom,
    double? right,
    required double size,
  }) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildCenterIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 120,
          backgroundColor: _primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWelcomeTitle() {
    return Text(
      'Welcome to the app',
      style: TextStyle(
        fontSize: _isTablet ? 32 : 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildWelcomeSubtitle() {
    return Text(
      'We\'re excited to help you book and manage\nyour service appointments with ease.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: _isTablet ? 17 : 15,
        color: Colors.grey.shade600,
        height: 1.5,
      ),
    );
  }

  Widget _buildWelcomeLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: _isTablet ? 60 : 56,
      child: ElevatedButton(
        onPressed: () => _navigateToPage(1),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: _isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return TextButton(
      onPressed:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          ),
      child: Text(
        'Create an account',
        style: TextStyle(
          fontSize: _isTablet ? 16 : 15,
          color: _primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoginPage(AuthState state) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: _isTablet ? 48.0 : 32.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _maxWidth),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: _isTablet ? 40 : 20),
                _buildBackButton(),
                SizedBox(height: _isTablet ? 30 : 20),

                // Lottie Animation
                _buildLottieAnimation(),

                SizedBox(height: _isTablet ? 30 : 20),
                _buildLoginTitle(),
                const SizedBox(height: 8),
                _buildLoginSubtitle(),
                SizedBox(height: _isTablet ? 40 : 30),
                _buildEmailField(),
                SizedBox(height: _isTablet ? 24 : 20),
                _buildPasswordField(),
                SizedBox(height: _isTablet ? 20 : 16),
                _buildKeepSignedInCheckbox(),
                SizedBox(height: _isTablet ? 40 : 32),
                _buildLoginButton(state),
                SizedBox(height: _isTablet ? 24 : 20),
                Center(child: _buildCreateAccountButton()),
                SizedBox(height: _isTablet ? 40 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Lottie Animation
  Widget _buildLottieAnimation() {
    final animationSize = _isTablet ? 280.0 : 220.0;

    return Center(
      child: SizedBox(
        width: animationSize,
        height: animationSize,
        child: Lottie.network(
          _lottieAnimationUrl,
          fit: BoxFit.contain,
          // Error handling jika gagal load
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.login,
                size: animationSize * 0.5,
                color: _primaryColor,
              ),
            );
          },
          // Loading indicator
          frameBuilder: (context, child, composition) {
            if (composition != null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                color: _primaryColor,
                strokeWidth: 2,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () => _navigateToPage(0),
      icon: Icon(Icons.arrow_back_ios, size: _isTablet ? 24 : 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildLoginTitle() {
    return Text(
      'Login',
      style: TextStyle(
        fontSize: _isTablet ? 38 : 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildLoginSubtitle() {
    return Text(
      'Welcome back to the app',
      style: TextStyle(
        fontSize: _isTablet ? 18 : 16,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Email Address'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: _isTablet ? 16 : 14),
          decoration: _buildInputDecoration('hello@example.com'),
          validator: (v) => v!.isEmpty ? 'Enter email' : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFieldLabel('Password'),
            _buildForgotPasswordButton(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: TextStyle(fontSize: _isTablet ? 16 : 14),
          decoration: _buildPasswordDecoration(),
          validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: _isTablet ? 15 : 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: _showForgotPasswordModal,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          fontSize: _isTablet ? 14 : 13,
          color: _primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      border: _buildBorder(Colors.grey.shade300),
      enabledBorder: _buildBorder(Colors.grey.shade300),
      focusedBorder: _buildBorder(_primaryColor, width: 2),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: _isTablet ? 18 : 16,
      ),
    );
  }

  InputDecoration _buildPasswordDecoration() {
    return _buildInputDecoration('••••••••••••').copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.grey.shade400,
          size: _isTablet ? 24 : 20,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildKeepSignedInCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: _isTablet ? 22 : 20,
          height: _isTablet ? 22 : 20,
          child: Checkbox(
            value: _keepSignedIn,
            onChanged:
                (value) => setState(() => _keepSignedIn = value ?? false),
            activeColor: _primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Keep me signed in',
          style: TextStyle(
            fontSize: _isTablet ? 15 : 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: _isTablet ? 60 : 56,
      child:
          state is AuthLoading
              ? _buildLoadingButton()
              : _buildActiveLoginButton(),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildActiveLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: _isTablet ? 18 : 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
