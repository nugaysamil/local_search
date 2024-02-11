// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin AssertMixin<T extends StatefulWidget> on State<T> {
  Future<Map<String, dynamic>?> readData(String path) async {
    final dataString = await DefaultAssetBundle.of(context).loadString(path);

    if (dataString.isEmpty) return null;
    final jsonBody = await compute(jsonDecode, dataString);
    if (jsonBody is Map<String, dynamic>) {
      return jsonBody;
    }
    return null;
  }
}
