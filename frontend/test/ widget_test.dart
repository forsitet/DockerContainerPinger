// ignore_for_file: file_names

import 'package:bloc_test/bloc_test.dart';
import 'package:exapmle_docker_pinger/generated/app_localizations.dart';
import 'package:exapmle_docker_pinger/generated/app_localizations_en.dart';
import 'package:exapmle_docker_pinger/generated/app_localizations_ru.dart';
import 'package:exapmle_docker_pinger/src/features/authorization/presentation/pages/login_page.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/auth/auth_bloc.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/auth/auth_event.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  group('LoginPage', () {
    late AuthBloc authBloc;

    setUp(() {
      authBloc = MockAuthBloc();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const LoginPage(),
        ),
      );
    }

    testWidgets('shows error snackbar on AuthError', (tester) async {
      whenListen(
        authBloc,
        Stream<AuthState>.fromIterable([
          AuthError(error: AppLocalizationsRu().auth_failure),
          AuthError(error: AppLocalizationsEn().auth_failure)
        ]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
