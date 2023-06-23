import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/pages/homepage/homepage_pages/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/pages/homepage/homepage_pages/search/bloc/search_bloc.dart';
import 'package:instagram_clone/pages/homepage/homepage_pages/feed/comment_page.dart';
import 'package:instagram_clone/widgets/instatext.dart';
import 'package:instagram_clone/widgets/post_tile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({
    super.key,
    required this.inProfile,
  });
  final bool inProfile;

  Widget buildBottomSheet(BuildContext context, double height, double width,
      bool inProfile, bool userPosts) {
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
              onTap: () {},
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
                      child: Image.asset(
                        'assets/images/insta_bookmark.png',
                        scale: 3.5,
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
            (inProfile || userPosts)
                ? ListTile(
                    minLeadingWidth: 0,
                    leading: Icon(
                      Icons.delete_outline,
                      color: instaRed,
                    ),
                    title: InstaText(
                      fontSize: 17,
                      color: instaRed,
                      fontWeight: FontWeight.normal,
                      text: "Delete",
                    ),
                    onTap: () {},
                  )
                : ListTile(
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () async {
            if (inProfile) {
              var bloc = context.read<ProfileBloc>();
              bloc.pageController.jumpToPage(0);
            } else {
              var bloc = context.read<SearchBloc>();
              if (bloc.state.usersPosts) {
                bloc.pageController.jumpToPage(1);
              } else {
                bloc.pageController.jumpToPage(0);
              }
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: InstaText(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          text: inProfile && context.read<ProfileBloc>().state.savedPosts
              ? "Saved"
              : (inProfile || context.read<SearchBloc>().state.usersPosts)
                  ? "Posts"
                  : "Explore",
        ),
      ),
      body: inProfile
          ? BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.white,
                    ),
                  );
                } else {
                  return ScrollablePositionedList.builder(
                    initialScrollIndex: state.savedPosts ? 0 : state.postsIndex,
                    itemCount: state.savedPosts
                        ? state.savedPostsList.length
                        : state.userData.posts.length,
                    itemBuilder: (context, index) {
                      return PostTile(
                        width: width,
                        height: height,
                        profileState: state,
                        searchState: null,
                        index: index,
                        feedState: null,
                        optionPressed: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: textFieldBackgroundColor,
                              context: context,
                              builder: (_) => BlocProvider.value(
                                    value: context.read<ProfileBloc>(),
                                    child: buildBottomSheet(context, height,
                                        width, inProfile, false),
                                  ));
                        },
                        likePressed: () {
                          context.read<ProfileBloc>().add(LikePostEvent(index));
                        },
                        onDoubleTap: () {
                          context.read<ProfileBloc>().add(LikePostEvent(index));
                        },
                        commentPressed: () async {
                          var sharedPreferences =
                              await SharedPreferences.getInstance();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                    value: context.read<ProfileBloc>(),
                                    child: CommentPage(
                                      sharedPreferences: sharedPreferences,
                                      postIndex: index,
                                      profileState: state,
                                      searchState: null,
                                      feedState: null,
                                    ),
                                  )));
                        },
                        bookmarkPressed: () {
                          context
                              .read<ProfileBloc>()
                              .add(BookmarkProfile(index));
                        },
                        sharePressed: () {},
                      );
                    },
                  );
                }
              },
            )
          : BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return ScrollablePositionedList.builder(
                  initialScrollIndex: state.postsIndex,
                  itemCount: state.usersPosts
                      ? state.userData.posts.length
                      : state.posts.length,
                  itemBuilder: (context, index) {
                    return PostTile(
                      width: width,
                      height: height,
                      profileState: null,
                      searchState: state,
                      index: index,
                      feedState: null,
                      optionPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: textFieldBackgroundColor,
                            context: context,
                            builder: (_) => BlocProvider.value(
                                  value: context.read<SearchBloc>(),
                                  child: buildBottomSheet(context, height,
                                      width, inProfile, state.usersPosts),
                                ));
                      },
                      likePressed: () {
                        context.read<SearchBloc>().add(SearchLikePostEvent(
                            index,
                            state.usersPosts,
                            state.usersPosts
                                ? state.userData.id
                                : state.posts[index].userId,
                            state.usersPosts
                                ? state.userData.posts[index].id
                                : state.posts[index].id));
                      },
                      commentPressed: () async {
                        var sharedPreferences =
                            await SharedPreferences.getInstance();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                                  value: context.read<SearchBloc>(),
                                  child: CommentPage(
                                    sharedPreferences: sharedPreferences,
                                    postIndex: index,
                                    searchState: state,
                                    profileState: null,
                                    feedState: null,
                                  ),
                                )));
                      },
                      bookmarkPressed: () {
                        context.read<SearchBloc>().add(BookmarkSearch(index));
                      },
                      sharePressed: () {},
                      onDoubleTap: () {
                        context.read<SearchBloc>().add(SearchLikePostEvent(
                            index,
                            state.usersPosts,
                            state.usersPosts
                                ? state.userData.id
                                : state.posts[index].userId,
                            state.usersPosts
                                ? state.userData.posts[index].id
                                : state.posts[index].id));
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}