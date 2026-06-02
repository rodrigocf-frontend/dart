import 'package:test/test.dart';
import 'package:weather/cli/weather_cli.dart';

void main() {
  group('Test Weather Cli', () {
    test("Test Weather CLI configuration", () {
      final WeatherCli cli = WeatherCli();

      expect(cli.executableName, equals("weather"));
      expect(
        cli.description,
        equals(
          'Check the current weather and forecast by city using Open-Meteo.',
        ),
      );

      expect(
        cli.commands.keys.toList(),
        equals(["help", "get", "forecast", "history", "clear"]),
      );
    });

    test("Test Weather CLI configuration", () {
      final WeatherCli cli = WeatherCli();

      cli.run(["get", "campina grande"]);
    });
  });
}
