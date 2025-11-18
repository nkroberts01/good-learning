import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_config_provider.dart';
import '../providers/active_session_provider.dart';
import 'session_builder_screen.dart';
import 'active_session_screen.dart';

/// Home screen - Main entry point of the app
/// 
/// Shows:
/// - Quick start button
/// - Current session configuration summary
/// - Navigation to session builder
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Good Learning'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<SessionConfigProvider>(
        builder: (context, sessionConfig, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.school,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ready to Learn?',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start your personalized learning session',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Current session summary
                if (sessionConfig.currentConfig != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Session',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Duration: ${sessionConfig.totalDuration} minutes',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Blocks: ${sessionConfig.contentBlocks.length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Enabled: ${sessionConfig.getEnabledBlocks().length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Action buttons
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to session builder
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SessionBuilderScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Configure Session'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: sessionConfig.currentConfig != null &&
                          sessionConfig.isValid()
                      ? () {
                          // Start the session
                          final config = sessionConfig.currentConfig!;
                          Provider.of<ActiveSessionProvider>(context,
                                  listen: false)
                              .startSession(config);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ActiveSessionScreen(),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Session'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

