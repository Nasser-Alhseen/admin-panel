import 'package:admin/add.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: Admin(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool isLoading = true;
  List users = [];
  Future checkLogin() async {
    Dio dio = Dio();

    String apiUrl = 'https://data-users.onrender.com/allusers';

    try {
      var response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        return response.data['allusers'];
        // Successful sign-in

      } else {
        // Failed sign-in
      }
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkLogin().then((value) {
      print(value);
      value.forEach((e) {
        users.add(e);
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const Add());
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(users[index]['password'] +
                      '    balance ' +
                      users[index]['balance'].toString()),
                  subtitle: Text(users[index]['email'].toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      try {
                        Dio dio = Dio();

                        var res = await dio.post(
                            'https://data-users.onrender.com/deleteuser',
                            data: {'email': users[index]['email']});
                        if (res.statusCode == 200) {
                          Get.snackbar('user deleted', '');
                          Get.offAll(() => const Admin());
                        } else {
                          print(res);
                        }
                      } catch (e) {}
                    },
                  ),
                  onTap: () {
                    TextEditingController e = TextEditingController();
                    Get.dialog(Scaffold(
                      body: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: e,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                Dio dio = Dio();
                                try {
                                  var res = await dio.post(
                                      'https://data-users.onrender.com/balance',
                                      data: {
                                        'balance': int.parse(e.text),
                                        'email': users[index]['email']
                                      });
                                  if (res.statusCode == 200) {
                                    Get.snackbar('balance updated', '');
                                    Get.offAll(() => const Admin());
                                  } else {
                                    print(res);
                                  }
                                } catch (e) {}
                              },
                              child: const Text('Update'))
                        ],
                      ),
                    ));
                  },
                );
              })),
    );
  }
}
