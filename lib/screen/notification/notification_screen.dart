import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/received_notification.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';
import 'package:restaurant_app/provider/notification/payload_provider.dart';
import 'package:restaurant_app/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app/service/local_notification_service.dart';

class NotificationScreen extends StatefulWidget {

  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
      //Navigator.pushNamed(context, MyRoute.detail.name, arguments: payload);
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
      //Navigator.pushNamed(context, MyRoute.detail.name, arguments: receivedNotification.payload);
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
        title: const Text("Notification Settings"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //const MyDivider(title: "Notification"),
              ElevatedButton(
                onPressed: () async {
                  await _requestPermission();
                },
                child: Consumer<LocalNotificationProvider>(
                  builder: (context, value, child) {
                    return Text(
                      "Request permission (${value.permission})",
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showNotification();
                },
                child: const Text(
                  "Show notification with payload and custom sound",
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showBigPictureNotification();
                },
                child: const Text(
                  "Show notification with big picture",
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _scheduleDailyElevenAMNotification();
                },
                child: const Text(
                  "Schedule daily 11:00:00 am notification",
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _checkPendingNotificationRequests();
                },
                child: const Text(
                  "Check pending notifications",
                  textAlign: TextAlign.center,
                ),
              ),
              //const MyDivider(title: "Background Service"),
              ElevatedButton(
                onPressed: () {
                  //_runBackgroundOneOffTask();
                },
                child: const Text(
                  "Run a task in background",
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //_runBackgroundPeriodicTask();
                },
                child: const Text(
                  "Run a task periodically in background",
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //_cancelAllTaskInBackground();
                },
                child: const Text(
                  "Cancel all task in background",
                  textAlign: TextAlign.center,
                ),
              ),
              //const MyDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  Future<void> _showNotification() async {
    context.read<LocalNotificationProvider>().showNotification();
  }

  Future<void> _showBigPictureNotification() async {
    context.read<LocalNotificationProvider>().showBigPictureNotification();
  }

  Future<void> _scheduleDailyElevenAMNotification() async {
    context.read<LocalNotificationProvider>().scheduleDailyElevenAMNotification();
  }

  Future<void> _checkPendingNotificationRequests() async {
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
            '${pendingData.length} pending notification requests',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: pendingData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = pendingData[index];
                return ListTile(
                  title: Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.body ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: IconButton(
                    onPressed: () {
                      localNotificationProvider
                        ..cancelNotification(item.id)
                        ..checkPendingNotificationRequests(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                );
              },
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
}