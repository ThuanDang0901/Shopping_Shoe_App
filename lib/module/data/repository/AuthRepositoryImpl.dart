import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userDoc = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    String role = 'user';
    String? name;

    if (userDoc.exists && userDoc.data() != null) {
      role = userDoc.data()!['role'] ?? 'user';
      name = userDoc.data()!['name'];
    }

    return UserEntity(
      uid: credential.user!.uid,
      email: credential.user!.email!,
      name: name ?? credential.user!.displayName,
      role: role, // Gán role đã lấy từ server
    );
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(name);

    // Lưu thông tin user mới đăng ký xuống Firestore và mặc định role là 'user'
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': email,
      'name': name,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return UserEntity(
      uid: credential.user!.uid,
      email: credential.user!.email!,
      name: name,
      role: 'user',
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<int> getTotalUsersCount() async {
    try {
      final aggregateQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'user')
          .count()
          .get();

      return aggregateQuery.count ?? 0;
    } catch (e) {
      throw Exception("Lỗi khi đếm số lượng người dùng: $e");
    }
  }

  // 1. Cập nhật lại hàm getUsers() để đọc đúng trường isActive từ Firestore
  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserEntity(
          uid: doc.id,
          email: data['email'] ?? '',
          name: data['name'] ?? 'No Name',
          role: data['role'] ?? 'user',
          isActive:
              data['isActive'] ?? true, // Lấy dữ liệu thực tế từ Firestore
        );
      }).toList();
    } catch (e) {
      throw Exception("Lỗi khi tải danh sách người dùng: $e");
    }
  }

  // 2. THÊM LOGIC CẬP NHẬT QUYỀN HẠN (ROLE)
  @override
  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await _firestore.collection('users').doc(uid).update({'role': newRole});
    } catch (e) {
      throw Exception("Lỗi khi cập nhật quyền hạn: $e");
    }
  }

  // 3. THÊM LOGIC CẬP NHẬT TRẠNG THÁI (BLOCK/UNBLOCK)
  @override
  Future<void> updateUserStatus(String uid, bool isActive) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isActive': isActive,
      });
    } catch (e) {
      throw Exception("Lỗi khi thay đổi trạng thái tài khoản: $e");
    }
  }
}
