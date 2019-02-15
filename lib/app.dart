import 'package:flutter/material.dart';
import 'package:gank_app/blocs/app_model_bloc.dart';
import 'package:gank_app/blocs/bloc_provider.dart';
import 'package:gank_app/gank_configuration.dart';
import 'package:gank_app/pages/home_page.dart';

class App extends StatelessWidget {
  App(this.configuration, this.updater);

  final GankConfiguration configuration;
  final ValueChanged<GankConfiguration> updater;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppModelBloc>(
      bloc: AppModelBloc(),
      child: HomePage(configuration, updater),
    );
  }
}
