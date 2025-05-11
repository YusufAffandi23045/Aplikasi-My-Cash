import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom wallet logo widget
            SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: WalletLogoPainter(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'My Cash',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C8F7C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter untuk membuat logo dompet
class WalletLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint mainPaint = Paint()
      ..color = const Color(0xFF3C8F7C)
      ..style = PaintingStyle.fill;

    final Paint backgroundPaint = Paint()
      ..color = const Color(0xFFE0F7FA)
      ..style = PaintingStyle.fill;

    // Ukuran dan posisi
    final double width = size.width;
    final double height = size.height;
    final double walletWidth = width * 0.8;
    final double walletHeight = height * 0.6;
    final double cornerRadius = walletWidth * 0.1;

    // Posisi wallet di tengah
    final double walletLeft = (width - walletWidth) / 2;
    final double walletTop = (height - walletHeight) / 2;

    // Gambar wallet utama (bentuk dasar)
    final RRect walletRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(walletLeft, walletTop, walletWidth, walletHeight),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(walletRect, mainPaint);

    // Gambar lipatan dalam wallet
    final RRect innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          walletLeft + width * 0.05,
          walletTop + height * 0.05,
          walletWidth - width * 0.1,
          walletHeight - height * 0.1
      ),
      Radius.circular(cornerRadius * 0.8),
    );
    canvas.drawRRect(innerRect, backgroundPaint);

    // Gambar bagian dalam wallet
    final RRect innerWalletRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          walletLeft + width * 0.1,
          walletTop + height * 0.1,
          walletWidth - width * 0.2,
          walletHeight - height * 0.2
      ),
      Radius.circular(cornerRadius * 0.6),
    );
    canvas.drawRRect(innerWalletRect, mainPaint);

    // Gambar lingkaran (koin) di tengah wallet
    final double coinRadius = width * 0.15;
    final Offset coinCenter = Offset(width / 2, height / 2);
    canvas.drawCircle(coinCenter, coinRadius, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}