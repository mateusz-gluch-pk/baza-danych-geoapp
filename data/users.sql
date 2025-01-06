INSERT INTO `users` 
	(`login`, `password_sha256`, `email`, `name`, `surname`, `language_code`, `account_type`) 
VALUES 
	('mateusz.gluch', SHA1('1234'), 'mateusz.gluch@student.pk.edu.pl', 'Mateusz', 'Gluch', 'PL', 'free');