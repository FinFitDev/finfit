import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class ChosenRecipientsList extends StatefulWidget {
  final Map<String, User> selectedUsers;
  final bool? disallowChange;
  const ChosenRecipientsList(
      {super.key, required this.selectedUsers, this.disallowChange});

  @override
  State<ChosenRecipientsList> createState() => _ChosenRecipientsListState();
}

class _ChosenRecipientsListState extends State<ChosenRecipientsList> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.selectedUsers.length,
        itemBuilder: (context, index) {
          final entry = widget.selectedUsers.entries.elementAt(index);

          return userCard(
              index,
              colors,
              entry.value.username,
              entry.value.image,
              widget.disallowChange == true
                  ? () {}
                  : () {
                      sendController.proccessSelectUser(entry.key);
                    });
        },
      ),
    );
  }
}

Widget userCard(int index, ColorScheme colors, String name, String? image,
    void Function() onPressed) {
  return Container(
    margin: EdgeInsets.only(right: 8),
    child: GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileImageGenerator(seed: image, size: 50),
            SizedBox(
              height: 8,
            ),
            Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11,
                  color: colors.tertiaryContainer,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    ),
  );
}
