import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/pages/authentication/bloc/auth_bloc.dart';
import 'package:instagram_clone/pages/homepage/bloc/homepage_bloc.dart';
import 'package:instagram_clone/pages/homepage/homepage.dart';
import 'package:instagram_clone/pages/authentication/auth_pages/signup_page.dart';
import 'package:instagram_clone/pages/homepage/homepage_pages/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/widgets/insta_button.dart';
import 'package:instagram_clone/widgets/insta_snackbar.dart';
import 'package:instagram_clone/widgets/insta_textfield.dart';
import 'package:instagram_clone/widgets/instatext.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginDone) {
          const InstaSnackbar(text: "Login Successfull !!!").show(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => HomepageBloc(),
                      ),
                      BlocProvider(
                        create: (context) => ProfileBloc(),
                      ),
                    ],
                    child: const HomePage(),
                  )));
        } else if (state is UserDataNotAvailable) {
          const InstaSnackbar(text: "Incorrect username or password")
              .show(context);
        } else if (state is FillAllDetails) {
          const InstaSnackbar(text: "Please fill all the details !!!")
              .show(context);
        } else if (state is ErrorState) {
          const InstaSnackbar(text: "Something went wrong !!!").show(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                SizedBox(
                    height: height * 0.1,
                    width: width * 0.5,
                    child: Image.asset('assets/images/instagram.png')),
                SizedBox(
                  height: height * 0.05,
                ),
                InstaTextField(
                  editProfileTextfield: false,
                  forPassword: false,
                  suffixIcon: null,
                  suffixIconCallback: () {},
                  backgroundColor: textFieldBackgroundColor,
                  borderRadius: 5,
                  icon: null,
                  controller: userNameController,
                  hintText: "Username",
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  hintColor: Colors.white.withOpacity(0.6),
                  obscureText: false,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return InstaTextField(
                      editProfileTextfield: false,
                      forPassword: true,
                      suffixIcon: state.obscurePassword
                          ? const Icon(
                              Icons.visibility,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: Colors.white,
                            ),
                      suffixIconCallback: () {
                        context
                            .read<AuthBloc>()
                            .add(ShowPassword(!state.obscurePassword));
                      },
                      backgroundColor: textFieldBackgroundColor,
                      borderRadius: 5,
                      icon: null,
                      controller: passwordController,
                      hintText: "Password",
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      hintColor: Colors.white.withOpacity(0.6),
                      obscureText: state.obscurePassword,
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {},
                    child: InstaText(
                        fontSize: 12,
                        color: instablue,
                        fontWeight: FontWeight.w500,
                        text: "Forgot password?"),
                  ),
                ),
                SizedBox(
                  height: height * 0.035,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return SizedBox(
                        height: height * 0.065,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        ),
                      );
                    } else {
                      return InstaButton(
                          height: height * 0.065,
                          buttonColor: instablue,
                          onPressed: () {
                            String username = userNameController.text;
                            String password = passwordController.text;
                            context
                                .read<AuthBloc>()
                                .add(RequestLoginEvent(username, password));
                          },
                          text: "Log in",
                          fontSize: 14,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w700);
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InstaText(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.normal,
                        text: "Dont have an account? "),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (create) => AuthBloc(),
                                    ),
                                  ],
                                  child: const SignupPage(),
                                ))));
                      },
                      child: InstaText(
                          fontSize: 14,
                          color: instablue,
                          fontWeight: FontWeight.normal,
                          text: "Sign up."),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
