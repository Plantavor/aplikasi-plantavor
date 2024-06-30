// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plantavor/model/task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:terature/model/task.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("terature_icon");

    // IOSInitializationSettings iosInitializationSettings =
    //     IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      // iOS: iosInitializationSettings
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        // 'channel description',
        importance: Importance.high,
        styleInformation: BigTextStyleInformation(''),
      ),
      // iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification(
      int id, String title, String body, String payload) async {
    return _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static void showScheduleNotification(Task task, String payload) async {
    final box = GetStorage();
    if (DateTime.parse(task.tanggalDeadline).isAfter(DateTime.now()) &&
        box.read('allowNotification')) {
      return _notification.zonedSchedule(
          task.id,
          'terature',
          'Your task, "${task.judul}" has reached the deadline! make sure you have finished it',
          tz.TZDateTime.from(DateTime.parse(task.tanggalDeadline), tz.local),
          await _notificationDetails(),
          payload: payload,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);
    }
  }

  static Future cancelAllNotifications() async {
    return await _notification.cancelAll();
  }

  static Future setNotificationFromAllUsersTask(List<Task> task) async {
    task.forEach((element) async {
      print('set notifikasi ${element.judul}');
      if (DateTime.parse(element.tanggalDeadline).isAfter(DateTime.now())) {
        print('set notifikasi ${element.judul} berhasil');
        await _notification.zonedSchedule(
          element.id,
          'terature',
          'Your task, "${element.judul}" has reached the deadline! make sure you have finished it',
          tz.TZDateTime.from(DateTime.parse(element.tanggalDeadline), tz.local),
          await _notificationDetails(),
          payload: 'terature',
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );
      }
    });
  }

  static Future cancelNotificationById(int id) async {
    await _notification.cancel(id);
  }
}
