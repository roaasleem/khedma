
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khedma/core/theme/app_colors.dart';
import 'package:khedma/core/enums/worker_status.dart';

import 'package:khedma/features/worker_dashboard/presentation/screens/edit_worker_profile_screen.dart';
import 'package:khedma/features/worker_dashboard/presentation/cubit/worker_dashboard_cubit.dart';
import 'package:khedma/features/worker_dashboard/presentation/cubit/worker_dashboard_state.dart';

class WorkerDashboardScreen extends StatelessWidget {
  const WorkerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerDashboardCubit, WorkerDashboardState>(
      listenWhen: (previous, current) {
        if (current is WorkerDashboardError) {
          return true;
        }

        if (previous is WorkerDashboardSuccess &&
            current is WorkerDashboardSuccess) {
          return previous.worker.status != current.worker.status;
        }

        return false;
      },
      listener: (context, state) {
        if (state is WorkerDashboardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is WorkerDashboardSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application status updated'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is WorkerDashboardLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is WorkerDashboardSuccess) {
          final worker = state.worker;

          String statusText;

          if (worker.status == WorkerStatus.approved) {
            statusText = 'Approved';
          } else if (worker.status == WorkerStatus.rejected) {
            statusText = 'Rejected';
          } else {
            statusText = 'Pending';
          }

          Color statusColor;

          if (worker.status == WorkerStatus.approved) {
            statusColor = AppColors.success;
          } else if (worker.status == WorkerStatus.rejected) {
            statusColor = AppColors.error;
          } else {
            statusColor = AppColors.warning;
          }

          return Scaffold(
            body: Column(
              children: [
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 28,
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(8, 102, 198, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.white,
                          backgroundImage: worker.avatar.isNotEmpty
                              ? NetworkImage(worker.avatar)
                              : null,
                          child: worker.avatar.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.primaryColor,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${worker.name}',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${worker.profession} - ${worker.area}',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.border,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Your Rating',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              worker.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Color.fromRGBO(8, 102, 198, 1),
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Reviews',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              worker.reviews.length.toString(),
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  width: 390,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Application Status',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),

            // Bottom Navigation Bar
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 1) {
                  final cubit = context.read<WorkerDashboardCubit>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: cubit,
                        child: EditWorkerProfileScreen(
                          worker: worker,
                        ),
                      ),
                    ),
                  );
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_outlined),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: AppColors.textSecondary,
              backgroundColor: AppColors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
          );
        }

        return const Scaffold();
      },
    );
  }
}
