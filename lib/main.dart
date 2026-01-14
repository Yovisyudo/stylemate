import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_state.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_bloc.dart';
import 'package:stylemate/features/auth/presentation/pages/home_page.dart';
import 'package:stylemate/injection_container.dart';

// Import Home & Profile
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/wardrobe/presentation/bloc/wardrobe_bloc.dart';
import 'features/event/presentation/bloc/event_bloc.dart';

// TAMBAHKAN IMPORT PROFILE DI SINI
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/pages/profile_page.dart';

import 'firebase_options.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// main.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Gunakan lazy: false khusus AuthBloc agar state autentikasi langsung siap
        BlocProvider(create: (_) => di.sl<AuthBloc>(), lazy: false),
        BlocProvider(create: (_) => di.sl<WardrobeBloc>()),
        BlocProvider(create: (_) => di.sl<EventBloc>()),
        BlocProvider(create: (_) => di.sl<RecommendationBloc>()),
        BlocProvider(create: (_) => di.sl<ProfileBloc>()),
      ],
      child: MaterialApp(
        title: 'StyleMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF91B1E7),
          useMaterial3: true,
        ),
        // Gunakan BlocBuilder untuk menentukan halaman awal secara otomatis
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const StyleMateHome();
            }
            return const LoginPage();
          },
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const StyleMateHome(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
