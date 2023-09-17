import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:http/http.dart';

import '../helpers/my_dialogs.dart';
import '../models/vpn.dart';

class APIs {
  static Future<List<Vpn>> getVPNServers() async {
    final List<Vpn> vpnList = [];

    try {
      final res = await get(Uri.parse('http://www.vpngate.net/api/iphone/'));
      final csvString = res.body.split("#")[1].replaceAll('*', '');

      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);

      final header = list[0];

      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};

        for (int j = 0; j < header.length; ++j) {
          tempJson.addAll({header[j].toString(): list[i][j]});
        }
        vpnList.add(Vpn.fromJson(tempJson));
      }
    } catch (e) {
      MyDialogs.error(msg: e.toString());
      log('\ngetVPNServersE: $e');
    }
    vpnList.shuffle();

    //if (vpnList.isNotEmpty) //Pref.vpnList = vpnList;

    return vpnList;
  }
}
