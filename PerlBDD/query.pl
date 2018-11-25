#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;
use Date::Calc qw(Day_of_Year);
use POSIX       qw( strftime );
use POSIX       qw/floor/;
use Time::Local qw( timegm );


#Connexion à la base de données
my $dbh = DBI->connect( "DBI:Pg:dbname=Base_Projet;host=localhost;port=5432",
    "postgres", "Allezbordeaux33", {
	RaiseError => 1,
})  || die "Connexion impossible";

sub messageReq (){
  print "Bienvenue sur l'outil de requêtes et de modification des tables, que voulez-vous faire ?\n";
}

sub menuReq () {
  print "###########################################################################################################\n";
  print "###################################### MENU REQUETES ET STATISTIQUES ######################################\n";
  print "###########################################################################################################\n";
  print "############                          [1] Affiche le nom des gérants                           ############\n";
  print "############                         [2] Affiche le nombre de gérants                          ############\n";
  print "############             [3] Affiche le nom des personnes gérant au moins 2 hôtels             ############\n";
  print "############            [4] Affiche le nom des hôtels où au moins une chambre libre            ############\n";
  print "############                         [5] Ajouter une chambre à un hôtel                        ############\n";
  print "############                      [6] Modifier le nom du gérant d'un hôtel                     ############\n";
  print "############        [7] Annuler une réservation (impossible si 2 jours avant son début)        ############\n";
  print "############                            [8] Ajouter une réservation                            ############\n";
  print "############              [9] Taux d'occupation d'un hôtel sur les 7 derniers jours            ############\n";
  print "############         [10] Taux d'occupation pour chaque hôtel sur les 7 derniers jours         ############\n";
  print "############              [11] Affiche l'hôtel avec le plus haut taux d'occupation             ############\n";
  print "############                        [12] Afficher les résultats (HTML)                         ############\n";
  print "############                                [0] Quitter le menu                                ############\n";
  print "###########################################################################################################\n";
  print "###########################################################################################################\n";
  my $choix = <>;
  chomp($choix);
  if ($choix == 1) {
    system('clear');
    afficheGerant();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 2) {
    system('clear');
    afficheNbGerants();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 3) {
    system('clear');
    nomPersonne();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 4) {
    system('clear');
    chambreLibre();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 5) {
    system('clear');
    ajoutChambre();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 6) {
    system('clear');
    modifNomGerant();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 7) {
    system('clear');
    annulationReserv();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 8) {
    system('clear');
    ajoutReserv();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 9) {
    system('clear');
    tauxOccup();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 10) {
    system('clear');
    tauxOccupHotel();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 11) {
    system('clear');
    print "Cette fonction n'existe pas !\n"
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 12) {
    system('clear');
    fichierResultat();
    print "Que voulez-vous faire ?\n";
    menuReq();
  }
  if ($choix == 0) {
    system('clear');
    print "Merci d'avoir utilisé notre outil. A bientôt.\n";
    exit;
  }
  else {
    system('clear');
    print "Valeur incorrecte. Réessayez\n";
    menuReq();
  };
};

################################ REQUETES ######################################

# Affiche le nom des gerants

sub afficheGerant () {
  my $requete1 = $dbh->prepare("SELECT Gerant FROM Hotel GROUP BY Gerant HAVING COUNT(*)>0");
  $requete1->execute();
  while (my @tab1 = $requete1->fetchrow_array()){
    print "Le nom des gérants : $tab1[0]\n";
  };
};
# Affiche le nombre de gérants

sub afficheNbGerants () {
  my $requete2 = $dbh->prepare("SELECT COUNT(DISTINCT Gerant) FROM Hotel");
  $requete2->execute();
  while (my @tab2 = $requete2->fetchrow_array()){
    print "Nombre de gérants : $tab2[0]\n";
    return $tab2[0];
  }
};
# Affiche le nom des personnes qui gèrent au moins deux hôtels

sub nomPersonne () {
  my $requete3 = $dbh->prepare("SELECT Gerant FROM Hotel GROUP BY Gerant HAVING COUNT (*) >1");
  $requete3->execute();
  while (my @tab3 = $requete3->fetchrow_array()){
    print "Nom des personnes gérant au moins deux hôtels : $tab3[0]\n";
    return $tab3[0];
  };
};

# Affiche le nom des hôtels où il y a au moins une chambre libre

