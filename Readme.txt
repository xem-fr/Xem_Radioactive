# Zone Radioactive - FiveM Script

## Description

Ce script ajoute des **zones radioactives dynamiques** sur votre serveur FiveM avec un syst�me de **vagues de zombies** et des **caisses de r�compenses** d�blocables. Les joueurs devront survivre aux vagues pour d�bloquer la caisse et r�cup�rer des objets pr�cieux.

## Fonctionnalit�s Principales

- ?? **Zones Radioactives Dynamiques** : Apparition al�atoire de zones radioactives avec effets visuels et d�g�ts.
- ????? **Syst�me de Vagues de Zombies** : 3 vagues de zombies g�n�r�es via `hrs_zombies_V2` avec des pauses de 10 secondes entre chaque vague.
- ?? **Caisse de R�compense D�bloquable** : La caisse reste verrouill�e jusqu'� la fin des vagues, puis se d�bloque pour offrir des r�compenses.
- ? **Suppression Automatique des Caisses** : Si la caisse n�est pas r�cup�r�e dans les 15 minutes, elle dispara�t automatiquement.
- ?? **Effets de Radiations et Protection** : Les joueurs subissent des d�g�ts s�ils ne portent pas de masque � gaz.
- ?? **Configuration Simplifi�e** : Ajustez les param�tres dans `config.lua` (nombre de zombies, d�g�ts des radiations, etc.).

## Installation

1. **T�l�chargez le script** et placez-le dans le dossier `resources` de votre serveur FiveM.
2. **Ajoutez** la ligne suivante dans votre `server.cfg` :
   ```
   ensure Xem_Radioactive
   ```
3. **Configurez** les param�tres dans `config.lua` selon vos besoins.

## D�pendances

- [**hrs\_zombies\_V2**](#) : N�cessaire pour la g�n�ration des zombies.
- **[ox\_lib](https://overextended.dev/)** : Utilis� pour les notifications et interactions.
- **[ox\_inventory](https://overextended.dev/)** : Pour la gestion des objets et des masques � gaz.

## Configuration

Le fichier `config.lua` vous permet de modifier :

- **D�g�ts des radiations**
- **Mod�les de caisses**
- **Nombre de zombies par vague**
- **Temps entre les vagues**
- **Dur�e avant suppression automatique des caisses**

---

**Cr�� par :** *Xem*
**Version :** 1.0.0

Profitez de l'exp�rience post-apocalyptique et bonne survie ! ?????????

