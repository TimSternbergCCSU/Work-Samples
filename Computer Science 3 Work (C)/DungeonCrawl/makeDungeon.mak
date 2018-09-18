CC=gcc
all: dungeonCrawl
dungeonCrawl: dungeonCrawl.o intro.o rip.o splash.o winner.o sortie.o scene00.o scene01.o scene02.o scene03.o scene04.o scene05.o scene06.o potionScene.o
	$(CC) -o dungeonCrawl dungeonCrawl.o intro.o rip.o splash.o winner.o sortie.o scene00.o scene01.o scene02.o scene03.o scene04.o  scene05.o scene06.o potionScene.o
	
dungeonCrawl.o: dungeonCrawl.c
	$(CC) -c dungeonCrawl.c
 
intro.o: intro.c
	$(CC) -c intro.c
	
rip.o: rip.c
	$(CC) -c rip.c
	
splash.o: splash.c
	$(CC) -c splash.c
	
winner.o: winner.c
	$(CC) -c winner.c
	
sortie.o: sortie.c
	$(CC) -c sortie.c
	
scene00.o: scene00.c
	$(CC) -c scene00.c
	
scene01.o: scene01.c
	$(CC) -c scene01.c
	
scene02.o: scene02.c
	$(CC) -c scene02.c
	
scene03.o: scene03.c
	$(CC) -c scene03.c
	
scene04.o: scene04.c
	$(CC) -c scene04.c	
	
scene05.o: scene05.c
	$(CC) -c scene05.c	
	
scene06.o: scene06.c
	$(CC) -c scene06.c	
	
potionScene.o: potionScene.c
	$(CC) -c potionScene.c	
