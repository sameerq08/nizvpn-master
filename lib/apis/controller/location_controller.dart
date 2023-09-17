import 'package:get/get.dart';

import '../../models/vpn.dart';
import '../apis.dart';

class LocationController extends GetxController {
  List<Vpn> vpnList = [];

  final RxBool isLoading = false.obs;

  Future<void> getVpnData() async {
    isLoading.value = true;
    vpnList.clear();
    vpnList = await APIs.getVPNServers();

    isLoading.value = false;
  }
}
