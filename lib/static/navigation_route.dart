enum NavigationRoute {
  mainRoute("/"),
  detailRoute("/detail"),
  reviewRoute("/review");

  const NavigationRoute(this.name);
  final String name;
}
