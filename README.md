# FCEyN — Computer Science Notes

Personal notes, exercises, and study material for the Computer Science degree at **FCEyN, Universidad de Buenos Aires**.

## How this repo works

Each **branch** is a different class. There's no single tree with folders per course — instead, `main` stays lightweight (just this index) and every course lives on its own branch, with its own history, commits, and pace.

```
main                                → this README (index)
organizacion-del-computador-2       → Organización del Computador 2
teoria-de-los-lenguajes             → Teoría de los Lenguajes
```

To work on a course, just check out its branch:

```bash
git checkout teoria-de-los-lenguajes
```

New course → new branch off `main`:

```bash
git checkout main
git checkout -b nombre-de-la-materia
```

## Active courses

| Branch | Course | Link |
|---|---|---|
| `organizacion-del-computador-2` | Organización del Computador 2 | [browse](../../tree/organizacion-del-computador-2) |
| `teoria-de-los-lenguajes` | Teoría de los Lenguajes | [browse](../../tree/teoria-de-los-lenguajes) |

## Conventions

- Commit as you go — small, incremental commits per class/topic are more useful here than big batched dumps.
- Keep each branch self-contained: notes, exercises, and any resources for that course live entirely within its own branch.
- `main` is only ever the index — course content doesn't merge back into it.
