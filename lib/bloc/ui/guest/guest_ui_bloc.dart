import 'package:flutter_bloc/flutter_bloc.dart';
import 'guest_ui_event.dart';
import 'guest_ui_state.dart';

class GuestUiBloc extends Bloc<GuestUiEvent, GuestUiState> {
  GuestUiBloc() : super(GuestUiInitial()) {
    on<ShowLoginDialog>((event, emit) => emit(GuestUiShowDialog(event)));
    on<ShowContactsDialog>((event, emit) => emit(GuestUiShowDialog(event)));
    on<ShowPackagesDialog>((event, emit) => emit(GuestUiShowDialog(event)));
    on<ShowNewsDialog>((event, emit) => emit(GuestUiShowDialog(event)));
    on<ShowPromosDialog>((event, emit) => emit(GuestUiShowDialog(event)));
    // если нужно, можешь добавить события для возврата к GuestUiInitial
  }
}
