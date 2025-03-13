import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.light)) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(themeMode: newThemeMode));
  }
}
