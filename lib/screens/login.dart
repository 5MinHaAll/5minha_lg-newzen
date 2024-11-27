import 'package:flutter/material.dart';
import '../home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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
                    icon: const Text(
                      'Korea, 한국어',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    label: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
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
          
                const SizedBox(
                    height: 20),
          
                // LG Logo
                Image.asset(
                  height: 40,
                  'assets/images/login/lge_logo_kr.png',
                ),
          
                const SizedBox(height: 60),
          
                // ID TextField
                TextField(
                  controller: userIdController,
                  decoration: InputDecoration(
                    hintText: '이메일 아이디 또는 휴대폰 번호',
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
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility_off : Icons.visibility,
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
          
                // MY LG ID Text
                const Center(
                  child: Text(
                    'MY LG ID',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          
                const SizedBox(height: 8),
          
                // Divider Line
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
          
                const SizedBox(height: 24),
          
                // Login Button
                ElevatedButton(
                  onPressed: () {
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
                            content: Text("아이디가 존재하지 않거나 비밀번호가 일치하지 않습니다."),
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormFilled
                        ? const Color(0xFFA50034)
                        : Colors.grey.shade200,
                    foregroundColor:
                    isFormFilled ? Colors.white : Colors.grey.shade500,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          
                const SizedBox(height: 16),
          
                // Find ID, Reset Password, Sign Up buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "아이디 찾기",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                    const Text("|", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "비밀번호 재설정",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                    const Text("|", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "회원가입",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 24),
          
                // Social Login Placeholders
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
          
                // Other Login Options
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