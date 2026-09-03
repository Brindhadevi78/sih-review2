// Voice reflection model — prototype only.
// Stores session metadata only. No raw audio bytes are stored globally.
// No transcription. No AI analysis. No external upload.

/// Recording status for a voice reflection.
enum VoiceReflectionStatus {
  /// Recording is in progress.
  recording,

  /// Recording stopped, awaiting save or delete.
  review,

  /// Saved for this prototype session.
  saved,
}

extension VoiceReflectionStatusLabel on VoiceReflectionStatus {
  String get label {
    switch (this) {
      case VoiceReflectionStatus.recording:
        return 'Recording';
      case VoiceReflectionStatus.review:
        return 'Review';
      case VoiceReflectionStatus.saved:
        return 'Saved';
    }
  }
}

/// A single voice reflection entry.
/// Stores only the minimum prototype metadata — no audio bytes, no transcript.
class VoiceReflection {
  final String id;
  final DateTime createdAt;

  /// Duration in seconds recorded.
  final int durationSeconds;

  /// Status at time of save.
  final VoiceReflectionStatus status;

  const VoiceReflection({
    required this.id,
    required this.createdAt,
    required this.durationSeconds,
    this.status = VoiceReflectionStatus.saved,
  });

  /// Human-readable duration string, e.g. "1:23".
  String get durationLabel {
    final m = durationSeconds ~/ 60;
    final s = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
