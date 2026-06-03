class DailyForecast {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;

  DailyForecast._({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
  });
}

class CityForecast {
  final String temperatureUnit;
  final List<DailyForecast> days;

  CityForecast._({required this.temperatureUnit, required this.days});

  static CityForecast fromJSON(Map<String, dynamic> data) {
    final times = data['daily']['time'] as List;
    final maxTemps = data['daily']['temperature_2m_max'] as List;
    final minTemps = data['daily']['temperature_2m_min'] as List;

    final days = List.generate(
      times.length,
      (i) => DailyForecast._(
        date: DateTime.parse(times[i] as String),
        maxTemperature: (maxTemps[i] as num).toDouble(),
        minTemperature: (minTemps[i] as num).toDouble(),
      ),
    );

    return CityForecast._(
      temperatureUnit: data['daily_units']['temperature_2m_max'] as String,
      days: days,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "daily_units": {
        "temperature_2m_max": temperatureUnit,
        "temperature_2m_min": temperatureUnit,
      },
      "daily": {
        "time": days
            .map((d) => d.date.toIso8601String().split('T').first)
            .toList(),
        "temperature_2m_max": days.map((d) => d.maxTemperature).toList(),
        "temperature_2m_min": days.map((d) => d.minTemperature).toList(),
      },
    };
  }
}
