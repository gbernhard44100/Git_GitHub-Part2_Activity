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

-- Procédure pour coannaître le taux de livraison dans les temps --
DELIMITER |
Create procedure performance (in j date, out p_resultat decimal(4,2))
begin
-- calcul le nombre de livraison en retard (temps supérieur à 20 minutes) pour un jour donné --
Set @retard_livraison:=(
Select count(distinct Commande_id) from Commande inner join Panier on Commande.id=Panier.commande_id
left join article on panier.article_id=article.id
where temps>20 and Commande.temps is not null and Article.jour=j);

-- calcul le nombre total de livraison sur un jour donné --
Set @nb_livraison:=(
Select count(distinct Commande_id) from Commande inner join Panier on Commande.id=Panier.commande_id
left join Article on Panier.article_id=Article.id
where Commande.temps is not null and Article.jour=j);

-- calcul du taux de livraison dans les temps en pourcent --
Set @taux_livraison:=100-@retard_livraison/@nb_livraison*100;
select @taux_livraison into p_resultat;
end |
DELIMITER ;

