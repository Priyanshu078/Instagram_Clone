part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GetPosts extends SearchEvent {}

class SearchUsers extends SearchEvent {
  final String text;
  const SearchUsers(this.text);
  @override
  List<Object> get props => [text];
}

class UserProfileEvent extends SearchEvent {
  final UserData userData;
  const UserProfileEvent(this.userData);
  @override
  List<Object> get props => [userData];
}

class UserProfileBackEvent extends SearchEvent {}

class TabChangeEvent extends SearchEvent {
  final int tabIndex;
  const TabChangeEvent(this.tabIndex);
  @override
  List<Object> get props => [tabIndex];
}

class PostsIndexChangeEvent extends SearchEvent {
  final int postIndex;
  final bool usersPosts;
  const PostsIndexChangeEvent(this.postIndex, this.usersPosts);

  @override
  List<Object> get props => [postIndex, usersPosts];
}

class SearchLikePostEvent extends SearchEvent {
  final int postIndex;
  final bool userPosts;
  final String userId;
  final String postId;
  const SearchLikePostEvent(
      this.postIndex, this.userPosts, this.userId, this.postId);

  @override
  List<Object> get props => [postIndex, userPosts, userId, postId];
}

class DeleteSearchComment extends SearchEvent {
  final int postIndex;
  final int commentIndex;
  const DeleteSearchComment(this.postIndex, this.commentIndex);

  @override
  List<Object> get props => [postIndex, commentIndex];
}

class AddSearchComment extends SearchEvent {
  final List<Comments> comments;
  final int postIndex;
  final String comment;
  const AddSearchComment(this.comments, this.postIndex, this.comment);

  @override
  List<Object> get props => [comments, postIndex, comment];
}

class BookmarkSearch extends SearchEvent {
  final int postIndex;
  const BookmarkSearch(this.postIndex);
  @override
  List<Object> get props => [postIndex];
}
