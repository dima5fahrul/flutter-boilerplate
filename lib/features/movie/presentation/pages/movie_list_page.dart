import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../di/movie_injection.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../bloc/movie_list/movie_list_bloc.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/app_loading_widget.dart';
import '../widgets/movie_card_widget.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieListBloc(
        getPopularMovies: movieInjection<GetPopularMovies>(),
      )..add(const MovieListEvent.started()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Popular Movies')),
        body: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            return switch (state.status) {
              MovieListStatus.initial => const SizedBox.shrink(),
              MovieListStatus.loading => const AppLoadingWidget(),
              MovieListStatus.failure => AppErrorWidget(
                  message: state.errorMessage ?? 'Something went wrong',
                  onRetry: () => context
                      .read<MovieListBloc>()
                      .add(const MovieListEvent.refresh()),
                ),
              MovieListStatus.success => ListView.builder(
                  itemCount: state.movies.length,
                  itemBuilder: (_, index) => MovieCardWidget(
                    movie: state.movies[index],
                    onTap: () => context.push(
                      '/movies/detail/${state.movies[index].id}',
                    ),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
