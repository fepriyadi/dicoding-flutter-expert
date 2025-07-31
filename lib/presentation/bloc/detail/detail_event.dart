part of 'detail_bloc.dart';

@immutable
abstract class DetailEvent {}

class DetailData extends DetailEvent {
  final int id;

  DetailData({required this.id});
}
