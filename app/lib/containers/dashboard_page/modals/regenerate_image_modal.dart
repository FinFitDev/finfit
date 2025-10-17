import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';
import 'package:uuid/uuid.dart';

class RegenerateImageModal extends StatefulWidget {
  const RegenerateImageModal({super.key});

  @override
  State<RegenerateImageModal> createState() => _RegenerateImageModalState();
}

class _RegenerateImageModalState extends State<RegenerateImageModal> {
  String? _seed;
  List<String> _randomSeeds = [];

  List<String> generateUUIDs({int count = 5}) {
    return List.generate(count, (_) => UuidV4().generate());
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _seed = userController.currentUser?.image;
    });

    setState(() {
      _randomSeeds = generateUUIDs(count: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ModalContentWrapper(
        title: 'Change image',
        onClose: () {
          closeModal(context);
        },
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: Column(
                children: [
                  ProfileImageGenerator(
                      seed: _seed,
                      size: MediaQuery.sizeOf(context).width -
                          8 * HORIZOTAL_PADDING),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _randomSeeds
                          .map(
                            (seed) => Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RippleWrapper(
                                    onPressed: () {
                                      setState(() {
                                        _seed = seed;
                                      });
                                    },
                                    child: ProfileImageGenerator(
                                      seed: seed,
                                      size: 50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 16,
                ),
                MainButton(
                    label: 'Regenerate image',
                    icon: 'assets/svg/reload.svg',
                    backgroundColor: colors.primaryContainer,
                    textColor: colors.primaryFixedDim,
                    onPressed: () {
                      setState(() {
                        _seed = UuidV4().generate();
                      });
                    }),
                SizedBox(
                  height: 8,
                ),
                MainButton(
                    isDisabled: _seed == userController.currentUser?.image,
                    label: 'Save image',
                    backgroundColor: colors.secondary,
                    textColor: colors.primary,
                    onPressed: () async {
                      final bool successfulUpdate =
                          await userController.fetchUpdateUserImage(_seed);
                      if (mounted && successfulUpdate) {
                        Navigator.pop(context);
                      }
                    }),
              ],
            )
          ],
        ));
  }
}
