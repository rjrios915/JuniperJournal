enum JournalStatus { initial, loading, success, saving, error }

class JournalLogState {
  final JournalStatus status;
  final String? journalJson;
  final String? errorMessage;

  JournalLogState({
    this.status = JournalStatus.initial,
    this.journalJson,
    this.errorMessage,
  });

  JournalLogState copyWith({
    JournalStatus? status,
    String? journalJson,
    String? errorMessage,
  }) {
    return JournalLogState(
      status: status ?? this.status,
      journalJson: journalJson ?? this.journalJson,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}