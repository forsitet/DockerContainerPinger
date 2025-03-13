import 'package:exapmle_docker_pinger/src/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class NavigatorManager {
  final GoRouter router = AppRouter.appRouter;
  NavigatorManager();

  void navigateToContainerListPage() {
    router.go(AppRouteNames.containers);
  }

  void navigateToLogin() {
    router.go(AppRouteNames.login);
  }
}
