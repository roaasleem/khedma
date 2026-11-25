import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';

import 'features/home/presentation/screens/home_screen.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';
import 'features/favorites/presentation/screens/favorites_screen.dart';

import 'features/worker_dashboard/presentation/screens/worker_dashboard_screen.dart';
import 'features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';

class KhedmaApp extends StatelessWidget {
  const KhedmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => FavoritesCubit()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.read<FavoritesCubit>().setUserId(state.user.id);
          } else if (state is AuthInitial) {
            context.read<FavoritesCubit>().setUserId(null);
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.favorites: (context) => const FavoritesScreen(),
            AppRoutes.workerDashboard: (context) => WorkerDashboardScreen(),
            AppRoutes.adminDashboard: (context) => AdminDashboardScreen(),
          },
        ),
      ),
    );
  }
}
