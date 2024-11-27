import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool get isFormFilled =>
      userIdController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.robotoTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language Selector
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Text(
                      'Korea, 한국어',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    label: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black87,
                      size: 20,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LG Logo
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/login/lge_logo_kr.png',
                    height: 40,
                  ),
                ),

                const SizedBox(height: 40),

                // ID TextField
                TextField(
                  controller: userIdController,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: '이메일 아이디 또는 휴대폰 번호',
                    hintStyle: textTheme.bodyLarge?.copyWith(),
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                // Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    hintStyle: textTheme.bodyLarge?.copyWith(),
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: isFormFilled
                      ? () {
                          if (userIdController.text == "test" &&
                              passwordController.text == "test") {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => Home(
                                  title: 'Flutter Demo Home Page',
                                  userId: userIdController.text,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content:
                                      Text("아이디가 존재하지 않거나 비밀번호가 일치하지 않습니다."),
                                );
                              },
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormFilled
                        ? const Color(0xFFA50034)
                        : Colors.grey.shade200,
                    foregroundColor:
                        isFormFilled ? Colors.white : Colors.grey.shade700,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    '로그인',
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: isFormFilled ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Find ID, Reset Password, Sign Up Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "아이디 찾기",
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " | ",
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      "비밀번호 재설정",
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " | ",
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      "회원가입",
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // MY LG ID Login Button
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFA50034)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/login/my_lg_id.png',
                        height: 16,
                      ),
                      Text(
                        ' 로그인',
                        style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFA50034),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Social Login Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/login/kakao.png',
                        width: 48,
                        height: 48,
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/login/naver.png',
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Other Login Option
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Text(
                      '다른 계정으로 로그인',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    label: const Icon(
                      Icons.chevron_right,
                      color: Colors.black54,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
