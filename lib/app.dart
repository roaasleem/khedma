import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';

import 'features/home/presentation/screens/home_screen.dart';
import 'features/worker_dashboard/presentation/screens/worker_dashboard_screen.dart';
import 'features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';

class KhedmaApp extends StatelessWidget {
  const KhedmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.home: (context) => HomeScreen(),
          AppRoutes.workerDashboard: (context) => WorkerDashboardScreen(),
          AppRoutes.adminDashboard: (context) => AdminDashboardScreen(),
        },
      ),
    );
  }
}
