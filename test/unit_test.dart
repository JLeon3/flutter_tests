import 'package:flutter_tests/logic.dart';
import 'package:flutter_tests/model.dart';
import 'package:test/test.dart';

void main() {
  TodoLogic todoLogic;

  group('Todo Logic', () {
    setUp(() {
      todoLogic = TodoLogic();
    });

    tearDown(() {
      todoLogic.dispose();
    });

    test('Check Todo List is empty', () {
      expect(todoLogic.list, <Todo>[]);
    });

    test('Add one todo by body', () {
      todoLogic.addTodo('Test todo');

      expect(todoLogic.list.length, 1);
      expect(todoLogic.list.first.body, 'Test todo');
    });

    test('Add todo by todo', () {
      Todo todo = Todo(
        body: 'A body',
        finished: false,
      );
      todoLogic.addTodoItem(todo);

      expect(todoLogic.list.first, todo);
    });

    test('Look at Todo logic stream controller', () {
      String firstTodo = 'test';
      String secondTodo = 'another todo';

      todoLogic.addTodo(firstTodo);
      todoLogic.addTodo(secondTodo);

      expect(
        todoLogic.streamController.stream,
        emitsInOrder([
          [
            Todo(body: firstTodo, finished: false),
            Todo(body: secondTodo, finished: false),
          ],
          [
            Todo(body: firstTodo, finished: false),
            Todo(body: secondTodo, finished: false),
          ],
        ]),
      );
    });

    test('Remove todo by index', () {
      String firstTodo = 'test';
      String secondTodo = 'another todo';

      todoLogic.addTodo(firstTodo);
      todoLogic.addTodo(secondTodo);

      todoLogic.removeTodoByIndex(0);

      expect(todoLogic.list.length, 1);
      expect(
        todoLogic.list.first,
        Todo(body: secondTodo, finished: false),
      );
    });

    test('Remove finished todos', () {
      String firstTodo = 'test';
      String secondTodo = 'another todo';

      todoLogic.addTodo(firstTodo);
      todoLogic.addTodo(secondTodo);

      todoLogic.markItemFinished(1, true);

      todoLogic.removeFinishedTodos();

      expect(todoLogic.list.first, Todo(body: firstTodo, finished: false));
    });

    test('Clear todos', () {
      String firstTodo = 'test';
      String secondTodo = 'another todo';

      todoLogic.addTodo(firstTodo);
      todoLogic.addTodo(secondTodo);

      todoLogic.clearTodos();

      expect(todoLogic.list, <Todo>[]);
    });
  });
}
