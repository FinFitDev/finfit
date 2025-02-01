import 'package:excerbuys/components/loaders/universal_loader_box.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class NewsContainer extends StatefulWidget {
  final bool? isLoading;
  const NewsContainer({super.key, this.isLoading});

  @override
  State<NewsContainer> createState() => _NewsContainerState();
}

class _NewsContainerState extends State<NewsContainer> {
  Widget get loadingContainer {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
      child: UniversalLoaderBox(
          height: 230,
          width: MediaQuery.sizeOf(context).width - 2 * HORIZOTAL_PADDING),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colors.tertiary,
                  ),
                ),
              ],
            ),
          ),
          widget.isLoading == true
              ? loadingContainer
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 6,
                      ),
                      newsCard(1, colors, 'Updates', () {}),
                      newsCard(2, colors, 'Collabs', () {}),
                      newsCard(3, colors, 'Arrivals', () {}),
                      newsCard(4, colors, 'Blog', () {}),
                      newsCard(3, colors, 'Arrivals', () {}),
                      newsCard(4, colors, 'Blog', () {}),
                      SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

Widget newsCard(
    int index, ColorScheme colors, String name, void Function() onPressed) {
  return RippleWrapper(
    onPressed: onPressed,
    child: Container(
      width: 90,
      padding: EdgeInsets.symmetric(vertical: HORIZOTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.pinkAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
              ),
              Positioned(
                left: 2.5,
                top: 2.5,
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colors.primaryContainer),
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    ),
  );
}
