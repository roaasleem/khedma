import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/worker_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class FavoriteButton extends StatelessWidget {
  final WorkerModel worker;
  final double size;

  const FavoriteButton({super.key, required this.worker, this.size = 26});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final cubit = context.read<FavoritesCubit>();
        final isFavorite = cubit.isFavorite(worker.id);
        final isEnabled =
            state.isLoaded && !state.isLoading && !state.requiresLogin;

        return IconButton(
          onPressed: !isEnabled
              ? null
              : () {
                  cubit.toggleFavorite(worker);
                },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.error : AppColors.textSecondary,
            size: size,
          ),
          tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
        );
      },
    );
  }
}
