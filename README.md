# Gumboot Project

Espace collaboratif privé pour un groupe de quatre élèves : discussion, recherches, tâches, calendrier, vidéos/musiques, chorégraphie, votes, dictionnaire et documents.

## Déploiement GitHub Pages
1. Ouvrir **Settings → Pages** dans le dépôt.
2. Source : **Deploy from a branch**.
3. Branch : `main`, dossier : `/(root)`.
4. Enregistrer. Le site sera publié à l'adresse `https://open-lab-1.github.io/gumboot/`.

## Configuration Supabase
Le projet Supabase doit être créé dans une région européenne. Dans **SQL Editor**, exécuter `supabase/schema.sql`.

Dans `app.js`, renseigner :
- `SUPABASE_URL` : URL du projet.
- `SUPABASE_ANON_KEY` : clé publishable (ou anon legacy).

Ces valeurs publiques sont prévues pour le navigateur. Ne jamais mettre une clé `service_role` ou un secret dans GitHub.

## Ajouter les quatre membres — important
1. Dans **Authentication → Providers**, garder Email activé et désactiver les inscriptions publiques.
2. Dans **Authentication → Users**, créer/inviter uniquement les quatre comptes.
3. Pour chaque utilisateur créé, copier son UUID et exécuter dans SQL Editor :

```sql
insert into public.group_members(user_id, display_name, role)
values ('UUID_DE_L_UTILISATEUR', 'Prénom', 'Membre');
```

La fonction `is_group_member()` et les règles RLS limitent les données aux membres inscrits dans cette table. Le site public ne donne pas accès aux données sans connexion et appartenance au groupe.

## État actuel
L'interface est prête à être configurée. La connexion et les données collaboratives nécessitent les identifiants du projet Supabase et les quatre comptes autorisés. Le dossier partagé accepte actuellement des liens ; le téléversement de fichiers nécessite la création d'un bucket Storage privé et ses règles d'accès.
