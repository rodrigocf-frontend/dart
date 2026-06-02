import 'dart:io';

abstract interface class WeatherLocalDatasource {
  Future<File> getFile(String path);
  Future<File> createStore(String path);
  Future<void> saveCurrentFile(File file, String fileData);
}
