# Todo CLI

Gerenciador de tarefas por linha de comando escrito em Dart. As tarefas são persistidas localmente em um arquivo JSON.

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
| `delete <id>` | Remove uma tarefa | `todo delete 1` |

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
todo delete 2
```

## Estrutura do projeto

```
bin/
  todo.dart            # Entry point
lib/
  todo_model.dart      # Entidade Todo e enum TodoStatus
  todo_repository.dart # Persistência em JSON
  todo_cli_model.dart  # Orquestração de comandos
  command_model.dart   # Abstração de Command
store/
  data.json            # Arquivo de dados local
```

## Estrutura do `data.json`

```json
{
  "list": [
    {
      "id": 1,
      "title": "comprar pão",
      "status": "pending",
      "createdAt": "31-05-2026"
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
