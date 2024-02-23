# gallery

## Membres du groupe

- Yann Bauduin
- Adrien Dupont
- Hector Roussel

## Description de l'application

### Page Accueil

Cette page a pour objectif de lister des photos par ordre décroissant de popularité.

Chaque photo est agrandissable par un simple toucher dessus.

Des métadonnées dont le profil du photographe étaient prévues dans l'affichage en dessous de chaque photo agrandie, avec une fonction d'abonnement au photographe (cf. page Artistes).

Des filtres peuvent s'appliquer pour restreindre la recherche :

- chaîne de caractères dans les métadonnées de la photo
- couleur dominante

Le bouton avec un coeur était prévu pour ajouter une photo à la liste des favoris.

### Page Favoris

Cette page aurait dû lister les photos favorites stockées dans la mémoire de l'appareil avec un système de filtres comparable à celui de la page d'accueil.

### Page Artistes

Cette page était prévue pour lister les photographes auquel l'utilisateur est abonné.

Comme la page d'accueil, elle aurait nécessité une connexion Internet pour afficher des photos.

## Spécificités techniques

### De quoi est faite l'application ?

Le framework utilisé est Flutter, construit autour du langage Dart. Etant très axé sur l'UI, il permet de construire des interfaces d'applications rapidement et de façon intuitive.

### D'où viennent les photos ?

L'application est connectée à l'[API Unsplash](https://unsplash.com/documentation) servant également le site du même nom.

## Difficultés rencontrées

### Mise à jour de l'affichage des photos après recherche

La recherche par filtres n'a pas été de tout repos car il fallait passer à d'un _StatelessWidget_ à un _StatefulWidget_ et adapter le code déjà présent. Le vrai challenge a été de gérer le conflit entre cette feature et celle de la pagination. La première considérait les _\_fetchedPictures_ comme un futur alors que la seconde avait besoin de les traiter comme une simple _List_. Il a donc fallu recoder la pagination par-dessus la recherche par filtres.
