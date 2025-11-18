import 'package:good_learning_flutter/models/content_type.dart';
import 'package:good_learning_flutter/models/difficulty.dart';

class ContentBlock {
  final ContentType contentType;
  final Difficulty difficulty;
  final int duration;
  final bool enabled;

  ContentBlock({
    required this.contentType,
    required this.difficulty,
    required this.duration,
    required this.enabled,
  });
} 