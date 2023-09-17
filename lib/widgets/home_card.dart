import 'package:flutter/material.dart';

late Size mq;

class HomeCard extends StatelessWidget {
  final String title, subtitle;
  final Widget icon;
  const HomeCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SizedBox(
      width: mq.width * .45,
      child: Column(
        children: [
          icon,
          const SizedBox(
            height: 6,
          ),
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 6,
          ),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
