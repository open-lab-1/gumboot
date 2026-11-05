# Gumboot Project

Espace collaboratif privé pour un groupe de quatre élèves : discussion, recherches, tâches, calendrier, vidéos/musiques, chorégraphie, votes, dictionnaire et documents.

## Déploiement GitHub Pages
1. Ouvrir **Settings → Pages** dans le dépôt.
2. Source : **Deploy from a branch**.
3. Branch : `main`, dossier : `/(root)`.
4. Enregistrer. Le site sera publié à l'adresse `https://open-lab-1.github.io/gumboot/`.

## Configuration Supabase
Le projet Supabase Gumboot Project est hébergé dans la région européenne. Le schéma de base de données se trouve dans `supabase/schema.sql`.

L'application utilise l'URL du projet et sa clé publishable dans `app.js`. Ces deux valeurs sont prévues pour le navigateur. Ne jamais mettre une clé `service_role` ou un secret dans GitHub.

## Comptes privés par nom d'utilisateur
Le site affiche un champ nom d'utilisateur. Pour se connecter, l'application transforme automatiquement l'identifiant en adresse technique `identifiant@gumboot.invalid`. Les membres n'ont donc pas besoin de vraie adresse e-mail.

1. Dans Supabase, ouvrir **Authentication → Sign In / Providers → Email** et désactiver **Confirm email**.
2. Désactiver les inscriptions publiques (Allow new users to sign up) : seuls les comptes créés par l'administrateur doivent exister.
3. Dans **Authentication → Users**, créer manuellement chacun des quatre utilisateurs avec une adresse technique, par exemple `lea@gumboot.invalid`, et le mot de passe choisi. Si l'interface propose **Auto Confirm User**, l'activer.
4. Pour chaque utilisateur, copier son UUID et exécuter dans SQL Editor :

```sql
insert into public.group_members(user_id, display_name, role)
values ('UUID_DE_L_UTILISATEUR', 'Prénom affiché', 'Membre');
```

Identifiants autorisés : 3 à 24 caractères, minuscules non accentuées, chiffres, point, tiret ou underscore. Le mot de passe est celui créé dans Supabase. Transmettre les identifiants individuellement et éviter un mot de passe commun.

La fonction `private.is_group_member()` et les règles RLS limitent les données aux comptes présents dans `group_members`. La professeure n'a pas de compte dans cet espace.

## État actuel
Les pages principales, la connexion, la discussion temps réel et les premières opérations de lecture/ajout sont en place. Certaines fonctions restent à compléter (édition/suppression, votes plus complets, calendrier avancé et véritable téléversement de fichiers). Le dossier partagé accepte actuellement des liens ; le téléversement nécessitera un bucket Storage privé et ses règles d'accès.
