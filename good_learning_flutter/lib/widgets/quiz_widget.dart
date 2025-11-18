import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../models/difficulty.dart';

/// Widget to display Quiz content
class QuizWidget extends StatefulWidget {
  final Difficulty difficulty;

  const QuizWidget({
    super.key,
    required this.difficulty,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  List<QuizQuestion>? _questions;
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _isLoading = true;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final questions = await contentProvider.getQuizQuestions(
      difficulty: widget.difficulty,
      count: 5,
    );
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _selectAnswer(int index) {
    if (_showResult) return;

    setState(() {
      _selectedAnswer = index;
      _showResult = true;
      if (index == _questions![_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions!.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = null;
        _showResult = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_questions == null || _questions!.isEmpty) {
      return const Center(
        child: Text('No quiz questions available'),
      );
    }

    final question = _questions![_currentQuestionIndex];
    final isCorrect = _selectedAnswer == question.correctAnswerIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of ${_questions!.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Score: $_score/${_questions!.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions!.length,
            minHeight: 6,
          ),
          const SizedBox(height: 32),

          // Question
          Text(
            question.question,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Answer options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswer == index;
            final isCorrectAnswer = index == question.correctAnswerIndex;

            Color? backgroundColor;
            Color? textColor;
            IconData? icon;

            if (_showResult) {
              if (isCorrectAnswer) {
                backgroundColor = Colors.green.shade100;
                textColor = Colors.green.shade900;
                icon = Icons.check_circle;
              } else if (isSelected && !isCorrectAnswer) {
                backgroundColor = Colors.red.shade100;
                textColor = Colors.red.shade900;
                icon = Icons.cancel;
              }
            } else if (isSelected) {
              backgroundColor = Theme.of(context).colorScheme.primaryContainer;
              textColor = Theme.of(context).colorScheme.onPrimaryContainer;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () => _selectAnswer(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (icon != null)
                        Icon(icon, color: textColor, size: 24)
                      else
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: textColor,
                                fontWeight: isSelected ? FontWeight.w600 : null,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Explanation
          if (_showResult && question.explanation != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.info,
                        color: isCorrect ? Colors.green : Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isCorrect ? 'Correct!' : 'Explanation',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.explanation!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],

          // Navigation buttons
          if (_showResult) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                ElevatedButton.icon(
                  onPressed: _currentQuestionIndex < _questions!.length - 1
                      ? _nextQuestion
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    _currentQuestionIndex < _questions!.length - 1
                        ? 'Next'
                        : 'Complete',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

