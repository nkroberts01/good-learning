import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/difficulty.dart';

/// Service for fetching geography information from REST Countries API
/// 
/// Uses REST Countries API v3.1 (restcountries.com) - free, no API key required
/// Provides comprehensive country data including location, facts, and statistics
class GeographyApiService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';
  
  /// Get a country of the day based on the current date
  /// Returns a country code (e.g., 'usa', 'fra', 'jpn')
  static String _getCountryOfTheDay() {
    // Curated list of interesting countries for learning
    final countries = [
      'usa', 'can', 'mex', 'bra', 'arg', 'chl', 'per', 'col',
      'gbr', 'fra', 'deu', 'ita', 'esp', 'nld', 'bel', 'che',
      'swe', 'nor', 'dnk', 'fin', 'pol', 'cze', 'aut', 'hun',
      'rus', 'chn', 'jpn', 'kor', 'ind', 'tha', 'vnm', 'phl',
      'idn', 'mys', 'sgp', 'aus', 'nzl', 'zaf', 'egy', 'ken',
      'nga', 'gha', 'mar', 'tun', 'tur', 'sau', 'are', 'isr',
      'irn', 'irq', 'pak', 'bgd', 'lka', 'npl', 'btn', 'mmr',
    ];
    
    // Pick a country based on the day of the year (0-364)
    final dayOfYear = DateTime.now().difference(
      DateTime(DateTime.now().year, 1, 1)
    ).inDays;
    
    return countries[dayOfYear % countries.length];
  }
  
  /// Fetch country data from REST Countries API
  /// Returns null if country not found or API error
  static Future<Map<String, dynamic>?> fetchCountryData(String countryCode) async {
    try {
      // Try by common name first, then by alpha code
      final url = Uri.parse('$_baseUrl/name/$countryCode?fullText=true');
      var response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      
      // If not found by name, try by alpha-3 code
      if (response.statusCode != 200) {
        final codeUrl = Uri.parse('$_baseUrl/alpha/$countryCode');
        response = await http.get(codeUrl).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Request timeout');
          },
        );
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // API returns array, get first result
        if (data is List && data.isNotEmpty) {
          return data[0] as Map<String, dynamic>;
        } else if (data is Map) {
          return data as Map<String, dynamic>;
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Get geography fact for a country
  /// Returns structured data suitable for GeographyFact model
  static Future<Map<String, dynamic>?> getGeographyFact({
    required Difficulty difficulty,
  }) async {
    final countryCode = _getCountryOfTheDay();
    final countryData = await fetchCountryData(countryCode);
    
    if (countryData == null) {
      return null;
    }
    
    try {
      // Extract country information
      final name = countryData['name'] as Map<String, dynamic>?;
      final commonName = name?['common'] as String? ?? 'Unknown Country';
      final officialNameRaw = name?['official'] as String?;
      final officialName = officialNameRaw ?? commonName;
      
      // Get capital city
      final capitals = countryData['capital'] as List<dynamic>?;
      final capital = capitals != null && capitals.isNotEmpty 
          ? capitals[0] as String 
          : null;
      
      // Get coordinates (latlng array: [latitude, longitude])
      final latlng = countryData['latlng'] as List<dynamic>?;
      double? latitude;
      double? longitude;
      if (latlng != null && latlng.length >= 2) {
        latitude = (latlng[0] as num).toDouble();
        longitude = (latlng[1] as num).toDouble();
      }
      
      // Get region and subregion
      final region = countryData['region'] as String?;
      final subregion = countryData['subregion'] as String?;
      
      // Get population
      final population = countryData['population'] as int?;
      
      // Get area (in square kilometers)
      final area = countryData['area'] as double?;
      
      // Get languages
      final languages = countryData['languages'] as Map<String, dynamic>?;
      final languageNames = languages?.values.toList() ?? [];
      
      // Get currencies
      final currencies = countryData['currencies'] as Map<String, dynamic>?;
      final currencyNames = currencies?.values
          .map((c) => (c as Map)['name'] as String?)
          .whereType<String>()
          .toList() ?? [];
      
      // Get borders (neighboring countries)
      final borders = countryData['borders'] as List<dynamic>?;
      
      // Get timezones
      final timezones = countryData['timezones'] as List<dynamic>?;
      
      // Build description based on difficulty
      String description;
      String title;
      
      switch (difficulty) {
        case Difficulty.beginner:
          // Simple facts for beginners
          title = commonName;
          final parts = <String>[];
          
          if (capital != null) {
            parts.add('The capital city is $capital.');
          }
          
          if (region != null) {
            parts.add('It is located in $region.');
          }
          
          if (population != null) {
            final popInMillions = (population / 1000000).toStringAsFixed(1);
            parts.add('It has a population of approximately $popInMillions million people.');
          }
          
          if (languageNames.isNotEmpty) {
            final langList = languageNames.take(2).join(' and ');
            parts.add('The main languages spoken are $langList.');
          }
          
          description = parts.join(' ');
          
        case Difficulty.intermediate:
          // More detailed information
          title = '$commonName';
          final parts = <String>[];
          
          if (officialNameRaw != null && officialName != commonName) {
            parts.add('Officially known as $officialName,');
          }
          
          if (capital != null) {
            parts.add('$commonName has $capital as its capital city.');
          }
          
          if (subregion != null) {
            parts.add('Located in $subregion, $region,');
          } else if (region != null) {
            parts.add('Located in $region,');
          }
          
          if (population != null) {
            final popInMillions = (population / 1000000).toStringAsFixed(1);
            parts.add('the country is home to approximately $popInMillions million people.');
          }
          
          if (area != null) {
            final areaInKm = area.toStringAsFixed(0);
            parts.add('It covers an area of $areaInKm square kilometers.');
          }
          
          if (languageNames.isNotEmpty) {
            final langList = languageNames.join(', ');
            parts.add('Languages spoken include $langList.');
          }
          
          if (currencyNames.isNotEmpty) {
            final currencyList = currencyNames.join(' and ');
            parts.add('The currency used is $currencyList.');
          }
          
          description = parts.join(' ');
          
        case Difficulty.advanced:
          // Comprehensive information
          title = '$commonName';
          final parts = <String>[];
          
          if (officialNameRaw != null && officialName != commonName) {
            parts.add('Officially known as $officialName,');
          }
          
          if (capital != null) {
            parts.add('$commonName\'s capital is $capital.');
          }
          
          if (subregion != null && region != null) {
            parts.add('The country is situated in $subregion, within the $region region.');
          } else if (region != null) {
            parts.add('It is located in the $region region.');
          }
          
          if (population != null) {
            final popFormatted = _formatNumber(population);
            parts.add('With a population of approximately $popFormatted people,');
          }
          
          if (area != null) {
            final areaInKm = area.toStringAsFixed(0);
            parts.add('it spans an area of $areaInKm square kilometers.');
          }
          
          if (languageNames.isNotEmpty) {
            final langList = languageNames.join(', ');
            parts.add('The country recognizes multiple languages: $langList.');
          }
          
          if (currencyNames.isNotEmpty) {
            final currencyList = currencyNames.join(', ');
            parts.add('Its official currency is $currencyList.');
          }
          
          if (borders != null && borders.isNotEmpty) {
            parts.add('It shares borders with ${borders.length} neighboring countries.');
          }
          
          if (timezones != null && timezones.isNotEmpty) {
            final tzCount = timezones.length;
            parts.add('The country spans $tzCount timezone${tzCount > 1 ? 's' : ''}.');
          }
          
          description = parts.join(' ');
      }
      
      // Build country display name
      String countryDisplay = commonName;
      if (capital != null && difficulty == Difficulty.beginner) {
        countryDisplay = '$commonName ($capital)';
      }
      
      return {
        'title': title,
        'description': description,
        'country': countryDisplay,
        'latitude': latitude,
        'longitude': longitude,
        'capital': capital,
        'region': region,
        'subregion': subregion,
      };
    } catch (e) {
      return null;
    }
  }
  
  /// Format large numbers with commas
  static String _formatNumber(int number) {
    final numberStr = number.toString();
    final buffer = StringBuffer();
    
    for (int i = 0; i < numberStr.length; i++) {
      if (i > 0 && (numberStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(numberStr[i]);
    }
    
    return buffer.toString();
  }
  
  /// Get a random country (alternative method)
  static Future<Map<String, dynamic>?> getRandomCountry() async {
    try {
      final url = Uri.parse('$_baseUrl/all?fields=name,cca3');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> countries = json.decode(response.body);
        if (countries.isNotEmpty) {
          final randomIndex = DateTime.now().millisecondsSinceEpoch % countries.length;
          final country = countries[randomIndex] as Map<String, dynamic>;
          final code = country['cca3'] as String?;
          if (code != null) {
            return await fetchCountryData(code.toLowerCase());
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

