import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc/app/app_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/app/app_event.dart';
import 'bloc/app/app_state.dart';
import 'l10n/app_localizations.dart';
import 'routes/app_routes.dart';
import 'services/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'bloc/home/home_bloc.dart';
import 'bloc/home/home_event.dart';
import 'bloc/location/location_bloc.dart';
import 'bloc/location/location_event.dart';
import 'bloc/settings/settings_bloc.dart';
import 'bloc/profile/profile_event.dart';
import 'bloc/friends/friends_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc()..add(AppStarted())),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => ProfileBloc()),
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => LocationBloc()..add(LocationRequested())),
        BlocProvider(create: (_) => SettingsBloc()..add(LoadSettings())),
        BlocProvider(create: (_) => FriendsBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        Locale locale = const Locale('en');
        if (state is SettingsLoaded) {
          locale = state.locale;
        }
        return MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('uk'), // Ukrainian
          ],
          locale: locale,
          title: 'WTHO App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          navigatorKey: NavigationService.navigatorKey,
          initialRoute: AppRoutes.login,
          routes: {
            AppRoutes.login: (context) => const AppNavigationWrapper(),
            AppRoutes.home: (context) => const AppNavigationWrapper(),
            AppRoutes.profile: (context) => const AppNavigationWrapper(),
          },
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}

class AppNavigationWrapper extends StatelessWidget {
  const AppNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => current is AppAuthenticated,
      listener: (context, state) {
        if (state is AppAuthenticated) {
          context.read<ProfileBloc>().add(ProfileLoadRequested());
          NavigationService.pushNamedAndRemoveUntil(
            AppRoutes.home,
            (route) => false,
          );
        }
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is AppAuthenticated) {
            return const HomeScreen();
          } else if (state is AppProfile) {
            return const ProfileScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
