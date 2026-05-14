import 'dart:io';

import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'dart:convert';

import 'package:it/constants.dart';

class WidgetService {
  static const String _appGroupId = 'group.it-widget';

  static Future<void> updateTaggedState(TagState state) async {
    if (!Platform.isIOS) return;
    try {
      await WidgetKit.setItem(
        'tagged_state',

        jsonEncode(state.toMap()),
        _appGroupId,
      );
      print('Widget data updated successfully');
      refreshWidgets();
    } catch (e) {
      print('Error updating widget data: $e');
    }
  }

  static Future<void> refreshWidgets() async {
    if (!Platform.isIOS) return;
    try {
      WidgetKit.reloadAllTimelines();
      print('Widgets refreshed successfully');
    } catch (e) {
      print('Error refreshing widgets: $e');
    }
  }
}
