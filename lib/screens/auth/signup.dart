import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newzen/components/appbar_default.dart';
import 'welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool get isFormFilled =>
      nameController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty;

  Future<void> signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 사용자 이름 업데이트
      await userCredential.user?.updateDisplayName(nameController.text.trim());
      await userCredential.user?.reload();

      // 회원가입 완료 후 환영 화면으로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WelcomeScreen(userName: nameController.text.trim()),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = '이미 사용 중인 이메일입니다.';
      } else if (e.code == 'invalid-email') {
        errorMessage = '유효하지 않은 이메일 형식입니다.';
      } else if (e.code == 'weak-password') {
        errorMessage = '비밀번호는 최소 6자리 이상이어야 합니다.';
      } else {
        errorMessage = '회원가입 중 오류가 발생했습니다.';
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(errorMessage),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.robotoTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: '회원가입',
        backgroundColor: Colors.white,
        useGoogleFonts: true,
        fontWeight: FontWeight.normal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Name TextField
                Text(
                  '이름',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 0),

                TextField(
                  controller: nameController,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),

                const SizedBox(height: 12),
                // Email TextField
                Text(
                  '이메일',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 0),

                TextField(
                  controller: emailController,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 12),
                // Password TextField
                Text(
                  '비밀번호',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 0),

                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
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

                const SizedBox(height: 60),
                // Sign Up Button
                ElevatedButton(
                  onPressed: isFormFilled ? signUp : null,
                  style: ElevatedButton.styleFrom(
                    // TODO: 비활성 상태 스타일 수정 - 배경 shade50, 글자색 200
                    backgroundColor: isFormFilled
                        ? const Color(0xFFA50034)
                        : Colors.grey.shade300,
                    foregroundColor:
                        isFormFilled ? Colors.white : Colors.grey.shade600,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    '회원가입',
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: isFormFilled ? Colors.white : Colors.grey.shade600,
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
