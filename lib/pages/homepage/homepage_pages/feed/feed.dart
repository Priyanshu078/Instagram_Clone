import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/pages/chat_page.dart';
import 'package:instagram_clone/pages/homepage/homepage_pages/feed/comment_page.dart';
import 'package:instagram_clone/pages/homepage/homepage_pages/search/user_profile.dart';
import 'package:instagram_clone/widgets/instatext.dart';
import 'package:instagram_clone/widgets/post_tile.dart';
import 'package:instagram_clone/widgets/profile_photo.dart';
import 'package:instagram_clone/widgets/user_posts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/feed_bloc.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  Widget buildBottomSheet(
      BuildContext context, double height, double width, int index) {
    var feedState = context.read<FeedBloc>().state;
    return SizedBox(
      height: height * 0.3,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.read<FeedBloc>().add(BookmarkFeed(index, true));
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  Container(
                    height: height * 0.09,
                    width: height * 0.09,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: feedState.myData.bookmarks
                              .contains(feedState.posts[index].id)
                          ? const Icon(
                              CupertinoIcons.bookmark_fill,
                              color: Colors.white,
                              size: 30,
                            )
                          : const Icon(
                              CupertinoIcons.bookmark,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  const InstaText(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    text: "Save",
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Divider(
              color: Colors.white.withOpacity(0.3),
            ),
            ListTile(
              minLeadingWidth: 0,
              leading: const Icon(
                Icons.person_remove,
                color: Colors.white,
              ),
              title: const InstaText(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                text: "Unfollow",
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: context.read<FeedBloc>().pageController,
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: textFieldBackgroundColor,
            title: SizedBox(
              height: AppBar().preferredSize.height * 0.8,
              width: width * 0.3,
              child: Image.asset('assets/images/instagram.png'),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChatPage()));
                },
                icon: SizedBox(
                  height: AppBar().preferredSize.height * 0.8,
                  width: width * 0.07,
                  child: Image.asset('assets/images/messanger.png'),
                ),
              ),
            ],
          ),
          body: BlocBuilder<FeedBloc, FeedState>(
            builder: (context, state) {
              if (state is FeedFetched ||
                  state is PostLikedState ||
                  state is CommentAddedState ||
                  state is CommentDeletedState ||
                  state is BookmarkedState ||
                  state is UserDataLoadingState ||
                  state is UserDataFetchedState ||
                  state is TabChangedFeedState ||
                  state is PostIndexChangeFeedState) {
                return ListView.builder(
                    itemCount: state.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              SizedBox(
                                height: height * 0.1,
                                width: width * 0.2,
                                child: GestureDetector(
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ProfilePhoto(
                                          height: height * 0.1,
                                          width: height * 0.1,
                                          wantBorder: false,
                                          storyAdder: false,
                                          imageUrl:
                                              state.myData.profilePhotoUrl,
                                        ),
                                        Container(
                                          height: height * 0.1,
                                          width: height * 0.1,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.pink.shade900,
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.1,
                                width: width * 0.8,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.5),
                                      child: GestureDetector(
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ProfilePhoto(
                                                height: height * 0.1,
                                                width: height * 0.1,
                                                wantBorder: false,
                                                storyAdder: false,
                                                imageUrl: state
                                                    .myData.profilePhotoUrl,
                                              ),
                                              Container(
                                                height: height * 0.1,
                                                width: height * 0.1,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors
                                                            .pink.shade900)),
                                              )
                                            ]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return PostTile(
                          isFeedData: true,
                          width: width,
                          height: height,
                          profileState: null,
                          searchState: null,
                          index: index - 1,
                          feedState: state,
                          onUserNamePressed: () async {
                            var bloc = context.read<FeedBloc>();
                            bloc.add(
                                FetchUserData(state.posts[index - 1].userId));
                            await bloc.pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease);
                          },
                          optionPressed: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: textFieldBackgroundColor,
                                context: context,
                                builder: (_) => BlocProvider.value(
                                      value: context.read<FeedBloc>(),
                                      child: buildBottomSheet(
                                        context,
                                        height,
                                        width,
                                        index - 1,
                                      ),
                                    ));
                          },
                          likePressed: () {
                            context.read<FeedBloc>().add(PostLikeEvent(
                                state.posts[index - 1].id,
                                index - 1,
                                state.posts[index - 1].userId,
                                true));
                          },
                          onDoubleTap: () {
                            context.read<FeedBloc>().add(PostLikeEvent(
                                state.posts[index - 1].id,
                                index - 1,
                                state.posts[index - 1].userId,
                                true));
                          },
                          commentPressed: () async {
                            var sharedPreferences =
                                await SharedPreferences.getInstance();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                      value: context.read<FeedBloc>(),
                                      child: CommentPage(
                                        sharedPreferences: sharedPreferences,
                                        feedState: state,
                                        profileState: null,
                                        searchState: null,
                                        postIndex: index - 1,
                                        inFeed: true,
                                      ),
                                    )));
                          },
                          bookmarkPressed: () {
                            context
                                .read<FeedBloc>()
                                .add(BookmarkFeed(index - 1, true));
                          },
                          sharePressed: () {},
                        );
                      }
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1,
                  ),
                );
              }
            },
          ),
        ),
        BlocProvider.value(
          value: context.read<FeedBloc>(),
          child: UserProfilePage(
            inSearch: false,
            pageController: context.read<FeedBloc>().pageController,
          ),
        ),
        BlocProvider.value(
          value: context.read<FeedBloc>(),
          child: const UserPosts(
            inProfile: false,
            inFeed: true,
          ),
        )
      ],
    );
  }
}
