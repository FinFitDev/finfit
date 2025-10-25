import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller/send_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UsersList extends StatelessWidget {
  final Map<String, User>? usersForSearch;
  final bool? isLoading;

  const UsersList({super.key, this.usersForSearch, this.isLoading});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return SingleChildScrollView(
        child: isLoading == true
            ? loadingUsers()
            : usersForSearch == null || usersForSearch!.isEmpty
                ? StreamBuilder<String?>(
                    stream: sendController.searchValueStream,
                    builder: (context, snapshot) {
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Container(
                          height: 500,
                          child: Center(
                            child: Text(
                              'No recent users.',
                              style: TextStyle(
                                color: colors.tertiaryContainer,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                      return emptyList(snapshot.data ?? '', colors, texts);
                    })
                : StreamBuilder<List<String>>(
                    stream: sendController.chosenUsersIdsStream,
                    builder: (context, snapshot) {
                      return StreamBuilder<List<String>>(
                          stream: sendController.recentRecipientsIdsStream,
                          builder: (context, recentUsersSnapshot) {
                            return Column(
                                children: usersForSearch!.entries.map((el) {
                              final value = el.value;
                              final key = el.key;

                              return userCard(colors, texts, value.username,
                                  value.email, value.image, () {
                                sendController.proccessSelectUser(key);
                              },
                                  (snapshot.data ?? []).contains(key),
                                  recentUsersSnapshot.data != null &&
                                      recentUsersSnapshot.data!.contains(key));
                            }).toList());
                          });
                    }));
  }
}

Widget userCard(
    ColorScheme colors,
    TextTheme texts,
    String name,
    String email,
    String? image,
    void Function() onPressed,
    bool? isSelected,
    bool? isRecent) {
  return RippleWrapper(
    onPressed: onPressed,
    child: Container(
      height: 70,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            spreadRadius: -5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ProfileImageGenerator(seed: image, size: 40),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.tertiaryContainer,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 12,
          ),
          isSelected == true
              ? Container(
                  padding: EdgeInsets.all(5),
                  child: SvgPicture.asset('assets/svg/tick.svg'),
                )
              : isRecent == true
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          child: SvgPicture.asset(
                            'assets/svg/clock.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink()
        ],
      ),
    ),
  );
}

Widget loadingUsers() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      UniversalLoaderBox(height: 70),
      SizedBox(
        height: 4,
      ),
      UniversalLoaderBox(height: 70),
      SizedBox(
        height: 4,
      ),
      UniversalLoaderBox(height: 70),
      SizedBox(
        height: 4,
      ),
      UniversalLoaderBox(height: 70),
    ],
  );
}

Widget emptyList(String query, ColorScheme colors, TextTheme texts) {
  return query.isNotEmpty
      ? RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: texts.headlineMedium
                ?.copyWith(color: colors.tertiaryContainer), // Default style
            children: [
              TextSpan(text: 'No results for query: '),
              TextSpan(
                text: query,
                style: texts.headlineMedium?.copyWith(
                    color: colors.secondary), // Different color for query
              ),
            ],
          ),
        )
      : SizedBox.shrink();
}
