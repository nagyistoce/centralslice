all:mtoc

mtoc:lex.yy.c
	gcc $< -o $@ -lfl

lex.yy.c:mtoc.l
	flex $<
