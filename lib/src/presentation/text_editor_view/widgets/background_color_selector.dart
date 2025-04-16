import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';

class BackgroundColorSelector extends StatelessWidget {
  const BackgroundColorSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TextEditingNotifier>(
      builder: (context, editorNotifier, child) {
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
                  itemCount: _getBackgroundColors().length,
                  itemBuilder: (context, index) {
                    final color = _getBackgroundColors()[index];
                    return GestureDetector(
                      onTap: () {
                        // Set the background color
                        editorNotifier.backGroundColor = color;
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
                        child: color == Colors.transparent
                            ? const Icon(Icons.block, color: Colors.white54, size: 16)
                            : null,
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

  // Helper method to get the list of background colors
  List<Color> _getBackgroundColors() {
    return [
      Colors.transparent,
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];
  }
}
