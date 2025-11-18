import 'package:flutter/foundation.dart';
import 'package:good_learning_flutter/models/session_config.dart';
import 'package:good_learning_flutter/models/content_block.dart';
import 'package:good_learning_flutter/models/content_type.dart';
import 'package:good_learning_flutter/models/difficulty.dart';

/// Manages the session configuration state
/// 
/// This provider handles:
/// - Creating and editing session configurations
/// - Managing content blocks (add, remove, reorder, enable/disable)
/// - Setting total duration
/// - Saving and loading session presets
class SessionConfigProvider extends ChangeNotifier {
  SessionConfig? _currentConfig;
  final List<SessionConfig> _savedPresets = [];

  // Getters
  SessionConfig? get currentConfig => _currentConfig;
  List<SessionConfig> get savedPresets => List.unmodifiable(_savedPresets);
  int get totalDuration => _currentConfig?.totalDuration ?? 15;
  List<ContentBlock> get contentBlocks => 
      _currentConfig?.contentBlocks ?? [];

  /// Initialize with a default session configuration
  void initializeDefault() {
    _currentConfig = SessionConfig(
      totalDuration: 15, // 15 minutes default
      contentBlocks: [
        ContentBlock(
          contentType: ContentType.quiz,
          difficulty: Difficulty.beginner,
          duration: 5,
          enabled: true,
        ),
        ContentBlock(
          contentType: ContentType.wordOfTheDay,
          difficulty: Difficulty.beginner,
          duration: 2,
          enabled: true,
        ),
      ],
    );
    notifyListeners();
  }

  /// Set the total duration of the session (in minutes)
  void setTotalDuration(int minutes) {
    if (minutes < 5 || minutes > 60) {
      throw ArgumentError('Duration must be between 5 and 60 minutes');
    }
    
    if (_currentConfig == null) {
      initializeDefault();
    }
    
    _currentConfig = SessionConfig(
      totalDuration: minutes,
      contentBlocks: _currentConfig!.contentBlocks,
    );
    notifyListeners();
  }

  /// Add a new content block to the session
  void addContentBlock({
    required ContentType contentType,
    Difficulty difficulty = Difficulty.beginner,
    int duration = 5,
    bool enabled = true,
  }) {
    if (_currentConfig == null) {
      initializeDefault();
    }

    final newBlock = ContentBlock(
      contentType: contentType,
      difficulty: difficulty,
      duration: duration,
      enabled: enabled,
    );

    final updatedBlocks = List<ContentBlock>.from(_currentConfig!.contentBlocks)
      ..add(newBlock);

    _currentConfig = SessionConfig(
      totalDuration: _currentConfig!.totalDuration,
      contentBlocks: updatedBlocks,
    );
    notifyListeners();
  }

  /// Remove a content block by index
  void removeContentBlock(int index) {
    if (_currentConfig == null || index < 0 || index >= _currentConfig!.contentBlocks.length) {
      return;
    }

    final updatedBlocks = List<ContentBlock>.from(_currentConfig!.contentBlocks)
      ..removeAt(index);

    _currentConfig = SessionConfig(
      totalDuration: _currentConfig!.totalDuration,
      contentBlocks: updatedBlocks,
    );
    notifyListeners();
  }

  /// Update an existing content block
  void updateContentBlock(int index, {
    ContentType? contentType,
    Difficulty? difficulty,
    int? duration,
    bool? enabled,
  }) {
    if (_currentConfig == null || index < 0 || index >= _currentConfig!.contentBlocks.length) {
      return;
    }

    final block = _currentConfig!.contentBlocks[index];
    final updatedBlock = ContentBlock(
      contentType: contentType ?? block.contentType,
      difficulty: difficulty ?? block.difficulty,
      duration: duration ?? block.duration,
      enabled: enabled ?? block.enabled,
    );

    final updatedBlocks = List<ContentBlock>.from(_currentConfig!.contentBlocks);
    updatedBlocks[index] = updatedBlock;

    _currentConfig = SessionConfig(
      totalDuration: _currentConfig!.totalDuration,
      contentBlocks: updatedBlocks,
    );
    notifyListeners();
  }

  /// Toggle enable/disable for a content block
  void toggleContentBlock(int index) {
    if (_currentConfig == null || index < 0 || index >= _currentConfig!.contentBlocks.length) {
      return;
    }

    final block = _currentConfig!.contentBlocks[index];
    updateContentBlock(index, enabled: !block.enabled);
  }

  /// Move a content block up in the list (earlier in session)
  void moveBlockUp(int index) {
    if (_currentConfig == null || index <= 0 || index >= _currentConfig!.contentBlocks.length) {
      return;
    }

    final updatedBlocks = List<ContentBlock>.from(_currentConfig!.contentBlocks);
    final block = updatedBlocks.removeAt(index);
    updatedBlocks.insert(index - 1, block);

    _currentConfig = SessionConfig(
      totalDuration: _currentConfig!.totalDuration,
      contentBlocks: updatedBlocks,
    );
    notifyListeners();
  }

  /// Move a content block down in the list (later in session)
  void moveBlockDown(int index) {
    if (_currentConfig == null || index < 0 || index >= _currentConfig!.contentBlocks.length - 1) {
      return;
    }

    final updatedBlocks = List<ContentBlock>.from(_currentConfig!.contentBlocks);
    final block = updatedBlocks.removeAt(index);
    updatedBlocks.insert(index + 1, block);

    _currentConfig = SessionConfig(
      totalDuration: _currentConfig!.totalDuration,
      contentBlocks: updatedBlocks,
    );
    notifyListeners();
  }

  /// Get only enabled content blocks
  List<ContentBlock> getEnabledBlocks() {
    return contentBlocks.where((block) => block.enabled).toList();
  }

  /// Calculate total duration of enabled blocks
  int getTotalBlockDuration() {
    return getEnabledBlocks().fold(0, (sum, block) => sum + block.duration);
  }

  /// Validate that the session configuration is valid
  bool isValid() {
    if (_currentConfig == null) return false;
    
    final enabledBlocks = getEnabledBlocks();
    if (enabledBlocks.isEmpty) return false;
    
    final totalBlockDuration = getTotalBlockDuration();
    // Allow some flexibility - blocks can be slightly over/under total duration
    return totalBlockDuration > 0 && totalBlockDuration <= totalDuration + 5;
  }

  /// Load a saved preset
  void loadPreset(SessionConfig preset) {
    _currentConfig = SessionConfig(
      totalDuration: preset.totalDuration,
      contentBlocks: List.from(preset.contentBlocks),
    );
    notifyListeners();
  }

  /// Save current configuration as a preset (for future use)
  /// In a real app, you'd save this to local storage
  void saveAsPreset(String name) {
    if (_currentConfig == null || !isValid()) {
      throw StateError('Cannot save invalid session configuration');
    }

    // For now, just store in memory
    // Later you'd save to SharedPreferences or a database
    _savedPresets.add(SessionConfig(
      totalDuration: _currentConfig!.totalDuration,
      contentBlocks: List.from(_currentConfig!.contentBlocks),
    ));
    notifyListeners();
  }

  /// Clear the current configuration
  void clear() {
    _currentConfig = null;
    notifyListeners();
  }
}

