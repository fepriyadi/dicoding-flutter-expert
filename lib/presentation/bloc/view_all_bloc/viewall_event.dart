part of 'viewall_bloc.dart';

@immutable
abstract class ViewAllEvent {}

class FetchCategoryItems extends ViewAllEvent {
  final ContentType type;
  final CategoryType categoryType;
  FetchCategoryItems(this.type, this.categoryType);
}
