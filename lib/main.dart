import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/Screen/Home.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/loc_food_data.dart';
import 'package:kiosk_project_test/bloc/bloc_nationalcetagoryfood.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider( 
      providers: [
        BlocProvider<FoodSetBloc>(
          create: (context) => FoodSetBloc(),
        ),
        BlocProvider<FoodCategoryBloc>(
          create: (context) => FoodCategoryBloc(),
        ),
        BlocProvider<FoodListBloc>(
          create: (context) => FoodListBloc()..add(LoadFoodLsit()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kiosk Project Test',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
