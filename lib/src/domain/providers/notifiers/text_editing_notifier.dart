import 'package:flutter/material.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';

class TextEditingNotifier extends ChangeNotifier {
  String _text = '';
  List<String> _textList = [];
  int _textColor = 0;
  double _textSize = 25.0;
  int _fontFamilyIndex = 0;
  int _fontAnimationIndex = 0;
  TextAlign _textAlign = TextAlign.center;
  Color _backGroundColor = Colors.transparent;
  TextAnimationType _animationType = TextAnimationType.none;
  bool _isFontFamily = true;
  bool _isTextAnimation = false;
  bool _isBackgroundColorSelection = false;

  PageController _fontFamilyController = PageController(viewportFraction: .125);
  PageController _textAnimationController =
      PageController(viewportFraction: .125);
  TextEditingController _textController = TextEditingController();

  int _currentColorBackground = 0;
  // Colori standard per i testi normali (NON obbligatori)
  final List<Color> _textColorBackGround = [
    Colors.transparent,
    Colors.black,
    Colors.white
  ];
  
  // Colori per il testo obbligatorio (senza transparent, black, white)
  final List<Color> _mandatoryTextBackgroundColors = [
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

  int _currentAlign = 0;
  final List<TextAlign> _texAlignment = [
    TextAlign.center,
    TextAlign.right,
    TextAlign.left
  ];

  int _currentAnimation = 0;
  final List<TextAnimationType> animationList = [
    TextAnimationType.none,
    TextAnimationType.fade,
    TextAnimationType.typer,
    TextAnimationType.typeWriter,
    TextAnimationType.scale,
    //TextAnimationType.colorize,
    TextAnimationType.wavy,
    TextAnimationType.flicker
  ];

  String get text => _text;
  int get textColor => _textColor;
  double get textSize => _textSize;
  int get fontFamilyIndex => _fontFamilyIndex;
  int get fontAnimationIndex => _fontAnimationIndex;
  TextAlign get textAlign => _textAlign;
  Color get backGroundColor => _backGroundColor;
  TextAnimationType get animationType => _animationType;
  bool get isFontFamily => _isFontFamily;
  bool get isTextAnimation => _isTextAnimation;
  bool get isBackgroundColorSelection => _isBackgroundColorSelection;
  PageController get fontFamilyController => _fontFamilyController;
  PageController get textAnimationController => _textAnimationController;
  TextEditingController get textController => _textController;
  List<String> get textList => _textList;

  set text(String text) {
    _text = text;
    notifyListeners();
  }

  set textColor(int color) {
    if (_backGroundColor == Colors.white && color == 0) {
      _textColor = 1;
      notifyListeners();
    } else if (_backGroundColor == Colors.black && color == 1) {
      _textColor = 0;
      notifyListeners();
    } else {
      _textColor = color;
      notifyListeners();
    }
  }

  set textSize(double size) {
    _textSize = size;
    notifyListeners();
  }

  set fontFamilyIndex(int fontIndex) {
    _fontFamilyIndex = fontIndex;
    notifyListeners();
  }

  set fontAnimationIndex(int fontIndex) {
    _fontAnimationIndex = fontIndex;
    notifyListeners();
  }

  set isFontFamily(bool isFamily) {
    _isFontFamily = isFamily;
    notifyListeners();
  }

  set isTextAnimation(bool isAnimation) {
    _isTextAnimation = isAnimation;
    notifyListeners();
  }
  
  set isBackgroundColorSelection(bool isSelection) {
    _isBackgroundColorSelection = isSelection;
    notifyListeners();
  }

  set fontFamilyController(PageController controller) {
    _fontFamilyController = controller;
    notifyListeners();
  }

  set textAnimationController(PageController controller) {
    _textAnimationController = controller;
    notifyListeners();
  }

  set textController(TextEditingController textController) {
    _textController = textController;
    notifyListeners();
  }

  set backGroundColor(Color backGround) {
    _backGroundColor = backGround;
    // Automatically set text color based on background brightness
    if (_backGroundColor != Colors.transparent) {
      _textColor = _getContrastingTextColor(_backGroundColor) == Colors.white ? 0 : 1;
    }
    notifyListeners();
  }

  set textAlign(TextAlign align) {
    _textAlign = align;
    notifyListeners();
  }

  set textList(List<String> list) {
    _textList = list;
    notifyListeners();
  }

  set animationType(TextAnimationType animation) {
    _animationType = animation;
    notifyListeners();
  }

  // Metodo per cambiare il colore di sfondo per i testi NON obbligatori
  onBackGroundChange() {
    if (_currentColorBackground < _textColorBackGround.length - 1) {
      _currentColorBackground += 1;
      _backGroundColor = _textColorBackGround[_currentColorBackground];
      if (_backGroundColor != Colors.transparent) {
        _textColor = _getContrastingTextColor(_backGroundColor) == Colors.white ? 0 : 1;
      }
      notifyListeners();
    } else {
      _currentColorBackground = 0;
      _backGroundColor = _textColorBackGround[_currentColorBackground];
      notifyListeners();
    }
  }
  
  // Imposta il colore di sfondo per il testo obbligatorio
  void setMandatoryTextBackgroundColor(Color color) {
    _backGroundColor = color;
    // Automatically set text color based on background brightness
    if (_backGroundColor != Colors.transparent) {
      _textColor = _getContrastingTextColor(_backGroundColor) == Colors.white ? 0 : 1;
    }
    notifyListeners();
  }
  
  // Restituisce la lista di colori per lo sfondo del testo obbligatorio
  List<Color> getMandatoryTextBackgroundColors() {
    return _mandatoryTextBackgroundColors;
  }

  onAlignmentChange() {
    if (_currentAlign < _texAlignment.length - 1) {
      _currentAlign += 1;
      _textAlign = _texAlignment[_currentAlign];
      notifyListeners();
    } else {
      _currentAlign = 0;
      _textAlign = _texAlignment[_currentAlign];
      notifyListeners();
    }
  }

  onAnimationChange() {
    if (_currentAnimation < animationList.length - 1) {
      _currentAnimation += 1;
      _animationType = animationList[_currentAnimation];
      notifyListeners();
    } else {
      _currentAnimation = 0;
      _animationType = animationList[_currentAnimation];
      notifyListeners();
    }
  }

  setDefaults() {
    _text = '';
    _textController.text = '';
    _textColor = 0;
    _textSize = 20.0;
    _fontFamilyIndex = 0;
    _fontAnimationIndex = 0;
    _textAlign = TextAlign.center;
    _backGroundColor = Colors.transparent;
    _fontFamilyController = PageController(viewportFraction: .125);
    _textAnimationController = PageController(viewportFraction: .125);
    _isFontFamily = true;
    _isTextAnimation = false;
    _isBackgroundColorSelection = false;
    _textList = [];
    _animationType = TextAnimationType.none;
  }

  disposeController() {
    _textController.dispose();
    _fontFamilyController.dispose();
    _textAnimationController.dispose();
  }
  
  // Helper method to determine if text should be white or black based on background color
  Color _getContrastingTextColor(Color backgroundColor) {
    double luminance = (0.299 * backgroundColor.red + 
                        0.587 * backgroundColor.green + 
                        0.114 * backgroundColor.blue) / 255;
    
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
  
  // Get appropriate text color for a background
  Color getTextColorForBackground() {
    if (_backGroundColor == Colors.transparent) {
      return Colors.white; // Default white for transparent background
    }
    return _getContrastingTextColor(_backGroundColor);
  }
}
