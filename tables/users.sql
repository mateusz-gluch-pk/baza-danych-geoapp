DROP TRIGGER IF EXISTS `users_set_created_at`;
DROP TRIGGER IF EXISTS `users_set_updated_at`;

DROP TABLE IF EXISTS `user_logins`;
DROP TABLE IF EXISTS `users`;

-- ====================================================================================================
-- USERS
-- TODO jeśli ustawiamy deleted at - wykonujemy procedurę soft delete na cofigurations, dashboards, trainings i usuwamy role usera
CREATE TABLE IF NOT EXISTS `users`(
    `id_users` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `login` VARCHAR(255) NOT NULL,
    `password_sha256` VARCHAR(50) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `surname` VARCHAR(255) NOT NULL,
    `language_code` ENUM('EN', 'PL') NOT NULL,
    `account_type` ENUM('free', 'premium') NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL INVISIBLE,

    PRIMARY KEY(`id_users`),

    CONSTRAINT `users_email_valid`
        CHECK (`email` REGEXP '^[[:alnum:]._%-\+]+@[[:alnum:].-]+[.][[:alnum:]]{2,4}$'),

    CONSTRAINT `users_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `users_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL))
);

ALTER TABLE `users` ADD INDEX `users_account_type_index`(`account_type`);
ALTER TABLE `users` ADD INDEX `users_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- USER LOGINS
CREATE TABLE IF NOT EXISTS `user_logins`(
    `id_user_logins` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT UNSIGNED NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,

    PRIMARY KEY(`id_user_logins`),

    CONSTRAINT `user_logins_id_users_foreign` 
    	FOREIGN KEY (`id_users`) 
        REFERENCES `users` (`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE `user_logins` ADD INDEX `user_logins_id_users_index`(`id_users`);
ALTER TABLE `user_logins` ADD INDEX `user_logins_timestamp_index`(`timestamp`);

DELIMITER //
CREATE OR REPLACE TRIGGER `users_set_created_at` 
    BEFORE INSERT ON `users` FOR EACH ROW
    BEGIN
        SET NEW.created_at = NOW();
        SET NEW.updated_at = NOW();
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `users_set_updated_at`
    BEFORE UPDATE ON `users` FOR EACH ROW
    BEGIN
        IF NEW.deleted_at IS NULL THEN 
            SET NEW.updated_at = NOW();
        END IF; 
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE user_soft_delete (
    IN 'v_id_users' BIGINT UNSIGNED
)
BEGIN
    UPDATE 'users'
    SET 'deleted_at' = NOW()
    WHERE 'id_users' = 'v_id_users';

    UPDATE 'user_dashboards'
    SET 'deleted_at' = NOW()
    WHERE 'id_users' = 'v_id_users';

    UPDATE 'user_configurations'
    SET 'deleted_at' = NOW()
    WHERE 'id_users' = 'v_id_users';

    UPDATE 'trainings'
    SET 'deleted_at' = NOW()
    WHERE 'id_users' = 'v_id_users';
    
    UPDATE 'user_team_roles'
    SET 'deleted_at' = NOW()
    WHERE 'id_users' = 'v_id_users';
END;
//
DELIMITER ;