class ApiEndpoint {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // TMDB Read Access Token — replace with --dart-define in production
  static const String accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZWRlYmM0YmNjZWNkNGY4MTIxNTY4MTlhYzE1MjZlZiIsIm5iZiI6MTY4MTcyMjQ2MS45OTYsInN1YiI6IjY0M2QwYzVkMmVhNmI5MDU0NjUxZjAwYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8_FVTdfmtdNI6ycSoyKDlug6yrjfLTUtpS1dz8tmbwk';

  static const String popularMovies = '$baseUrl/movie/popular';

  static String movieDetail(int movieId) => '$baseUrl/movie/$movieId';
}
