# Zone Radioactive - FiveM Script

## Description

Ce script ajoute des **zones radioactives dynamiques** sur votre serveur FiveM avec un système de **vagues de zombies** et des **caisses de récompenses** déblocables. Les joueurs devront survivre aux vagues pour débloquer la caisse et récupérer des objets précieux.

## Fonctionnalités Principales

- ?? **Zones Radioactives Dynamiques** : Apparition aléatoire de zones radioactives avec effets visuels et dégâts.
- ????? **Système de Vagues de Zombies** : 3 vagues de zombies générées via `hrs_zombies_V2` avec des pauses de 10 secondes entre chaque vague.
- ?? **Caisse de Récompense Débloquable** : La caisse reste verrouillée jusqu'à la fin des vagues, puis se débloque pour offrir des récompenses.
- ? **Suppression Automatique des Caisses** : Si la caisse n’est pas récupérée dans les 15 minutes, elle disparaît automatiquement.
- ?? **Effets de Radiations et Protection** : Les joueurs subissent des dégâts s’ils ne portent pas de masque à gaz.
- ?? **Configuration Simplifiée** : Ajustez les paramètres dans `config.lua` (nombre de zombies, dégâts des radiations, etc.).

## Installation

1. **Téléchargez le script** et placez-le dans le dossier `resources` de votre serveur FiveM.
2. **Ajoutez** la ligne suivante dans votre `server.cfg` :
   ```
   ensure Xem_Radioactive
   ```
3. **Configurez** les paramètres dans `config.lua` selon vos besoins.

## Dépendances

- [**hrs\_zombies\_V2**](#) : Nécessaire pour la génération des zombies.
- **[ox\_lib](https://overextended.dev/)** : Utilisé pour les notifications et interactions.
- **[ox\_inventory](https://overextended.dev/)** : Pour la gestion des objets et des masques à gaz.

## Configuration

Le fichier `config.lua` vous permet de modifier :

- **Dégâts des radiations**
- **Modèles de caisses**
- **Nombre de zombies par vague**
- **Temps entre les vagues**
- **Durée avant suppression automatique des caisses**

---

Profitez de l'expérience post-apocalyptique et bonne survie ! ?????????

