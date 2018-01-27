-- Initialisation --
drop procedure if exists performance;
drop view if exists Encours_du_jour;

Drop table if exists Erreur;
Drop Trigger if exists before_insert_client;

-- Vue permettant d'afficher son encours du jour --
Create or replace view Encours_du_jour 
as Select Commande.id as 'Numéro de commande', Client.id as 'identifiant du client', Client.adresse as 'adresse du client', Client.postal_code as 'code postal du client',
group_concat(Article.nom,": ",Panier.quantity,"   " order by Article.nom) as 'Panier commandé', livreur_alloue as 'id du livreur en charge' 
From Commande
inner join Client on Client.id= Commande.client_alloue
inner join Panier on Commande.id = Panier.commande_id
right join Article on Panier.article_id=Article.id
where delivered=0 and Article.jour=current_date()
group by Commande.id
order by Commande.livreur_alloue;
