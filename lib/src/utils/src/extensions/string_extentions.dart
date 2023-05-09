import 'package:flutter/material.dart';

import '../../../localization/app_locallization.dart';

extension StringExtension on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? '';
  }
}