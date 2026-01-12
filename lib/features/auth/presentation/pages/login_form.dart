import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_state.dart';
import 'package:stylemate/features/auth/presentation/pages/app_constant.dart';
import 'forgot_password_modal.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AuthState authState;
  final VoidCallback onLogin;
  final VoidCallback onBack;
  final Function(String email) onForgotPassword;
  final VoidCallback onCreateAccount;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.authState,
    required this.onLogin,
    required this.onBack,
    required this.onForgotPassword,
    required this.onCreateAccount,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _keepSignedIn = false;

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;

  double _maxWidth(BuildContext context) =>
      _isTablet(context) ? AppConstants.maxTabletWidth : double.infinity;

  void _showForgotPasswordModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => ForgotPasswordModal(
        onSubmit: (email) {
          widget.onForgotPassword(email);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 48.0 : 32.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _maxWidth(context)),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isTablet ? 40 : 20),
                _buildBackButton(isTablet),
                SizedBox(height: isTablet ? 30 : 20),
                _buildLottieAnimation(isTablet),
                SizedBox(height: isTablet ? 30 : 20),
                _buildLoginTitle(isTablet),
                const SizedBox(height: 8),
                _buildLoginSubtitle(isTablet),
                SizedBox(height: isTablet ? 40 : 30),
                _buildEmailField(isTablet),
                SizedBox(height: isTablet ? 24 : 20),
                _buildPasswordField(isTablet),
                SizedBox(height: isTablet ? 20 : 16),
                _buildKeepSignedInCheckbox(isTablet),
                SizedBox(height: isTablet ? 40 : 32),
                _buildLoginButton(isTablet),
                SizedBox(height: isTablet ? 24 : 20),
                Center(child: _buildCreateAccountButton(isTablet)),
                SizedBox(height: isTablet ? 40 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation(bool isTablet) {
    final animationSize = isTablet ? 280.0 : 220.0;

    return Center(
      child: SizedBox(
        width: animationSize,
        height: animationSize,
        child: Lottie.network(
          AppConstants.lottieAnimationUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.login,
                size: animationSize * 0.5,
                color: AppConstants.primaryColor,
              ),
            );
          },
          frameBuilder: (context, child, composition) {
            if (composition != null) return child;
            return Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryColor,
                strokeWidth: 2,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(bool isTablet) {
    return IconButton(
      onPressed: widget.onBack,
      icon: Icon(Icons.arrow_back_ios, size: isTablet ? 24 : 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildLoginTitle(bool isTablet) {
    return Text(
      'Login',
      style: TextStyle(
        fontSize: isTablet ? 38 : 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildLoginSubtitle(bool isTablet) {
    return Text(
      'Welcome back to the app',
      style: TextStyle(
        fontSize: isTablet ? 18 : 16,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildEmailField(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Email Address', isTablet),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: isTablet ? 16 : 14),
          decoration: _buildInputDecoration('hello@example.com', isTablet),
          validator: (v) => v!.isEmpty ? 'Enter email' : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFieldLabel('Password', isTablet),
            _buildForgotPasswordButton(isTablet),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          style: TextStyle(fontSize: isTablet ? 16 : 14),
          decoration: _buildPasswordDecoration(isTablet),
          validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text, bool isTablet) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isTablet ? 15 : 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildForgotPasswordButton(bool isTablet) {
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
          fontSize: isTablet ? 14 : 13,
          color: AppConstants.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, bool isTablet) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      border: _buildBorder(Colors.grey.shade300),
      enabledBorder: _buildBorder(Colors.grey.shade300),
      focusedBorder: _buildBorder(AppConstants.primaryColor, width: 2),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isTablet ? 18 : 16,
      ),
    );
  }

  InputDecoration _buildPasswordDecoration(bool isTablet) {
    return _buildInputDecoration('••••••••••••', isTablet).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.grey.shade400,
          size: isTablet ? 24 : 20,
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

  Widget _buildKeepSignedInCheckbox(bool isTablet) {
    return Row(
      children: [
        SizedBox(
          width: isTablet ? 22 : 20,
          height: isTablet ? 22 : 20,
          child: Checkbox(
            value: _keepSignedIn,
            onChanged: (value) => setState(() => _keepSignedIn = value ?? false),
            activeColor: AppConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Keep me signed in',
          style: TextStyle(
            fontSize: isTablet ? 15 : 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isTablet) {
    return SizedBox(
      width: double.infinity,
      height: isTablet ? 60 : 56,
      child: widget.authState is AuthLoading
          ? _buildLoadingButton()
          : _buildActiveLoginButton(isTablet),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildActiveLoginButton(bool isTablet) {
    return ElevatedButton(
      onPressed: widget.onLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(bool isTablet) {
    return TextButton(
      onPressed: widget.onCreateAccount,
      child: Text(
        'Create an account',
        style: TextStyle(
          fontSize: isTablet ? 16 : 15,
          color: AppConstants.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}