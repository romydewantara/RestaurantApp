import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/notification/notification_state_provider.dart';
import 'package:restaurant_app/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app/provider/theme/theme_state_provider.dart';
import 'package:restaurant_app/utils/notification_state.dart';
import 'package:restaurant_app/utils/theme_state.dart';

class SettingScreen extends StatefulWidget {

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox.square(dimension: 18),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 16.0,
            ),
            child:
            Consumer<SharedPreferencesProvider>(
              builder: (context, stateValue, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          stateValue.setting!.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        const SizedBox.square(dimension: 8.0),
                        const Text(
                          'Dark Mode',
                          style: TextStyle(fontSize: 18),
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
                );
              },
            ),
          ),
          const SizedBox.square(dimension: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 16.0,
            ),
            child: Consumer<SharedPreferencesProvider>(
              builder: (context, stateValue, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          stateValue.setting!.notificationEnable
                              ? Icons.notifications_active
                              : Icons.notifications_off,
                        ),
                        const SizedBox.square(dimension: 8.0),
                        const Text(
                          'Notification',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Switch(
                      value: stateValue.setting!.notificationEnable,
                      onChanged: (value) {
                        updateNotification(value);
                      },
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateTheme(bool isDarkMode) {
    final sharedPreferencesProvider =
    context.read<SharedPreferencesProvider>();
    sharedPreferencesProvider.updateDarkMode(isDarkMode);
  }

  void updateNotification(bool isEnable) {
    final sharedPreferencesProvider =
    context.read<SharedPreferencesProvider>();
    sharedPreferencesProvider.updateEnable(isEnable);
  }
}