import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/main.dart';
import 'package:flutter_tests/screens/home_screen.dart';

void main() {
  group('Find by type', () {
    testWidgets('Test to see that MaterialApp widget is in Tree',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp()); // builds and renders the provided widget

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Test to see that CircularProgressIndicator widget is in tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Application logic', () {
    testWidgets('Add a todo', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      final textFinder = find.byKey(Key('todo-field'));
      final addButtonFinder = find.byKey(Key('add-todo'));

      await tester.enterText(textFinder, 'A sample todo');
      await tester.tap(addButtonFinder);
      // moves app forward by a frame, essentially rebuilds app with changes
      await tester.pump();

      expect(find.text('A sample todo'), findsOneWidget);
      expect(find.byKey(ValueKey('0-todo')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Remove a todo', (WidgetTester tester) async {
      String text = 'A sample todo';
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      final textFinder = find.byKey(Key('todo-field'));
      final addButtonFinder = find.byKey(Key('add-todo'));
      final removeTodoFinder = find.byKey(Key('gd-0'));

      await tester.enterText(textFinder, text);
      await tester.tap(addButtonFinder);
      await tester.pump();

      expect(find.text(text), findsOneWidget);

      await tester.longPress(removeTodoFinder);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNothing);
    });

    testWidgets('Finish a todo', (WidgetTester tester) async {
      String firstTodo = 'A sample todo';
      String secondTodo = 'Another todo';
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      final textFinder = find.byKey(Key('todo-field'));
      final addButtonFinder = find.byKey(Key('add-todo'));
      final todoFinder = find.byKey(ValueKey('0-false-checkbox'));

      await tester.enterText(textFinder, firstTodo);
      await tester.tap(addButtonFinder);
      await tester.pump();

      await tester.enterText(textFinder, secondTodo);
      await tester.tap(addButtonFinder);
      await tester.pump();

      await tester.tap(todoFinder);
      await tester.pump();

      expect(find.text(firstTodo), findsOneWidget);
      expect(find.text(secondTodo), findsOneWidget);
      expect(find.byKey(ValueKey('0-true-checkbox')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
