import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Inisialisasi timezone
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    } catch (_) {}

    // 2. Konfigurasi Android & iOS
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationPlugin.initialize(initSettings);

    // 3. Request permission dan buat channel Android
    final androidPlatform = notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlatform?.requestNotificationsPermission();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminder Notifications',
      description: 'Channel untuk reminder dan alert notifikasi CastLog',
      importance: Importance.high,
    );
    await androidPlatform?.createNotificationChannel(channel);
  }

  /// Immediate notification: muncul langsung saat dipanggil
  Future<void> showInstantNotification({
    required String title,
    required String body,
    int? id,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await notificationPlugin.show(
      id ?? (DateTime.now().millisecondsSinceEpoch % 100000),
      title,
      body,
      notifDetails,
    );
  }

  /// Scheduled notification: muncul di waktu yang ditentukan
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
      ),
      notifDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Helper: Notifikasi saat ikan berhasil dicatat ke game
  Future<void> showCatchNotification({
    required String species,
    required double weightKg,
    required String waterway,
    bool isPersonalBest = false,
  }) async {
    if (isPersonalBest) {
      await showInstantNotification(
        title: '🏆 Personal Best Baru!',
        body: 'Strike luar biasa! $species seberat ${weightKg.toStringAsFixed(2)} kg di $waterway.',
      );
    } else {
      await showInstantNotification(
        title: '🎣 Strike! $species',
        body: '$species (${weightKg.toStringAsFixed(2)} kg) berhasil dicatat ke sesi $waterway.',
      );
    }
  }

  /// Helper: Notifikasi saat sesi mancing dimulai
  Future<void> showSessionStartedNotification({required String waterway}) async {
    await showInstantNotification(
      title: '🎣 Sesi Mancing Dimulai',
      body: 'Sesi aktif di $waterway telah berjalan. Buka game Fishing Planet dan pantau strike!',
    );
  }
}