sub chambreLibre () {
  print "Entrez la date du début de la réservation : \n";
  my $dateDeb = <>;
  chomp($dateDeb);
  print "Entrez la date de fin de la réservation : \n";
  my $dateFin = <>;
  chomp($dateFin);
  my $requete4 = $dbh->prepare("SELECT Hotel,NumChambre FROM Reservation EXCEPT SELECT Hotel,NumChambre FROM Reservation WHERE DebutResa = ?  AND FinResa <  ? ");
  $requete4->execute($dateDeb, $dateFin);
  while (my @tab4 = $requete4->fetchrow_array()){
    print "Hôtel où il y a une chambre libre à la période indiquée : $tab4[0]\n";
    print "Numéro de la chambre : $tab4[1]\n";
    print " \n";
  };
};

################################# MISE A JOUR ##################################

# Ajouter une chambre à un hôtel

sub ajoutChambre () {
  print "Numéro de la chambre : \n";
  my $numChambre = <>;
  chomp($numChambre);
  print "Nom de l'hôtel : \n";
  my $nomHotel = <>;
  chomp($nomHotel);
  print "Type de couchage : \n";
  my $typeCouchage = <>;
  chomp($typeCouchage);
  print "Prix basse saison : \n";
  my $prixBS = <>;
  chomp($prixBS);
  print "Prix haute saison : \n";
  my $prixHS = <>;
  chomp($prixHS);
  my $maj1 = $dbh->prepare("INSERT INTO Chambre (NumChambre, Hotel, TypeCouchage, PrixBS, PrixHS) VALUES (?,?,?,?,?)");
  $maj1->execute($numChambre, $nomHotel, $typeCouchage, $prixBS, $prixHS);
}

# Modifier le nom du gérant d'un hôtel

sub modifNomGerant () {
  print "Nouveau nom de gérant : \n";
  my $nouvNom = <>;
  chomp($nouvNom);
  print "De quel hôtel ? : \n";
  my $hotel = <>;
  chomp($hotel);
  my $maj2 = $dbh->prepare("maj Hotel SET Gerant = ? WHERE Hotel = ?");
  $maj2->execute($nouvNom, $hotel);
}

# Annuler une réservation (on ne peut pas annuler une réservation moins de deux jours avant son début)

sub annulationReserv () {
  print "Saisir le numero de reservation que vous souhaitez annuler: \n";
  my $numResa = <>;
  chomp ($numResa);
  my $maj3 = $dbh-> prepare("SELECT DebutResa FROM Reservation WHERE NumResa= ? ");
  $maj3-> execute($numResa);
  while (my @tab5 = $maj3->fetchrow_array){
    foreach (@tab5) {
      if ($_ =~ /(\d{4})-(\d{2})-(\d{2})/){
        my $an = $1;
        my $mois = $2;
        my $jour = $3;
        my @semaine = localtime;
        my $jourActuel = $semaine[7];
        my $dateLimite = $jourActuel+2;
        my $dateResa = Day_of_Year($an,$mois,$jour);
        if ($dateLimite>= $dateResa){
          print "Vous ne pouvez pas annuler une réservation dont le début est dans moins de deux jours\n";
        }
        else {
          my $supp = $dbh-> prepare("DELETE FROM Reservation WHERE NumResa= ?");
          $supp-> execute($numResa);
          print "La réservation a été annulée.\n";
        }
      }
    }
  }
}
# Ajouter une réservation

sub ajoutReserv () {
  print "Numéro de la réservation : \n";
  my $numResa = <>;
  chomp($numResa);
  print "Début de la réservation : \n";
  my $debutResa = <>;
  chomp($debutResa);
  print "Fin de la réservation : \n";
  my $finResa = <>;
  chomp($finResa);
  print "Numéro de la chambre : \n";
  my $numChambre = <>;
  chomp($numChambre);
  print "Nom de l'hôtel : \n";
  my $nomHotel = <>;
  chomp($nomHotel);
  print "Nom du client : \n";
  my $client = <>;
  chomp($client);
  #my $verifChambre = $dbh->prepare("SELECT Hotel,NumChambre FROM Reservation EXCEPT SELECT Hotel,NumChambre FROM Reservation WHERE DebutResa = ?  AND FinResa <  ? AND Hotel = ? AND NumChambre = ? ");
  #$verifChambre->execute($debutResa,$finResa,$nomHotel,$numChambre);
  #print $verifChambre."\n";
  #if ($verifChambre eq "") {
  my $maj4 = $dbh->prepare("INSERT INTO Reservation (NumResa, DebutResa, FinResa, NumChambre, Hotel, NomClient) VALUES (?,?,?,?,?,?)");
  $maj4->execute($numResa, $debutResa, $finResa, $numChambre, $nomHotel, $client);
  #}else{
  #  print "Il y a déjà une réservation dans cette chambre pour cette date\n";
  #  print "Réservation impossible, réassayez\n";
  #}
}
############################### STATISTIQUES ###################################

