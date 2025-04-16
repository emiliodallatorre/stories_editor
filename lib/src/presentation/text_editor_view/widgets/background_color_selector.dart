import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';

class BackgroundColorSelector extends StatelessWidget {
  const BackgroundColorSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TextEditingNotifier>(
      builder: (context, editorNotifier, child) {
        // Ottieni la lista di colori per testo obbligatorio
        final colors = editorNotifier.getMandatoryTextBackgroundColors();
        
        return Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    // Imposta il colore di sfondo usando il metodo specifico per testo obbligatorio
                    editorNotifier.setMandatoryTextBackgroundColor(color);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: editorNotifier.backGroundColor == color
                            ? Colors.white
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
