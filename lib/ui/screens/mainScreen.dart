//import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:open_nizvpn/core/models/dnsConfig.dart';
//import 'package:open_nizvpn/core/models/vpnConfig.dart';
//import 'package:open_nizvpn/core/models/vpnStatus.dart';
//import 'package:open_nizvpn/core/utils/nizvpn_engine.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:open_nizvpn/screens/location_screen.dart';
import 'package:open_nizvpn/widgets/count_down_timer.dart';
import 'package:open_nizvpn/widgets/home_card.dart';

import '../../apis/controller/home_controller.dart';

import '../../models/vpn_config.dart';
import '../../models/vpn_status.dart';
import '../../services/vpn_engine.dart';

late Size mq;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //String _controller.vpnState.value = NizVpn.vpnDisconnected;
  //List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;

  final _controller = HomeController();

  //final RxBool _controller.startTimerr = false.obs;

  @override
  void initState() {
    super.initState();

    ///Add listener to update vpnstate
    VpnEngine.vpnStageSnapshot().listen((event) {
      //setState(() {
      _controller.vpnState.value = event;
      //});
    });

    ///Call initVpn
    //initVpn();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/*
  ///Here you can start fill the listVpn, for this simple app, i'm using free vpn from https://www.vpngate.net/
  void initVpn() async {
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString("assets/vpn/japan.ovpn"),
        name: "Japan"));
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString("assets/vpn/us.ovpn"),
        name: "United State"));
    if (mounted)
      setState(() {
        _selectedVpn = _listVpn.first;
      });
  }*/

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text("Secure Proxy VPN"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.brightness_medium,
              size: 26,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 8),
            onPressed: () {},
            icon: Icon(
              Icons.info,
              size: 26,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _changeLocation(),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Obx(() => _vpnButton()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeCard(
              title: 'Country',
              subtitle: 'Free',
              icon: CircleAvatar(
                radius: 30,
                child: Icon(
                  Icons.vpn_lock_rounded,
                  size: 30,
                ),
              ),
            ),
            HomeCard(
              title: '100 ms',
              subtitle: 'Ping',
              icon: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.equalizer_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        StreamBuilder<VpnStatus?>(
          initialData: VpnStatus(),
          stream: VpnEngine.vpnStatusSnapshot(),
          builder: (context, snapshot) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //download
              HomeCard(
                  title: '${snapshot.data?.byteIn ?? '0 kbps'}',
                  subtitle: 'DOWNLOAD',
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.lightGreen,
                    child: Icon(Icons.arrow_downward_rounded,
                        size: 30, color: Colors.white),
                  )),

              //upload
              HomeCard(
                  title: '${snapshot.data?.byteOut ?? '0 kbps'}',
                  subtitle: 'UPLOAD',
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.arrow_upward_rounded,
                        size: 30, color: Colors.white),
                  )),
            ],
          ),
        ),
      ]),
    );
  }

  void _connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_controller.vpnState.value == VpnEngine.vpnDisconnected) {
      ///Start if stage is disconnected
      VpnEngine.startVpn(
        _selectedVpn!,
        //dns: DnsConfig("23.253.163.53", "198.101.242.72"),
      );
      _controller.startTimer.value = true;
    } else {
      ///Stop if stage is "not" disconnected
      _controller.startTimer.value = false;

      VpnEngine.stopVpn();
    }
  }

  // VPN Button
  Widget _vpnButton() => Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _connectClick();
                //_controller.startTimer.value = !_controller.startTimer.value;
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _controller.getButtonColor.withOpacity(0.1),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(0.3),
                  ),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          size: 28,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          _controller.getButtonText,
                          style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : _controller.vpnState.replaceAll('_', ' ').toLowerCase(),
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.white,
              ),
            ),
          ),
          Obx(() => CountDownTimer(startTimer: _controller.startTimer.value)),
        ],
      );
  Widget _changeLocation() => SafeArea(
        child: Semantics(
          button: true,
          child: InkWell(
            onTap: () => Get.to(() => LocationScreen()),
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.globe,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Change Location',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
