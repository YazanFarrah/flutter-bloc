import 'dart:convert';

import 'package:habaybna/data/data_provider/weather_data_provider.dart';
import 'package:habaybna/models/weather_model.dart';

class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;

  WeatherRepository({
    required this.weatherDataProvider,
  });
  Future<WeatherModel> getCurrentWeather() async {
    try {
      String cityName = 'London';
      //didn't create instance of WeatherDataProvider here if we needed to
      //unit test this function

      final weatherData = await weatherDataProvider.getCurrentWeather(cityName);

      final data = jsonDecode(weatherData);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return WeatherModel.fromMap(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
