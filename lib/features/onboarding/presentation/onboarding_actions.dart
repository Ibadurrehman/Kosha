import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../data/profile_repository_impl.dart';

/// Marks onboarding done and lands on Home — used by every step's "Skip" and
/// by the last step once its job is done. Completing first (rather than just
/// navigating) matters: the router's redirect sends an incomplete profile
/// straight back to onboarding, so leaving without this call would bounce.
Future<void> finishOnboarding(BuildContext context, WidgetRef ref) async {
  await ref.read(profileRepositoryProvider).completeOnboarding();
  if (context.mounted) context.go(Routes.home);
}
