import 'package:weather/cli/weather_cli.dart';

Future<void> main(List<String> arguments) async {
  final WeatherCli cli = WeatherCli();

  cli.run(arguments);
}
