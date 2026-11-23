import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/worker_dashboard/presentation/cubit/worker_dashboard_cubit.dart';
import 'features/worker_dashboard/presentation/screens/worker_dashboard_screen.dart';

class KhedmaApp extends StatelessWidget {
  const KhedmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
home: BlocProvider(
  create: (context) {
  final cubit = WorkerDashboardCubit();
  cubit.getWorkerData('1');
  return cubit;
},
  child: const WorkerDashboardScreen(),
),    );
  }
}
