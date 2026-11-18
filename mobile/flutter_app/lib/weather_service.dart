import 'dart:convert';
import 'package:http/http.dart' as http;

class City {
  const City({required this.name, required this.latitude, required this.longitude, this.admin1, this.country});
  final String name;
  final double latitude;
  final double longitude;
  final String? admin1;
  final String? country;

  String get label => [name, admin1, country].where((part) => part != null && part.isNotEmpty).join(', ');
}

class WeatherSnapshot {
  const WeatherSnapshot({required this.current, required this.daily, required this.timezone, required this.unit});
  final Map<String, dynamic> current;
  final Map<String, dynamic> daily;
  final String timezone;
  final String unit;
}

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<List<City>> searchCities(String query) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query,
      'count': '6',
      'language': 'en',
      'format': 'json',
    });
    final response = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) throw Exception('Geocoding request failed (${response.statusCode})');
    final results = (jsonDecode(response.body) as Map<String, dynamic>)['results'] as List<dynamic>? ?? [];
    return results.map((item) {
      final value = item as Map<String, dynamic>;
      return City(
        name: value['name'] as String? ?? '',
        latitude: (value['latitude'] as num).toDouble(),
        longitude: (value['longitude'] as num).toDouble(),
        admin1: value['admin1'] as String?,
        country: value['country'] as String?,
      );
    }).toList();
  }

  Future<WeatherSnapshot> fetchWeather(City city, {required bool fahrenheit}) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': city.latitude.toString(),
      'longitude': city.longitude.toString(),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,sunrise,sunset',
      'temperature_unit': fahrenheit ? 'fahrenheit' : 'celsius',
      'wind_speed_unit': 'kmh',
      'timezone': 'auto',
      'forecast_days': '5',
    });
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) throw Exception('Weather request failed (${response.statusCode})');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return WeatherSnapshot(
      current: json['current'] as Map<String, dynamic>,
      daily: json['daily'] as Map<String, dynamic>,
      timezone: json['timezone'] as String? ?? 'UTC',
      unit: fahrenheit ? '°F' : '°C',
    );
  }
}
