# PerlWebServer

## TODO

- [x] Configuration
- [ ] Requêtes GET
  - [x] Vérification de la requête
  - [x] Parcours des projections
  - [x] Traitement des requêtes vers le système de fichiers
  - [ ] Traitement des requêtes vers des programmes CGI
- [x] Journal des évènements
- [x] Traitement des requêtes en parallèle
- [ ] Gestion des erreurs
  - [x] 200 OK
  - [x] 400 Bad Request
  - [ ] 403 Forbidden
  - [x] 404 Not Found
  - [x] 405 Method Not Allowed
  - [x] 415 Unsupported Media Type
  - [x] 503 Service Unavailable
  - [x] 505 HTTP Version Not Supported
- [x] Utilisation

## Guide utilisateur rapide

### Configuration

Avant de lancer le serveur, veuillez ajuster les paramètres à vos besoins dans le fichier **commanche.conf** en suivant le modèle déja présent. Vous pourrez y modifier :
  - Le port d'écoute;
  - La page d'erreur par défaut;
  - Le fichier index dans les répertoires;
  - Le nombre de connexions simultanées maximum;
  - Le fichier de journal des évènements (attention aux droits sur le dossier contenant ce fichier);
  - Les routes de projection.
  
### Lancer le serveur

Pour lancer le serveur, il vous suffit d'éxecuter, depuis le répertoire contenant votre script et votre fichier de configuration, la commande `./commanche start`.

Vous pouvez à tout moment arrêter le serveur en utilisant la commande `./commanche stop`.

De plus, vous pouvez récupérer les informations concernant votre serveur en utilisant la commande `./commanche status`. Cette dernière vous affichera le PID du processus principal, le nombre de requêtes reçues et traitées ainsi que le nombre d'ouvriers actifs et leur PID.

### Tester le serveur

Vous pouvez tester votre serveur simplement avec un navigateur, sur la même machine que le serveur. Pour ce faire, entrez simplement l'url *localhost:8080*, 8080 étant le port et sera donc à changer si vous avez modifié le fichier de configuration.  


## Documentation technique

### Lancement du serveur

Au lancement du serveur, le script vérifie si ce dernier n'est pas déjà lancé grâce au fichier caché puis lancer le chargement des configuration. Il ne se lance pas si un des paramètres est incorrect. 

Après le chargement des configurations, le serveru créer le fichier de log.

La dernière étape dans le démarrage du serveur et de créer un fils qui s'occupera de la gestion des connexions afin de rendre la main sur le terminal.

### Gestion des connexions

Le fils initialise les paramètres et la socket du serveur puis rentre dans une boucle infinie qui accepte les connexions puis arrête les fils qui ont terminés leur travail.

Les connexions, donc, se font en écoutant sur le port spécifier et en acceptant les demande de connexions dans la limite de connexions maximum. Si cette limite est dépassée, le serveur envoie lui-même une erreur au client.

Sinon, le serveur créer un fils qui va s'occuper d'appeler la méthode de vérification de requête et envoyer l'erreur correspondante si besoin est. Enfin, si la requête est valide, il va parcourir les projections à la recherche du fichier demandé et enverra la page demandée si elle existe, ou une liste des éléments du dossier si la ressource demandée en est un. Le fils ferme ensuite la connexion au client et notifie le processus principal du succès de la requête avant de se fermer.

### Fermeture du serveur

La fermeture du serveur peut intérvenir n'importe quand et se contente de fermer le processus principal et supprimer le fichier caché.

### Affichage du status

La version actuelle de l'écriture du status du serveur utilise un fichier que le serveur rempli à chaque requête. Le processus d'écriture de status y récupère le PID du processus principal, le nombre de requêtes reçues et terminées et le nombre d'ouvrier actifs ainsi que leur PID.


Toutes les requêtes, les ouvertures du serveur et les fermetures de ce dernier sont consignées dans le journal d'événements.
