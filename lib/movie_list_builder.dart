import 'package:flutter/material.dart';
import 'package:movie_library_test/movie.dart';


class MoviesListView extends StatelessWidget{

  final List<Movie> movies;
  final ScrollController scrollController;

  MoviesListView({ this.movies, this.scrollController });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: movies.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: buildRow(movies[index])
          );
        });
  }

  Widget buildRow(Movie movie) {
    return Column(
      children: <Widget>[
        Divider(
          height: 15.0,
          color: Colors.black26,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(movie.posterPath, width: 90.0, height: 120.0),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(movie.title,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                        maxLines: 2,
                      ),
                    ),
                    Text(movie.overview,
                      style: TextStyle(fontSize: 14.0),
                      maxLines: 4,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Release date: ', style: TextStyle(fontSize: 16.0, color: Colors.blueAccent)),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(movie.releaseDate, style: TextStyle(fontSize: 14.0, color: Colors.blueAccent)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }


}