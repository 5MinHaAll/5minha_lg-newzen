// device.dart
import 'dart:core';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newzen/features/byproduct/byproduct_manager.dart';
import 'package:newzen/theme/app_text.dart';
import '../../components/appbar_default.dart';
import '../../components/sliding_segment_control.dart';
import '../../data/generate_data.dart';
import '../../features/device/device_operation.dart';
import '../../features/device/demo_fab_manager.dart';
import '../../theme/app_colors.dart';
import '../functions/functions.dart';

class DeviceOn extends StatefulWidget {
  const DeviceOn({Key? key}) : super(key: key);

  @override
  _DeviceOnState createState() => _DeviceOnState();
}
