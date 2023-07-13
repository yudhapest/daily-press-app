import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:daily_press/common/navigation.dart';
import 'package:daily_press/data/api/api_service.dart';
import 'package:daily_press/data/db/database_helper.dart';
import 'package:daily_press/data/model/article.dart';
import 'package:daily_press/data/preferences/preferences_helper.dart';
import 'package:daily_press/provider/database_provider.dart';
import 'package:daily_press/provider/news_provider.dart';
import 'package:daily_press/provider/preferences_provider.dart';
import 'package:daily_press/provider/scheduling_provider.dart';
import 'package:daily_press/ui/article_detail_page.dart';
import 'package:daily_press/ui/article_web_view.dart';
import 'package:daily_press/ui/bookmarks_page.dart';
import 'package:daily_press/ui/home_page.dart';
import 'package:daily_press/ui/settings_page.dart';
import 'package:daily_press/ui/splash_screen_page.dart';
import 'package:daily_press/utils/background_service.dart';
import 'package:daily_press/utils/notification_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
      ],
      child: Consumer<PreferencesProvider>(builder: (context, provider, child) {
        return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'DailyPress',
            theme: provider.themeData,
            builder: (context, child) {
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness:
                      provider.isDarkTheme ? Brightness.dark : Brightness.light,
                ),
                child: Material(child: child),
              );
            },
            initialRoute: SplashScreenPage.routeName,
            routes: {
              SplashScreenPage.routeName: (context) => const SplashScreenPage(),
              HomePage.routeName: (context) => const HomePage(),
              ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                  article:
                      ModalRoute.of(context)?.settings.arguments as Article),
              ArticleWebView.routeName: (context) => ArticleWebView(
                  url: ModalRoute.of(context)?.settings.arguments as String),
              BookmarksPage.routeName: (context) => const BookmarksPage(),
              SettingsPage.routeName: (context) => const SettingsPage(),
            });
      }),
    );
  }
}
