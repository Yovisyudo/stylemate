

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stylemate/features/auth/presentation/pages/login_page.dart';
import 'package:stylemate/features/event/presentation/bloc/event_bloc.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_bloc.dart';
import 'package:stylemate/injection_container.dart' as di;

class Event {
  final int id;
  final String name;
  final String description;
  final DateTime date;
  final String location;
  final int? weatherTemp;
  final String? weatherCondition;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    this.weatherTemp,
    this.weatherCondition,
  });
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
      ],
      child: MaterialApp(
        title: 'Outfit Recommendation',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: LoginPage(),
      ),
    );
  }
}
