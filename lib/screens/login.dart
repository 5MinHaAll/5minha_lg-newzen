import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'signup.dart';

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

  Future<void> signIn() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userIdController.text.trim(),
        password: passwordController.text.trim(),
      );

      final userName = userCredential.user?.displayName ?? '사용자';

      // Home 화면으로 이동하며 사용자 이름 전달
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Home(
            title: 'Flutter Demo Home Page',
            userId: userIdController.text,
            userName: userName,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
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
    final textTheme = GoogleFonts.robotoTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language Selector
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Korea, 한국어',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // LG Logo
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/login/lge_logo_kr.png',
                    height: 50,
                  ),
                ),

                const SizedBox(height: 40),

                // ID TextField
                Text(
                  '이메일 아이디 또는 휴대폰 번호 아이디',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 0),

                TextField(
                  controller: userIdController,
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

                const SizedBox(height: 0),

                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
          
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
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
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 8),

                // Login Button
                ElevatedButton(
                  onPressed: isFormFilled ? signIn : null,
          
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "아이디 찾기",
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "비밀번호 재설정",
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUp(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "회원가입",
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 80),

                // Divider
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),

                const SizedBox(height: 16),

                // MY LG ID Login Button
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFA50034)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 13,
                        child: Center(
                          child: Image.asset(
                            'assets/images/login/my_lg_id.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Text(
                        ' 로그인',
                        style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFA50034),
                          fontSize: 16,
                          height: 1,
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
                        width: 32,
                        height: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/login/naver.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Other Login Options
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '다른 계정으로 로그인',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black54,
                        size: 20,
                      ),
                    ],
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
