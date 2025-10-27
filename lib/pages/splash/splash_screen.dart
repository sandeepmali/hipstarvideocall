import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipstarvideocall/bloc/splash/splash_cubit.dart';
import 'package:hipstarvideocall/pages/login/login_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..startAnimation(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          }
        },
        child: const _SplashView(),
      ),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8A2BE2), // Purple
              Color(0xFF00BCD4), // Cyan
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: BlocBuilder<SplashCubit, SplashState>(
            builder: (context, state) {
              final bool isAnimating = state is SplashAnimating;
              return AnimatedScale(
                scale: isAnimating ? 1.0 : 0.8,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: isAnimating ? 1.0 : 0.0,
                  duration: const Duration(seconds: 2),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                    height: 160,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
