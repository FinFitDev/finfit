import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/store/controllers/activity/strava_controller/strava_controller.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

class StravaTogglePosition extends StatelessWidget {
  const StravaTogglePosition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colors.primaryContainer),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ImageComponent(
              size: 24,
              image:
                  "https://images.prismic.io/sacra/9232e343-6544-430f-aacd-ca85f968ca87_strava+logo.png?auto=compress,format",
            ),
          ),
          Expanded(
            child: Text('STRAVA Integration',
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 90, 7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
          StreamBuilder<bool>(
              stream: stravaController.enabledStream,
              builder: (context, snapshot) {
                return FlutterSwitch(
                  width: 50.0,
                  height: 25.0,
                  value: snapshot.data == true,
                  borderRadius: 30.0,
                  activeColor: const Color.fromARGB(255, 255, 90, 7),
                  inactiveColor: colors.tertiaryContainer.withAlpha(100),
                  padding: 3.0,
                  showOnOff: false,
                  onToggle: (val) {
                    stravaController.updateEnabled(val);
                  },
                );
              }),
        ],
      ),
    );
  }
}
