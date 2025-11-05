# Instalasi awal
Supaya semua package otomatis dikenali & error merah hilang, setiap pertama kali buka project Flutter:
1. Install semua dependency sesuai pubspec.yaml dengan:
   flutter pub get
(Buka terminal dari folder utama project Flutter, jalankan perintah di atas)
2. JANGAN lupa:
Kalau kamu tambah package di pubspec.yaml, habis itu harus run flutter pub get lagi.
Package yang paling sering WAJIB di-install di Flutter (buat aplikasi modern):
Flutter SDK (otomatis bila dev setup sudah benar)
google_fonts
shared_preferences
image_picker
google_ml_kit dan varian google_mlkit_...
location (untuk akses lokasi)
provider atau get (untuk state management - kalau dipakai)
Semua package yang tampil di bagian dependencies: di pubspec.yaml milik project kamu
**Cek cepat dependencies yang belum ter-install:**
1. Jalankan:
  flutter pub outdated
Ini menunjukkan mana yang outdated atau belum update, tapi intinya semua package wajib di-install dengan flutter pub get.
Bonus:
Kalau masih merah juga setelah itu, biasanya error kodenya:
Salah import (nama file tidak sesuai)
Salah ketik nama class/widget
Atau dependensi tertentu belum support, perlu update
Kesimpulan:
Untuk memperbaiki semua error merah package/material saat awal, cukup jalankan:
flutter pub get
Itu langkah WAJIB setiap mulai project Flutter!
Kalau masih ada error setelah itu, biasanya kode logic/sintaks atau penamaan classnya.
Mau tahu detail error spesifik lain? Atau mau aku cek file pubspec.yaml kamu untuk memastikan semua package penting sudah ada?


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
