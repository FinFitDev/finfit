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
    final texts = Theme.of(context).textTheme;

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

Widget userCard(
    int index, ColorScheme colors, String name, void Function() onPressed) {
  return Container(
    margin: EdgeInsets.only(right: 8),
    child: GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://imageupscaler.com/wp-content/uploads/2024/07/deblured-cutty-fox.jpg'))),
            ),
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
