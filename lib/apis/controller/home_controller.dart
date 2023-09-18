import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/vpn_engine.dart';

class HomeController extends GetxController {
  final vpnState = VpnEngine.vpnDisconnected.obs;

  final RxBool startTimer = false.obs;

  Future<void> initializedData() async {}

  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;
      case VpnEngine.vpnConnected:
        return Colors.green;
      default:
        return Colors.orangeAccent;
    }
  }

  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';
      case VpnEngine.vpnConnected:
        return 'Disconnect';
      default:
        return 'Connecting';
    }
  }
}
