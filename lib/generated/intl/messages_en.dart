// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "discard": MessageLookupByLibrary.simpleMessage("Discard"),
        "discardEdits": MessageLookupByLibrary.simpleMessage("Discard Edits?"),
        "discardEditsExtended": MessageLookupByLibrary.simpleMessage(
            "If you go back now, you\'ll lose all the edits you\'ve made."),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "nothingToSave":
            MessageLookupByLibrary.simpleMessage("Nothing to Save"),
        "saveDraft": MessageLookupByLibrary.simpleMessage("Save Draft"),
        "successfullySaved":
            MessageLookupByLibrary.simpleMessage("Successfully Saved"),
        "tapToType": MessageLookupByLibrary.simpleMessage("Tap to type")
      };
}
