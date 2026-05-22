import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserEntity(
      uid: credential.user!.uid,
      email: credential.user!.email!,
    );
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(name);

    return UserEntity(
      uid: credential.user!.uid,
      email: credential.user!.email!,
      name: name,
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}
