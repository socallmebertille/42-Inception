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

### Step 5 - Création de scripts d’init pour les services

- Initialisation de mariadb avec script Bash.
- Tests pour vérifier la base et les users via mysql.

### Step 6 - Configuration de Nginx avec HTTPS (certificat autosigné).

...... En cours.