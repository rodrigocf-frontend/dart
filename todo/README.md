# Todo CLI

Gerenciador de tarefas por linha de comando escrito em Dart. As tarefas são persistidas localmente em um arquivo JSON criado automaticamente na primeira execução.

## Requisitos

- Dart SDK `^3.12.1`

## Instalação

```bash
dart pub get
dart compile exe bin/todo.dart -o todo
```

## Uso

```
todo <comando> [argumentos]
```

### Comandos

| Comando | Descrição | Exemplo |
|---|---|---|
| `add <título>` | Adiciona uma nova tarefa | `todo add comprar pão` |
| `list` | Lista todas as tarefas | `todo list` |
| `done <id>` | Marca uma tarefa como concluída | `todo done 1` |
| `remove <id>` | Remove uma tarefa | `todo remove 1` |

### Exemplos

```bash
# Adicionar tarefas
todo add comprar pão
todo add estudar Dart

# Listar tarefas
todo list

# Marcar como concluída
todo done 1

# Remover
todo remove 2
```

## Estrutura do projeto

```
bin/
  todo.dart                  # Entry point
lib/
  commands/
    add_command.dart          # Comando add
    list_command.dart         # Comando list
    done_command.dart         # Comando done
    remove_command.dart       # Comando remove
  models/
    todo_model.dart           # Entidade Todo e enum TodoStatus
    todo_cli.dart             # CommandRunner principal
  repository/
    todo_repository.dart      # Persistência em JSON
  service/
    todo_service.dart         # Regras de negócio
test/
  todo_model_test.dart        # Testes da entidade Todo
  todo_service_test.dart      # Testes do serviço
  todo_repository_test.dart   # Testes do repositório
```

## Estrutura do `data.json`

O arquivo é criado automaticamente em `store/data.json` na primeira execução.

```json
{
  "list": [
    {
      "id": 1,
      "title": "comprar pão",
      "status": "pending",
      "createdAt": "01-06-2026"
    }
  ],
  "lastIdCreated": 1
}
```

## Desenvolvimento

Para rodar sem compilar:

```bash
dart run bin/todo.dart list
```

Para rodar os testes:

```bash
dart test
```
