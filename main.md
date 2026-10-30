# root

This is a *content*.

## Reviewer list

By chapter...

[]{.review-by-chapter}

By author...

[]{.review-by-author}

!include`incrementSection=1` content/showcase.md

!include`incrementSection=1` content/chapter1.md

!include`incrementSection=1` content/chapter2.md

!include`incrementSection=1` content/random-wrap.md

# another root chapter

Nothing inside.

## sub1

This is subchapter with the existing title.
See [this ref](#explicit-ref).

## sub2 {#explicit-ref review="Lojze Novak"}

This is subchapter2, see also [root](#root).

