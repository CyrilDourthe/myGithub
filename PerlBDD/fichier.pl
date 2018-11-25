use DBI;

my $dbh = DBI->connect( "DBI:Pg:dbname=Base_Projet;host=localhost;port=5432",
    "postgres", "Allezbordeaux33", {
	RaiseError => 1,
})  || die "Connexion impossible";


$dbh->do("create table Hotel (Hotel varchar(40) primary key, Gerant varchar(40), Etoiles integer)");
$dbh->do("create table Reservation (NumResa integer primary key, DebutResa date, FinResa date, NumChambre integer, Hotel varchar(40), NomClient varchar(40)) ");
$dbh->do("create table Client (NomClient varchar(40) primary key, PhoneClient integer)");
$dbh->do("create table Chambre (NumChambre integer, Hotel varchar(40), TypeCouchage varchar(40), PrixBS integer, PrixHS integer, PRIMARY KEY (NumChambre,Hotel))");

sub fichierCSV () {
  open(FILE, "Hotels.csv");
  my $myline=<FILE>;
  my @l=split(';',$myline);
  my $sth1 = $dbh -> prepare("INSERT INTO Hotel($l[0],$l[2],$l[1]) SELECT ?,?,? WHERE NOT EXISTS (SELECT 1 FROM Hotel WHERE $l[0]=? and $l[2]=? and $l[1]=?)");
  my $sth2 = $dbh -> prepare("INSERT INTO Reservation($l[7],$l[10],$l[0],$l[3],$l[8],$l[9]) SELECT ?,?,?,?,?,? WHERE NOT EXISTS (SELECT 1 FROM Reservation WHERE $l[7]=? and $l[10]=? and $l[0]=? and $l[3]=? and $l[8]=? and $l[9]=?)");
  my $sth3 = $dbh -> prepare("INSERT INTO Client($l[10],$l[11]) SELECT ?,? WHERE NOT EXISTS (SELECT 1 FROM Client WHERE $l[10]=? and $l[11]=?)");
  my $sth4 = $dbh -> prepare("INSERT INTO Chambre($l[3],$l[0],$l[4],$l[5],$l[6]) SELECT ?,?,?,?,? WHERE NOT EXISTS (SELECT 1 FROM Chambre WHERE $l[3]=? and $l[0]=? and $l[4]=? and $l[5]=? and $l[6]=?)");;
  while(<FILE>) {
    chomp $_;
    my @line = split(';',$_);

    $sth3-> execute($line[10],$line[11],$line[10],$line[11]);
    $sth1-> execute($line[0],$line[2],$line[1],$line[0],$line[2],$line[1]);
    $sth4-> execute($line[3],$line[0],$line[4],$line[5],$line[6],$line[3],$line[0],$line[4],$line[5],$line[6]);
    $sth2-> execute($line[7],$line[10],$line[0],$line[3], $line[8],$line[9],$line[7],$line[10],$line[0],$line[3], $line[8],$line[9]);

  }
  close(FILE);
}
fichierCSV();
