import 'package:flutter/material.dart';
import '../../../../core/constant/api_endpoint.dart';
import '../../domain/entities/movie_entity.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const MovieCardWidget({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Image.network(
              '${ApiEndpoint.imageBaseUrl}${movie.posterPath}',
              width: 80,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(width: 80, height: 120, child: Icon(Icons.movie)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('⭐ ${movie.voteAverage.toStringAsFixed(1)}'),
                  Text(movie.releaseDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
