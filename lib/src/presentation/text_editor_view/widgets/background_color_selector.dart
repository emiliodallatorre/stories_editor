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
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Color selection grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, 
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final color = colors[index];
                    return GestureDetector(
                      onTap: () {
                        // Imposta il colore di sfondo usando il metodo specifico per testo obbligatorio
                        editorNotifier.setMandatoryTextBackgroundColor(color);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color: editorNotifier.backGroundColor == color
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
