-- Initialisation --
drop procedure if exists performance;
drop view if exists Encours_du_jour;

Drop table if exists Erreur;
Drop Trigger if exists before_insert_client;
