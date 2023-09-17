import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../apis/controller/location_controller.dart';

late Size mq;

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _controller = LocationController();
  @override
  void initState() {
    super.initState();
    _controller.getVpnData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Secure Proxy VPN"),
      ),
      body: Obx(() => _controller.isLoading.value
          ? _loadingWidget()
          : _controller.vpnList.isEmpty
              ? _noVPNFound()
              : _vpnData()),
    );
  }

  _vpnData() => ListView.builder(
        itemCount: _controller.vpnList.length,
        itemBuilder: (ctx, i) => Text(_controller.vpnList[i].hostname),
      );

  _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/lottie/loading.json',
                width: mq.width * .7),
            Text(
              'Loading VPN...',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
  _noVPNFound() => Center(
        child: Text(
          'No VPN Found...',
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      );
}
