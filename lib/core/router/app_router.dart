import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/application/auth_state.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/verify_email_screen.dart';
import '../../features/matching/presentation/discover_feed_screen.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/scenarios/presentation/living_style_result_screen.dart';
import '../../features/scenarios/presentation/scenario_test_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<AuthState>(ref.watch(authControllerProvider));

  ref.listen<AuthState>(authControllerProvider, (_, next) {
    authNotifier.value = next;
  });

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final auth = authNotifier.value;
      final location = state.matchedLocation;

      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/forgot-password';

      // 1. Unauthenticated users
      if (auth.status == AuthStatus.unauthenticated || auth.user == null) {
        return isAuthRoute ? null : '/login';
      }

      // 2. Email verification check
      final user = auth.user!;
      if (!user.isEmailVerified) {
        return location == '/verify-email' ? null : '/verify-email';
      }

      // 3. Authenticated & Verified
      if (isAuthRoute || location == '/verify-email') {
        final onboardingState = ref.read(onboardingControllerProvider);
        if (onboardingState.isCompleted) {
          return '/scenarios';
        }
        return '/onboarding';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/scenarios',
        name: 'scenarios',
        builder: (context, state) => const ScenarioTestScreen(),
        routes: [
          GoRoute(
            path: 'result',
            name: 'scenario-result',
            builder: (context, state) => const LivingStyleResultScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/discover',
        name: 'discover',
        builder: (context, state) => const DiscoverFeedScreen(),
      ),
      GoRoute(
        path: '/house-rules',
        name: 'house-rules',
        builder: (context, state) {
          final candidate = (state.extra as RoommateMatchCandidate?) ?? demoCandidates.first;
          return HouseRulesAgreementScreen(candidate: candidate);
        },
      ),
      GoRoute(
        path: '/chat-demo',
        name: 'chat-demo',
        builder: (context, state) {
          final candidate = (state.extra as RoommateMatchCandidate?) ?? demoCandidates.first;
          return ChatRoomDemoScreen(candidate: candidate);
        },
      ),
    ],
  );
});
