import 'package:good_learning_flutter/models/content_block.dart';

class SessionConfig {
  final int totalDuration;
  final List<ContentBlock> contentBlocks;

  SessionConfig({
    required this.totalDuration,
    required this.contentBlocks,
  });
}