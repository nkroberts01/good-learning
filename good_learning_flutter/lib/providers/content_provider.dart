import 'package:flutter/foundation.dart';
import 'package:good_learning_flutter/models/content_type.dart';
import 'package:good_learning_flutter/models/difficulty.dart';

/// Placeholder data structures for content
/// These will be replaced with real data sources later

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });
}

class WordOfTheDay {
  final String word;
  final String definition;
  final String? example;
  final String? etymology;

  WordOfTheDay({
    required this.word,
    required this.definition,
    this.example,
    this.etymology,
  });
}

class GeographyFact {
  final String title;
  final String description;
  final String? country;
  final double? latitude;
  final double? longitude;

  GeographyFact({
    required this.title,
    required this.description,
    this.country,
    this.latitude,
    this.longitude,
  });
}

class HistoryFact {
  final String title;
  final String description;
  final String? date;
  final String? location;

  HistoryFact({
    required this.title,
    required this.description,
    this.date,
    this.location,
  });
}

class NewsArticle {
  final String title;
  final String summary;
  final String? source;
  final String? url;
  final DateTime? publishedDate;

  NewsArticle({
    required this.title,
    required this.summary,
    this.source,
    this.url,
    this.publishedDate,
  });
}

/// Manages content data for different content types
/// 
/// This provider handles:
/// - Loading content for each content type
/// - Managing content based on difficulty
/// - Caching content
/// - Providing content for active sessions
/// 
/// Note: Currently uses mock data. Later you'll replace this with
/// real API calls or local database queries.
class ContentProvider extends ChangeNotifier {
  // Cache for loaded content
  final Map<ContentType, Map<Difficulty, List<dynamic>>> _contentCache = {};
  
  // Track loading states
  final Map<ContentType, bool> _loadingStates = {};

  /// Check if content is currently loading
  bool isLoading(ContentType type) => _loadingStates[type] ?? false;

  /// Get quiz questions for a given difficulty
  /// Returns mock data for now
  Future<List<QuizQuestion>> getQuizQuestions({
    required Difficulty difficulty,
    int count = 5,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Realistic quiz questions based on difficulty
    final questions = [
      QuizQuestion(
        question: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctAnswerIndex: 2,
        explanation: 'Paris is the capital and largest city of France.',
      ),
      QuizQuestion(
        question: 'Which planet is known as the Red Planet?',
        options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        correctAnswerIndex: 1,
        explanation: 'Mars is called the Red Planet due to iron oxide (rust) on its surface.',
      ),
      QuizQuestion(
        question: 'What is 15 × 7?',
        options: ['95', '100', '105', '110'],
        correctAnswerIndex: 2,
        explanation: '15 multiplied by 7 equals 105.',
      ),
      QuizQuestion(
        question: 'Who wrote "Romeo and Juliet"?',
        options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
        correctAnswerIndex: 1,
        explanation: 'William Shakespeare wrote the famous tragedy "Romeo and Juliet" in the late 16th century.',
      ),
      QuizQuestion(
        question: 'What is the largest ocean on Earth?',
        options: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
        correctAnswerIndex: 3,
        explanation: 'The Pacific Ocean is the largest and deepest ocean, covering about one-third of Earth\'s surface.',
      ),
    ];
    
    return questions.take(count).toList();
  }

  /// Get word of the day
  /// Returns mock data for now
  Future<WordOfTheDay> getWordOfTheDay() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Rotate through different words (in a real app, this would be date-based)
    final words = [
      WordOfTheDay(
        word: 'Serendipity',
        definition: 'The occurrence and development of events by chance in a happy or beneficial way.',
        example: 'A fortunate stroke of serendipity brought the two old friends together.',
        etymology: 'Coined by Horace Walpole in 1754, from the Persian fairy tale "The Three Princes of Serendip"',
      ),
      WordOfTheDay(
        word: 'Ephemeral',
        definition: 'Lasting for a very short time; transient.',
        example: 'The beauty of cherry blossoms is ephemeral, lasting only a few weeks each spring.',
        etymology: 'From Greek "ephemeros" meaning "lasting only a day"',
      ),
      WordOfTheDay(
        word: 'Resilient',
        definition: 'Able to recover quickly from difficulties; tough.',
        example: 'Despite the setbacks, she remained resilient and continued pursuing her goals.',
        etymology: 'From Latin "resilire" meaning "to rebound"',
      ),
    ];
    
    // Simple rotation based on current time
    final index = DateTime.now().millisecondsSinceEpoch % words.length;
    return words[index];
  }

