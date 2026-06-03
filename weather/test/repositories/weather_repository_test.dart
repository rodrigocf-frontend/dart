import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:weather/core/result.dart';
import 'package:weather/datasources/local/weather_local_datasource.dart';
import 'package:weather/datasources/remote/weather_remote_datasource.dart';
import 'package:weather/exceptions/weather.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/repositories/weather_repository_impl.dart';

import 'weather_repository_test.mocks.dart';

@GenerateMocks([WeatherRemoteDatasource, WeatherLocalDatasource])
void main() {
  late MockWeatherRemoteDatasource mockRemote;
  late MockWeatherLocalDatasource mockLocal;
  late WeatherRepositoryImpl repository;

  final tLocation = CityLocation.fromJSON({
    'id': 3403642,
    'name': 'Campina Grande',
    'country_code': 'BR',
    'latitude': -7.23056,
    'longitude': -35.88111,
    'timezone': 'America/Fortaleza',
  });

  final tWeather = CityWeather.fromJSON({
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
  });

  final tNow = DateTime.now();
  final tFreshCache = tNow.subtract(const Duration(minutes: 30));
  final tExpiredCache = tNow.subtract(const Duration(hours: 2));

  setUp(() {
    mockRemote = MockWeatherRemoteDatasource();
    mockLocal = MockWeatherLocalDatasource();
    repository = WeatherRepositoryImpl.withDatasources(mockRemote, mockLocal);

    provideDummy<Result<CityLocation>>(Failure(UnexpectedError('')));
    provideDummy<Result<CityWeather>>(Failure(UnexpectedError('')));
    provideDummy<({CityLocation location, CityWeather weather, DateTime lastCacheUpdated})>(
      (location: tLocation, weather: tWeather, lastCacheUpdated: tNow),
    );
    provideDummy<List<({DateTime fetchedAt, int id, String name})>>([]);
  });

  group('getCurrentWeather', () {
    test('cache válido → retorna do cache sem chamar a API', () async {
      when(mockLocal.loadCurrentWeatherFile(any)).thenAnswer(
        (_) async => (
          location: tLocation,
          weather: tWeather,
          lastCacheUpdated: tFreshCache,
        ),
      );

      final result = await repository.getCurrentWeather('Campina Grande', false);

      expect(result, isA<Success>());
      final value = (result as Success).value;
      expect(value.fromCache, true);
      verifyNever(mockRemote.getWeather(any));
    });

    test('cache expirado → chama API e salva novo cache', () async {
      when(mockLocal.loadCurrentWeatherFile(any)).thenAnswer(
        (_) async => (
          location: tLocation,
          weather: tWeather,
          lastCacheUpdated: tExpiredCache,
        ),
      );
      when(mockRemote.getWeather(any)).thenAnswer((_) async => Success(tWeather));
      when(mockLocal.findAndUpdateCurrentFile(any, any, any)).thenAnswer((_) => Future.value());
      when(mockLocal.findAndUpdateHistoryByLocation(any, any)).thenAnswer((_) => Future.value());

      final result = await repository.getCurrentWeather('Campina Grande', false);

      expect(result, isA<Success>());
      expect((result as Success).value.fromCache, false);
      verify(mockRemote.getWeather(any)).called(1);
    });

    test('--refresh → ignora cache válido e chama API', () async {
      when(mockLocal.loadCurrentWeatherFile(any)).thenAnswer(
        (_) async => (
          location: tLocation,
          weather: tWeather,
          lastCacheUpdated: tFreshCache,
        ),
      );
      when(mockRemote.getWeather(any)).thenAnswer((_) async => Success(tWeather));
      when(mockLocal.findAndUpdateCurrentFile(any, any, any)).thenAnswer((_) => Future.value());
      when(mockLocal.findAndUpdateHistoryByLocation(any, any)).thenAnswer((_) => Future.value());

      final result = await repository.getCurrentWeather('Campina Grande', true);

      expect(result, isA<Success>());
      verify(mockRemote.getWeather(any)).called(1);
    });

    test('cache miss → busca localização na API e cria store', () async {
      when(mockLocal.loadCurrentWeatherFile(any)).thenThrow(
        PathNotFoundException('store/campina_grande_current.json', OSError()),
      );
      when(mockRemote.getLocation(any)).thenAnswer((_) async => Success(tLocation));
      when(mockRemote.getWeather(any)).thenAnswer((_) async => Success(tWeather));
      when(mockLocal.createCurrentStore(any)).thenAnswer(
        (_) => Future.value(File('store/campina_grande_current.json')),
      );
      when(mockLocal.findAndUpdateCurrentFile(any, any, any)).thenAnswer((_) => Future.value());
      when(mockLocal.findAndUpdateHistoryByLocation(any, any)).thenAnswer((_) => Future.value());

      final result = await repository.getCurrentWeather('Campina Grande', false);

      expect(result, isA<Success>());
      expect((result as Success).value.fromCache, false);
      verify(mockRemote.getLocation('Campina Grande')).called(1);
    });

    test('cidade não encontrada → retorna Failure(CityNotFound)', () async {
      when(mockLocal.loadCurrentWeatherFile(any)).thenThrow(
        PathNotFoundException('store/desconhecida_current.json', OSError()),
      );
      when(mockRemote.getLocation(any)).thenAnswer(
        (_) async => Failure(CityNotFound('Desconhecida')),
      );

      final result = await repository.getCurrentWeather('Desconhecida', false);

      expect(result, isA<Failure>());
      final error = (result as Failure).error;
      expect(error, isA<CityNotFound>());
      expect((error as CityNotFound).cityName, 'Desconhecida');
    });

    test('erro de rede → retorna Failure(NetworkError)', () async {
      when(mockLocal.loadCurrentWeatherFile(any)).thenThrow(
        PathNotFoundException('', OSError()),
      );
      when(mockRemote.getLocation(any)).thenAnswer(
        (_) async => Failure(NetworkError('Sem conexão com a internet.')),
      );

      final result = await repository.getCurrentWeather('Campina Grande', false);

      expect(result, isA<Failure>());
      expect((result as Failure).error, isA<NetworkError>());
    });
  });

  group('getHistory', () {
    test('delega para o local datasource', () async {
      final tHistory = [(id: 1, name: 'Campina Grande', fetchedAt: tNow)];
      when(mockLocal.loadHistoryFile()).thenAnswer((_) async => tHistory);

      final result = await repository.getHistory();

      expect(result.length, 1);
      expect(result.first.name, 'Campina Grande');
      verify(mockLocal.loadHistoryFile()).called(1);
    });

    test('retorna lista vazia quando não há histórico', () async {
      when(mockLocal.loadHistoryFile()).thenAnswer((_) async => []);

      final result = await repository.getHistory();

      expect(result, isEmpty);
    });
  });

  group('clearCache', () {
    test('delega para o local datasource e retorna contagem', () async {
      when(mockLocal.deleteCache()).thenAnswer((_) async => 3);

      final result = await repository.clearCache();

      expect(result, 3);
      verify(mockLocal.deleteCache()).called(1);
    });

    test('retorna 0 quando não há cache', () async {
      when(mockLocal.deleteCache()).thenAnswer((_) async => 0);

      final result = await repository.clearCache();

      expect(result, 0);
    });
  });
}
