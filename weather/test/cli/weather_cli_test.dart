import 'package:test/test.dart';
import 'package:weather/cli/weather_cli.dart';

void main() {
  group('WeatherCli', () {
    test('configura executableName e description corretamente', () {
      final cli = WeatherCli();

      expect(cli.executableName, equals('weather'));
      expect(
        cli.description,
        equals('Check the current weather and forecast by city using Open-Meteo.'),
      );
    });

    test('registra os quatro commands corretamente', () {
      final cli = WeatherCli();

      expect(
        cli.commands.keys.toList(),
        equals(['help', 'get', 'forecast', 'history', 'clear']),
      );
    });
  });
}
