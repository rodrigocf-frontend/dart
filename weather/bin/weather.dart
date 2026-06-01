import 'package:weather/cli/weather_cli.dart';

Future<void> main(List<String> arguments) async {
  //GET TEMPERATURE
  // var url = Uri.https('api.open-meteo.com', '/v1/forecast', {
  //   "latitude": "-7.2306",
  //   "longitude": "-35.8811",
  //   "current": "temperature_2m",
  // });
  // var response = await http.get(url);

  //GET LatitudeLong
  // var url = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
  //   "name": "Campina Grande",
  //   "count": "1",
  // });
  // var response = await http.get(url);
  // print(response.body);

  final WeatherCli cli = WeatherCli();

  cli.run(arguments);
}
