import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:state_notifier/state_notifier.dart';

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
  // final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  // final FirebaseAuthFacade auth = FirebaseAuthFacade(firebaseAuth: mockFirebaseAuth);
  // setUp(() {});
  // tearDown(() {});
  //
  // // test("emit occurs", () async {
  // //   expectLater(auth.getSignedInUser(), emitsInOrder([_mockUser]));
  // // });
  //
  // test("create account", () async {
  //   when(
  //     mockFirebaseAuth.createUserWithEmailAndPassword(
  //         email: "tadas@gmail.com", password: "123456"),
  //   ).thenAnswer((realInvocation) => null);
  //
  //   expect(
  //       await auth.registerWithEmailAndPassword(emailAddress: state.email, password: "123456"),
  //       "Success");
  // });
  //
  // test("create account exception", () async {
  //   when(
  //     mockFirebaseAuth.createUserWithEmailAndPassword(
  //         email: "tadas@gmail.com", password: "123456"),
  //   ).thenAnswer((realInvocation) =>
  //   throw FirebaseAuthException(message: "You screwed up"));
  //
  //   expect(
  //       await auth.createAccount(email: "tadas@gmail.com", password: "123456"),
  //       "You screwed up");
  // });
  //
  // test("sign in", () async {
  //   when(
  //     mockFirebaseAuth.signInWithEmailAndPassword(
  //         email: "tadas@gmail.com", password: "123456"),
  //   ).thenAnswer((realInvocation) => null);
  //
  //   expect(await auth.signIn(email: "tadas@gmail.com", password: "123456"),
  //       "Success");
  // });
  //
  // test("sign in exception", () async {
  //   when(
  //     mockFirebaseAuth.signInWithEmailAndPassword(
  //         email: "tadas@gmail.com", password: "123456"),
  //   ).thenAnswer((realInvocation) =>
  //   throw FirebaseAuthException(message: "You screwed up"));
  //
  //   expect(await auth.signIn(email: "tadas@gmail.com", password: "123456"),
  //       "You screwed up");
  // });
  //
  // test("sign out", () async {
  //   when(
  //     mockFirebaseAuth.signOut(),
  //   ).thenAnswer((realInvocation) => null);
  //
  //   expect(await auth.signOut(), "Success");
  // });
  //
  // test("create account exception", () async {
  //   when(
  //     mockFirebaseAuth.signOut(),
  //   ).thenAnswer((realInvocation) =>
  //   throw FirebaseAuthException(message: "You screwed up"));
  //
  //   expect(await auth.signOut(), "You screwed up");
  // });
}
