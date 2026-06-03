import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

class Display {
  static void logWeather(
    CityLocation location,
    CityWeather weather, {
    required bool fromCache,
    DateTime? fetchedAt,
  }) {
    print('${location.name}, ${location.countryCode}');
    print('Temperatura:  ${weather.temperature}°C');
    print('Vento:        ${weather.relativeHumidity} km/h');
    print('Umidade:      ${weather.relativeHumidity}%');
    print('Atualizado:   ${_source(fromCache, fetchedAt)}');
  }

  static void logHistory(
    List<({int id, String name, DateTime fetchedAt})> cities,
  ) {
    print('Cidades pesquisadas:');
    for (final city in cities) {
      final name = city.name.padRight(20);
      print('  $name (${_timeAgo(city.fetchedAt)})');
    }
  }

  static String _source(bool fromCache, DateTime? fetchedAt) {
    if (!fromCache) return 'agora (ao vivo)';
    return 'há ${_timeAgo(fetchedAt!)} (cache)';
  }

  static String _timeAgo(DateTime fetchedAt) {
    final diff = DateTime.now().difference(fetchedAt);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays} dia(s)';
  }

  static void logClear(int count) {
    if (count == 0) {
      print('Nenhum cache encontrado.');
    } else {
      print('Cache limpo. $count cidade(s) removida(s).');
    }
  }
}
