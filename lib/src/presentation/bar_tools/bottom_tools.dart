import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_video_trimmer/flutter_native_video_trimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/domain/sevices/save_as_image.dart';
import 'package:stories_editor/src/presentation/draggable_items/video_player_wrapper.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

class BottomTools extends StatelessWidget {
  final GlobalKey contentKey;
  final Function(String contentUri) onDone;
  final Widget? onDoneButtonStyle;
  final List<EditableItem> editableItems;
  final String? mediaPath;

  /// editor background color
  final Color? editorBackgroundColor;

  const BottomTools({
    Key? key,
    required this.contentKey,
    required this.editableItems,
    required this.onDone,
    this.mediaPath,
    this.onDoneButtonStyle,
    this.editorBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier, __) {
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// preview gallery
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: _preViewContainer(
                        /// if [model.imagePath] is null/empty return preview image
                        child: controlNotifier.mediaPath.isEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () {
                                    /// scroll to gridView page
                                    if (controlNotifier.mediaPath.isEmpty) {
                                      scrollNotifier.pageController.animateToPage(
                                        1,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                      );
                                    }
                                  },
                                  child: const CoverThumbnail(
                                    thumbnailQuality: 150,
                                    requestType: RequestType.common,
                                  ),
                                ),
                              )

                            /// return clear [imagePath] provider
                            : GestureDetector(
                                onTap: () {
                                  /// clear image url variable
                                  controlNotifier.mediaPath = '';
                                  itemNotifier.editableItems.removeAt(0);
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  color: Colors.transparent,
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                /// center logo
                if (controlNotifier.middleBottomWidget != null)
                  Expanded(
                    child: Center(
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          child: controlNotifier.middleBottomWidget),
                    ),
                  )
                else
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/instagram_logo.png',
                            package: 'stories_editor',
                            color: Colors.white,
                            height: 42,
                          ),
                          const Text(
                            'Stories Creator',
                            style: TextStyle(
                                color: Colors.white38,
                                letterSpacing: 1.5,
                                fontSize: 9.2,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                /// save final image to gallery
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 0.9,
                      child: AnimatedOnTapButton(
                          onTap: () async {
                            if (editableItems.any((final EditableItem item) => item.type == ItemType.video)) {
                              assert(editableItems.where((final EditableItem item) => item.type == ItemType.video).length == 1,
                                  'Only one video is allowed in the story');
                              assert(mediaPath != null, 'Media path is required for video trimming');

                              final EditableItem video = editableItems.firstWhere((final EditableItem item) => item.type == ItemType.video);

                              final VideoTrimmer trimmer = VideoTrimmer();
                              await trimmer.loadVideo(mediaPath!);
                              final String await trimmer.trimVideo(
                                  startTimeMs: 0,
                                  endTimeMs: VideoPlayerWrapper.maxVideoDuration.inMilliseconds,
                                  videoFileName: "${randomAlphaNumeric(20)}.mp4",
                                  onSave: (final String? output) {
                                    if (output == null || output.isEmpty) {
                                      throw Exception('Error saving video');
                                    }

                                    onDone(output);
                                  });

                              return;
                            }

                            // Image management
                            String pngUri;
                            await takePicture(
                                    contentKey: contentKey,
                                    context: context,
                                    saveToGallery: false)
                                .then((bytes) {
                              if (bytes != null) {
                                pngUri = bytes;
                                onDone(pngUri);
                              } else {
                                throw Exception('Error saving image');
                              }
                            });
                          },
                          child: onDoneButtonStyle ??
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 5, top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.white, width: 1.5)),
                                child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Share',
                                        style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ]),
                              )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }
}
