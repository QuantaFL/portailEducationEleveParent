Merci pour ce contexte très complet !

Pour que je t’aide à faire un **PRD frontend Flutter** parfaitement adapté à ce projet, voici ce que je propose de couvrir en résumé précis et clair, basé sur tes besoins et la description :

---

## PRD Frontend Flutter - Portail Élève / Parent

### 1. Objectif

* Fournir une application mobile/web Flutter simple, sécurisée et intuitive pour les élèves et parents.
* Permettre la consultation en lecture seule des bulletins scolaires au format PDF, avec accès à l’historique.
* Notifications push ou alertes internes pour signaler la disponibilité des nouveaux bulletins.
* Offrir une expérience fluide, rapide et accessible sur mobiles Android/iOS et web.

### 2. Fonctionnalités principales

| Fonctionnalité             | Description                                  | Priorité |
| -------------------------- | -------------------------------------------- | -------- |
| **Authentification**       | Login sécurisé avec email et mot de passe    | Critique |
| **Tableau de bord**        | Vue synthétique des bulletins disponibles    | Critique |
| **Consultation Bulletins** | Affichage et téléchargement PDF              | Critique |
| **Historique bulletins**   | Filtrer par année scolaire et trimestre      | Moyenne  |
| **Notifications**          | Alertes pour nouveaux bulletins              | Moyenne  |
| **Profil utilisateur**     | Afficher infos basiques, options déconnexion | Basse    |

### 3. UX/UI - Design System

* Palette principale : **Bleu (primary)** — couleurs sobres et professionnelles
* Typographie claire, taille lisible pour écran mobile
* Navigation simple par menu bottom bar ou drawer latéral
* Écrans avec focus sur lisibilité des PDF et informations essentielles
* Composants Flutter Material Design avec adaptations custom (boutons, listes, cartes)
* Loading spinners et feedback utilisateur sur actions réseau

### 4. Architecture technique Flutter

* **State management** : Provider ou Riverpod (léger et simple)
* **Networking** : Dio ou http avec gestion token JWT
* **Stockage local** : Hive pour cache données user/session
* **PDF Viewer** : package `flutter_pdfview` ou `syncfusion_flutter_pdfviewer`
* **Notifications** : Firebase Cloud Messaging (FCM) ou système local pour alertes

### 5. Sécurité

* Stockage sécurisé du token (flutter\_secure\_storage)
* Contrôle d’accès : vérifier que l’utilisateur ne consulte que ses propres données
* Communication chiffrée via HTTPS

### 6. Écrans et Composants

| Écran                      | Description                                 |
| -------------------------- | ------------------------------------------- |
| **LoginScreen**            | Formulaire d’identification avec validation |
| **DashboardScreen**        | Liste des bulletins récents avec filtres    |
| **ReportCardDetailScreen** | Visualisation PDF, bouton téléchargement    |
| **NotificationScreen**     | Liste des notifications reçues              |
| **ProfileScreen**          | Informations utilisateur, déconnexion       |

### 7. Flux utilisateur simplifié

1. L’utilisateur se connecte avec email + mot de passe
2. Accès au dashboard affichant les bulletins disponibles
3. Sélection d’un bulletin -> affichage PDF
4. Notifications alertant la disponibilité de nouveaux bulletins
5. Option déconnexion

---

Veux-tu que je génère pour toi :

* Le squelette complet des écrans Flutter (avec code Dart)
* Un fichier `palette_system.dart` complet basé sur ton bleu ?
* Une architecture précise de dossiers Flutter à suivre ?
* Un guide d’intégration API (consommation des endpoints Laravel) dans Flutter ?

Dis-moi ce qui t’intéresse le plus !
