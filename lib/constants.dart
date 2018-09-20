import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectConfig {
  // Date Overview
  static const FontColorDateOverview = Colors.black;
  static const IconColorDateOverview = Colors.redAccent;
  static const IconColorDateOverviewLeading = Colors.black;
  static const BoxDecorationColorDateOverview = Colors.white;
  static const TextAppBarDateOverview = "Termine";
  static const TextFloatingActionButtonTooltipDateOverview = "Termin hinzufügen";
  static const TextNotLoggedInSnackbarMessage = "Bitte erst einloggen";
  static const TextNotAllowedDateEntry = "Leider darfst du keine Termine hinzufügen";
  static const TextNotAllowedDateRemoval = "Leider darfst du keine Termine löschen";
  static const SnackbarBackgroundColorDateOverview = Colors.red;
  static const TextDateOverviewTryToDeleteEvent = "Termin löschen?";
  static const TextDeleteEventDialogOptionYes = "OK";
  static const TextDeleteEventDialogOptionNo = "Abbruch";

  // Date Detail
  static const FontColorDateDetail = Colors.black;
  static const TextAppBarDateDetail = "Termindetails";
  static var dateDetailFormat = new DateFormat("dd.MM.yyyy HH:mm");
  static const FontSizeSubHeaderDateDetail = 16.0;
  static const FontSizeHeaderDateDetail = 20.0;

  // Global 
  static const ColorAppBar = Colors.indigo;



}
