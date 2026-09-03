// Voice Reflection Provider — prototype only.
// All state is in-memory. Nothing is uploaded. No audio bytes stored.
// No AI analysis. No transcription. No external service contact.

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/voice_reflection.dart';

/// Recording state for the active (in-progress) recording session.
enum RecordingState {
  /// No active recording.
  idle,

  /// Simulated recording in progress (prototype — no real mic API used).
  recording,

  /// Recording stopped, pending save or discard.
  review,
}

class VoiceReflectionProvider extends ChangeNotifier {
  final List<VoiceReflection> _saved = [];

  RecordingState _recordingState = RecordingState.idle;
  int _elapsedSeconds = 0;
  Timer? _timer;

  // ── Getters ─────────────────────────────────────────────────────────────────

  RecordingState get recordingState => _recordingState;
  int get elapsedSeconds => _elapsedSeconds;
  List<VoiceReflection> get savedReflections =>
      List.unmodifiable(_saved.reversed.toList());
  int get savedCount => _saved.length;

  String get elapsedLabel {
    final m = _elapsedSeconds ~/ 60;
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Recording lifecycle ──────────────────────────────────────────────────────

  /// Starts a prototype recording session.
  /// In production this would request microphone permission and start capture.
  /// Here it starts a timer to simulate elapsed time.
  void startRecording() {
    if (_recordingState == RecordingState.recording) return;
    _elapsedSeconds = 0;
    _recordingState = RecordingState.recording;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  /// Stops recording and moves to review state.
  void stopRecording() {
    if (_recordingState != RecordingState.recording) return;
    _timer?.cancel();
    _timer = null;
    _recordingState = RecordingState.review;
    notifyListeners();
  }

  /// Cancels and discards the current recording without saving.
  void cancelRecording() {
    _timer?.cancel();
    _timer = null;
    _elapsedSeconds = 0;
    _recordingState = RecordingState.idle;
    notifyListeners();
  }

  /// Saves the current review-state recording as a VoiceReflection.
  /// Returns the saved reflection, or null if not in review state.
  VoiceReflection? saveRecording() {
    if (_recordingState != RecordingState.review) return null;
    final reflection = VoiceReflection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      durationSeconds: _elapsedSeconds,
    );
    _saved.add(reflection);
    _elapsedSeconds = 0;
    _recordingState = RecordingState.idle;
    notifyListeners();
    return reflection;
  }

  /// Deletes a single saved voice reflection by id.
  void deleteReflection(String id) {
    _saved.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  /// Clears all saved voice reflections and resets recording state.
  void clearAll() {
    _timer?.cancel();
    _timer = null;
    _saved.clear();
    _elapsedSeconds = 0;
    _recordingState = RecordingState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ── VoiceReflectionScope ──────────────────────────────────────────────────────

// Scope is defined in app.dart alongside all other scopes.
// This file exports only the provider.
