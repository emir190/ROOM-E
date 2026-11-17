import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/l10n/app_localizations.dart';
import 'core/notifications/push_notification_service.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class RoomieApp extends ConsumerStatefulWidget {
  const RoomieApp({super.key});

  @override
  ConsumerState<RoomieApp> createState() => _RoomieAppState();
}

class _RoomieAppState extends ConsumerState<RoomieApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pushNotificationProvider.notifier).initializeFCM();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Roomie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: currentLocale,
      builder: (context, child) {
        return PushNotificationBannerOverlay(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
