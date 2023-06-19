import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub',
      theme: ThemeData(
      scaffoldBackgroundColor: Colors.white10,
      appBarTheme: AppBarTheme(
        color: Colors.black,
      )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('https://api.github.com/users/$username'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        userData = jsonData;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userData: userData!),
        ),
      );
    } else {
      // Tratar caso de erro
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Falha ao obter dados do usuário.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
      appBar: AppBar(
        title: Text('Perfil do GitHub'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Digite o nome de usuário do GitHub:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
    primary: Colors.black, // Define a cor do botão para preto
  ),
              onPressed: () {
                fetchUserData();
              },
              child: Text('Pressione o botão'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  ProfileScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userData['avatar_url']),
              radius: 64,
            ),
            SizedBox(height: 16),
            Text(
              userData['name'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(userData['bio'] ?? ''),
            SizedBox(height: 8),
            Text('Seguidores: ${userData['followers'] ?? 0}'),
            SizedBox(height: 8),
            Text('Seguindo: ${userData['following'] ?? 0}'),
          ],
        ),
      ),
    );
  }
}
