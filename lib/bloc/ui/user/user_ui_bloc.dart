import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_ui_event.dart';
import 'user_ui_state.dart';

class UserUiBloc extends Bloc<UserUiEvent, UserUiState> {
  UserUiBloc() : super(UserUiInitial()) {
    on<ShowContactsDialog>((event, emit) => emit(UserUiShowDialog(event)));
    on<ShowPackagesDialog>((event, emit) => emit(UserUiShowDialog(event)));
    on<ShowNewsDialog>((event, emit) => emit(UserUiShowDialog(event)));
    on<ShowPromosDialog>((event, emit) => emit(UserUiShowDialog(event)));
    on<ShowHistoryDialog>((event, emit) => emit(UserUiShowDialog(event)));
  }
}
