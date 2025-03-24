import 'package:excerbuys/components/shared/indicators/canvas/ellipse_painter.dart';
import 'package:excerbuys/components/shared/indicators/canvas/rectangle_painter.dart';
import 'package:excerbuys/components/shared/indicators/canvas/triangle_painter.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/user/profile_image.dart';
import 'package:excerbuys/utils/user/requests.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 100),
    );
  }
}
