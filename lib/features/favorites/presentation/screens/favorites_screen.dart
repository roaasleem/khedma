import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/worker_model.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/customer_bottom_nav_bar.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../widgets/favorite_button.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return _MessageState(
              message: state.errorMessage!,
              icon: state.requiresLogin
                  ? Icons.lock_outline
                  : Icons.error_outline,
              showRetry: !state.requiresLogin,
            );
          }

          if (state.favorites.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final worker = state.favorites[index];

              return _WorkerCard(worker: worker);
            },
          );
        },
      ),
      bottomNavigationBar: CustomerBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        },
      ),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final WorkerModel worker;

  const _WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          child: worker.avatar.isEmpty
              ? const Icon(Icons.person, size: 30)
              : ClipOval(
                  child: Image.network(
                    worker.avatar,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 30);
                    },
                  ),
                ),
        ),
        title: Text(
          worker.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('${worker.profession} • ${worker.area}'),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(' ${worker.rating}'),
                const SizedBox(width: 12),
                Text('From ${worker.price} EGP'),
              ],
            ),
          ],
        ),
        trailing: FavoriteButton(worker: worker),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No favorites yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the heart on any worker to save them here.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final String message;
  final IconData icon;
  final bool showRetry;

  const _MessageState({
    required this.message,
    required this.icon,
    required this.showRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (showRetry) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<FavoritesCubit>().loadFavorites();
                },
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
