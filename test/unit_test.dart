import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:professional_todo/services/auth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);

  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  test("create account", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "joao@gmail.com", password: "123456"))
        .thenAnswer((realInvocation) => null);

    expect(
        await auth.createAccount(email: "joao@gmail.com", password: "123456"),
        "Success");
  });

  test("create account exception", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "joao@gmail.com", password: "123456"))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: "Error", code: "1"));

    expect(
        await auth.createAccount(email: "joao@gmail.com", password: "123456"),
        "Error");
  });

  test("sign in", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: "joao@gmail.com", password: "123456"))
        .thenAnswer((realInvocation) => null);

    expect(await auth.signIn(email: "joao@gmail.com", password: "123456"),
        "Success");
  });

  test("sign in exception", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: "joao@gmail.com", password: "123456"))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: "Error", code: "1"));

    expect(await auth.signIn(email: "joao@gmail.com", password: "123456"),
        "Error");
  });

  test("sign out", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => null);

    expect(await auth.signOut(), "Success");
  });

  test("sign out exception", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) =>
        throw FirebaseAuthException(message: "Error", code: "1"));

    expect(await auth.signOut(), "Error");
  });
}
