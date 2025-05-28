# 42-Inception

## What is Docker 🐳 ?

Docker est une plateforme open-source qui permet de créer, déployer et exécuter des applications dans des conteneurs.
Un conteneur est une unité légère, portable et isolée qui embarque tout le nécessaire pour faire fonctionner une application (code, librairies, dépendances, configuration…).

Contrairement aux machines virtuelles, les conteneurs partagent le noyau du système hôte, ce qui les rend plus rapides, plus légers et plus efficaces.
Docker permet ainsi de garantir que l'application se comporte de la même façon partout, quel que soit l'environnement (développement, test, production...).

## Few notions

### Liens entre les conteneurs

| `docker-compose.yml` | fichier central du projet |
|---|---|
| permet | de mettre en relation plusieurs conteneurs Docker, il permet donc de créer un réseau Docker |
| définit et configure | les services (conteneurs) à exécuter ensemble, leurs volumes, réseaux, et les variables d’environnement nécessaires |

### Espaces de stockage

| `volumes` |
|---|
| espaces de stockage partagés entre conteneurs pour persister les données au-delà du cycle de vie des conteneurs |

```
volumes:
  mariadb_data:
    driver: local
    driver_opts:
      type: none    # pas de système de fichiers spécial, utilisation du système hôte
      device: /home/${USER}/data/mariadb   # dossier sur la machine hôte lié au conteneur
      o: bind       # bind mount : partage direct du dossier hôte dans le conteneur
```


## Building the 42 Inception project

```
inception/
├── Makefile                    # Automatisation des tâches
└── srcs/
    ├── docker-compose.yml      # Orchestration des services
    ├── .env                    # Variables d'environnement
    └── requirements/
        ├── mariadb/            # Service de base de données
        │   ├── Dockerfile
        │   ├── conf/50-server.cnf
        │   └── tools/script.sh
        ├── nginx/              # Serveur web/proxy
        │   ├── Dockerfile
        │   └── conf/nginx.conf
        └── wordpress/          # Application PHP
            ├── Dockerfile
            └── tools/setup.sh
```

```
[Internet/Utilisateur]
         ↓ HTTPS (443)
  [Nginx Container]
         ↓ FastCGI (9000)
[WordPress Container]
         ↓ MySQL (3306)
  [MariaDB Container]
```

### Step 1 - Création d'une VM Debian via VirtualBox

- Ici on créé une VM pour réaliser des commandes sudo non accessibles depuis une session d'un post de l'école 42.
- Tips : utiliser un disque dur ou une clé USB suffiamment volumineuse pour y placer la VM.

### Step 2 - Installation des outils nécessaires

- Docker, Docker Compose, make, vim, zsh, oh-my-zsh, etc.
- Résolution de problèmes liés aux dépôts (ex. clé GPG pour VSCode).

### Step 3 - Création du repo Git & clonage dans la VM.

### Step 4 - Écriture du docker-compose.yml

- Services définis : mariadb, wordpress, nginx, etc.
- Gestion des volumes, des ports, des variables d’environnement.

### Step 5 - Création des Dockerfile et des scripts d’init pour chaque service

Ex : Service mariadb
- Initialisation de mariadb avec script Bash.
- Tests pour vérifier la base et les users via mysql.

### Step 6 - Tester

#### Mariadb

- dans le terminal `docker exec -it mariadb mysql -u root -p`
- rentrer le mot de passe pour root de mariadb
- `SHOW DATABASES;`
- `USE wordpress;`
- `SHOW TABLES;`
- `SELECT * FROM wp_users;`
- `USE mysql;`
- `SHOW TABLES;`
- `SELECT User, Host FROM user;`
- dans le terminal `mysql -h 127.0.0.1 -P 3306 -u root -p`
- entre le mdp de root mariadb => doit afficher une erreur ACCESS DENIED

#### Wordpress

- dans le terminal `make re`
- dans un navigateur `DOMAIN_NAME.42.fr`
- creer un nouveau commentaire
- dans un navigateur `DOMAIN_NAME.42.fr/wp-admin`
- se connecter en tant qu'admin
- approuver le commentaire
- dans le terminal `make re`
- dans un navigateur `DOMAIN_NAME.42.fr`
- voir si le commentaire et toujours present
- dans le terminal `telnet 127.0.0.1 9000` => doit echouer Connection refused

#### Nginx

- dans un navigateur `https://DOMAIN_NAME.42.fr` => OK
- dans un navigateur `http://DOMAIN_NAME.42.fr` => doit renvoyer vers https
- dans un navigateur `https://DOMAIN_NAME.42.fr/nimportequoi` => ERROR 404 Not Found
- dans un navigateur `https://localhost` => Connection Failed
- dans le terminal `docker exec -it nginx bash`
- `apt install nmap net-tools -y`
- `nmap -p 1-65535 localhost` => affiche les ports exposes
- `netstat -tln` => de meme
- puis CTRL + D
- dans le terminal `docker port nginx` => 443 uniquement

#### Depuis le terminal

- `docker images` => verifier qu'il y a 1 image/service
- `docker logs SERVICE_NAME` => verifier que les logs sont coherents et sans erreur
- `docker volume ls` => on devrait retrouver les 2 volumes de mariadb et wordpress
- `docker ps` => on devrait voir la liste de nos 3 dockers avec leur image etc...
- `docker network ls` => on devrait avoir notre nouveau reseau inception dans la liste