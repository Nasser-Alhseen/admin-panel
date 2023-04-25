import 'package:admin/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              controller: email,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              controller: password,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                Dio dio = Dio();
                Map body = {'email': email.text, 'password': password.text};
                var res = await dio.post(
                    'https://data-users.onrender.com/adduser',
                    data: body);
                if (res.statusCode == 200) {
                  Get.to(() => const Admin());
                }
              },
              child: const Text('Create Account'))
        ],
      ),
    );
  }
}
