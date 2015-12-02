#!/usr/bin/perl

sub order {
	if(s/^set ([\w]+)/$1/g) {
		@order = split / /;
		@variables = ("port", "error", "index", "logfile", "clients");
		#Verification de la variable
		grep(/^$order[0]/, @variables) or die "Invalid variable : $!";
		$variables{$order[0]} = $order[1];
	}
	else {
		@order = split / /;
		if($order[0] eq "route") {
			#Regexp1 comme clef, Regexp2 comme valeur:
			$order[2] eq "to" or die "Invalid route : $!";
			$route{$order[1]} = $order[3];
		}
		else
		{	
			#Regexp1 comme clef, Regexp2 comme valeur:
			$order[2] eq "from" or die "Invalid route : $!";
			$exec{$order[1]} = $order[3];
		}
	}
}

#Variables:
%variables;
$variables{$port} = 8080;
$variables{$error} = "";
$variables{$index} = "";
$variables{$logfile} = "";
$variables{$clients} = 1;

#Routes statiques:
%route;

#Routes dynamiques:
%exec;

#Ouverture du fichier de config
open(CONFIG, "comanche.conf") or die "open: $!";

#Fixation des variables
while(<CONFIG>) {
	#Suppression des espaces
	s/^[ \t]+//g;
	#On ignore les commentaires
	if(!/^[#\t\n\ ]+/) {
		#Verification de l'ordre
		$order = /^set|^route|^exec/ or die "Invalid order: $!";
		order $order;
	}
}
print "\n";