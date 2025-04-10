import 'package:dio/dio.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/theme/theme_bloc.dart';
import 'package:exapmle_docker_pinger/src/core/router/navigation_manager.dart';
import 'package:exapmle_docker_pinger/src/core/styles/theme/themes.dart';
import 'package:exapmle_docker_pinger/generated/l10n.dart';
import 'package:exapmle_docker_pinger/src/features/authorization/data/repositories/auth_repository_impl.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/auth/auth_bloc.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/data/datasources/container_remote_datasource.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/data/repositories/container_repository_impl.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/delete_container_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/get_containers_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/send_ping_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/presentation/bloc/container_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final GetContainersUseCase getContainersUseCase = GetContainersUseCase(
    ContainerRepositoryImpl(ContainerRemoteDataSource(Dio())),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: AuthRepositoryImpl(dio: Dio())),
        ),
        BlocProvider(
          create: (_) => ContainerListBloc(
              getContainers:
                  GetContainersUseCase(getContainersUseCase.repository),
              sendPing: SendPingUseCase(getContainersUseCase.repository),
              deleteOld:
                  DeleteContainersUseCase(getContainersUseCase.repository)),
        )
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});
  static final _mainNavigation = NavigatorManager();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeState.themeMode,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          title: 'Docker Manager',
          routerConfig: _mainNavigation.router,
          // home: BlocProvider(
          //     create: (context) => ContainerListBloc(),
          //     child: ContainerListPage()),
        );
      },
    );
  }
}
