import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_bloc.dart';
import 'package:stylemate/features/auth/presentation/pages/home_page.dart';
import 'package:stylemate/injection_container.dart';
// Import Home Anda
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/wardrobe/presentation/bloc/wardrobe_bloc.dart';
import 'features/event/presentation/bloc/event_bloc.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<WardrobeBloc>()),
        BlocProvider(create: (_) => di.sl<EventBloc>()),
        BlocProvider(create: (_) => sl<RecommendationBloc>()),
      ],
      child: MaterialApp(
        title: 'StyleMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        // Halaman awal
        home: const LoginPage(),
        // DAFTARKAN RUTE DI SINI AGAR TIDAK ERROR
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const StyleMateHome(),
        },
      ),
    );
  }
}
