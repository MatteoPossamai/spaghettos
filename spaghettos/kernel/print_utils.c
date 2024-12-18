#include "print_utils.h"

char* TM_START;
int CELL;


int start(){
	TM_START = (char*) 0xb8000;
	CELL = 0;

	cls();
	setMonitorColor(0xa5);

	char Welcome[] = "SpahettOs - Pile of spaghetti code in your kernel\n";
	char Welcome2[] = "Version 0.0.1\n\n";
	char OSM[] = "linguine $> ";

	printString(Welcome);
	printString(Welcome2);
	printColorString(OSM , 0xa8);
    return 0;
}


void cls(){
	int i = 0;
	CELL = 0;
	while(i < (2 * 80 * 25)){
		*(TM_START + i) = ' '; // Clear screen
		i += 2;
	}
}

void setMonitorColor(char Color){
	int i = 1;
	while(i < (2 * 80 * 25)){
		*(TM_START + i) = Color;
		i += 2;
	}
}

void printString(char* cA){
	int i = 0;
	while(*(cA + i) != '\0'){
		printChar(*(cA + i));
		i++;
	}
}

void printChar(char c){
	if(CELL == 2 * 80 * 25)
		scroll();
	if(c == '\n'){
		CELL = ((CELL + 160) - (CELL % 160));
		return;
	}
	*(TM_START + CELL) = c;
	CELL += 2;	
}

void scroll(){
	int i = 160 , y = 0;
	while(i < 2 * 80 * 25){
		*(TM_START + y) = *(TM_START + i);
		i += 2;
		y += 2;
	}
	CELL = 2 * 80 * 24;
	i = 0;
	while(i < 160){
		*(TM_START + CELL + i) = ' ';
		i += 2;
	}
}

void printColorString(char* c , char co){
	int i = 0;
	while(*(c + i) != '\0'){
		printColorChar(*(c + i) , co);
		i++;
	}
}

void printColorChar(char c , char co){
	if(CELL == 2 * 80 * 25)
		scroll();
	if(c == '\n'){
		CELL = ((CELL + 160) - (CELL % 160));
		return;
	}
	*(TM_START + CELL) = c;
	*(TM_START + CELL + 1) = co;
	CELL += 2;	
}