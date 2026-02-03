import 'package:flutter_bloc/flutter_bloc.dart';
import 'journal_log_state.dart';
import '../../../../backend/db/repositories/projects_repo.dart';

class JournalLogCubit extends Cubit<JournalLogState> {
  final ProjectsRepo _projectsRepo;
  final String projectId;

  JournalLogCubit(this._projectsRepo, this.projectId) : super(JournalLogState());

  Future<void> loadJournal() async {
    emit(state.copyWith(status: JournalStatus.loading));
    try {
      final json = await _projectsRepo.getJournalLog(projectId);
      emit(state.copyWith(status: JournalStatus.success, journalJson: json));
    } catch (e) {
      emit(state.copyWith(status: JournalStatus.error, errorMessage: e.toString()));
    }
  }

  Future<bool> saveJournal(String json) async {
    emit(state.copyWith(status: JournalStatus.saving));
    try {
      await _projectsRepo.updateJournalLog(
        id: projectId,
        journalLogJson: json,
      );
      emit(state.copyWith(status: JournalStatus.success));
      return true;
    } catch (e) {
      emit(state.copyWith(status: JournalStatus.error, errorMessage: "Save failed"));
      return false;
    }
  }
}