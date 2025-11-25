import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching word definitions and information
/// Uses Free Dictionary API (dictionaryapi.dev) - free, no API key required
class DictionaryApiService {
  static const String _freeDictionaryBaseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';
  
  /// Get a word of the day based on the current date
  /// Uses a curated word list and picks one deterministically based on date
  static String _getWordOfTheDay() {
    // Curated list of interesting words for learning
    final words = [
      'serendipity', 'ephemeral', 'resilient', 'eloquent', 'meticulous',
      'ubiquitous', 'paradigm', 'quintessential', 'perspicacious', 'sagacious',
      'ephemeral', 'luminous', 'resplendent', 'mellifluous', 'petrichor',
      'wanderlust', 'epiphany', 'nostalgia', 'ethereal', 'solitude',
      'halcyon', 'ineffable', 'laconic', 'sonder', 'petrichor',
      'ephemeral', 'resilient', 'eloquent', 'meticulous', 'ubiquitous',
    ];
    
    // Pick a word based on the day of the year (0-364)
    final dayOfYear = DateTime.now().difference(
      DateTime(DateTime.now().year, 1, 1)
    ).inDays;
    
    return words[dayOfYear % words.length];
  }
  
  /// Fetch word definition from Free Dictionary API
  /// Returns null if word not found or API error
  static Future<Map<String, dynamic>?> fetchWordDefinition(String word) async {
    try {
      final url = Uri.parse('$_freeDictionaryBaseUrl/$word');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0] as Map<String, dynamic>;
        }
      } else if (response.statusCode == 404) {
        // Word not found
        return null;
      }
      
      return null;
    } catch (e) {
      // Log error in production, return null for now
      return null;
    }
  }
  
  /// Get word of the day with full definition
  /// Returns a structured WordOfTheDay object
  static Future<Map<String, dynamic>?> getWordOfTheDayData() async {
    final word = _getWordOfTheDay();
    final definitionData = await fetchWordDefinition(word);
    
    if (definitionData == null) {
      return null;
    }
    
    // Parse the Free Dictionary API response
    try {
      final meanings = definitionData['meanings'] as List<dynamic>?;
      if (meanings == null || meanings.isEmpty) {
        return null;
      }
      
      // Get the first meaning (most common)
      final firstMeaning = meanings[0] as Map<String, dynamic>;
      final definitions = firstMeaning['definitions'] as List<dynamic>?;
      
      if (definitions == null || definitions.isEmpty) {
        return null;
      }
      
      final firstDefinition = definitions[0] as Map<String, dynamic>;
      
      // Extract etymology if available
      String? etymology;
      if (definitionData.containsKey('etymologies') && 
          (definitionData['etymologies'] as List).isNotEmpty) {
        etymology = (definitionData['etymologies'] as List)[0] as String;
      } else if (definitionData.containsKey('origin')) {
        etymology = definitionData['origin'] as String?;
      }
      
      // Get example if available
      String? example;
      if (firstDefinition.containsKey('example')) {
        example = firstDefinition['example'] as String?;
      }
      
      // Get phonetic pronunciation if available
      String? phonetic;
      if (definitionData.containsKey('phonetic')) {
        phonetic = definitionData['phonetic'] as String?;
      } else if (definitionData.containsKey('phonetics') && 
                 (definitionData['phonetics'] as List).isNotEmpty) {
        final phonetics = definitionData['phonetics'] as List;
        if (phonetics[0] is Map && (phonetics[0] as Map).containsKey('text')) {
          phonetic = (phonetics[0] as Map)['text'] as String?;
        }
      }
      
      return {
        'word': word,
        'definition': firstDefinition['definition'] as String? ?? 'No definition available',
        'example': example,
        'etymology': etymology,
        'phonetic': phonetic,
        'partOfSpeech': firstMeaning['partOfSpeech'] as String?,
      };
    } catch (e) {
      return null;
    }
  }
}

