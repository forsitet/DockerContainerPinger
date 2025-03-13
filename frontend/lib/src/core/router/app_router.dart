import 'package:exapmle_docker_pinger/src/features/authorization/presentation/factories/login_page_factory.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/presentation/pages/container_list_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: AppRouteNames.login,
    routes: [
      GoRoute(
        name: AppRouteNames.containers,
        path: AppRouteNames.containers,
        builder: (context, state) => ContainerListPage(),
      ),
      GoRoute(
        name: AppRouteNames.login,
        path: AppRouteNames.login,
        builder: (context, state) => LoginScreenFactory.create(context),
      ),
    ],
  );
}

abstract class AppRouteNames {
  static const login = '/login';
  static const containers = '/containers';
}
