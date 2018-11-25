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

#################################### MENU #####################################

sub message (){
  print "Bienvenue sur l'outil de création et de remplissage des tables, que voulez-vous faire ?\n";
}
sub menuTable () {
  print "###################################################################\n";
  print "######################### MENU CREATION ###########################\n";
  print "###################################################################\n";
  print "######               [1] Créer les tables                    ######\n";
  print "######               [2] Remplir la table Hotel              ######\n";
  print "######               [3] Remplir la table Chambre            ######\n";
  print "######               [4] Remplir la table Client             ######\n";
  print "######               [5] Remplir la table Reservation        ######\n";
  print "######               [6] Remplissage CSV                     ######\n";
  print "######               [7] Accés menu Requêtes                 ######\n";
  print "######               [0] Quitter le menu                     ######\n";
  print "###################################################################\n";
  print "###################################################################\n";
  my $choix = <>;
  chomp($choix);
  if ($choix == 1) {
    creationTable();
    cleEtrangere();
    system('clear');
    print "Tables créées avec succés\n";
    print "Que voulez-vous faire ?\n";
    menuTable();
  }
  if ($choix == 2) {
    tableHotel();
    system('clear');
    print "Table Hotel remplie avec succés\n";
    print "Que voulez-vous faire ?\n";
    menuTable();
  }
  if ($choix == 3) {
    tableChambre();
    system('clear');
    print "Table Chambre remplie avec succés\n";
    print "Que voulez-vous faire ?\n";
    menuTable();
  }
  if ($choix == 4) {
    tableClient();
    system('clear');
    print "Table Client remplie avec succés\n";
    print "Que voulez-vous faire ?\n";
    menuTable();
  }
  if ($choix == 5) {
    tableReservation();
    system('clear');
    print "Table Reservation remplie avec succés\n";
    print "Que voulez-vous faire ?\n";
    menuTable();
  }
  if ($choix == 6) {
    fichierCSV();
    system('clear');
    print "Tables remplies avec succés\n";
    print "Que voulez-vous faire ?\n";
    menuTable();
  }
  if ($choix == 7) {
    system('clear');
    messageReq();
    menuReq();
    system('clear');
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
    menuTable();
  };
};

#Création des tables

sub creationTable () {
  $dbh->do("create table Hotel (Hotel varchar(40) primary key, Gerant varchar(40), Etoiles integer)");
  $dbh->do("create table Reservation (NumResa integer primary key, DebutResa date, FinResa date, NumChambre integer, Hotel varchar(40), NomClient varchar(40)) ");
  $dbh->do("create table Client (NomClient varchar(40) primary key, PhoneClient integer)");
  $dbh->do("create table Chambre (NumChambre integer, Hotel varchar(40), TypeCouchage varchar(40), PrixBS integer, PrixHS integer, PRIMARY KEY (NumChambre,Hotel))");
}

#Définition des clés étrangères
sub cleEtrangere() {
  $dbh->do("ALTER TABLE Reservation ADD CONSTRAINT F1 FOREIGN KEY (NomClient) REFERENCES Client(NomClient) ON UPDATE CASCADE ON DELETE CASCADE");
  $dbh->do("ALTER TABLE Reservation ADD CONSTRAINT F2 FOREIGN KEY (Hotel) REFERENCES Hotel(Hotel) ON UPDATE CASCADE ON DELETE CASCADE");
  $dbh->do("ALTER TABLE Reservation ADD CONSTRAINT F3 FOREIGN KEY (NumChambre,Hotel) REFERENCES Chambre(NumChambre,Hotel) ON UPDATE CASCADE ON DELETE CASCADE");
}

#Remplissage des tables

