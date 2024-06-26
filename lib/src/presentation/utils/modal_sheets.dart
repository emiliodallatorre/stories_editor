import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/generated/l10n.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/domain/sevices/save_as_image.dart';
import 'package:stories_editor/src/presentation/utils/Extensions/hex_color.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

/// create item of type GIF
Future createGiphyItem({required BuildContext context, required giphyKey}) async {
  final editableItem = Provider.of<DraggableWidgetNotifier>(context, listen: false);
  editableItem.giphy = await ModalGifPicker.pickModalSheetGif(
    context: context,
    apiKey: giphyKey,
    rating: GiphyRating.r,
    sticker: true,
    backDropColor: Colors.black,
    crossAxisCount: 3,
    childAspectRatio: 1.2,
    topDragColor: Colors.white.withOpacity(0.2),
  );

  /// create item of type GIF
  if (editableItem.giphy != null) {
    editableItem.editableItems.add(EditableItem(
      type: ItemType.gif,
      position: const Offset(0.0, 0.0),
    )..gif = editableItem.giphy!);
  }
}

/// custom exit dialog
Future<bool> exitDialog({required context, required contentKey}) async {
  return (await showDialog(
        context: context,
        barrierColor: Colors.black38,
        barrierDismissible: true,
        builder: (c) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetAnimationDuration: const Duration(milliseconds: 300),
          insetAnimationCurve: Curves.ease,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.only(top: 25, bottom: 5, right: 20, left: 20),
                alignment: Alignment.center,
                // height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: HexColor.fromHex('#262626'),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.white10, offset: Offset(0, 1), blurRadius: 4),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      S.of(context).discardEdits,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).discardEditsExtended,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white54, letterSpacing: 0.1),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    /// discard
                    AnimatedOnTapButton(
                      onTap: () async {
                        _resetDefaults(context: context);
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        S.of(context).discard,
                        style: TextStyle(fontSize: 16, color: Colors.redAccent.shade200, fontWeight: FontWeight.bold, letterSpacing: 0.1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                      child: Divider(
                        color: Colors.white10,
                      ),
                    ),

                    /// save and exit
                    AnimatedOnTapButton(
                      onTap: () async {
                        final paintingProvider = Provider.of<PaintingNotifier>(context, listen: false);
                        final widgetProvider = Provider.of<DraggableWidgetNotifier>(context, listen: false);
                        if (paintingProvider.lines.isNotEmpty || widgetProvider.editableItems.isNotEmpty) {
                          /// save image
                          var response = await takePicture(contentKey: contentKey, context: context, saveToGallery: true);
                          if (response) {
                            _dispose(context: context, message: S.of(context).successfullySaved);
                          } else {
                            _dispose(context: context, message: S.of(context).error);
                          }
                        } else {
                          _dispose(context: context, message: S.of(context).nothingToSave);
                        }
                      },
                      child: Text(
                        S.of(context).saveDraft,
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                      child: Divider(
                        color: Colors.white10,
                      ),
                    ),

                    ///cancel
                    AnimatedOnTapButton(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        S.of(context).cancel,
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )) ??
      false;
}

_resetDefaults({required BuildContext context}) {
  final paintingProvider = Provider.of<PaintingNotifier>(context, listen: false);
  final widgetProvider = Provider.of<DraggableWidgetNotifier>(context, listen: false);
  final controlProvider = Provider.of<ControlNotifier>(context, listen: false);
  final editingProvider = Provider.of<TextEditingNotifier>(context, listen: false);
  paintingProvider.lines.clear();
  widgetProvider.editableItems.clear();
  widgetProvider.setDefaults();
  paintingProvider.resetDefaults();
  editingProvider.setDefaults();
  controlProvider.mediaPath = '';
}

_dispose({required context, required message}) {
  _resetDefaults(context: context);
  Fluttertoast.showToast(msg: message);
  Navigator.of(context).pop(true);
}
