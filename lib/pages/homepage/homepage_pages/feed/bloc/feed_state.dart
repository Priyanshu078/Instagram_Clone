part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState(this.posts, this.myData, this.userData, this.tabIndex,
      this.postsIndex, this.stories);
  final List<Post> posts;
  final UserData myData;
  final UserData userData;
  final int postsIndex;
  final int tabIndex;
  final List<StoryData> stories;
  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class FeedInitial extends FeedState {
  const FeedInitial(super.posts, super.myData, super.userData, super.tabIndex,
      super.postsIndex, super.stories);

  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class FeedFetched extends FeedState {
  const FeedFetched(super.posts, super.myData, super.userData, super.tabIndex,
      super.postsIndex, super.stories);

  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class PostLikedState extends FeedState {
  const PostLikedState(super.posts, super.myData, super.userData,
      super.tabIndex, super.postsIndex, super.stories);

  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class CommentAddedState extends FeedState {
  const CommentAddedState(super.posts, super.myData, super.userData,
      super.tabIndex, super.postsIndex, super.stories);
  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class CommentDeletedState extends FeedState {
  const CommentDeletedState(super.posts, super.myData, super.userData,
      super.tabIndex, super.postsIndex, super.stories);
  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class BookmarkedState extends FeedState {
  const BookmarkedState(super.posts, super.myData, super.userData,
      super.tabIndex, super.postsIndex, super.stories);
  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class UserDataLoadingState extends FeedState {
  const UserDataLoadingState(super.posts, super.myData, super.userData,
      super.tabIndex, super.postsIndex, super.stories);

  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class UserDataFetchedState extends FeedState {
  const UserDataFetchedState(super.posts, super.myData, super.userData,
      super.tabIndex, super.postsIndex, super.stories);

  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class TabChangedFeedState extends FeedState {
  const TabChangedFeedState(super.posts, super.myData, super.userData,
      super.tabIndex, super.postsIndex, super.stories);
  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}

class PostIndexChangeFeedState extends FeedState {
  const PostIndexChangeFeedState(super.posts, super.myData, super.userData,
      super.tabIndex, super.postsIndex, super.stories);
  @override
  List<Object> get props =>
      [posts, myData, userData, tabIndex, postsIndex, stories];
}
