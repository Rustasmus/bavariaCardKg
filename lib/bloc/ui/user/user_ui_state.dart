import 'user_ui_event.dart';

abstract class UserUiState {}

class UserUiInitial extends UserUiState {}
class UserUiShowDialog extends UserUiState {
  final UserUiEvent dialogEvent;
  UserUiShowDialog(this.dialogEvent);
}
