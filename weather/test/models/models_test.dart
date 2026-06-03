import 'package:test/test.dart';
import 'package:weather/models/forecast.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

void main() {
  group('CityLocation', () {
    final tJson = {
      'id': 3403642,
      'name': 'Campina Grande',
      'country_code': 'BR',
      'latitude': -7.23056,
      'longitude': -35.88111,
      'timezone': 'America/Fortaleza',
    };

    test('fromJSON mapeia os campos corretamente', () {
      final location = CityLocation.fromJSON(tJson);

      expect(location.id, 3403642);
      expect(location.name, 'Campina Grande');
      expect(location.countryCode, 'BR');
      expect(location.latitude, '-7.23056');
      expect(location.longitude, '-35.88111');
      expect(location.timezone, 'America/Fortaleza');
    });

    test('toJSON retorna os campos corretos', () {
      final location = CityLocation.fromJSON(tJson);
      final json = location.toJSON();

      expect(json['id'], 3403642);
      expect(json['name'], 'Campina Grande');
      expect(json['country_code'], 'BR');
      expect(json['latitude'], '-7.23056');
      expect(json['longitude'], '-35.88111');
      expect(json['timezone'], 'America/Fortaleza');
    });

    test('fromJSON → toJSON → fromJSON preserva os dados', () {
      final original = CityLocation.fromJSON(tJson);
      final restored = CityLocation.fromJSON(original.toJSON());

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.countryCode, original.countryCode);
    });
  });

  group('CityWeather', () {
    final tJson = {
      'current_units': {
        'time': 'iso8601',
        'temperature_2m': '°C',
        'relative_humidity_2m': '%',
      },
      'current': {
        'time': '2026-06-01T19:45',
        'temperature_2m': 21.3,
        'relative_humidity_2m': 95,
      },
    };

    test('fromJSON mapeia os campos corretamente', () {
      final weather = CityWeather.fromJSON(tJson);

      expect(weather.temperature, '21.3');
      expect(weather.temperatureUnits, '°C');
      expect(weather.relativeHumidity, '95');
      expect(weather.relativeHumidityUnits, '%');
      expect(weather.time, '2026-06-01T19:45');
    });

    test('toJSON retorna os campos corretos', () {
      final weather = CityWeather.fromJSON(tJson);
      final json = weather.toJSON();

      expect(json['current']['temperature_2m'], '21.3');
      expect(json['current']['relative_humidity_2m'], '95');
      expect(json['current_units']['temperature_2m'], '°C');
    });

    test('fromJSON → toJSON → fromJSON preserva os dados', () {
      final original = CityWeather.fromJSON(tJson);
      final restored = CityWeather.fromJSON(original.toJSON());

      expect(restored.temperature, original.temperature);
      expect(restored.relativeHumidity, original.relativeHumidity);
    });
  });

  group('CityForecast', () {
    final tJson = {
      'daily_units': {
        'temperature_2m_max': '°C',
        'temperature_2m_min': '°C',
      },
      'daily': {
        'time': ['2026-06-02', '2026-06-03', '2026-06-04'],
        'temperature_2m_max': [25.6, 25.5, 25.6],
        'temperature_2m_min': [19.1, 19.8, 20.4],
      },
    };

    test('fromJSON mapeia os dias corretamente', () {
      final forecast = CityForecast.fromJSON(tJson);

      expect(forecast.days.length, 3);
      expect(forecast.temperatureUnit, '°C');
      expect(forecast.days[0].maxTemperature, 25.6);
      expect(forecast.days[0].minTemperature, 19.1);
      expect(forecast.days[0].date, DateTime(2026, 6, 2));
    });

    test('toJSON retorna os arrays corretos', () {
      final forecast = CityForecast.fromJSON(tJson);
      final json = forecast.toJSON();

      expect((json['daily']['temperature_2m_max'] as List).length, 3);
      expect(json['daily']['temperature_2m_max'][0], 25.6);
      expect(json['daily']['temperature_2m_min'][0], 19.1);
    });

    test('fromJSON → toJSON → fromJSON preserva os dados', () {
      final original = CityForecast.fromJSON(tJson);
      final restored = CityForecast.fromJSON(original.toJSON());

      expect(restored.days.length, original.days.length);
      expect(restored.days[0].maxTemperature, original.days[0].maxTemperature);
    });
  });
}
