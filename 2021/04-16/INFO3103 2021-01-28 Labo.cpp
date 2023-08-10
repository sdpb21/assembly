// INFO3103 2021-01-28 Labo.cpp 
/*
Au labo, on va écrire des programmes qui vont faire 
l'équivalent des blocs de code suivants.

Les programmes sont relativement courts, ce qui ne 
veut pas dire que ça va se faire rapidement.


Exécutez ce programme pour en voir le comportement 
visible (ce qu'il produit). Essayez avec diverses 
valeurs de N et M en entrées (pour les trois premiers 
"programmes"),des valeurs positives et des 
valeurs négatives.
*/
#include <iostream>
using namespace std;

int main()
{
  // Premier programme : faire une addition en assembleur.
	{

		long N, M, S;

		cout << "Debut du premier programme - addition" << endl << endl;

		cout << "Entrez deux valeurs entieres : ";
		cin >> N;
		cin >> M;
		S = N + M;
		cout << "La somme est " << S << endl;

		cout << "Fin du premier programme" << endl << endl;

	}


	// Deuxième programme : faire une soustraction en assembleur.
	{
		long N, M, D;
		cout << "Debut du deuxieme programme - soustraction" << endl << endl;

		cout << "Entrez deux valeurs entieres : ";
		cin >> N;
		cin >> M;
		D = N - M;
		cout << "La difference est " << D << endl;

		cout << "Fin du deuxieme programme" << endl << endl;

	}
	// Indice de performance humaine : on fera une copie 
	// du programme précédente et on le modifiera.
	// Vous ferez de même pour les prochains programmes : copier 
	// un fichier existant et le modifier.


	// Troisième programme : fabrication de l'équivalent d'un if en assembleur.
	{
		long N, M;
		cout << "Debut du troisieme programme - if" << endl << endl;

		cout << "Entrez deux valeurs entieres : ";
		cin >> N;
		cin >> M;

		if (N < M)
			cout << N << " est plus petit que " << M << endl;
		else
			cout << N << " est plus grand ou egal a " << M << endl;

		cout << "Fin du troisieme programme" << endl << endl;
	}

	// Quatrième programme : fabrication de l'équivalent d'un while en assembleur.
	{
		long N = 1;
		cout << "Debut du quatrieme programme - while" << endl << endl;

		while (N < 10)
		{
			cout << "N =  " << N << endl;
			N = N + 1;
		}
		cout << "Fin du quatrieme programme" << endl << endl;


	}

	// Cinquième programme : fabrication de l'équivalent d'un do while en assembleur.
	{
		long N = 1;
		cout << "Debut du cinquieme programme - do while" << endl << endl;

		do
		{
			cout << "N =  " << N << endl;
			N = N + 1;
		} while (N < 10);

		cout << "Fin du cinquieme programme" << endl << endl;
	}

	// Sixième programme : fabrication de l'équivalent d'un for en assembleur.
	{
		long N = 1;
		cout << "Debut du sixieme programme - for" << endl << endl;

		for( long N = 1 ; N < 10 ; N = N + 1)
		{
			cout << "N =  " << N << endl;
		} 

		cout << "Fin du sixieme programme" << endl << endl;
	}

	return 0;
}
/*

Vous aurez remarqué la présence d'accolades supplémentaires 
et qu'il y a des, semble-t-il, des redéclarations de variables.

Rappel :

Le fait de créer des blocs de code avec ces accolades supplémentaires
fait que les variables qui y sont déclarées sont locales à ce bloc.
Leurs zone de visibilité est donc restreintes au bloc.
Donc, par exemple, chacune des variables N de ce programme C++ ont 
des zones de visibilités disjointes. Ceci fait que le compilateur
les distinguent très aisément.


*/