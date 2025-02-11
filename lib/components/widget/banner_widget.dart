import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  final String imageUrl;

  const BannerWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: 100,
        height: 10,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class SlidingBannerWidget extends StatelessWidget {
  const SlidingBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView(
        children: [
          BannerWidget(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/electronicsrent-aa920.appspot.com/o/banner%2FheadPhone.png?alt=media&token=b6120ea6-38e5-45cb-96d4-031bdd55cf9d',
          ),
          BannerWidget(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/electronicsrent-aa920.appspot.com/o/banner%2Fsony.jpg?alt=media&token=5c4afeb4-eefa-427f-a84a-75dcc063450c',
          ),
          // BannerWidget(
          //   imageUrl:
          //       'https://firebasestorage.googleapis.com/v0/b/electronicsrent-aa920.appspot.com/o/banner%2F360_F_496471319_DbtjoUvKqyy2e9OfgBnK5mm2AXhKpa9m.jpg?alt=media&token=33634ba7-48cc-45ed-9a1c-addae90546b4',
          // ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: SlidingBannerWidget(),
      ),
    ),
  ));
}
