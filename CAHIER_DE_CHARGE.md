# Cahier des Charges - Application Mzra3ti

## 1. Présentation du Projet

### 1.1 Contexte
**Mzra3ti** est une application mobile de gestion agricole destinée aux agriculteurs marocains. L'application permet de gérer tous les aspects d'une exploitation agricole de manière simple et efficace, même hors ligne.

### 1.2 Objectifs
- Faciliter la gestion quotidienne des exploitations agricoles
- Offrir un outil multilingue adapté au contexte marocain (Arabe, Français, Anglais)
- Permettre le suivi financier et la planification agricole
- Fournir des informations météorologiques en temps réel
- Fonctionner en mode hors ligne pour les zones rurales

## 2. Spécifications Fonctionnelles

### 2.1 Gestion des Dépenses
**Fonctionnalités :**
- Ajout/modification/suppression des dépenses
- Catégorisation des dépenses (Engrais, Pesticides, Main-d'œuvre, Carburant, etc.)
- Historique complet des transactions
- Statistiques et graphiques des dépenses
- Export des données en PDF

**Données enregistrées :**
- Date de la dépense
- Montant en MAD (Dirham marocain)
- Catégorie
- Description détaillée
- Méthode de paiement

### 2.2 Gestion des Ventes
**Fonctionnalités :**
- Enregistrement des ventes de produits agricoles
- Gestion des clients
- Historique des transactions
- Calcul automatique des bénéfices
- Génération de factures PDF

**Données enregistrées :**
- Date de vente
- Produit vendu
- Quantité
- Prix unitaire et total
- Informations client
- Mode de paiement

### 2.3 Gestion de l'Irrigation
**Fonctionnalités :**
- Planification des sessions d'irrigation
- Historique d'irrigation
- Calcul de la consommation d'eau
- Alertes et rappels d'irrigation
- Conseils basés sur la météo

**Données enregistrées :**
- Date et heure d'irrigation
- Zone irriguée
- Durée d'irrigation
- Volume d'eau utilisé
- Type d'irrigation (goutte-à-goutte, aspersion, etc.)

### 2.4 Gestion des Récoltes
**Fonctionnalités :**
- Enregistrement des récoltes
- Suivi des rendements
- Historique par culture
- Statistiques de production
- Prévisions basées sur les données historiques

**Données enregistrées :**
- Date de récolte
- Type de culture
- Quantité récoltée
- Qualité du produit
- Surface récoltée

### 2.5 Calendrier Agricole
**Fonctionnalités :**
- Calendrier personnalisé par culture
- Rappels des tâches agricoles
- Planning des semis et récoltes
- Rotation des cultures
- Conseils saisonniers

**Cultures supportées :**
- Tomates
- Pommes de terre
- Blé
- Orge
- Maïs
- Pastèque
- Melon
- Fraises
- Agrumes
- Olives

### 2.6 Carte des Terres
**Fonctionnalités :**
- Visualisation GPS des parcelles
- Délimitation des zones agricoles
- Calcul de surface
- Informations par parcelle
- Intégration Google Maps

### 2.7 Météo et Conseils
**Fonctionnalités :**
- Prévisions météo sur 7 jours
- Géolocalisation automatique
- Températures min/max
- Conditions météorologiques
- Conseils d'irrigation basés sur la météo
- Alertes météo importantes

**API utilisée :**
- OpenWeatherMap API
- Géolocalisation en temps réel

### 2.8 Notifications
**Fonctionnalités :**
- Alertes d'irrigation
- Rappels de tâches agricoles
- Notifications météo
- Alertes de dépenses importantes
- Notifications personnalisables

### 2.9 Analyses Financières
**Fonctionnalités :**
- Tableau de bord financier
- Graphiques des revenus et dépenses
- Calcul des profits
- Tendances sur 7 jours
- Comparaison mensuelle/annuelle
- Ratios de rentabilité

### 2.10 Paramètres de la Ferme
**Fonctionnalités :**
- Informations de base de l'exploitation
- Surface totale en hectares
- Localisation (ville)
- Type de sol
- Types de cultures pratiquées
- Informations du gestionnaire
- Coordonnées de contact

### 2.11 Assistant Vocal (Accessibilité)
**Fonctionnalités :**
- Lecture vocale de tous les textes (Text-to-Speech)
- Saisie vocale dans les formulaires (Speech-to-Text)
- Annonces automatiques lors de la navigation
- Descriptions vocales des boutons et actions
- Guidage vocal pour les opérations
- Support pour utilisateurs analphabètes
- Réglages personnalisables (vitesse, volume, tonalité)

**Langues supportées pour la voix :**
- Arabe marocain (ar-MA)
- Français (fr-FR)
- Anglais (en-US)

**Commandes vocales :**
- Saisie de nombres (montants, quantités)
- Saisie de texte (descriptions, notes)
- Questions oui/non
- Navigation par commandes vocales

**Paramètres vocaux :**
- Vitesse de parole (0-100%)
- Volume (0-100%)
- Tonalité (0.5-2.0)
- Activation/désactivation globale

## 3. Spécifications Techniques

### 3.1 Architecture
**Framework :** Flutter 3.x
**Langage :** Dart
**Type :** Application mobile hybride (iOS, Android, Web)

### 3.2 Base de Données
**Type :** Local (hors ligne)
**Technologie :** SharedPreferences pour données simples
**Format :** JSON pour données structurées
**Persistance :** Locale avec possibilité d'export

### 3.3 Dépendances Principales
```yaml
- flutter_localizations (Multilingue)
- intl (Internationalisation)
- provider (Gestion d'état)
- shared_preferences (Stockage local)
- file_picker (Sélection de fichiers)
- pdf (Génération PDF)
- printing (Impression documents)
- share_plus (Partage de fichiers)
- path_provider (Accès au système de fichiers)
- url_launcher (Ouverture de liens)
- google_maps_flutter (Cartographie)
- geolocator (Géolocalisation)
- geocoding (Conversion coordonnées)
- http (Requêtes API)
- flutter_tts (Text-to-Speech)
- speech_to_text (Speech-to-Text)
```

### 3.4 Localisation
**Langues supportées :**
- Arabe (ar) - Langue principale
- Français (fr)
- Anglais (en)

**Format :** ARB (Application Resource Bundle)
**Nombre de clés de traduction :** 80+ clés

### 3.5 Thèmes
**Modes disponibles :**
- Mode clair
- Mode sombre

**Couleurs principales :**
- Dégradés verts (thème agricole)
- Dégradés bleus (sections spécifiques)
- Design moderne et épuré

### 3.6 Services Externes
**API Météo :**
- Provider : OpenWeatherMap
- Type : REST API
- Format : JSON
- Fréquence : Temps réel

**Cartographie :**
- Provider : Google Maps
- Intégration : google_maps_flutter
- Fonctionnalités : Marqueurs, polygones, géolocalisation

## 4. Interface Utilisateur

### 4.1 Principes de Design
- Interface intuitive et épurée
- Navigation par onglets en bas
- Menu latéral (drawer) pour accès rapide
- Boutons d'action flottants (FAB)
- Cartes avec ombres et dégradés
- Animations fluides et transitions
- Icônes personnalisées

### 4.2 Navigation Principale
**Écrans principaux :**
1. Tableau de bord (Home)
2. Dépenses
3. Ventes
4. Irrigation
5. Récoltes
6. Calendrier agricole
7. Carte des terres
8. Météo
9. Notifications
10. Analyses
11. Paramètres

### 4.3 Composants Réutilisables
- Dashboard Cards (cartes de statistiques)
- Premium Cards (cartes avec effets)
- Formulaires standardisés
- Listes avec filtres
- Graphiques interactifs
- Modals et bottom sheets

## 5. Exigences Non-Fonctionnelles

### 5.1 Performance
- Démarrage de l'application : < 2 secondes
- Navigation entre écrans : < 300ms
- Chargement des données : < 1 seconde
- Génération PDF : < 3 secondes
- Réponse API météo : < 5 secondes

### 5.2 Compatibilité
**Plateformes :**
- Android 5.0+ (API 21+)
- iOS 11.0+
- Web (Chrome, Firefox, Safari, Edge)

**Résolutions :**
- Smartphones : 360x640 à 1440x3200
- Tablettes : Support responsive
- Web : Design adaptatif

### 5.3 Sécurité
- Données stockées localement
- Pas de transmission de données sensibles
- Validation des entrées utilisateur
- Protection contre les injections
- API keys sécurisées

### 5.4 Accessibilité
- Support RTL (Right-to-Left) pour l'arabe
- Textes lisibles (tailles adaptées)
- Contrastes respectés (WCAG)
- Tooltips et labels explicites
- Navigation clavier (web)
- **Assistant vocal complet (TTS/STT)**
- **Support pour utilisateurs analphabètes**
- **Commandes vocales en 3 langues**
- **Descriptions audio de toutes les actions**
- **Guidage vocal dans les formulaires**

### 5.5 Maintenance
- Code modulaire et réutilisable
- Architecture propre (Clean Architecture)
- Documentation inline
- Gestion d'erreurs robuste
- Logs pour débogage

## 6. Fonctionnalités Futures (Roadmap)

### Phase 2
- [ ] Synchronisation cloud
- [ ] Mode collaboratif (plusieurs utilisateurs)
- [ ] Export Excel/CSV
- [ ] Intégration caméra (photos cultures)
- [ ] Reconnaissance de maladies des plantes (IA)

### Phase 3
- [ ] Marketplace agricole
- [ ] Forum communautaire
- [ ] Conseils d'experts
- [ ] Prévisions de rendement (ML)
- [ ] Intégration IoT (capteurs)

### Phase 4
- [ ] Application desktop
- [ ] API publique
- [ ] Versions premium
- [ ] Intégrations bancaires
- [ ] Traçabilité blockchain

## 7. Livrables

### 7.1 Application
- ✅ Application Flutter fonctionnelle
- ✅ Version Web déployable
- ✅ Documentation technique
- ✅ Code source sur GitHub

### 7.2 Documentation
- ✅ Cahier des charges
- ✅ Guide utilisateur (à venir)
- ✅ Documentation API (à venir)
- ✅ Guide de déploiement (à venir)

### 7.3 Ressources
- ✅ Fichiers ARB de traduction
- ✅ Assets (icônes, images)
- ✅ Configurations (Android, iOS, Web)
- ✅ Fichiers de style (AppStyles)

## 8. Contraintes et Limites

### 8.1 Contraintes Techniques
- Doit fonctionner hors ligne
- Taille de l'APK < 50 MB
- Consommation batterie optimisée
- Utilisation mémoire < 200 MB

### 8.2 Contraintes Métier
- Contexte agricole marocain
- Monnaie : Dirham marocain (MAD)
- Unités métriques (hectares, litres, kg)
- Cultures adaptées au Maroc

### 8.3 Limites Actuelles
- Pas de synchronisation cloud
- Pas de backup automatique
- API météo requiert connexion internet
- Pas de mode multi-exploitation
- Pas d'authentification utilisateur

## 9. Tests et Qualité

### 9.1 Types de Tests
- Tests unitaires (logique métier)
- Tests d'intégration (services)
- Tests d'interface (widgets)
- Tests de performance
- Tests de compatibilité

### 9.2 Critères de Qualité
- 0 erreurs de compilation
- Navigation fluide
- Traductions complètes
- Design cohérent
- Expérience utilisateur optimale

## 10. Déploiement

### 10.1 Environnements
- **Développement :** Local (flutter run)
- **Test :** Navigateurs web + émulateurs
- **Production :** Stores (Play Store, App Store) + Web hosting

### 10.2 Configuration
- API Keys à configurer
- Signatures Android/iOS
- Configurations de build
- Assets et ressources

## 11. Support et Maintenance

### 11.1 Bugs et Issues
- Suivi via GitHub Issues
- Corrections de bugs prioritaires
- Mises à jour régulières

### 11.2 Évolutions
- Ajout de nouvelles cultures
- Nouvelles traductions
- Amélioration UI/UX
- Optimisations performances

## 12. Contacts et Ressources

### 12.1 Dépôt Git
**Repository :** https://github.com/ZakariaOualmam/Mzra3ti.git
**Branche principale :** main

### 12.2 Technologies Clés
- **Flutter :** https://flutter.dev
- **Dart :** https://dart.dev
- **OpenWeatherMap :** https://openweathermap.org
- **Google Maps :** https://developers.google.com/maps

---

**Version du document :** 1.0  
**Date de création :** 20 Janvier 2026  
**Dernière mise à jour :** 20 Janvier 2026  
**Statut du projet :** En production (Phase 1 complétée)
