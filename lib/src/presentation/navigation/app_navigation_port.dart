/// Thin facade so [AppCoordinator] does not depend on GoRouter types in tests.
abstract class AppNavigationPort {
  String get currentLocation;

  bool get canPop;

  void go(String location);

  void push(String location);

  void replace(String location);

  void pop();
}
