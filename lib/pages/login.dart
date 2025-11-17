import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controller buat nampung input email & password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // key buat validasi form
  bool _isLoading = false; // penanda lagi proses login atau engga

  void _login() async {
    // cek dulu form valid apa engga
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // mulai loading
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        // request POST ke backend login
        final response = await http.post(
          Uri.parse('http://192.168.18.8:5000/login'), // IP backend kamu
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          // coba decode JSON dari backend
          try {
            final result = jsonDecode(response.body);

            // cek kalau backend balikin status sukses
            if (result['status'] == 'success') {
              final prefs = await SharedPreferences.getInstance();

              // simpan data user biar ga perlu login ulang
              await prefs.setBool('isLoggedIn', true);
              await prefs.setString('userEmail', result['data']['email']);
              await prefs.setString(
                'userName',
                result['data']['username'],
              ); // nama user

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Login berhasil!')));

              // pindah ke halaman home
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              // kalau backend balikin pesan gagal
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result['message'] ?? 'Login gagal')),
              );
            }
          } catch (e) {
            // kalau JSON backend aneh / error
            print("Error decoding JSON: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Respon server tidak valid')),
            );
          }
        } else {
          // kalau code bukan 200, berarti email/password salah
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email atau passwoed salah (${response.statusCode})',
              ),
            ),
          );
        }
      } catch (e) {
        // error koneksi jaringan atau backend mati
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan koneksi: $e')),
        );
      } finally {
        // matiin loading apapun hasilnya
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // biar ga ketutup area notch hp
        child: SingleChildScrollView(
          // biar bisa scroll kalau keyboard muncul
          padding: const EdgeInsets.all(24.0), // padding biar rapi
          child: Form(
            key: _formKey, // form biar bisa validasi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // judul halaman login
                const Text(
                  'Masuk ke Lariin',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // input email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  keyboardType:
                      TextInputType.emailAddress, // keyboard khusus email
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    // cek format email valid
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // input password
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  obscureText: true, // hide password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // tombol login
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _login, // disable kalau loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
                        // loading indikator
                        ? const CircularProgressIndicator(color: Colors.white)
                        // teks tombol
                        : const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // tombol ke halaman daftar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/register',
                        ); // pindah ke register
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(color: Colors.blue), // warna biru
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
      