import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/received_notification.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';
import 'package:restaurant_app/provider/notification/notification_state_provider.dart';
import 'package:restaurant_app/provider/notification/payload_provider.dart';
import 'package:restaurant_app/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app/provider/theme/theme_state_provider.dart';
import 'package:restaurant_app/service/local_notification_service.dart';
import 'package:restaurant_app/service/workmanager_service.dart';
import 'package:restaurant_app/utils/notification_state.dart';
import 'package:restaurant_app/utils/theme_state.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
    });
  }

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();

    Future.microtask(() {
      context.read<SharedPreferencesProvider>().getSettingValue();
    });

    final themeStateProvider = context.read<ThemeStateProvider>();
    final notificationStateProvider = context.read<NotificationStateProvider>();
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();
    Future.microtask(() async {
      sharedPreferencesProvider.getSettingValue();
      final setting = sharedPreferencesProvider.setting;

      if (setting != null) {
        themeStateProvider.themeState = setting.isDarkMode.isDarkMode;
        notificationStateProvider.notificationState =
            setting.notificationEnable.isEnable;
      }
    });
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SharedPreferencesProvider>(
        builder: (context, stateValue, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: getColor(stateValue.setting!.isDarkMode, 'top'),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: getColor(stateValue.setting!.isDarkMode, 'mid'),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: getColor(
                                stateValue.setting!.isDarkMode, 'bottom'),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      stateValue.setting!.isDarkMode
                                          ? Icons.dark_mode
                                          : Icons.light_mode,
                                      color: getColor(
                                        stateValue.setting!.isDarkMode,
                                        'text',
                                      ),
                                    ),
                                    const SizedBox.square(dimension: 8.0),
                                    Text(
                                      'Dark Mode',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: getColor(
                                          stateValue.setting!.isDarkMode,
                                          'text',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: stateValue.setting!.isDarkMode,
                                  onChanged: (value) {
                                    updateTheme(value);
                                  },
                                )
                              ],
                            ),
                          ),
                          const SizedBox.square(dimension: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      stateValue.setting!.notificationEnable
                                          ? Icons.notifications_active
                                          : Icons.notifications_off,
                                      color: getColor(
                                        stateValue.setting!.isDarkMode,
                                        'text',
                                      ),
                                    ),
                                    const SizedBox.square(dimension: 8.0),
                                    Text(
                                      'Notification',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: getColor(
                                          stateValue.setting!.isDarkMode,
                                          'text',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: stateValue.setting!.notificationEnable,
                                  onChanged: (value) {
                                    updateNotification(context, value);
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox.square(dimension: 14.0),
              if (stateValue.setting!.notificationEnable) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Notification Terms",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: getColor(
                                stateValue.setting!.isDarkMode,
                                'text',
                              ),
                            ),
                          ),
                          const SizedBox.square(dimension: 4.0),
                          Icon(
                            size: 18.0,
                            Icons.warning_amber_rounded,
                            color: getColor(
                              stateValue.setting!.isDarkMode,
                              'text',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        "You have enabled customized notification settings to appear every day at 11:00 AM based on your local time.",
                        style: TextStyle(
                          fontSize: 13,
                          color: getColor(
                            stateValue.setting!.isDarkMode,
                            'text',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showNotificationRequestDialog();
                        },
                        child: Text(
                          "Tap to view.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void updateTheme(bool isDarkMode) {
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();
    sharedPreferencesProvider.updateDarkMode(isDarkMode);
  }

  // Daily Reminder (using LocalNotificationService in every 11:00 AM)
  void updateNotification(BuildContext context, bool isEnable) async {
    final workManagerService = WorkmanagerService(); // Custom Daily Reminder using Workmanager
    if (isEnable) {
      await workManagerService.runPeriodicTask();
      _scheduleDailyElevenAMNotification();
    } else {
      await workManagerService.cancelAllTask();
      final localNotificationProvider =
          context.read<LocalNotificationProvider>();
      await localNotificationProvider.checkPendingNotificationRequests(context);
      if (!mounted) {
        return;
      }

      final pendingData = localNotificationProvider.pendingNotificationRequests;
      if (pendingData.isNotEmpty) {
        final item = pendingData[0];
        await localNotificationProvider.cancelNotification(item.id);
        await localNotificationProvider
            .checkPendingNotificationRequests(context);
      }
    }
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();
    sharedPreferencesProvider.updateEnable(isEnable);
  }

  Future<void> showNotificationRequestDialog() async {
    final localNotificationProvider = context.read<LocalNotificationProvider>();
    await localNotificationProvider.checkPendingNotificationRequests(context);
    if (!mounted) {
      return;
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final pendingData = context.select(
            (LocalNotificationProvider provider) =>
                provider.pendingNotificationRequests);
        return AlertDialog(
          title: Text(
            'Notification Request',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: SizedBox(
            height: 100,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pendingData[0].title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  pendingData[0].body!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _scheduleDailyElevenAMNotification() async {
    context
        .read<LocalNotificationProvider>()
        .scheduleDailyElevenAMNotification();
  }

  Future<void> _showBigPictureNotification() async {
    context.read<LocalNotificationProvider>().showBigPictureNotification();
  }

  Color getColor(bool isDarkMode, String widgetType) {
    switch (widgetType) {
      case 'top':
        return isDarkMode ? Colors.white : Colors.teal;
      case 'mid':
        return isDarkMode ? Colors.black87 : Colors.teal.shade50;
      case 'bottom':
        return isDarkMode
            ? Colors.white.withOpacity(0.3)
            : Colors.teal.withOpacity(0.3);
      default:
        return isDarkMode ? Colors.white : Colors.black87;
    }
  }
}
