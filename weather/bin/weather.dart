import 'package:args/command_runner.dart';
import 'package:weather/cli/weather_cli.dart';

Future<void> main(List<String> arguments) async {
  final WeatherCli cli = WeatherCli();

  try {
    await cli.run(arguments);
  } on UsageException catch (e) {
    print(e.message);
  }
}
