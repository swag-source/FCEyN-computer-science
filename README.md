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

## El `.gitignore` compartido

Vive en `main` y se mergea hacia cada rama (`main` -> rama). Es infraestructura,
no contenido de curso, asi que no rompe la regla de "cada rama autocontenida",
y toda rama nueva creada desde `main` lo hereda.

Para actualizarlo: editarlo en `main`, commitear, y propagarlo.

```bash
git checkout main
# editar .gitignore, commitear
for b in organizacion-del-computador-2 teoria-de-los-lenguajes; do
  git checkout $b && git merge main
done
```

## Ojo: los archivos sin trackear no pertenecen a ninguna rama

Es la trampa principal de tener una rama por materia. Git solo cambia los
archivos *trackeados* al hacer `checkout`: todo lo que este sin trackear o
ignorado **se queda en disco y aparece en todas las ramas**.

Por eso los PDFs de Teoria de los Lenguajes aparecian estando en la rama de
Orga 2, y las carpetas de Orga 2 aparecian estando en Teoria. Nunca estuvieron
commiteados en la rama equivocada: estaban sin trackear, flotando.

Dos consecuencias practicas:

1. **Commitear el material en su rama lo antes posible.** Mientras este sin
   trackear, te sigue a todas las ramas.
2. `git status` limpio **no** significa carpeta limpia. Para ver que hay
   flotando: `git status --ignored`.

Si molesta ver las carpetas de las otras materias en disco, la solucion
definitiva es un worktree por materia (una carpeta por rama, sin pisarse):

```bash
git worktree add ../FCEyN-orga2     organizacion-del-computador-2
git worktree add ../FCEyN-lenguajes teoria-de-los-lenguajes
```

## Conventions

- Commit as you go — small, incremental commits per class/topic are more useful here than big batched dumps.
- Keep each branch self-contained: notes, exercises, and any resources for that course live entirely within its own branch.
- `main` is only ever the index — course content doesn't merge back into it.
