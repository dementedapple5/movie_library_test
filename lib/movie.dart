import 'package:meta/meta.dart';

class Movie {
  int id;
  String title, posterPath, overview, releaseDate;
  double voteAverage;

  Movie({
     this.id,
     this.title,
     this.posterPath,
     this.overview,
     this.voteAverage,
    this.releaseDate
  });

  factory Movie.fromJson(Map<String, dynamic> json){

    final posterBaseUrl = "http://image.tmdb.org/t/p/w185/";

    return Movie(
      id: json['id'],
      posterPath: json['poster_path'].toString() != "null" ? "$posterBaseUrl${json['poster_path']}" : "https://image.flaticon.com/icons/png/128/179/179386.png",
      voteAverage: json['vote_average'] * 1.0,
      overview: json['overview'],
      title: json['title'],
      releaseDate: json['release_date']
    );
  }

}
