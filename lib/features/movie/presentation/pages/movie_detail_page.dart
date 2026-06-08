import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/api_endpoint.dart';
import '../../di/movie_injection.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../bloc/movie_detail/movie_detail_bloc.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/app_loading_widget.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc(
        getMovieDetail: movieInjection<GetMovieDetail>(),
      )..add(MovieDetailEvent.started(movieId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Movie Detail')),
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            return switch (state.status) {
              MovieDetailStatus.initial => const SizedBox.shrink(),
              MovieDetailStatus.loading => const AppLoadingWidget(),
              MovieDetailStatus.failure => AppErrorWidget(
                  message: state.errorMessage ?? 'Something went wrong',
                ),
              MovieDetailStatus.success when state.movie != null =>
                _DetailBody(movie: state.movie!),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final MovieDetailEntity movie;

  const _DetailBody({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            '${ApiEndpoint.imageBaseUrl}${movie.posterPath}',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(
              height: 300,
              child: Icon(Icons.movie, size: 80),
            ),
          ),
          const SizedBox(height: 16),
          Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
          if (movie.tagline.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              movie.tagline,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '⭐ ${movie.voteAverage.toStringAsFixed(1)}  '
            '⏱ ${movie.runtime} min  '
            '📅 ${movie.releaseDate}',
          ),
          const SizedBox(height: 8),
          Text(
            movie.genres.map((g) => g.name).join(', '),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Text(movie.overview),
        ],
      ),
    );
  }
}
