import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/active_session_provider.dart';
import '../models/content_type.dart';
import '../models/content_block.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/word_of_day_widget.dart';
import '../widgets/geography_widget.dart';
import '../widgets/history_widget.dart';
import '../widgets/ai_news_widget.dart';

/// Active Session Screen - Shows the running learning session
/// 
/// Displays:
/// - Current content block
/// - Progress indicators
/// - Timer
/// - Navigation controls
class ActiveSessionScreen extends StatelessWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Session'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<ActiveSessionProvider>(
            builder: (context, session, child) {
              if (session.state == SessionState.running) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: () => session.pauseSession(),
                );
              } else if (session.state == SessionState.paused) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => session.resumeSession(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<ActiveSessionProvider>(
        builder: (context, session, child) {
          if (session.state == SessionState.notStarted) {
            return const Center(
              child: Text('No active session'),
            );
          }

          if (session.state == SessionState.completed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Session Complete!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      session.cancelSession();
                      Navigator.pop(context);
                    },
                    child: const Text('Return Home'),
                  ),
                ],
              ),
            );
          }

          final currentBlock = session.currentBlock;
          if (currentBlock == null) {
            return const Center(
              child: Text('No content block available'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Overall progress
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Progress',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              session.formatTime(session.totalRemainingSeconds),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: session.totalProgress,
                          minHeight: 8,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(session.totalProgress * 100).toInt()}% complete',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Current block info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getContentTypeName(currentBlock.contentType),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Block ${session.currentBlockIndex + 1} of ${session.enabledBlocks.length}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              session.formatTime(session.currentBlockRemainingSeconds),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: session.currentBlockProgress,
                          minHeight: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Content area - dynamically loads the appropriate widget
                Expanded(
                  child: Card(
                    child: _buildContentWidget(currentBlock),
                  ),
                ),
                const SizedBox(height: 16),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: session.currentBlockIndex > 0
                          ? () => session.previousBlock()
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => session.nextBlock(),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getContentTypeName(ContentType type) {
    switch (type) {
      case ContentType.quiz:
        return 'Quiz';
      case ContentType.wordOfTheDay:
        return 'Word of the Day';
      case ContentType.geography:
        return 'Geography';
      case ContentType.history:
        return 'History';
      case ContentType.aiNews:
        return 'AI News';
    }
  }

  /// Builds the appropriate content widget based on content type
  Widget _buildContentWidget(ContentBlock block) {
    switch (block.contentType) {
      case ContentType.quiz:
        return QuizWidget(difficulty: block.difficulty);
      case ContentType.wordOfTheDay:
        return WordOfDayWidget(difficulty: block.difficulty);
      case ContentType.geography:
        return GeographyWidget(difficulty: block.difficulty);
      case ContentType.history:
        return HistoryWidget(difficulty: block.difficulty);
      case ContentType.aiNews:
        return AiNewsWidget(difficulty: block.difficulty);
    }
  }
}

