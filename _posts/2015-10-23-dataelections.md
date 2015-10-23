---
layout: postCommentit
title: 'Visualisation de résultats électoraux : dataelections.fr'
category: french
---

*I make this post in french because it is about a project linked with
french election system.*

Je rends publique aujourd'hui sur [dataelections.fr](https://dataelections.fr/)
une application de visualisation des résultats électoraux. Elle permet la
visualisation par couleur politique et en comparant dans le temps les
différentes échéances. Elle est publiée sous licence
[AGPLv3](https://www.gnu.org/licenses/agpl.html), et le code source est
disponible sur [Github](https://github.com/guilro/dataelections.fr). Elle a été
créée il y a plusieurs mois dans un autre contexte, mais je la ressors
aujourd'hui de manière publique.

J'y ai importé les résultats des premiers tours depuis les élections européennes
de 2009, jusqu'à celles de 2014. Pour les départementales, l'application n'avait
pas été conçue pour gérer les cantons, mais cela devrait pouvoir se faire à
l'avenir. Les données proviennent de [data.gouv.fr](https://data.gouv.fr), les
étiquettes politiques sont donc celles fournies par le Ministère de l'Intérieur.
Le regroupement de ces étiquettes est complètement arbitraire de ma part, mais
le choix de celui-ci fait partie des fonctionnalités à implémenter. Il en va
de même pour la gestion des seconds tours.

Pour les personnes souhaitant juste lire les résultats, il suffit de se rendre
sur le site et de taper le nom d'une commune, d'un département, d'une région,
d'une circonscription européenne ou même simplement "France".

Si vous souhaitez l'installer sur vos serveurs, les instructions se trouvent
dans le [README](). <small>(Mais plutôt que de louer un serveur, vous pouvez
aussi utiliser [dataelections.fr](https://dataelections.fr) et utiliser l'argent
ainsi économisé pour me faire un don et m'aider à payer les miens.)</small>

Enfin si vous souhaitez contribuer, rendez-vous sur le dépôt
[Github](https://github.com/guilro/dataelections.fr)&nbsp;! Toutes les
contributions sont les bienvenues&nbsp;: import de datasets, ajout des
fonctionnalités citées plus haut, optimisation...

Je termine par quelques remarques techniques destinées aux développeurs et
développeuses qui lisent ce post.

Les performances sur la compilation des données sur de larges territoires sont
mauvaises. J'ai commencé ce projet à l'époque où je découvrais le Domain Driven
Design et notamment le travail de [Mathias Verraes](http://verraes.net/) et
[William Durand](http://williamdurand.fr/2013/11/13/ddd-with-symfony2-basic-
persistence-and-testing/). J'ai donc fait des choix de conceptions dans ce sens,
notamment de découpler le domaine et la couche de persistance des données. Il
est en théorie possible d'implémenter la persistance sur autre chose que l'ORM
Doctrine. Mais pour cette raison, rien n'a été pensé *a priori* dans
l'architecture de la base SQL pour rendre les requêtes moins lourdes.

L'application compense donc au maximum, à la fois par de la mise en cache
agressive au niveau des contrôleurs, et par des systèmes de prédiction au niveau
des implémentations SQL des repository. Par ailleurs, même si sur
[dataelections.fr](https://dataelections.fr), les données sont enregistrées au
niveau communal, le système supporte les données à différentes échelons
territoriaux. Par exemple, si les données communales d'un département sont
incomplètes, mais qu'elles sont remplies au niveau départemental, le système
peut donner le score national correct en compilant cette donnée départementale
avec les données communales du reste de la France.

Enfin, c'est le seul projet que j'ai jamais fait où je n'ai pas nommé mes
variables et méthodes intégralement en anglais. Malgré le découplage, les
contrôleurs manipulent des variables qui représentent des concepts spécifiques
au contexte français. Je pense qu'il aurait été encore pire de faire coexister
des ```CirconscriptionEuropeenne``` et des ```ElectionResult```, par conséquent le
français a pris le dessus. L'application n'a pas été pensée pour être exportée.
