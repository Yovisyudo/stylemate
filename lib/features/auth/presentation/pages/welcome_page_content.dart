import 'package:flutter/material.dart';
import 'package:stylemate/features/auth/presentation/pages/app_constant.dart';


class WelcomePageContent extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onCreateAccount;

  const WelcomePageContent({
    super.key,
    required this.onLogin,
    required this.onCreateAccount,
  });

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;

  double _maxWidth(BuildContext context) =>
      _isTablet(context) ? AppConstants.maxTabletWidth : double.infinity;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _maxWidth(context)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 48.0 : 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildWelcomeIllustration(context, isTablet),
              SizedBox(height: isTablet ? 50 : 40),
              _buildWelcomeTitle(isTablet),
              const SizedBox(height: 12),
              _buildWelcomeSubtitle(isTablet),
              const Spacer(),
              _buildWelcomeLoginButton(isTablet),
              const SizedBox(height: 16),
              _buildCreateAccountButton(isTablet),
              SizedBox(height: isTablet ? 40 : 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeIllustration(BuildContext context, bool isTablet) {
    final size = isTablet ? 320.0 : 280.0;
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
          backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWelcomeTitle(bool isTablet) {
    return Text(
      'Welcome to the app',
      style: TextStyle(
        fontSize: isTablet ? 32 : 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildWelcomeSubtitle(bool isTablet) {
    return Text(
      'We\'re excited to help you book and manage\nyour service appointments with ease.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: isTablet ? 17 : 15,
        color: Colors.grey.shade600,
        height: 1.5,
      ),
    );
  }

  Widget _buildWelcomeLoginButton(bool isTablet) {
    return SizedBox(
      width: double.infinity,
      height: isTablet ? 60 : 56,
      child: ElevatedButton(
        onPressed: onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
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
      ),
    );
  }

  Widget _buildCreateAccountButton(bool isTablet) {
    return TextButton(
      onPressed: onCreateAccount,
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
