import 'package:flutter/material.dart';
import 'package:newzen/screens/login.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;

  const WelcomeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LG 로고
            const Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Image(
                image: AssetImage(
                    'assets/images/login/lge_logo_kr.png'), // LG 로고 이미지
                height: 80,
              ),
            ),
            // 사용자 이름 환영 메시지
            Text(
              '$userName님',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // 환영 메시지
            const Text(
              '회원가입을 환영합니다.\n가입하신 아이디로 LG전자의 다양한 서비스를 이용할 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            // 확인 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false, // 모든 이전 화면 제거
                ); // 로그인 화면으로 이동
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA50034),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              ),
              child: const Text(
                '확인',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
