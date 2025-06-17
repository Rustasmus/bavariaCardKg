import 'guest_ui_event.dart';

abstract class GuestUiState {}

class GuestUiInitial extends GuestUiState {}
class GuestUiShowDialog extends GuestUiState {
  final GuestUiEvent dialogEvent;
  GuestUiShowDialog(this.dialogEvent);
}