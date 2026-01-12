import 'package:flutter/material.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_state.dart';
import 'package:stylemate/features/auth/presentation/pages/app_constant.dart';
import 'form_text_field.dart';
import 'form_password_field.dart';
import 'style_dropdown_field.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final AuthState authState;
  final Function(String stylePreference) onRegister;
  final VoidCallback onBackToLogin;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.authState,
    required this.onRegister,
    required this.onBackToLogin,
  });

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;

  double _maxWidth(BuildContext context) =>
      _isTablet(context) ? AppConstants.maxTabletWidth : double.infinity;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    String? selectedStyle;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 48.0 : 32.0,
            vertical: isTablet ? 40.0 : 0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _maxWidth(context)),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isTablet ? 40 : 20),
                  _buildBackButton(context, isTablet),
                  SizedBox(height: isTablet ? 40 : 30),
                  _buildTitle(isTablet),
                  const SizedBox(height: 8),
                  _buildSubtitle(isTablet),
                  SizedBox(height: isTablet ? 50 : 40),
                  
                  // Full Name Field
                  FormTextField(
                    label: 'Full Name',
                    hint: 'John Doe',
                    controller: nameController,
                    isTablet: isTablet,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: isTablet ? 24 : 20),
                  
                  // Email Field
                  FormTextField(
                    label: 'Email Address',
                    hint: 'hello@example.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    isTablet: isTablet,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: isTablet ? 24 : 20),
                  
                  // Password Field
                  FormPasswordField(
                    label: 'Password',
                    hint: '••••••••••••',
                    controller: passwordController,
                    isTablet: isTablet,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: isTablet ? 24 : 20),
                  
                  // Confirm Password Field
                  FormPasswordField(
                    label: 'Confirm Password',
                    hint: '••••••••••••',
                    controller: confirmPasswordController,
                    isTablet: isTablet,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: isTablet ? 24 : 20),
                  
                  // Style Preference Dropdown
                  StyleDropdownField(
                    isTablet: isTablet,
                    onChanged: (value) => selectedStyle = value,
                  ),
                  
                  SizedBox(height: isTablet ? 40 : 32),
                  
                  // Register Button
                  _buildRegisterButton(context, isTablet, selectedStyle),
                  
                  SizedBox(height: isTablet ? 32 : 24),
                  
                  // Login Link
                  _buildLoginLink(isTablet),
                  
                  SizedBox(height: isTablet ? 40 : 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isTablet) {
    return IconButton(
      onPressed: onBackToLogin,
      icon: Icon(Icons.arrow_back_ios, size: isTablet ? 24 : 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildTitle(bool isTablet) {
    return Text(
      'Create Account',
      style: TextStyle(
        fontSize: isTablet ? 38 : 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSubtitle(bool isTablet) {
    return Text(
      'Sign up to get started',
      style: TextStyle(
        fontSize: isTablet ? 18 : 16,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, bool isTablet, String? selectedStyle) {
    return SizedBox(
      width: double.infinity,
      height: isTablet ? 60 : 56,
      child: authState is AuthLoading
          ? _buildLoadingButton(isTablet)
          : _buildActiveRegisterButton(isTablet, selectedStyle),
    );
  }

  Widget _buildLoadingButton(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: SizedBox(
          width: isTablet ? 28 : 24,
          height: isTablet ? 28 : 24,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveRegisterButton(bool isTablet, String? selectedStyle) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          onRegister(selectedStyle ?? 'casual');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: Text(
        'Register',
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoginLink(bool isTablet) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: TextStyle(
              fontSize: isTablet ? 15 : 14,
              color: Colors.grey.shade600,
            ),
          ),
          TextButton(
            onPressed: onBackToLogin,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: isTablet ? 15 : 14,
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}