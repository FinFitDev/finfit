import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/store/controllers/shop/offers_controller/offers_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OffersTopContainer extends StatefulWidget {
  OffersTopContainer({super.key});

  @override
  State<OffersTopContainer> createState() => _OffersTopContainerState();
}

class _OffersTopContainerState extends State<OffersTopContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Rewards & offers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 4),
          Text(
            "Discover exclusive rewards just for you!",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: colors.primaryFixedDim),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16),
          InputWithIcon(
              placeholder: 'Search offers',
              borderRadius: 10,
              verticalPadding: 12,
              rightIcon: 'assets/svg/search.svg',
              onChange: (e) {
                _debouncer.run(() {
                  offersController.setSearchQuery(e);
                });
              }),
          SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.secondary,
                  Color.fromARGB(255, 165, 177, 255),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  spreadRadius: -5,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Available points',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colors.primary.withAlpha(200)),
                        ),
                        StreamBuilder<double?>(
                            stream: userController.userBalanceStream,
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data == null
                                    ? '0'
                                    : formatNumber(snapshot.data!.round()),
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    'assets/svg/stars_featured.svg',
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                        colors.primary.withAlpha(200), BlendMode.srcIn),
                    width: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
