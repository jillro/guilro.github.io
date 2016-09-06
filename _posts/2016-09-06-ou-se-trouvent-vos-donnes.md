---
layout: postCommentit
title: Comptons les adresses emails
---

*From today, I will try to write more often on this blog, even very shorter posts. Some posts will still be in English, but I will switch to French for non technical posts.*

Prenons une petite organisation. Ce peut être une boutique e-commerce avec un fichier de 20 000 clients ayant accepté de recevoir des informations sur les produits. Ce peut-être une association de défense des droits des animaux, ou encore un théâtre souhaitant tenir ses spectateurs au courant des nouvelles pièces s'y jouant.

L'organisation possède une ou plusieurs listes d'adresse e-mail recensant un certain nombre de personnes, clients, ahdérents ou donateurs. Elle les utilise pour un certain nombre de choses. Parmi elle une est particulièrement importante : envoyer des informations au client.

La liste de l'outil de newsletter n'est pas la seule liste d'adresses e-mail ou de personnes dont dispose une organisation. On peut penser à des objets comme :
- les commandes dans la boutique
- les prélévements automatiques
- les paiments sur Paypal ou un portail de paiement direct en banque comme Systempay ou Paybox
- les interactions sur une page Facebook ou un compte Twitter, que l'on peut récolter via l'API (certains outils le font d'ailleurs très bien)

Or, derrière cette explosion de données, souvent, un seul indicateur est utilisé pour exprimer l'état du fichier. C'est le nombre d'adresses email valides. Plus précisemment, c'est le nombre d'adresse email valides dans l'outil d'envoi de newsletter. C'est souvent à raison : une informations email qui ne peut pas servir à contacter ou mieux contacfter quelqu'un est inutile. Si elle provient d'un autre outil, elle peut au mieux servir pour la fontionnalité de cet outil. Le fichier des commandes de la boutique sert à éditer automatiquement les confirmation de commande et les suivis d'expédition.

Dans la suite de ce post, on parlera des conséquences de la centralité de cet outil de newsletter !