#Table Hotel
sub tableHotel () {
  $dbh->do("INSERT INTO Hotel VALUES ('Bordeaux','Dupont',5)");
  $dbh->do("INSERT INTO Hotel VALUES ('Bruges','Dupont',3)");
  $dbh->do("INSERT INTO Hotel VALUES ('Talence','Dupond',2)");
  $dbh->do("INSERT INTO Hotel VALUES ('Pessac','Jouan',5)");
  $dbh->do("INSERT INTO Hotel VALUES ('Gradignan','Schrieke',4)");
  $dbh->do("INSERT INTO Hotel VALUES ('Cestas','Latour',1)");
}

#Table Reservation
sub tableReservation () {
  $dbh->do("INSERT INTO Reservation VALUES (1,'21/04/2018','22/04/2018',1,'Bordeaux','Martin')");
  $dbh->do("INSERT INTO Reservation VALUES (3,'28/03/2018','30/03/2018',1,'Bordeaux','Marin')");
  $dbh->do("INSERT INTO Reservation VALUES (4,'05/04/2018','06/04/2018',1,'Bruges','Marin')");
  $dbh->do("INSERT INTO Reservation VALUES (6,'01/04/2018','03/04/2018',1,'Talence','Marin')");
  $dbh->do("INSERT INTO Reservation VALUES (8,'01/04/2018','02/04/2018',2,'Talence','Seb')");
  $dbh->do("INSERT INTO Reservation VALUES (9,'23/04/2018','24/04/2018',1,'Pessac','Paul')");
  $dbh->do("INSERT INTO Reservation VALUES (10,'12/04/2018','18/04/2018',1,'Pessac','Clement')");
  $dbh->do("INSERT INTO Reservation VALUES (11,'24/04/2018','25/04/2018',1,'Gradignan','Paul')");
  $dbh->do("INSERT INTO Reservation VALUES (12,'28/03/2018','29/03/2018',1,'Gradignan','Hans')");
  $dbh->do("INSERT INTO Reservation VALUES (14,'21/04/2018','22/04/2018',2,'Gradignan','Hans')");
  $dbh->do("INSERT INTO Reservation VALUES (16,'08/04/2018','09/04/2018',1,'Cestas','Martin')");
  $dbh->do("INSERT INTO Reservation VALUES (17,'28/03/2018','29/03/2018',1,'Talence','Didier')");
  $dbh->do("INSERT INTO Reservation VALUES (19,'29/03/2018','30/03/2018',1,'Cestas','Bernard')");
  $dbh->do("INSERT INTO Reservation VALUES (20,'20/04/2018','22/04/2018',1,'Pessac','Paul')");
}

#Table Client
sub tableClient () {
  $dbh->do("INSERT INTO Client VALUES ('Martin',66666666)");
  $dbh->do("INSERT INTO Client VALUES ('Marin',66666667)");
  $dbh->do("INSERT INTO Client VALUES ('Seb',66666668)");
  $dbh->do("INSERT INTO Client VALUES ('Didier',66666665)");
  $dbh->do("INSERT INTO Client VALUES ('Bernard',66666669)");
  $dbh->do("INSERT INTO Client VALUES ('Paul',66666662)");
  $dbh->do("INSERT INTO Client VALUES ('Clement',66666664)");
  $dbh->do("INSERT INTO Client VALUES ('Hans',66666661)");
}

#Table Chambre
sub tableChambre () {
  $dbh->do("INSERT INTO Chambre VALUES (1,'Bordeaux','Double',200,400)");
  $dbh->do("INSERT INTO Chambre VALUES (1,'Bruges','Single',60,80)");
  $dbh->do("INSERT INTO Chambre VALUES (1,'Talence','Single',60,80)");
  $dbh->do("INSERT INTO Chambre VALUES (2,'Talence','Single',60,80)");
  $dbh->do("INSERT INTO Chambre VALUES (1,'Pessac','Single',160,280)");
  $dbh->do("INSERT INTO Chambre VALUES (2,'Pessac','Double',200,320)");
  $dbh->do("INSERT INTO Chambre VALUES (3,'Pessac','Double',210,340)");
  $dbh->do("INSERT INTO Chambre VALUES (1,'Gradignan','Single',90,200)");
  $dbh->do("INSERT INTO Chambre VALUES (2,'Gradignan','Double',120,250)");
  $dbh->do("INSERT INTO Chambre VALUES (1,'Cestas','Single',20,50)");
}

