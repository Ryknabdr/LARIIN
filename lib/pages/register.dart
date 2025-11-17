import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controller buat nampung input user (nama, email, password)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>(); // buat validasi form
  bool _isLoading = false; // biar tau lagi loading atau enggak

  void _register() async {
    // cek form valid atau engga dulu
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // mulai loading
      });

      try {
        final url = Uri.parse(
          "http://192.168.18.8:5000/register", // IP backend (sesuai jaringan kamu)
        );

        // ngirim data user ke backend
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": _nameController.text,
            "email": _emailController.text,
            "password": _passwordController.text,
          }),
        );

        setState(() {
          _isLoading = false; // matiin loading
        });

        // kalau sukses daftar
        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"] ?? "Pendaftaran berhasil!")),
          );

          // simpan data user ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true); // tandain udah login
          await prefs.setString('userEmail', _emailController.text);
          await prefs.setString('userName', _nameController.text);

          // pindah ke halaman home
          Navigator.pushReplacementNamed(context, '/home');
        } 
        // kalau email/username udah dipakai
        else if (response.statusCode == 409) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Username atau email sudah terdaftar!'),
            ),
          );
        } 
        // kalau backend error
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghubungi server')),
          );
        }
      } catch (e) {
        // kalau aplikasi error (misal koneksi putus)
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // biar ga kehalang notch HP
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), // padding biar rapi
          child: Form(
            key: _formKey, // form yang bisa divalidasi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                const Text(
                  'Daftar ke Lariin', // judul halaman daftar
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // warna biru khas app kamu
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // input username
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ussername',
                    prefixIcon: Icon(Icons.person), // icon orang
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ussername tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // input email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress, // keyboard email
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    // ngecek format email valid atau enggak
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
                  obscureText: true, // hide password
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
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

                const SizedBox(height: 20),

                // input konfirmasi password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true, // hide password juga
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Kata Sandi',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi kata sandi tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Kata sandi tidak cocok'; // kalau beda
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // tombol daftar
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register, // cek loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // warna tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white) // animasi loading
                        : const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // tombol ke halaman login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // balik ke login
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(color: Colors.blue), // warna link login
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
