# Todo CLI

A command-line task manager written in Dart. Tasks are persisted locally in a JSON file created automatically on first run.

## Requirements

- Dart SDK `^3.12.1`

## Installation

```bash
dart pub get
dart compile exe bin/todo.dart -o todo
```

## Usage

```
todo <command> [arguments]
```

### Commands

| Command | Description | Example |
|---|---|---|
| `add <title>` | Add a new task | `todo add buy groceries` |
| `list` | List all tasks | `todo list` |
| `done <id>` | Mark a task as done | `todo done 1` |
| `remove <id>` | Remove a task | `todo remove 1` |

### Examples

```bash
# Add tasks
todo add buy groceries
todo add study Dart

# List tasks
todo list

# Mark as done
todo done 1

# Remove
todo remove 2
```

## Project Structure

```
bin/
  todo.dart                  # Entry point
lib/
  commands/
    add_command.dart          # add command
    list_command.dart         # list command
    done_command.dart         # done command
    remove_command.dart       # remove command
  models/
    todo_model.dart           # Todo entity and TodoStatus enum
    todo_cli.dart             # Main CommandRunner
  repository/
    todo_repository.dart      # JSON persistence
  service/
    todo_service.dart         # Business logic
test/
  todo_model_test.dart        # Todo entity tests
  todo_service_test.dart      # Service tests
  todo_repository_test.dart   # Repository tests
```

## Data File Structure

The file is created automatically at `store/data.json` on first run.

```json
{
  "list": [
    {
      "id": 1,
      "title": "buy groceries",
      "status": "pending",
      "createdAt": "01-06-2026"
    }
  ],
  "lastIdCreated": 1
}
```

## Development

Run without compiling:

```bash
dart run bin/todo.dart list
```

Run tests:

```bash
dart test
```
