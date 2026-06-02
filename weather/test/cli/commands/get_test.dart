import 'package:args/command_runner.dart';
import 'package:test/test.dart';
import 'package:weather/cli/commands/get.dart';

void main() {
  group('GetCommand', () {
    late List<String> output;
    late CommandRunner cli;

    setUp(() {
      output = [];
      cli = CommandRunner('weather', '')..addCommand(GetCommand());
    });

    test('cidade válida → consulta remote/cache', () async {
      await cli.run(['get', 'Campina Grande']);
      expect(output, contains('Consult remote/locale'));
      print(output);
    });

    // test('--refresh → força atualização', () async {
    //   await cli.run(['get', 'Campina Grande', '--refresh']);
    //   expect(output, contains('OK! force refreshing cache'));
    //   print(output);
    // });

    // test('sem cidade → invalid command', () async {
    //   await cli.run(['get']);
    //   expect(output, contains('invalid command'));
    //   print(output);
    // });

    // test('mais de 1 arg → invalid command', () async {
    //   await cli.run(['get', 'cidade1', 'cidade2']);
    //   expect(output, contains('invalid command'));
    //   print(output);
    // });
  });
}
