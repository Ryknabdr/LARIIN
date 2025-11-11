---

# 🚀 Setup & Instalasi Project Flutter

Ketika pertama kali membuka project Flutter ini, pastikan untuk melakukan instalasi dependency agar tidak muncul error merah pada kode.

## ✅ Langkah Instalasi Awal

1. **Masuk ke folder project Flutter**
2. Jalankan perintah berikut di terminal:

   ```
   flutter pub get
   ```

   Perintah ini akan menginstall semua package yang tercantum di `pubspec.yaml`.

> **Catatan:**
> Jika kamu menambahkan package baru di `pubspec.yaml`, kamu **harus** menjalankan perintah `flutter pub get` lagi.

---

## 📦 Package yang Umum Digunakan dalam Project Flutter

Beberapa package yang sering dipakai untuk aplikasi modern:

| Package                              | Kegunaan                                       |
| ------------------------------------ | ---------------------------------------------- |
| **google_fonts**                     | Menggunakan font dari Google Fonts             |
| **shared_preferences**               | Menyimpan data lokal (seperti login)           |
| **image_picker**                     | Mengambil gambar dari kamera/galeri            |
| **google_ml_kit** / `google_mlkit_*` | Fitur ML seperti scan teks / wajah / barcode   |
| **location**                         | Mengakses lokasi GPS                           |
| **provider / get**                   | State management (jika dipakai di project ini) |

Semua package yang dibutuhkan sudah berada di file **`pubspec.yaml`**.

---

## 🔎 Mengecek Dependency yang Outdated

Jika ingin melihat package yang perlu di-update, jalankan:

```
flutter pub outdated
```

---

## 🧠 Jika Masih Ada Error Setelah `flutter pub get`

Biasanya penyebabnya:

* Salah penulisan import
* Salah penamaan class atau file
* Versi package tidak kompatibel (perlu update)

---

## 📘 Referensi Flutter (Opsional untuk belajar)

* **Codelab Resmi:** [https://docs.flutter.dev/get-started/codelab](https://docs.flutter.dev/get-started/codelab)
* **Flutter Cookbook:** [https://docs.flutter.dev/cookbook](https://docs.flutter.dev/cookbook)
* **Dokumentasi Lengkap:** [https://docs.flutter.dev/](https://docs.flutter.dev/)

---

Selamat coding! 🎉
Kalau kamu mau, aku bisa juga **buatkan screenshot + panduan cara run di emulator / real device** 👍
