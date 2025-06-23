part of 'intro_app_cubit.dart';

@immutable
abstract class IntroAppState {}

class IntroAppInitial extends IntroAppState {}

class ForceUpdate extends IntroAppState {
  final String appLink;

  ForceUpdate({required this.appLink});
}

class NoRestriction extends IntroAppState {}

class AppUnderMaintenance extends IntroAppState {}