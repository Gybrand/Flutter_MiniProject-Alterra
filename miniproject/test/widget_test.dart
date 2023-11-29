import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniproject/Auth/page_forgotpw.dart';
import 'package:miniproject/Components/auth_field.dart';
import 'package:miniproject/Components/function_button.dart';

void main() {
  // Now run your tests.
  testWidgets('Judul Harus...', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ForgotPasswordPage(
        onTap: null,
      ),
    ));
    expect(
        find.text("Recieve an email to reset your password"), findsOneWidget);
  });
  testWidgets('TextField Email', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ForgotPasswordPage(
        onTap: null,
      ),
    ));
    expect(find.widgetWithText(AuthField, 'Email'), findsOneWidget);
  });
  testWidgets('Tombol Reset Password', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ForgotPasswordPage(
        onTap: null,
      ),
    ));
    expect(
        find.widgetWithText(FunctionButton, 'Reset Password'), findsOneWidget);
  });
  testWidgets('Tulisan Back', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ForgotPasswordPage(
        onTap: null,
      ),
    ));
    expect(find.text("Back"), findsOneWidget);
  });
}
