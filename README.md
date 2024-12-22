# Proyek Akhir Semester - Mujur Reborn

## Kelompok E07:
- 2306275784 - Dicky Bayu Sadewo
- 2306219215 - Joel Anand Garcia Sinaga
- 2306228756 - Krisna Putra Purnomo
- 2306152355 - Muhammad Hamid
- 2306203690 - Raffi Dary Hibban
- 2306206446 - Valentino Vieri Zhuo
<hr>

[![Build status](https://build.appcenter.ms/v0.1/apps/6cc07b04-fe20-418e-bd34-0af803354539/branches/main/badge)](https://appcenter.ms)

## Tautan Aplikasi: https://install.appcenter.ms/orgs/kelompoke07pbp/apps/mujur-reborn/distribution_groups/public/releases/1

## Aplikasi:
Mujur Reborn

<hr>

## Deskripsi Aplikasi:
Selamat datang di Mujur Reborn, solusi modern untuk memenuhi kebutuhan gaya profesional Anda. Sebagai aplikasi mobile yang dirancang khusus, Mujur Reborn memungkinkan Anda menjelajahi berbagai koleksi dasi dan aksesori seperti jepitan dasi dengan mudah, di mana saja dan kapan saja.

Didesain dengan antarmuka yang ramah pengguna, Mujur Reborn menawarkan pengalaman berbelanja yang cepat dan praktis. Pilihan dasi kami mencakup berbagai warna, model, dan harga, sehingga Anda dapat menemukan aksesori yang sempurna untuk melengkapi penampilan Anda. Apakah Anda mempersiapkan diri untuk hari pertama bekerja, menghadiri rapat penting, atau menghadiri acara formal, Mujur Reborn memastikan Anda tampil percaya diri dan profesional.
<hr>

## Daftar Modul:
1. **Main (Bersama)**
> Main adalah halaman utama aplikasi mobile yang berisi daftar produk dalam toko. Selain itu, modul ini juga memiliki fitur login, register, dan logout.
2. **Edit (Valentino Vieri Zhuo)**
> Edit adalah halaman untuk menambahkan, menghapus, dan update produk di dalam toko.
3. **Pembayaran (Dicky Bayu Sadewo)**
> Pembayaran adalah halaman untuk melihat rincian pembayaran serta metode pembayaran yang akan digunakan pengguna termasuk konfirmasi pembayaran.
4. **Keranjang (Krisna Putra Purnomo)**
> Keranjang adalah halaman untuk mengatur keranjang pembelian.
5. **Ulasan (Muhammad Hamid)**
> Ulasan adalah halaman untuk menyampaikan ulasan terkait produk di dalam aplikasi mobile.
6. **Pengiriman (Raffi Dary Hibban)**
> Pengiriman adalah halaman untuk mengatur lokasi pengiriman produk yang telah dipilih pengguna.
7. **Forum (Joel Anand Garcia Sinaga)**
> Forum adalah halaman untuk menyampaikan informasi terkait cara merawat produk tertentu.

<hr>

## Peran:
1. **Admin**
> Admin adalah pengguna aplikasi yang memiliki hak untuk edit produk dan mencari produk dalam aplikasi mobile.
2. **Pelanggan**
> Pelanggan adalah pengguna aplikasi yang memiliki hak untuk mencari produk, mengatur keranjang pembelian, menyampaikan testimoni, mengatur lokasi pengiriman, dan menyampaikan informasi terkait cara merawat produk tersebut.

<hr>

## Alur Pengintegrasian:
**1. Membangun Aplikasi Mobile**

> Langkah pertama adalah membuat aplikasi mobile dengan fitur-fitur dasar, tanpa melibatkan integrasi dengan aplikasi web. Fokus awal ini hanya pada tampilan dan fungsionalitas aplikasi, seperti navigasi antarhalaman, input data, dan elemen-elemen interaktif lainnya. Tujuannya adalah memastikan aplikasi mobile siap digunakan sebelum dihubungkan dengan sistem backend.

**2. Menambahkan Modul API di Aplikasi Web**

> Setelah aplikasi mobile siap, kita akan menambahkan API di aplikasi web agar aplikasi mobile bisa terhubung. API ini akan dikembangkan menggunakan Django REST Framework (DRF) untuk menyediakan data yang bisa diakses oleh aplikasi mobile, seperti daftar produk, detail pengguna, atau lainnya. API harus aman dan sesuai dengan kebutuhan aplikasi mobile.

**3. Menghubungkan Aplikasi Mobile ke Backend**

> Setelah API selesai, aplikasi mobile akan dihubungkan ke aplikasi web. Ini dilakukan dengan menambahkan fitur pengiriman request HTTP (GET, POST, DELETE) dari aplikasi mobile ke server web. Dengan cara ini, aplikasi mobile bisa mengambil data dari server atau mengirimkan data yang diinput oleh pengguna.

**4. Menyempurnakan Routing Aplikasi**

> Selanjutnya, kita akan menyempurnakan routing, baik di aplikasi mobile maupun web. Di aplikasi web, endpoint API akan dipastikan berjalan dengan benar. Di aplikasi mobile, navigasi akan diperbaiki agar lebih intuitif, terutama untuk menampilkan data yang diterima dari server.

**5. Menguji Alur Kerja**

> Setiap bagian aplikasi akan diuji untuk memastikan semua fungsi berjalan lancar. Pengujian ini mencakup koneksi antara aplikasi mobile dan server web, pengolahan data yang benar, dan penanganan error seperti koneksi gagal atau data tidak valid. Semua proses akan diperiksa secara menyeluruh untuk memastikan aplikasi siap digunakan.

**6. Deployment Aplikasi**

> Setelah semua diuji dan bekerja dengan baik, aplikasi mobile akan dideploy ke App Center untuk didistribusikan ke pengguna.
<hr>
