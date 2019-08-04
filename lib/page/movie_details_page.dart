import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trembit_test_app/bloc/movie_details/movie_details_bloc.dart';
import 'package:trembit_test_app/data/network/network_client.dart';
import 'package:trembit_test_app/model/result.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

class MovieDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieDetailsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Result<Movie>>(
          stream: bloc.movie,
          builder: (context, snapshot) {
            if (snapshot != null && snapshot.data != null) {
              final result = snapshot.data;
              if (result.state == ResultState.ERROR) {
                return Text('Trembit Test App');
              } else {
                return Text(result.data.title);
              }
            } else {
              return Text('Trembit Test App');
            }
          },
        ),
      ),
      body: StreamBuilder<Result<Movie>>(
        stream: bloc.movie,
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.data != null) {
            final result = snapshot.data;
            if (result.state == ResultState.ERROR) {
              return Center(
                child: Text('Something went wrong...'),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      NetworkClient.buildImageUrl(result.data.imageUrl),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(result.data.title),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        result.data.overview,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          result.data.releaseDate.toUtc().toIso8601String()),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
