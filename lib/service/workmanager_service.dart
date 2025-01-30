import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/service/http_service.dart';
import 'package:restaurant_app/service/local_notification_service.dart';
import 'package:restaurant_app/static/restaurant_workmanager.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final httpService = HttpService();
    final localNotification = LocalNotificationService(httpService);
    if (task == RestaurantWorkmanager.periodic.taskName) {
      final baseUrl = "https://restaurant-api.dicoding.dev";
      final result = await httpService.getDataFromUrl("$baseUrl/list");
      debugPrint('result: ${jsonDecode(result)}');

      Map<String, dynamic> parsedResult = jsonDecode(result);
      List<dynamic> restaurants = parsedResult['restaurants'];
      if (restaurants.isNotEmpty) {
        Random random = Random();
        var randomRestaurant = restaurants[random.nextInt(restaurants.length)];

        String title =
            "Hello, let's try going to ${randomRestaurant['name']} now!";
        String body =
            "📍 ${randomRestaurant['city']} City - ⭐ ${randomRestaurant['rating']}";
        String pictureId = randomRestaurant['pictureId'];
        String imageUrl = "$baseUrl/images/small/$pictureId"; // save to cache

        int notificationId = Random().nextInt(100000);

        await localNotification.showNotification(
          id: notificationId,
          title: title,
          body: body,
          payload: randomRestaurant['id'],
        );
      }
    }

    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
      : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runOneOffTask() async {
    await _workmanager.registerOneOffTask(
      RestaurantWorkmanager.oneOff.uniqueName,
      RestaurantWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": "Restaurant data",
      },
    );
  }

  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      RestaurantWorkmanager.periodic.uniqueName,
      RestaurantWorkmanager.periodic.taskName,
      frequency: const Duration(hours: 24), // Run daily
      initialDelay: const Duration(seconds: 5), // Small delay for safety
      inputData: {"data": "Fetching restaurant data"},
      constraints: Constraints(
        networkType: NetworkType.connected, // Requires internet
      ),
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
