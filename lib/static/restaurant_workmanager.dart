enum RestaurantWorkmanager {
  oneOff("task-identifier", "task-identifier"),
  periodic("com.example.restaurant_app", "com.example.restaurant_app");

  final String uniqueName;
  final String taskName;

  const RestaurantWorkmanager(this.uniqueName, this.taskName);
}
