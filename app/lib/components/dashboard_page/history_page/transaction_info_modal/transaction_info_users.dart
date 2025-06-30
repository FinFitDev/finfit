import 'dart:math';

import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:flutter/material.dart';

class TransactionInfoUsers extends StatelessWidget {
  final List<User> users;
  final double totalFinpoints;
  const TransactionInfoUsers(
      {super.key, required this.users, required this.totalFinpoints});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
            spacing: 8,
            children: users
                .map((user) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: PositionWithBackground(
                            name: user.username,
                            image: user.image,
                            textStyle: TextStyle(
                              color: colors.tertiaryContainer,
                              fontSize: 12,
                            ),
                            backgroundColor: colors.primary,
                          ),
                        ),
                        StreamBuilder<bool>(
                            stream: dashboardController.balanceHiddenStream,
                            builder: (context, snapshot) {
                              bool isHidden = snapshot.data ?? false;
                              return Text(
                                '${isHidden ? '*****' : ((totalFinpoints) / max(users.length, 1)).round()} finpoints',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colors.tertiaryContainer),
                              );
                            })
                      ],
                    ))
                .toList()));
  }
}
