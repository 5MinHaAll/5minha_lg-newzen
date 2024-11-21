import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home.dart';

import 'main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false; // 비밀번호 표시 상태 관리

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 중앙 정렬을 위해 최소 크기로 설정
            children: [
              // LG 로고
              SvgPicture.asset(
                "images/lg logo.svg", // SVG 파일 경로
                height: 80, // 높이 설정
              ),
              const SizedBox(height: 40),
              // 안내 텍스트
              const Text(
                "이메일 아이디 또는 휴대폰 번호 아이디",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              // 아이디 입력 필드
              TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "아이디",
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
              // 비밀번호 입력 필드
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible, // 비밀번호 표시 여부
                decoration: InputDecoration(
                  labelText: "비밀번호",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility // 비밀번호 표시 아이콘
                          : Icons.visibility_off, // 비밀번호 숨김 아이콘
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible; // 상태 변경
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 로그인 버튼
              ElevatedButton(
                onPressed: () {
                  // 로그인 처리 로직 추가
                  // Navigator.of(context).push(
                  if (userIdController.text == "test" &&
                      passwordController.text == "test")
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) =>
                              Home(
                                title: 'Flutter Demo Home Page', userId: userIdController.text,)),
                    );
                  else
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(content: Text(
                              "아이디가 존재하지 않거나 비밀번호가 일치하지 않습니다."),);
                        }
                    );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey, backgroundColor: Colors.grey[300], // 텍스트 색상
                  minimumSize: const Size(double.infinity, 48), // 버튼 크기
                  elevation: 0, // 그림자 제거
                ),
                child: const Text("로그인"),
              ),
              const SizedBox(height: 16),
              // 아이디 찾기, 비밀번호 재설정, 회원가입
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // 아이디 찾기 로직
                    },
                    child: const Text(
                      "아이디 찾기",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Text("|", style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      // 비밀번호 재설정 로직
                    },
                    child: const Text(
                      "비밀번호 재설정",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Text("|", style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      // 회원가입 로직
                    },
                    child: const Text(
                      "회원가입",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}