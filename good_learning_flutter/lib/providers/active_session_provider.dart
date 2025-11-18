import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:good_learning_flutter/models/session_config.dart';
import 'package:good_learning_flutter/models/content_block.dart';

/// Represents the current state of an active session
enum SessionState {
  notStarted,
  running,
  paused,
  completed,
}

/// Manages the state of an active learning session
/// 
/// This provider handles:
/// - Starting, pausing, and completing sessions
/// - Tracking current content block
/// - Managing session timer
/// - Progress tracking
class ActiveSessionProvider extends ChangeNotifier {
  SessionState _state = SessionState.notStarted;
  SessionConfig? _sessionConfig;
  int _currentBlockIndex = 0;
  int _totalElapsedSeconds = 0;
  int _currentBlockElapsedSeconds = 0;
  Timer? _timer;

  // Getters
  SessionState get state => _state;
  SessionConfig? get sessionConfig => _sessionConfig;
  int get currentBlockIndex => _currentBlockIndex;
  int get totalElapsedSeconds => _totalElapsedSeconds;
  int get currentBlockElapsedSeconds => _currentBlockElapsedSeconds;
  
  /// Get the current content block being displayed
  ContentBlock? get currentBlock {
    if (_sessionConfig == null) return null;
    final enabledBlocks = _sessionConfig!.contentBlocks
        .where((block) => block.enabled)
        .toList();
    if (_currentBlockIndex >= enabledBlocks.length) return null;
    return enabledBlocks[_currentBlockIndex];
  }

  /// Get total duration in seconds
  int get totalDurationSeconds {
    return _sessionConfig?.totalDuration ?? 0;
  }

  /// Get current block duration in seconds
  int get currentBlockDurationSeconds {
    return currentBlock?.duration ?? 0;
  }

  /// Get remaining time for current block (in seconds)
  int get currentBlockRemainingSeconds {
    final remaining = currentBlockDurationSeconds - _currentBlockElapsedSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// Get total remaining time (in seconds)
  int get totalRemainingSeconds {
    final remaining = (totalDurationSeconds * 60) - _totalElapsedSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// Get progress as a percentage (0.0 to 1.0)
  double get totalProgress {
    if (totalDurationSeconds == 0) return 0.0;
    return _totalElapsedSeconds / (totalDurationSeconds * 60);
  }

  /// Get current block progress as a percentage (0.0 to 1.0)
  double get currentBlockProgress {
    if (currentBlockDurationSeconds == 0) return 0.0;
    return _currentBlockElapsedSeconds / (currentBlockDurationSeconds * 60);
  }

  /// Get list of all enabled blocks
  List<ContentBlock> get enabledBlocks {
    if (_sessionConfig == null) return [];
    return _sessionConfig!.contentBlocks.where((block) => block.enabled).toList();
  }

  /// Check if session is active (running or paused)
  bool get isActive => _state == SessionState.running || _state == SessionState.paused;

  /// Start a new session with the given configuration
  void startSession(SessionConfig config) {
    if (_state == SessionState.running) {
      throw StateError('Session is already running');
    }

    _sessionConfig = config;
    _currentBlockIndex = 0;
    _totalElapsedSeconds = 0;
    _currentBlockElapsedSeconds = 0;
    _state = SessionState.running;
    
    _startTimer();
    notifyListeners();
  }

  /// Pause the current session
  void pauseSession() {
    if (_state != SessionState.running) return;
    
    _state = SessionState.paused;
    _timer?.cancel();
    notifyListeners();
  }

  /// Resume a paused session
  void resumeSession() {
    if (_state != SessionState.paused) return;
    
    _state = SessionState.running;
    _startTimer();
    notifyListeners();
  }

  /// Move to the next content block
  void nextBlock() {
    if (_sessionConfig == null) return;
    
    final enabledBlocks = this.enabledBlocks;
    if (_currentBlockIndex < enabledBlocks.length - 1) {
      _currentBlockIndex++;
      _currentBlockElapsedSeconds = 0;
      notifyListeners();
    } else {
      // No more blocks, complete the session
      completeSession();
    }
  }

  /// Move to the previous content block
  void previousBlock() {
    if (_currentBlockIndex > 0) {
      _currentBlockIndex--;
      _currentBlockElapsedSeconds = 0;
      notifyListeners();
    }
  }

  /// Skip to a specific block index
  void goToBlock(int index) {
    final enabledBlocks = this.enabledBlocks;
    if (index >= 0 && index < enabledBlocks.length) {
      _currentBlockIndex = index;
      _currentBlockElapsedSeconds = 0;
      notifyListeners();
    }
  }

  /// Complete the current session
  void completeSession() {
    _state = SessionState.completed;
    _timer?.cancel();
    notifyListeners();
  }

  /// Cancel/stop the current session
  void cancelSession() {
    _state = SessionState.notStarted;
    _timer?.cancel();
    _sessionConfig = null;
    _currentBlockIndex = 0;
    _totalElapsedSeconds = 0;
    _currentBlockElapsedSeconds = 0;
    notifyListeners();
  }

  /// Start the timer that updates every second
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state != SessionState.running) {
        timer.cancel();
        return;
      }

      _totalElapsedSeconds++;
      _currentBlockElapsedSeconds++;

      // Check if current block time is up
      if (_currentBlockElapsedSeconds >= currentBlockDurationSeconds * 60) {
        // Auto-advance to next block if time is up
        nextBlock();
      }

      // Check if total session time is up
      if (_totalElapsedSeconds >= totalDurationSeconds * 60) {
        completeSession();
      }

      notifyListeners();
    });
  }

  /// Format seconds as MM:SS
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

