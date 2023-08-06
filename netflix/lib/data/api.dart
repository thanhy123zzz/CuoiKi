// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart';
import 'package:netflix/data/model/episode_model.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/data/model/movie_detail_model.dart';

class Api {
  Api(this.client);
  final Client client;
  static String baseURL = 'https://api.themoviedb.org/3';
  // ignore: non_constant_identifier_names
  static String api_key = "api_key=b7c3309b3ea8fdf5c9afa62154eefc7f&language=vi-VN";
  Future<HomeModel> getHome() async {
    try {
      final banner = await client.get(
        Uri.parse("$baseURL/trending/all/week?$api_key")
      );
      final action = await client.get(
        Uri.parse("$baseURL/discover/movie?$api_key&with_genres=28")
      );
      final romance = await client.get(
        Uri.parse("$baseURL/discover/movie?$api_key&with_genres=10749")
      );
      final series = await client.get(
        Uri.parse("$baseURL/tv/popular?$api_key&language=en-US")
      );
      if(banner.statusCode == 200 && action.statusCode == 200 && romance.statusCode == 200 && series.statusCode == 200) {
        Map<String, dynamic> dataBanners = jsonDecode(banner.body);
        Map<String, dynamic> dataAction = jsonDecode(action.body);
        Map<String, dynamic> dataRomance = jsonDecode(romance.body);
        Map<String, dynamic> dataSeries = jsonDecode(series.body);

        for (var map in dataAction['results']) {
          map['media_type'] = 'movie';
         }
         for (var map in dataRomance['results']) {
          map['media_type'] = 'movie';
         }
         for (var map in dataSeries['results']) {
          map['media_type'] = 'tv';
         }

        
        Map<String, dynamic> data  = {
          'banner': dataBanners["results"][1],
          'action': dataAction["results"],
          'romance': dataRomance["results"],
          'series': dataSeries["results"]
        };

        HomeModel model = HomeModel.fromJson(data);
        return model;
      } else {
        throw Exception('Server không phản hồi, hãy thử lại...');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieDetailModel> getMovieDetail(int id, String type) async {
   try {
      final response = await client.get(
        Uri.parse("$baseURL/$type/$id?$api_key")
      );
      final videos = await client.get(
        Uri.parse("$baseURL/$type/$id/videos?$api_key")
      );
      final images = await client.get(
        Uri.parse("$baseURL/$type/$id/images?$api_key")
      );
      final credits = await client.get(
        Uri.parse("$baseURL/$type/$id/credits?$api_key")
      );
      
      if(response.statusCode == 200 && credits.statusCode == 200 && images.statusCode == 200 && videos.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);


        data.addAll({
          'videos': jsonDecode(videos.body),
          'images': jsonDecode(images.body),
          'credits': jsonDecode(credits.body)
        });
        MovieDetailModel model = MovieDetailModel.fromJson(data);
        return model;
      } else {
        throw Exception('Server không phản hồi, hãy thử lại...');
      }
    } catch (e) {
      rethrow;
    } 
  }

  Future<List<Episodes>> getEpisode(int id, int season) async {
   try {
      final response = await client.get(
        Uri.parse("$baseURL/episode?tmdb=$id&season=$season")
      );
      
      if(response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        EpisodeModel model = EpisodeModel.fromJson(data);
        return model.episodes!;
      } else {
        throw Exception('Server không phản hồi, hãy thử lại...');
      }
    } catch (e) {
      rethrow;
    } 
  }

  Future<List<Movie>> getNewest(int page) async {
   try {
      final responseMovies = await client.get(
        Uri.parse("$baseURL/movie/popular?page=$page&$api_key")
      );
      final responseTvs = await client.get(
        Uri.parse("$baseURL/tv/popular?page=$page&$api_key")
      );
      
      if(responseMovies.statusCode == 200 && responseTvs.statusCode == 200) {

         // ignore: non_constant_identifier_names
         Map<String, dynamic> Movies = jsonDecode(responseMovies.body);
         Map<String, dynamic> Tvs = jsonDecode(responseTvs.body);
         for (var map in Movies['results']) {
          map['mediaType'] = 'movie';
         }

        for (var map in Tvs['results']) {
          map['mediaType'] = 'tv';
        }
         var data = Movies['results'] + Tvs['results'];


        List<Movie> result = <Movie>[];
        for (Map<String, dynamic> v in data) {
          result.add(Movie.fromJson(v));
        }

        return result;
      } else {
        throw Exception('Server không phản hồi, hãy thử lại...');
      }
    } catch (e) {
      rethrow;
    } 
  }

  Future<List<Movie>> getSearch(String title, int page) async {
   try {
      final response = await client.get(
        Uri.parse("$baseURL/search?title=$title&page=$page")
      );
      
      if(response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Movie> result = <Movie>[];
        for (Map<String, dynamic> v in data) {
          result.add(Movie.fromJson(v));
        }

        return result;
      } else {
        throw Exception('Server không phản hồi, hãy thử lại...');
      }
    } catch (e) {
      rethrow;
    } 
  }

  Future<List<Movie>> getCategory(String category, int page) async {
   try {
      final response = await client.get(
        Uri.parse("$baseURL/genre?genre=$category&page=$page")
      );
      
      if(response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Movie> result = <Movie>[];
        for (Map<String, dynamic> v in data) {
          result.add(Movie.fromJson(v));
        }

        return result;
      } else {
        throw Exception('Server không phản hồi, hãy thử lại...');
      }
    } catch (e) {
      rethrow;
    } 
  }
}