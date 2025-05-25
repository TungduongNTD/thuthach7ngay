import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thuthach7ngay/blocs/new_habit_cubit.dart';
import 'package:thuthach7ngay/blocs/theme_cubit.dart';
import 'package:thuthach7ngay/config/theme_data.dart';
import 'package:thuthach7ngay/models/habit_hive_model.dart';
import 'package:thuthach7ngay/models/user_hive_model.dart';
import 'package:thuthach7ngay/screens/habit_screen.dart';
import 'package:thuthach7ngay/screens/login_screen.dart';
import 'package:thuthach7ngay/screens/main_screen.dart';
import 'package:thuthach7ngay/screens/settings_screen.dart';
import 'package:thuthach7ngay/blocs/locale_cubit.dart';
import 'package:thuthach7ngay/blocs/selected_day_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thuthach7ngay/firebase_options.dart';

import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Khởi tạo Hive
  await Hive.initFlutter();
  Hive.registerAdapter(HabitHiveAdapter());
  Hive.registerAdapter(UserHiveAdapter());
  await Hive.openBox<UserHive>('userBox');
  final settingsBox = await Hive.openBox('settings');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LocaleCubit(settingsBox)),
        BlocProvider(create: (context) => SelectedDayCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              routerConfig: GoRouter(
                routes: [
                  GoRoute(
                    path: '/',
                    redirect: (context, state) {
                      final box = Hive.box<UserHive>('userBox');
                      final isLoggedIn = box.isNotEmpty;
                      return isLoggedIn ? '/home' : '/login';
                    },
                  ),
                  GoRoute(
                      path: '/login',
                      builder: (context, state) => const LoginScreen()
                  ),
                  GoRoute(
                      path: '/home',
                      builder: (context, state) => const MainScreen()
                  ),
                  GoRoute(
                    path: '/habits/new',
                    builder: (context, state) => BlocProvider(
                      create: (context) => NewHabitCubit(),
                      child: const HabitScreen(id: null),
                    ),
                  ),
                  GoRoute(
                    path: '/habits/:id',
                    builder: (context, state) => BlocProvider(
                      create: (context) => NewHabitCubit(),
                      child: HabitScreen(id: state.pathParameters['id']),
                    ),
                  ),
                  GoRoute(
                    path: '/settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
              debugShowCheckedModeBanner: false,
              theme: lightModeTheme,
              darkTheme: darkModeTheme,
              themeMode: themeMode,
              locale: locale,
              supportedLocales: const [
                Locale('en'),
                Locale('vi'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              title: 'Triply',
              builder: (context, child) {
                final tr = AppLocalizations.of(context)!;
                final GetIt getIt = GetIt.I;
                if (!getIt.isRegistered<AppLocalizations>()) {
                  getIt.registerSingleton<AppLocalizations>(tr);
                }
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}