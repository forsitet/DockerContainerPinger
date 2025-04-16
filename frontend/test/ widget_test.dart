import 'package:flutter_test/flutter_test.dart';

void main() {
  test('String split', () {
    var string = "foo bar";
    expect(string.split(" "), equals(["foo", "bar"]));
  });
  test('Simple computation)', () {
    final a = 1 + 1;
    expect(a, 2);
  });
}
