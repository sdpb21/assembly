#include <time.h>
#include <stdio.h>
#include <windows.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
typedef struct {
	int manufacturer;
	int reference;
	char partn[28];
	char description[17];
}tproduct;
tproduct product;
bool flag=false;
FILE *arch;
int gotoxy(int x,int y)
{
    COORD coord;
    coord.X=x;
    coord.Y=y;
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE),coord);
}
int consult_pn()
{
	char pn[28];
	int k=0;
	//int flag=0;
	arch=fopen("data.dat","rb");
	if (arch==NULL){
		//printf("\nError\n");
		exit(1);
	}
	//printf("Introduce the part number: ");
	fflush(stdin);
	gotoxy(50,5);
	scanf("%[^\n]",pn);
	for(k=strlen(pn);k>0;k--){
		fread(&product, sizeof(tproduct), 1, arch);
    	while(!feof(arch))
	    {
        	if (strncmp(product.partn,pn,k)==0){
				flag=true;
				return 0;
        	}
        	fread(&product, sizeof(tproduct), 1, arch);
    	}
    	rewind(arch);
	}
}
void consult_ref()
{
	unsigned long int ref;
	//int flag=0;
	arch=fopen("ref.dat","rb");
	if (arch==NULL){
		//printf("\nError\n");
		exit(1);
	}
	//printf("Introduce the reference: ");
	do{
		gotoxy(36,5);
		printf("                                           ");
		gotoxy(36,5);
		scanf("%D",&ref);
	}while(ref>999999999);
	fread(&product, sizeof(tproduct), 1, arch);
    while(!feof(arch))
    {
        if (product.reference>=ref){
			flag=true;
			break;
        }
        fread(&product, sizeof(tproduct), 1, arch);
    }
    //if (!flag)
        //printf("\nReference doesn't exists\n");
    //fclose(arch);
}
void Color(int Background, int Text){ // Función para cambiar el color del fondo y/o pantalla

	HANDLE Console = GetStdHandle(STD_OUTPUT_HANDLE); // Tomamos la consola.

	// Para cambiar el color, se utilizan números desde el 0 hasta el 255.
	// Pero, para convertir los colores a un valor adecuado, se realiza el siguiente cálculo.
	int    New_Color= Text + (Background * 16); 

	SetConsoleTextAttribute(Console, New_Color); // Guardamos los cambios en la Consola.

}
int i;
void print_list(){
	for(i=8;i<22;i++){
		fread(&product, sizeof(tproduct), 1, arch);
		if(i==14) Color(7,0);
		gotoxy(0,i);
		printf("                                                                                ");
		gotoxy(5,i);
		printf("%d",product.manufacturer);
		gotoxy(20,i);
		printf("%d",product.reference);
		gotoxy(35,i);
		printf("%s",product.partn);
		gotoxy(55,i);
		printf("%s",product.description);
		if(i==14) Color(0,7);
	}
}
void main(){
	time_t t;
	struct tm *tm;
	char queryType;
	long int bytes;

	t=time(NULL);
	tm=localtime(&t);
	//initscr();
	//refresh();
	//move(0,0);
	printf("%02d/%02d/%d",tm->tm_mday,tm->tm_mon+1,tm->tm_year-100);
	//refresh();
	gotoxy(36,0);
	//refresh();
	printf("MAGIC II");
	gotoxy(60,0);
	printf(" Kamtech Systems Ltd");
	for(i=1;i<=80;i++)
		printf("%c",205);
	gotoxy(37,1);
	printf("Query");
	gotoxy(25,3);
	printf("MFR");
	gotoxy(36,3);
	printf("REF");
	gotoxy(50,3);
	printf("P/N");
	gotoxy(25,4);
	printf("%c%c%c%c%c%c%c%c",196,196,196,196,196,196,196,196);
	gotoxy(36,4);
	printf("%c%c%c%c%c%c%c%c%c%c",196,196,196,196,196,196,196,196,196,196);
	gotoxy(50,4);
	printf("%c%c%c%c%c%c%c%c%c%c",196,196,196,196,196,196,196,196,196,196);
	printf("%c%c%c%c%c%c%c%c%c%c",196,196,196,196,196,196,196,196,196,196);
	gotoxy(0,22);
	for(i=1;i<=80;i++)
        printf("%c",205);
    printf("\n      1      2      3      4      5      6      7      8      9 end  10");
while(1){
	gotoxy(20,2);
	printf("Query type ( P/N = 1 REF = 2 MFR = 3): ");
	printf(" %c",8);
	do{
		queryType=getche();
		if(queryType==0){
			queryType=getche();
			if(queryType=='C'){
				do{
					gotoxy(14,23);
					printf("Are you sure you want to exit? y (yes) or n (no): ");
					queryType=getche();
				}while(queryType!='y' && queryType!='n');
				if(queryType=='y'){
					exit(1);
				}else{
					gotoxy(14,23);
					printf("                                                   ");
					gotoxy(20,2);
					printf("Query type ( P/N = 1 REF = 2 MFR = 3): ");
					queryType='3';
				}
			}
		}
		if(queryType<'1' || queryType>'2')
			printf("%c",8);
	}while(queryType<'1' || queryType>'2');
	gotoxy(25,5);
	printf("                                                      ");
	switch(queryType){
		case '1':consult_pn();
		break;
		case '2':consult_ref();
		break;
	}
	if(flag){
		for(i=1;i<=80;i++)
        	printf("%c",205);
		gotoxy(32,6);
		printf("Response Screen");
		gotoxy(0,7);
		printf("                                  ");
		gotoxy(5,7);
		printf("Manufacturer");
		gotoxy(20,7);
		printf("Reference");
		gotoxy(35,7);
		printf("Part Number");
		gotoxy(55,7);
		printf("Description");
		bytes=-7;
		if(fseek(arch,bytes*(sizeof(product)),SEEK_CUR)==0){
			print_list();
		}else{
			rewind(arch);
			print_list();
		}
	}else{
		printf("\nPart number or reference not found                                              ");
		gotoxy(0,8);
		queryType='9';
		for(i=1;i<=14;i++)
			printf("                                                                                ");
	}
	while(queryType!='C'){
		gotoxy(5,21);
		queryType=getch();//^[==27
		if(queryType==(-32)){
			queryType=getch();//[==91
			switch(queryType){
				case 'H':bytes=-15;
					if(fseek(arch,bytes*(sizeof(product)),SEEK_CUR)==0){
						print_list();
					}else{
						rewind(arch);
						print_list();
					}
				break;
				case 'P':bytes=-13;
					if(fseek(arch,bytes*(sizeof(product)),SEEK_CUR)==0) print_list();
				break;
			}//switch ends
		}
		if(queryType==0){
			queryType=getch();
		}
	}//while(queryType!='C') ends here
	flag=false;
	fclose(arch);
}//while(1) ends here
	//queryType=getch();
	//endwin();
}

