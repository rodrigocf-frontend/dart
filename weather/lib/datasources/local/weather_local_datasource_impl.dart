import 'dart:io';

import 'package:weather/datasources/local/weather_local_datasource.dart';

class WeatherLocalDatasourceImpl implements WeatherLocalDatasource {
  Future<File> getFile(String path) async {
    final File file = File(path);
    return file;
  }

  Future<File> createStore(String path) async {
    final File file = File(path);
    file.createSync(recursive: true);
    return file;
  }

  Future<void> saveCurrentFile(File file, String fileData) async {
    await file.writeAsString(fileData);
  }
}
