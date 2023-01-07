
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){ 
    FILE * fich_base  =  NULL;
    FILE * fich_temp  =  NULL;
    int nbr_propositions, nbr_variables, nbr_clauses, i, but[20], non_but[20];
    char nom_base[20], c;


    printf("Entrez le nom de votre Fichier BC (sans extension) :\n");
    gets(nom_base);
    strcat(nom_base,".cnf");
    fich_base = fopen(nom_base,"r+");

    if(fich_base  ==   NULL) 
        printf("Impossible d'ouvrir BC...\n");
    else{

        fich_temp = fopen("Temp.cnf","rw+");

        if(fich_temp ==  NULL) 
            printf("Impossible de transferer BC \n");
        else{
            fscanf(fich_base, "p cnf %d %d ",&nbr_variables,&nbr_clauses); // on prend la première ligne de la BC
            nbr_clauses +=  1 ; // pour rajouter le non_but
            fprintf (fich_temp,"p cnf %d %d  ""\n", nbr_variables,nbr_clauses); // on met les infos dans le fichier qu'on va traiter
        }
        c = fgetc(fich_base);
        while(c!= EOF){
            c = fgetc(fich_base);
            if(c!=  EOF) fputc(c,fich_temp);
        } // on a recopier le reste de la BC dans le fichier qu'on va traiter

    printf("Liste des variables de la BC (littereaux):\n "); //afficher les codes pour l'utilisateur
    printf("1: Na;\t\t 2: Nb;\t\t 3: Nc;\t \n 4: Cea;\t 5: Ceb:\t 6: Cec;\t \n 7: Coa;\t 8: Cob;\t 9: Coc;\t \n 10: Ma;\t 11: Mb;\t 12: Mc;\t\n\n");    
    printf("Donnez le nombre de littereaux : \n"); //prendre les buts à inferer 
    scanf("%d",&nbr_propositions);  


    for(i = 1; i<nbr_propositions+1; i++){

        printf("Entrez le literal %d :  \n",i);
        scanf("%d", &but[i]);
        if(but[i]>-13 && but[i]<13) 
            non_but[i] = but[i]*(-1); //si les codes sot corrects on prend la negation du but (absurde)
        else 
            puts("Erreur, Vous avez entrer un code invalide");
    }


    fprintf(fich_temp, "\n");  //completion du fichier à traiter
    for(i = 1; i<nbr_propositions+1; i++)fprintf(fich_temp,"%d ",non_but[i]);  //Ajout des negations au fichier
    fprintf(fich_temp,"0"); //Ajout des 0 pour marquer la fin

    system("ubcsat -alg saps -i Temp.cnf -solve > results.txt"); //execution solveur
}
fclose(fich_temp);


    int termine = 0; //signaler fin affichage
    FILE *fich  = fopen("results.txt","r+");
    if(fich_base   ==  NULL) printf("Impossible d'acceder aux resultats...\n");
    else{
        char texte[1000];
        while(fgets(texte, 1000, fich) && !termine){
            if(strstr(texte, "# Solution found for -target 0")){

                printf("\n BC U {Non but} est satisfiable. La base infere le but. \n Solution : \n");
                fscanf(fich, "\n");
                while(!strstr(fgets(texte, 1000, fich), "Variables"))
                    printf("%s", texte);
                termine = 1;
            }
        }
        if(termine   ==  0){ //cas de non satisfiablité
        printf("\n BC U {Non but} est non satisfiable. La base n'infere pas le but.\n");
        int j;
        for(j = 1;j<nbr_propositions+1;j++){
            printf("%d ",(-1)*but[j]);
        }
        if(j>2)
            printf("ne peuvent pas etre atteints");
        else 
            printf("ne peut pas etre atteint\n");
        }
    }

    fclose(fich_temp);
}


