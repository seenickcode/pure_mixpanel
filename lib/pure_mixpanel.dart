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
  final bool trackIp;

  Mixpanel({@required this.token, this.debug: false, this.trackIp: false});

  Future<http.Response> track(String eventName,
      {String distinctID, Map<String, String> properties}) async {
    if (properties == null) {
      properties = Map<String, String>();
    }
    properties.putIfAbsent('token', () => this.token);

    var payload = MixpanelPayload.createEncoded(
        event: eventName, distinctID: distinctID, properties: properties);
    final uri = MixpanelUri.create(path: '/track', queryParameters: {
      'data': payload,
      'verbose': (this.debug ? '1' : '0'),
      'ip': (this.trackIp ? '1': '0'),
    });
    if (debug) {
      print(
          'mixpanel req\n\tproperties: $properties\n\turi: ${uri.toString()}');
    }
    return http.get(uri.toString());
  }
}

class MixpanelPayload {
  static String createEncoded(
      {@required String event,
      String distinctID,
      Map<String, String> properties}) {
    if (distinctID != null) {
      properties.putIfAbsent('distinct_id', () => distinctID);
    }
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
      scheme: 'http',
      host: MixpanelBaseUri,
      path: path,
      queryParameters: queryParameters,
    );
  }
}
