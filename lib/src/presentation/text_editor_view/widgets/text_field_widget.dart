// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/text_editor_view/text_editor.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil();
    FocusNode textNode = FocusNode();
    // Ottieni il valore di isMandatory dall'InheritedWidget TextEditor
    final bool isMandatory = context.findAncestorWidgetOfExactType<TextEditor>()?.isMandatory ?? false;
    
    return Consumer2<TextEditingNotifier, ControlNotifier>(
      builder: (context, editorNotifier, controlNotifier, child) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenUtil.screenWidth - 100,
            ),
            child: IntrinsicWidth(
                child: Stack(
              alignment: Alignment.center,
              children: [
                // We only need one text rendering since we're fixing the background
                _textField(
                  editorNotifier: editorNotifier,
                  textNode: textNode,
                  controlNotifier: controlNotifier,
                  isMandatory: isMandatory,
                )
              ],
            )),
          ),
        );
      },
    );
  }

  Widget _textField({
    required TextEditingNotifier editorNotifier,
    required FocusNode textNode,
    required ControlNotifier controlNotifier,
    required bool isMandatory,
  }) {
    // Get the contrasting text color (black or white) based on background brightness
    Color textColor = isMandatory 
        ? editorNotifier.getTextColorForBackground() 
        : controlNotifier.colorList![editorNotifier.textColor];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // Only apply background if it's not transparent
        color: editorNotifier.backGroundColor != Colors.transparent 
            ? editorNotifier.backGroundColor 
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        focusNode: textNode,
        autofocus: true,
        textInputAction: TextInputAction.newline,
        controller: editorNotifier.textController,
        textAlign: editorNotifier.textAlign,
        style: TextStyle(
          fontFamily: controlNotifier.fontList![editorNotifier.fontFamilyIndex],
          package: controlNotifier.isCustomFontList ? null : 'stories_editor',
          color: textColor,
          fontSize: editorNotifier.textSize,
          // Add shadows for better visibility
          shadows: <Shadow>[
            Shadow(
              offset: const Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: textColor == Colors.black ? Colors.white38 : Colors.black38
            )
          ],
        ),
        cursorColor: textColor,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          editorNotifier.text = value;
        },
      ),
    );
  }
}
