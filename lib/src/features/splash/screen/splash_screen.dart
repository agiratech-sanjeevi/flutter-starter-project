import 'package:flutter_starter_project/src/ui_utils/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../services/connectivity_service_provider.dart/connectivity_service_provider.dart';
import '../../../utils/utils.dart';
import '../../../constants/string_constants.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen<AsyncValue<ConnectionStatus>>(
      connectionStreamProvider,
      (prevState, newState) {
        newState.whenOrNull(
          data: (status) {
            String message = status == ConnectionStatus.disconnected
                ? 'Your Disconnected'
                : 'Your Back Online';
            AppSnackBar(isPositive: true, message: message)
                .showAppSnackBar(context);
          },
        );
      },
    );
    return Scaffold(
      body: Container(
          color: AppColors.primaryColor,
          child: Center(child: Text(StringConstants.appName.tr(context)))),
    );
  }
}
