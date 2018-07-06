import 'package:test/test.dart';
import 'package:pure_mixpanel/pure_mixpanel.dart';

void main() {
  test('adds one to input values', () async {
    final mixpanel =
        Mixpanel(token: '7efab866c097943d3a2273c0adac028f', debug: true);
    var res1 = await mixpanel.track('foobar');
    print('>>>>>> $res1');
    expect(res1, '1');
  });
}
