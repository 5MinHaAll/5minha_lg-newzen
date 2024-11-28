import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'signup.dart';

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

  Future<void> signIn() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userIdController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 사용자 이름 가져오기
      final userName = userCredential.user?.displayName ?? '사용자';

      print('로그인 성공: ${userCredential.user?.email}, 이름: $userName');

      // Home 화면으로 이동하며 사용자 이름 전달
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Home(
            title: 'Flutter Demo Home Page',
            userId: userIdController.text,
            userName: userName, // 사용자 이름 전달
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException 발생: ${e.code}, 메시지: ${e.message}');
      String errorMessage = '로그인 정보를 확인해주세요.\n'
          '이메일이나 비밀번호가 올바르지 않거나 등록되지 않은 계정입니다.';

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
              const SizedBox(height: 20),
              // LG Logo Placeholder
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(
                  child: Text('LG Logo Placeholder'),
                ),
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
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
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
                onPressed: isFormFilled ? signIn : null,
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
                  'MY LG ID 로그인',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SignUp(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.grey.shade500,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // ElevatedButton(
              //   onPressed: isFormFilled ? signUp : null,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.grey.shade200,
              //     foregroundColor: Colors.grey.shade500,
              //     elevation: 0,
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     shape: const RoundedRectangleBorder(
              //       borderRadius: BorderRadius.zero,
              //     ),
              //   ),
              //   child: const Text(
              //     '회원가입',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
