import 'package:test/test.dart';
import 'package:weather/core/result.dart';
import 'package:weather/exceptions/weather.dart';

void main() {
  group('Result<T>', () {
    test('Success carrega o valor corretamente', () {
      final result = Success<int>(42);
      expect(result.value, 42);
    });

    test('Failure carrega o erro corretamente', () {
      final result = Failure<int>(CityNotFound('Campina Grande'));
      expect(result.error, isA<CityNotFound>());
    });

    test('pattern matching em Success retorna o valor', () {
      final Result<String> result = Success('ok');

      switch (result) {
        case Success(:final value):
          expect(value, 'ok');
        case Failure():
          fail('Não deveria ser Failure');
      }
    });

    test('pattern matching em Failure retorna o erro', () {
      final Result<String> result = Failure(NetworkError('Sem conexão'));

      switch (result) {
        case Success():
          fail('Não deveria ser Success');
        case Failure(:final error):
          expect(error, isA<NetworkError>());
      }
    });
  });

  group('WeatherError', () {
    test('CityNotFound guarda o nome da cidade', () {
      final error = CityNotFound('São Paulo');
      expect(error.cityName, 'São Paulo');
    });

    test('NetworkError guarda a mensagem', () {
      final error = NetworkError('Sem conexão com a internet.');
      expect(error.message, 'Sem conexão com a internet.');
    });

    test('UnexpectedError guarda a mensagem', () {
      final error = UnexpectedError('algo deu errado');
      expect(error.message, 'algo deu errado');
    });

    test('switch em WeatherError é exaustivo', () {
      final WeatherError error = CityNotFound('Recife');
      String? handled;

      switch (error) {
        case CityNotFound():
          handled = 'city_not_found';
        case NetworkError():
          handled = 'network_error';
        case UnexpectedError():
          handled = 'unexpected_error';
      }

      expect(handled, 'city_not_found');
    });
  });
}
