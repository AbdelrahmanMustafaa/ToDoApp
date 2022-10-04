import 'package:firebasetest/view/home/cubit/home_cubit.dart';
import 'package:firebasetest/view/home/cubit/home_state.dart';
import 'package:firebasetest/view/home/cubit/observer/bloc_observer.dart';
import 'package:firebasetest/view/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
