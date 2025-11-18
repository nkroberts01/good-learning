import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_config_provider.dart';
import '../models/content_type.dart';
import '../models/difficulty.dart';

/// Session Builder Screen - Configure your learning session
/// 
/// Allows users to:
/// - Set total duration
/// - Add/remove content blocks
/// - Configure block settings (type, difficulty, duration)
/// - Enable/disable blocks
class SessionBuilderScreen extends StatelessWidget {
  const SessionBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Session'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<SessionConfigProvider>(
        builder: (context, sessionConfig, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Total duration section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Duration',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${sessionConfig.totalDuration} minutes',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: sessionConfig.totalDuration.toDouble(),
                        min: 5,
                        max: 60,
                        divisions: 11,
                        label: '${sessionConfig.totalDuration} minutes',
                        onChanged: (value) {
                          sessionConfig.setTotalDuration(value.toInt());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Content blocks section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Content Blocks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddBlockDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Block'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // List of content blocks
              if (sessionConfig.contentBlocks.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No content blocks yet',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add a block to get started',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...sessionConfig.contentBlocks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final block = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: block.enabled,
                        onChanged: (_) {
                          sessionConfig.toggleContentBlock(index);
                        },
                      ),
                      title: Text(_getContentTypeName(block.contentType)),
                      subtitle: Text(
                        '${block.duration} min • ${_getDifficultyName(block.difficulty)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditBlockDialog(context, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              sessionConfig.removeContentBlock(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 24),

              // Validation status
              if (!sessionConfig.isValid())
                Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Session configuration needs at least one enabled block',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showAddBlockDialog(BuildContext context) {
    ContentType? selectedType = ContentType.quiz;
    Difficulty selectedDifficulty = Difficulty.beginner;
    int duration = 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Content Block'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ContentType>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Content Type'),
                items: ContentType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getContentTypeName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Difficulty>(
                value: selectedDifficulty,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: Difficulty.values.map((difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(_getDifficultyName(difficulty)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedDifficulty = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  duration = int.tryParse(value) ?? 5;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<SessionConfigProvider>(context, listen: false)
                    .addContentBlock(
                  contentType: selectedType!,
                  difficulty: selectedDifficulty,
                  duration: duration,
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBlockDialog(BuildContext context, int index) {
    final sessionConfig = Provider.of<SessionConfigProvider>(context, listen: false);
    final block = sessionConfig.contentBlocks[index];
    
    ContentType selectedType = block.contentType;
    Difficulty selectedDifficulty = block.difficulty;
    final durationController = TextEditingController(text: block.duration.toString());

    // Dispose the controller when the dialog is dismissed
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Content Block'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ContentType>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Content Type'),
                items: ContentType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getContentTypeName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Difficulty>(
                value: selectedDifficulty,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: Difficulty.values.map((difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(_getDifficultyName(difficulty)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedDifficulty = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final duration = int.tryParse(durationController.text) ?? block.duration;
                sessionConfig.updateContentBlock(
                  index,
                  contentType: selectedType,
                  difficulty: selectedDifficulty,
                  duration: duration,
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ).then((_) {
      // Dispose the controller after the dialog is dismissed
      durationController.dispose();
    });
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

  String _getDifficultyName(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
    }
  }
}

