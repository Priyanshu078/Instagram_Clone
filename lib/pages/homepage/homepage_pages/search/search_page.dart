import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/widgets/user_posts.dart';
import 'package:instagram_clone/pages/homepage/homepage_pages/search/user_profile.dart';
import 'package:instagram_clone/widgets/insta_textfield.dart';
import 'package:instagram_clone/widgets/instatext.dart';
import 'bloc/search_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: context.read<SearchBloc>().pageController,
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: textFieldBackgroundColor,
            title: SizedBox(
              height: AppBar().preferredSize.height,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: InstaTextField(
                  focusNode: context.read<SearchBloc>().focusNode,
                  enabled: true,
                  editProfileTextfield: false,
                  forPassword: false,
                  suffixIcon: null,
                  suffixIconCallback: () {},
                  backgroundColor: searchTextFieldColor,
                  borderRadius: 15,
                  icon: Icon(
                    Icons.search,
                    color: searchHintText,
                  ),
                  controller: context.read<SearchBloc>().searchController,
                  hintText: "Search",
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  hintColor: searchHintText,
                  obscureText: false,
                  onChange: (value) {
                    if (value.isNotEmpty) {
                      context.read<SearchBloc>().add(SearchUsers(value));
                    } else {
                      context.read<SearchBloc>().add(GetPosts());
                    }
                  },
                ),
              ),
            ),
          ),
          body: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1,
                  ),
                );
              } else if (state is PostsFetched ||
                  state is PostIndexChangedState) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: GridView.builder(
                    itemCount: state.posts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          var bloc = context.read<SearchBloc>();
                          bloc.add(PostsIndexChangeEvent(index, false));
                          await bloc.pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.ease,
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: state.posts[index].imageUrl,
                          fit: BoxFit.fill,
                          placeholder: (context, val) {
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              } else if (state is UsersSearched) {
                return SizedBox(
                  height: height,
                  width: width,
                  child: ListView.builder(
                    itemCount: state.usersList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          var bloc = context.read<SearchBloc>();
                          await bloc.pageController.animateToPage(1,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.ease);
                          bloc.add(UserProfileEvent(state.usersList[index]));
                        },
                        leading: ClipOval(
                          child: Container(
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            height: double.maxFinite,
                            width: width * 0.16,
                            child: CachedNetworkImage(
                              imageUrl: state.usersList[index].profilePhotoUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: InstaText(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          text: state.usersList[index].username,
                        ),
                        subtitle: InstaText(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.normal,
                          text: state.usersList[index].name,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: InstaText(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      text: "Search"),
                );
              }
            },
          ),
        ),
        BlocProvider.value(
          value: context.read<SearchBloc>(),
          child: UserProfilePage(
            pageController: context.read<SearchBloc>().pageController,
          ),
        ),
        BlocProvider.value(
          value: context.read<SearchBloc>(),
          child: const UserPosts(inProfile: false),
        )
      ],
    );
  }
}