####################################### CSV ####################################

sub fichierCSV () {
  open(CSV, "Hotels.csv");
  my $monCSV=<CSV>;
  my @l=split(';',$monCSV);
  my $hotel = $dbh -> prepare("INSERT INTO Hotel($l[0],$l[2],$l[1]) SELECT ?,?,? WHERE NOT EXISTS (SELECT 1 FROM Hotel WHERE $l[0]=? and $l[2]=? and $l[1]=?)");
  my $reservation = $dbh -> prepare("INSERT INTO Reservation($l[7],$l[10],$l[0],$l[3],$l[8],$l[9]) SELECT ?,?,?,?,?,? WHERE NOT EXISTS (SELECT 1 FROM Reservation WHERE $l[7]=? and $l[10]=? and $l[0]=? and $l[3]=? and $l[8]=? and $l[9]=?)");
  my $client = $dbh -> prepare("INSERT INTO Client($l[10],$l[11]) SELECT ?,? WHERE NOT EXISTS (SELECT 1 FROM Client WHERE $l[10]=? and $l[11]=?)");
  my $chambre = $dbh -> prepare("INSERT INTO Chambre($l[3],$l[0],$l[4],$l[5],$l[6]) SELECT ?,?,?,?,? WHERE NOT EXISTS (SELECT 1 FROM Chambre WHERE $l[3]=? and $l[0]=? and $l[4]=? and $l[5]=? and $l[6]=?)");;
  while(<CSV>) {
    chomp $_;
    my @lignes = split(';',$_);

    $client-> execute($lignes[10],$lignes[11],$lignes[10],$lignes[11]);
    $hotel-> execute($lignes[0],$lignes[2],$lignes[1],$lignes[0],$lignes[2],$lignes[1]);
    $chambre-> execute($lignes[3],$lignes[0],$lignes[4],$lignes[5],$lignes[6],$lignes[3],$lignes[0],$lignes[4],$lignes[5],$lignes[6]);
    $reservation-> execute($lignes[7],$lignes[10],$lignes[0],$lignes[3], $lignes[8],$lignes[9],$lignes[7],$lignes[10],$lignes[0],$lignes[3], $lignes[8],$lignes[9]);

  }
  close(CSV);
}

################################### MENU REQ ###################################

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
    print "Cette fonction n'existe pas !\n";
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
  my $maj2 = $dbh->prepare("UPDATE Hotel SET Gerant = ? WHERE Hotel = ?");
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

# Afficher le taux d'occupation le plus élevé


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
  print OUTPUT "<BR>\n";
  print OUTPUT "<BR>\n";
  print OUTPUT "<BR>\n";
  print OUTPUT "<div align=center> \n";
  print OUTPUT "<TABLE BORDER=4>\n";
  print OUTPUT "<CAPTION>Tableau sur le taux d'occupation des hotels </CAPTION>\n";
  my $hotels = $dbh->prepare("SELECT Hotel FROM Hotel");
  $hotels->execute();
  print OUTPUT "<TR> <TD> Hotel </TD><TD> Occupation </TD> </TR>\n";
  while (my $x = $hotels->fetchrow_array()) {
    my $taux = tauxOccupHotel();
    print OUTPUT "<TR> <TD> $x </TD><TD> $taux </TD> </TR>\n";
  }
  print OUTPUT "</TABLE>\n";
  print OUTPUT "</div>\n";
  print OUTPUT "</BODY>\n";
  print OUTPUT "</HTML>\n";
  close(OUTPUT);
}


###################################### MAIN ####################################
system('clear');
message();
menuTable();
