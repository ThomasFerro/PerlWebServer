#!/usr/bin/perl
use Socket;

socket (SERVEUR, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
$adresse = inet_aton ("localhost") || die ("inet_aton");
$adresse_complete = sockaddr_in("8080",$adresse) || die ("sockaddr_in");
connect (SERVEUR, $adresse_complete) || die ("connect");
SERVEUR->autoflush(1);

while (<STDIN>) {
    print SERVEUR $_;
    print scalar <SERVEUR>;
}

close (SERVEUR);