import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _pendingUsers = FirebaseFirestore.instance
      .collection('pending_users');

  // Gửi OTP qua Email
  Future<void> sendOTPEmail(String toEmail, String otpCode) async {
    String username = 'damtutai147@gmail.com'; // Email của bạn
    String password = dotenv.env['GMAIL_PASS'] ?? "";

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'AUNORA Store')
      ..recipients.add(toEmail)
      ..subject = 'Mã xác nhận tài khoản AUNORA'
      ..html =
          "<h3>Mã OTP của bạn là: <b style='color: #EC5353;'>$otpCode</b></h3>";

    try {
      await send(message, smtpServer);
    } catch (e) {
      throw Exception("Lỗi gửi mail: $e");
    }
  }

  // Lưu thông tin tạm thời
  Future<void> savePendingUser(
    String email,
    String password,
    String name,
    String code,
  ) async {
    await _pendingUsers.doc(email).set({
      'email': email,
      'password': password,
      'name': name,
      'code': code,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getPendingData(String email) =>
      _pendingUsers.doc(email).get();
  Future<void> deletePendingData(String email) =>
      _pendingUsers.doc(email).delete();
}
