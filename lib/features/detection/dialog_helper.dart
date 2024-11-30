import 'package:flutter/material.dart';
import 'dialog_fullscreen.dart';

void showLabelResultDialog(
  BuildContext context,
  Map<String, List<String>> categorizedLabels,
) {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => DialogFullscreen(
        labels: categorizedLabels,
      ),
    ),
  );
}