# Afficher le taux d'occupation de l'hôtel souhaité sur les 7 derniers jours

sub tauxOccup () {
  print "Entrez le nom de l'hôtel : \n";
  my $h = <>;
  chomp($h);
  my $taux = 0;
  my $count = 0;
  my ($d,$m,$y) = (localtime())[3,4,5];
  my $date = (strftime("%Y_%m_%d\n", gmtime(timegm(0,0,0,$d,$m,$y))));
  my $datesept = (strftime("%Y_%m_%d\n", gmtime(timegm(0,0,0,$d,$m,$y) + 24*60*60*(-7))));
  my $request = $dbh->prepare("SELECT (FinResa-DebutResa) FROM Reservation WHERE DebutResa >= ?  AND FinResa <=  ? AND Hotel = ?");
  $request->execute($datesept,$date,$h);
  while (my @tab6 = $request->fetchrow_array()){
    my $res = $tab6[0];
    $count = $count + $res;
  };
  $taux = (($count/7)*100);
  my $arrondi = floor($taux);
  print "Taux d'occupation de l'hôtel de $h : $arrondi %\n";
};

# Afficher le taux d'occupation de tous les hôtels (NON FONCIONNEL /!\)

sub tauxOccupHotel () {

  my $taux = 0;
  my $count = 0;
  my ($d,$m,$y) = (localtime())[3,4,5];
  my $date = (strftime("%Y_%m_%d\n", gmtime(timegm(0,0,0,$d,$m,$y))));
  my $datesept = (strftime("%Y_%m_%d\n", gmtime(timegm(0,0,0,$d,$m,$y) + 24*60*60*(-7))));
  my $request = $dbh->prepare("SELECT Hotel FROM Reservation GROUP BY Hotel HAVING COUNT (*) > 0");
  $request->execute();
  my $rerequest = $dbh->prepare("SELECT (FinResa-DebutResa), Hotel FROM Reservation WHERE DebutResa >= ?  AND FinResa <=  ?");
  $rerequest->execute($datesept,$date);
  while (my @tab6 = $rerequest->fetchrow_array()){
    my $res = $tab6[0];
    $count = $count + $res;
    $taux = (($count/7)*100);
    $count = 0;
    foreach(@tab6){
      my @tab7 = $request->fetchrow_array();
      print "Taux d'occupation de l'hôtel $tab7[0] : $taux %\n";
    };
  };
};

################################### HTML #######################################

sub fichierResultat () {
  open(OUTPUT, ">", "resultat.html") or die "Couldn't open: $!";
  print OUTPUT "<HTML>\n";
  print OUTPUT "<HEAD>\n";
  print OUTPUT "<TITLE>Resultats</TITLE>\n";
  print OUTPUT "<style type='text/css'> \n body {h1 {\ntext-align: center;}</style>";
  print OUTPUT "</HEAD>\n";
  print OUTPUT "<BODY>\n";
  print OUTPUT "<h1>Resultats </h1>";
  print OUTPUT "<BR>\n";
  print OUTPUT "<BR>\n";
  print OUTPUT "<div align=center> \n";
  print OUTPUT "<TABLE BORDER=4>\n";
  print OUTPUT "<CAPTION>Tableau du nombre de gerants</CAPTION>\n";
  my $result=afficheNbGerants();
  print $result;
  print OUTPUT "<TR><TD> Nombre de gerants </TD>";
  print OUTPUT "<TD> $result </TD> </TR>\n";
  print OUTPUT "</TABLE>\n";
  print OUTPUT "</div>\n";
  print OUTPUT "<BR>\n";
  print OUTPUT "<BR>\n";
  print OUTPUT "<BR>\n";
  print OUTPUT "<div align=center> \n";
  print OUTPUT "<TABLE BORDER=4>\n";
  print OUTPUT "<CAPTION>Tableau des personnes gerant 2 hotels ou plus </CAPTION>\n";
  my $result2=nomPersonne();
  print OUTPUT "<TR> <TD> Nom des personnes gerant au moins 2 hotels </TD>";
  print OUTPUT "<TD> $result2 </TD> </TR>\n";
  print OUTPUT "</TABLE>\n";
  print OUTPUT "</div>\n";
  print OUTPUT "</BODY>\n";
  print OUTPUT "</HTML>\n";
  close(OUTPUT);
}

################################### MAIN #######################################
messageReq();
menuReq();
