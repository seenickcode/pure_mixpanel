import 'package:test/test.dart';
import 'dart:convert';
import 'package:pure_mixpanel/pure_mixpanel.dart';

void main() {
  test('adds one to input values', () async {
    const cases = [
      {
        'event': 'foobar',
        'distinct_id': '492',
        'token': '7efab866c097943d3a2273c0adac028f',
        'debug': true,
        'expects': true
      },
    ];

    // NOTE for some reason, loop cases above using 'async' doesn't work
    // so doing this manually
    var mixpanel = Mixpanel(token: cases[0]['token'], debug: cases[0]['debug']);
    var result = await mixpanel.track(cases[0]['event'],
        distinctID: cases[0]['distinct_id']);
    print('>>> result is ${result}');
    expect(cases[0]['expects'], (result.statusCode == 200));
  });
}
