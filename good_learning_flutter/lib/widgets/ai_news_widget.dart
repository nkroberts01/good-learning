import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../models/difficulty.dart';
import 'package:intl/intl.dart';

/// Widget to display AI News content
class AiNewsWidget extends StatefulWidget {
  final Difficulty difficulty;

  const AiNewsWidget({
    super.key,
    required this.difficulty,
  });

  @override
  State<AiNewsWidget> createState() => _AiNewsWidgetState();
}

class _AiNewsWidgetState extends State<AiNewsWidget> {
  List<NewsArticle>? _articles;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final articles = await contentProvider.getAINews(
      difficulty: widget.difficulty,
      count: 3,
    );
    setState(() {
      _articles = articles;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_articles == null || _articles!.isEmpty) {
      return const Center(
        child: Text('No news articles available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _articles!.length,
      itemBuilder: (context, index) {
        final article = _articles![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (article.source != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          article.source!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    if (article.publishedDate != null)
                      Text(
                        _formatDate(article.publishedDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Summary
                Text(
                  article.summary,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 12),

                // Read more button (placeholder)
                if (article.url != null)
                  TextButton.icon(
                    onPressed: () {
                      // In a real app, open URL in browser
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Would open: ${article.url}'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Read More'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

