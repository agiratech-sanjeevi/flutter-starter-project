import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import '../../ui_utils/app_snack_bar.dart';

class NetworkCheck {
  Future<bool> check() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<void> checkNetworkAndShowSnackBar(BuildContext context) async {
    bool isNetWorkAvailable = await check();
    if (!isNetWorkAvailable) {
      // ignore: use_build_context_synchronously
      AppSnackBar(
          message: 'Check Your Internet Connection',
          actionText: 'Ok',
          onPressed: () => {}).showAppSnackBar(context);
    }
  }

  void showNoInternetMessage(BuildContext context) {
    AppSnackBar(
        message: 'Check Your Internet Connection',
        actionText: 'Ok',
        onPressed: () => {}).showAppSnackBar(context);
  }
}
