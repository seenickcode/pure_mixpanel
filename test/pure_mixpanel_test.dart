import 'package:test/test.dart';
import 'dart:convert';
import 'package:pure_mixpanel/pure_mixpanel.dart';

void main() {
  test('Mixpanel track events', () async {
    const pureMixpanelPublicAPIToken = 'f9b25358a89f5a20adaecc608a7d6f72';
    const cases = [
      {
        'event': 'foobar',
        'distinct_id': '492',
        'token': pureMixpanelPublicAPIToken,
        'debug': true,
        'expects_status_code': 200,
        'expects_status': 1,
      },
      {
        'event': 'foobar',
        'distinct_id': null,
        'token': pureMixpanelPublicAPIToken,
        'debug': false,
        'expects_status_code': 200,
        'expects_status': 1,
      },
    ];

    // test a basic event
    var mixpanel = Mixpanel(token: pureMixpanelPublicAPIToken);
    var result = await mixpanel.track('foobar');
    expect(1, json.decode(result.body));

    // NOTE for some reason, loop cases above using 'async' doesn't work
    // so doing this manually
    for (var i = 0; i < cases.length; i++) {
      print('testing case ${cases[i]}');
      var k = cases[i];
      var mixpanel = Mixpanel(token: k['token'], debug: k['debug']);
      var result =
          await mixpanel.track(k['event'], distinctID: k['distinct_id']);
      if (k['debug'] == true) {
        // if in debug mode, lib adds a 'verbose' flag and Mixpanel returns a
        // JSON object
        Map<String, dynamic> respMap = json.decode(result.body);
        print('got response $respMap');
        expect(k['expects_status'], respMap['status']);
      } else {
        // normally, Mixpanel returns a single integer representing success or not
        int respStatus = json.decode(result.body);
        print('got response $respStatus');
        expect(k['expects_status'], respStatus);
      }
      // test for standard HTTP response status code
      expect(k['expects_status_code'], result.statusCode);
    }
  });
}
