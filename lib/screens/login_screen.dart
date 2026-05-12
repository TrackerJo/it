import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/api/auth.dart';
import 'package:it/api/database.dart';
import 'package:it/api/shared_prefs.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/custom_tabs.dart';
import 'package:it/widgets/dotted_rounded_border.dart';
import 'package:it/widgets/fancy_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedTab = "create";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController createEmailController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController createPasswordConfirmController =
      TextEditingController();

  static const _pressDuration = Duration(milliseconds: 80);
  bool buttonPressed = false;
  bool isLoading = false;
  DateTime? _pressedAt;

  void _releaseButton() {
    if (!buttonPressed) return;
    final elapsed = DateTime.now().difference(_pressedAt ?? DateTime.now());
    final remaining = _pressDuration - elapsed;
    if (remaining > Duration.zero) {
      Future.delayed(remaining, () {
        if (mounted) setState(() => buttonPressed = false);
      });
    } else {
      setState(() => buttonPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: styling.green,

        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,

            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Row(
                    children: [
                      Text(
                        "Welcome to",
                        style: styling.headerFont.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w400,
                          color: styling.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "It!",
                        style: styling.headerFont.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                          color: styling.pink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTabs(
                    tabs: [
                      TabItem(label: "Create Account", value: "create"),
                      TabItem(label: "Login", value: "login"),
                    ],
                    onTabChanged: (value) {
                      setState(() {
                        selectedTab = value;
                      });
                    },
                  ),
                  if (selectedTab == "create") ...buildCreate(context),
                  if (selectedTab == "login") ...buildLogin(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildCreate(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Text(
        "EMAIL",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(
        controller: createEmailController,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 32),
      Text(
        "PASSWORD",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(
        controller: createPasswordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),
      const SizedBox(height: 32),
      Text(
        "CONFIRM PASSWORD",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(
        controller: createPasswordConfirmController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),

      const SizedBox(height: 32),
      GestureDetector(
        onTapDown: (details) {
          HapticFeedback.lightImpact();
          setState(() {
            buttonPressed = true;
            _pressedAt = DateTime.now();
          });
        },
        onTapUp: (details) {
          HapticFeedback.lightImpact();
          _releaseButton();
        },
        onTapCancel: _releaseButton,
        onTap: () async {
          if (isLoading) return;
          if (createEmailController.text.isEmpty ||
              createPasswordController.text.isEmpty ||
              createPasswordConfirmController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Please fill in all fields",
                  style: styling.bodyFont.copyWith(color: styling.white),
                ),
                backgroundColor: styling.pink,
              ),
            );
            return;
          }
          if (createPasswordController.text !=
              createPasswordConfirmController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Passwords do not match",
                  style: styling.bodyFont.copyWith(color: styling.white),
                ),
                backgroundColor: styling.pink,
              ),
            );
            return;
          }
          setState(() {
            isLoading = true;
          });
          String? success = await Auth().createAccount(
            createEmailController.text.trim(),
            createPasswordController.text.trim(),
          );
          setState(() {
            isLoading = false;
          });
          if (success != null) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success,
                  style: styling.bodyFont.copyWith(color: styling.white),
                ),
                backgroundColor: styling.pink,
              ),
            );
            return;
          }

          router.pushReplacement("/onboarding");
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, buttonPressed ? 5 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: styling.pink,
            shape: StadiumBorder(
              side: BorderSide(color: styling.blue, width: 2),
            ),
            shadows: [
              if (!buttonPressed)
                BoxShadow(
                  color: styling.blue,
                  offset: Offset(0, 5),
                  blurRadius: 0,
                ),
            ],
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: styling.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Text(
                  "Create Account",
                  style: styling.bodyFont.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: styling.white,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    ];
  }

  List<Widget> buildLogin(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Text(
        "EMAIL",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 32),
      Text(
        "PASSWORD",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),

      const SizedBox(height: 32),
      GestureDetector(
        onTapDown: (details) {
          HapticFeedback.lightImpact();
          setState(() {
            buttonPressed = true;
            _pressedAt = DateTime.now();
          });
        },
        onTapUp: (details) {
          HapticFeedback.lightImpact();
          _releaseButton();
        },
        onTapCancel: _releaseButton,
        onTap: () async {
          if (isLoading) return;
          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Please fill in all fields",
                  style: styling.bodyFont.copyWith(color: styling.white),
                ),
                backgroundColor: styling.pink,
              ),
            );
            return;
          }
          setState(() {
            isLoading = true;
          });

          String? success = await Auth().login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
          setState(() {
            isLoading = false;
          });

          if (success != null) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success,
                  style: styling.bodyFont.copyWith(color: styling.white),
                ),
                backgroundColor: styling.pink,
              ),
            );
            return;
          }

          Game? game = await Database().getGamePlayersIn(Auth().getUserId()!);
          if (game != null) {
            await SharedPrefs.setGameIdSF(game.id);
            gameNotifier.value = game;
            playerNotifier.value = game.getPlayerFromId(Auth().getUserId()!);
            router.pushReplacement("/home");
            return;
          }

          router.pushReplacement("/onboarding");
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, buttonPressed ? 5 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: styling.pink,
            shape: StadiumBorder(
              side: BorderSide(color: styling.blue, width: 2),
            ),
            shadows: [
              if (!buttonPressed)
                BoxShadow(
                  color: styling.blue,
                  offset: Offset(0, 5),
                  blurRadius: 0,
                ),
            ],
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: styling.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Text(
                  "Login",
                  style: styling.bodyFont.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: styling.white,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    ];
  }
}
