import 'package:todo/base/base_view.dart';
import 'package:todo/database/data/Todo.dart';

abstract class AddTodoView extends BaseView {
  void onTodoAvailable(Todo todo);

  void onPasswordValidate(String password);

  void onTodoUpdated(String message);
}
