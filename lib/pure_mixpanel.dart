library pure_mixpanel;

import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

const MixpanelBaseUri = 'api.mixpanel.com';

/// Allows one to track Mixpanel events.
class Mixpanel {
  final String token;
  final bool debug;

  Mixpanel({@required this.token, this.debug});

  Future<String> track(String eventName,
      {Map<String, String> properties}) async {
    properties.putIfAbsent('token', () => this.token);

    var payload =
        MixpanelPayload.createEncoded(event: eventName, properties: properties);
    final uri = MixpanelUri.create(path: '/track', queryParameters: {
      'data': payload,
      'verbose': (this.debug ? 1 : 0),
    });
    if (debug) {
      print('mixpanel sending: ${uri.toString()}');
    }
    final resp = await http.get(uri.toString());
    if (debug) {
      print('mixpanel response is: $resp.statusCode');
    }
    return resp.body;
  }
}

class MixpanelPayload {
  static String createEncoded(
      {@required String event, Map<String, String> properties}) {
    var payload = {
      'event': event,
      'properties': properties,
    };
    var jsonString = json.encode(payload);
    var bytes = utf8.encode(jsonString);
    return base64.encode(bytes);
  }

  String encode() {
    var jsonString = json.encode(this);
    var bytes = utf8.encode(jsonString);
    return base64.encode(bytes);
  }
}

class MixpanelUri {
  static Uri create(
      {@required String path, @required Map<String, dynamic> queryParameters}) {
    return Uri(
      scheme: 'https',
      host: MixpanelBaseUri,
      port: 80,
      path: path,
      queryParameters: queryParameters,
    );
  }
}
