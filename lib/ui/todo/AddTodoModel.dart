import 'package:todo/database/data/Todo.dart';
import 'package:todo/database/data/TodoProvider.dart';
import 'package:todo/ui/todo/AddTodoView.dart';

class AddTodoModel {
  AddTodoView _view;

  AddTodoModel(AddTodoView view) {
    this._view = view;
  }

  TodoProvider _todoProvider = TodoProvider();

  void getTodo(int todoId) {
    _todoProvider.getTodo(todoId).then((todo) {
      _view.onTodoAvailable(todo);
    }).catchError((error) {
      _view.onError('Error while reading detail: ' + error.toString());
    });
  }

  void addTodo(String title, String description, int color, int todoId,
      String password) {
    if (description.isEmpty) {
      _view.onError("Please provide description");
      return;
    }

    if (_todoProvider != null) {
      if (todoId == 0) {
        _todoProvider
            .insert(Todo(
                title: title,
                description: description,
                color: color,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                password: password))
            .then(
          (value) {
            _view.onTodoUpdated("Note was created successfully.");
          },
        ).catchError(
          (error) {
            print('error while inserting todo: ' + error.toString());
            _view.onError("Something wrong, please try again.");
          },
        );
      } else {
        _todoProvider
            .update(Todo(
                id: todoId,
                title: title,
                description: description,
                color: color,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                password: password))
            .then(
          (value) {
            _view.onTodoUpdated("Note was updated successfully.");
          },
        ).catchError(
          (error) {
            print('error while inserting todo: ' + error.toString());
            _view.onError("Something wrong, please try again.");
          },
        );
      }
    }
  }

  void deleteTodo(int todoId) {
    if (_todoProvider != null) {
      if (todoId > 0) {
        _todoProvider.delete(todoId).then(
          (value) {
            _view.onTodoUpdated("Note was deleted successfully.");
          },
        ).catchError(
          (error) {
            print('error while deleting todo: ' + error.toString());
            _view.onError("Something wrong, please try again.");
          },
        );
      }
    }
  }

  void addPassword(Todo todo, String password) {
    if (_todoProvider != null) {
      if (todo.id > 0) {
        _todoProvider.updatePassword(password, todo.id).then((value) {
          _view.onTodoUpdated("Note was protected successfully.");
        }).catchError((error) {
          print('error while updating password: ' + error.toString());
          _view.onError("Something wrong, please try again.");
        });
      }
    }
  }

  void removePassword(int todoId) {
    if (_todoProvider != null) {
      if (todoId > 0) {
        _todoProvider.updatePassword("", todoId).then((value) {
          _view.onTodoUpdated("Note was un-protected successfully.");
        }).catchError((error) {
          print('error while updating password: ' + error.toString());
          _view.onError("Something wrong, please try again.");
        });
      }
    }
  }
}
