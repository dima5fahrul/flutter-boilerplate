import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../core/debug/debug_screen.dart';
import '../../features/movie/presentation/pages/movie_detail_page.dart';
import '../../features/movie/presentation/pages/movie_list_page.dart';
import 'app_name_routes.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    navigatorKey: ChuckerFlutter.navigatorKey,
    initialLocation: AppNameRoutes.movieList,
    routes: [
      GoRoute(
        path: AppNameRoutes.movieList,
        name: AppNameRoutes.movieList,
        builder: (_, __) => const MovieListPage(),
        routes: [
          GoRoute(
            path: '${AppNameRoutes.movieDetail}/:id',
            name: AppNameRoutes.movieDetail,
            builder: (_, state) {
              final id = int.parse(state.pathParameters['id']!);
              return MovieDetailPage(movieId: id);
            },
          ),
        ],
      ),
      if (kDebugMode)
        GoRoute(
          path: AppNameRoutes.debug,
          name: AppNameRoutes.debug,
          builder: (_, __) => const DebugScreen(),
        ),
    ],
  );
}
