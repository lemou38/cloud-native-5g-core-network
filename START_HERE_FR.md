# Guide de démarrage — français

**Projet :** Cloud-Native 5G Core Network — Telecom Engineering Lab.

Ce dépôt contient un projet de validation et d'analyse 5G avec scripts, tests et documentation. Le déploiement 5G réel repose sur un dépôt Open5GS/UERANSIM tiers, téléchargé par `scripts/bootstrap.sh`. Aucune performance expérimentale n'est présumée.

## Étapes

1. Utiliser Ubuntu (VMware recommandé).
2. Installer Docker Engine et Docker Compose depuis la documentation officielle.
3. Lancer `bash scripts/preflight.sh`.
4. Lancer `bash scripts/bootstrap.sh` (Internet requis).
5. Lire `docs/DEPLOYMENT.md`, puis le README du dépôt dans `vendor/docker_open5gs`.
6. Déployer le profil 5G SA + UERANSIM supporté et configurer les abonnés de test.
7. Vérifier l'enregistrement du terminal, la session PDU et la connectivité via le tunnel UE.
8. Produire les captures et résultats, puis remplir le rapport `docs/EXPERIMENTS.md`.

## Important pour le CV

Tant que les tests ne sont pas validés, indiquer « projet en cours ». Après validation, utiliser les formulations de `docs/CV_AND_PORTFOLIO.md` uniquement pour les réalisations démontrées.