  /// Get geography fact
  /// Returns mock data for now
  Future<GeographyFact> getGeographyFact({required Difficulty difficulty}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final facts = [
      GeographyFact(
        title: 'Mount Everest',
        description: 'Mount Everest is Earth\'s highest mountain above sea level, standing at 8,849 meters (29,032 feet). Located in the Mahalangur Himal sub-range of the Himalayas, it straddles the border between Nepal and China.',
        country: 'Nepal/China',
        latitude: 27.9881,
        longitude: 86.9250,
      ),
      GeographyFact(
        title: 'The Amazon River',
        description: 'The Amazon River is the largest river by discharge volume of water in the world, and by some definitions, the longest. It flows through South America and empties into the Atlantic Ocean.',
        country: 'Brazil/Peru/Colombia',
        latitude: -3.4653,
        longitude: -62.2159,
      ),
      GeographyFact(
        title: 'The Great Barrier Reef',
        description: 'The Great Barrier Reef is the world\'s largest coral reef system, composed of over 2,900 individual reefs and 900 islands. It is located in the Coral Sea, off the coast of Queensland, Australia.',
        country: 'Australia',
        latitude: -18.2871,
        longitude: 147.6992,
      ),
    ];
    
    final index = DateTime.now().millisecondsSinceEpoch % facts.length;
    return facts[index];
  }

  /// Get history fact
  /// Returns mock data for now
  Future<HistoryFact> getHistoryFact({required Difficulty difficulty}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final facts = [
      HistoryFact(
        title: 'The Renaissance',
        description: 'The Renaissance was a period in European history marking the transition from the Middle Ages to modernity. It was characterized by a renewed interest in classical learning, art, and science, beginning in Italy in the 14th century and spreading throughout Europe.',
        date: '14th-17th century',
        location: 'Europe',
      ),
      HistoryFact(
        title: 'The Industrial Revolution',
        description: 'The Industrial Revolution was the transition from manual production methods to machines, new chemical manufacturing and iron production processes, and the increasing use of steam power. It began in Great Britain in the late 18th century.',
        date: '1760-1840',
        location: 'Great Britain, then worldwide',
      ),
      HistoryFact(
        title: 'The Moon Landing',
        description: 'On July 20, 1969, Apollo 11 astronauts Neil Armstrong and Buzz Aldrin became the first humans to land on the Moon. Armstrong\'s first step onto the lunar surface was watched by an estimated 650 million people worldwide.',
        date: 'July 20, 1969',
        location: 'Moon (Sea of Tranquility)',
      ),
    ];
    
    final index = DateTime.now().millisecondsSinceEpoch % facts.length;
    return facts[index];
  }

  /// Get AI news articles
  /// Returns mock data for now
  Future<List<NewsArticle>> getAINews({
    required Difficulty difficulty,
    int count = 3,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final articles = [
      NewsArticle(
        title: 'Breakthrough in Large Language Models',
        summary: 'Researchers have developed a new AI model that can understand context across multiple domains with unprecedented accuracy. The model shows significant improvements in reasoning and problem-solving capabilities.',
        source: 'AI Research Weekly',
        url: 'https://example.com/llm-breakthrough',
        publishedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NewsArticle(
        title: 'AI Assists in Medical Diagnosis',
        summary: 'A new AI system has been approved to assist doctors in diagnosing rare diseases. Early trials show it can identify conditions that might take human doctors months to diagnose.',
        source: 'Medical Tech News',
        url: 'https://example.com/ai-medical',
        publishedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      NewsArticle(
        title: 'Ethical AI Guidelines Updated',
        summary: 'International organizations have released updated guidelines for ethical AI development, emphasizing transparency, fairness, and human oversight in AI systems.',
        source: 'Tech Ethics Journal',
        url: 'https://example.com/ai-ethics',
        publishedDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
    
    return articles.take(count).toList();
  }

  /// Get content based on content type and difficulty
  /// This is a convenience method that routes to the appropriate getter
  Future<dynamic> getContent({
    required ContentType type,
    required Difficulty difficulty,
    int? count,
  }) async {
    switch (type) {
      case ContentType.quiz:
        return getQuizQuestions(difficulty: difficulty, count: count ?? 5);
      case ContentType.wordOfTheDay:
        return getWordOfTheDay();
      case ContentType.geography:
        return getGeographyFact(difficulty: difficulty);
      case ContentType.history:
        return getHistoryFact(difficulty: difficulty);
      case ContentType.aiNews:
        return getAINews(difficulty: difficulty, count: count ?? 3);
    }
  }

  /// Clear cached content (useful for refreshing)
  void clearCache() {
    _contentCache.clear();
    notifyListeners();
  }

  /// Clear cache for a specific content type
  void clearCacheForType(ContentType type) {
    _contentCache.remove(type);
    notifyListeners();
  }
}

