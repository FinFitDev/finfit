import 'package:excerbuys/components/dashboard_page/send/chosen_recipients_list.dart';
import 'package:excerbuys/components/dashboard_page/send/users_list.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/containers/dashboard_page/modals/send/qrscanner_modal.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller/send_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:flutter/material.dart';

class ChooseRecipientsModal extends StatefulWidget {
  final void Function() nextPage;
  const ChooseRecipientsModal({super.key, required this.nextPage});

  @override
  State<ChooseRecipientsModal> createState() => _ChooseRecipientsModalState();
}

class _ChooseRecipientsModalState extends State<ChooseRecipientsModal> {
  final Debouncer _debouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    if (sendController.recentRecipientsIds.isEmpty) {
      sendController.loadRecentRecipients();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ModalContentWrapper(
      padding: EdgeInsets.only(
          bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ModalHeader(
            title: 'Send finpoints',
            subtitle: 'Choose recipients',
            onClose: () {
              closeModal(context);
            },
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: InputWithIcon(
              placeholder: 'Find users',
              onChange: (val) {
                _debouncer.run(() {
                  sendController.setSearchValue(val);
                });
              },
              rightIcon: 'assets/svg/scan.svg',
              borderRadius: 10,
              verticalPadding: 12,
              onPressRightIcon: () => openModal(context, QrscannerModal()),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          StreamBuilder<List<String>>(
              stream: sendController.chosenUsersIdsStream,
              builder: (context, listSnapshot) {
                return StreamBuilder<ContentWithLoading<Map<String, User>>>(
                    stream: sendController.selectedUsersStream,
                    builder: (context, snapshot) {
                      return snapshot.hasData &&
                              snapshot.data!.content.isNotEmpty
                          ? Column(
                              children: [
                                ChosenRecipientsList(
                                  selectedUsers: snapshot.data!.content,
                                ),
                              ],
                            )
                          : SizedBox.shrink();
                    });
              }),
          Expanded(
              child: StreamBuilder<ContentWithLoading<Map<String, User>>>(
                  stream: sendController.usersForSearchStream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: HORIZOTAL_PADDING),
                      child: UsersList(
                        usersForSearch: snapshot.data?.content,
                        isLoading: snapshot.data?.isLoading,
                      ),
                    );
                  })),
          SizedBox(
            height: 16,
          ),
          StreamBuilder<List<String>>(
              stream: sendController.chosenUsersIdsStream,
              builder: (context, snapshot) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
                  child: MainButton(
                      isDisabled: !snapshot.hasData || snapshot.data!.isEmpty,
                      label: 'Confirm recipients',
                      backgroundColor: colors.secondary,
                      textColor: colors.primary,
                      onPressed: () {
                        widget.nextPage();
                      }),
                );
              })
        ],
      ),
    );
  }
}
