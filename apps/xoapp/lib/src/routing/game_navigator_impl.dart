import 'package:go_router/go_router.dart';
import 'package:tictactoe_feature/tictactoe_feature.dart';
import 'package:xoapp/src/routing/app_routes.dart';

class GameNavigatorImpl implements GameNavigator {
  GameNavigatorImpl(this._router);

  final GoRouter _router;

  @override
  void exitToHome() => _router.go(AppRoutes.homePath);
}
