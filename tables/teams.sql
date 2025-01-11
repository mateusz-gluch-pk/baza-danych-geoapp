DROP TRIGGER IF EXISTS `teams_set_created_at`;
DROP TRIGGER IF EXISTS `teams_set_updated_at`;
DROP TRIGGER IF EXISTS `user_team_roles_set_created_at`;
DROP TRIGGER IF EXISTS `user_team_roles_set_updated_at`;

DROP PROCEDURE IF EXISTS `teams_soft_delete`;
DROP PROCEDURE IF EXISTS `user_team_roles_soft_delete`;

DROP TABLE IF EXISTS `user_team_roles`;
DROP TABLE IF EXISTS `teams`;
DROP TABLE IF EXISTS `roles`;

-- ====================================================================================================
-- TEAMS 
-- TODO: WYSZUKIWANIE PO NAZWIE TEAMU - INDEX FULL TEXT
-- TODO: procedura soft delete 
CREATE TABLE `teams`(
    `id_teams` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,

    `created_at` TIMESTAMP NOT NULL,
    `created_by` BIGINT UNSIGNED NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `updated_by` BIGINT UNSIGNED NULL,
    `deleted_at` TIMESTAMP NULL INVISIBLE,
    `deleted_by` BIGINT UNSIGNED NULL INVISIBLE,

    PRIMARY KEY (`id_teams`),

    CONSTRAINT `teams_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `teams_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `teams_created_by_foreign` 
        FOREIGN KEY(`created_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `teams_updated_by_foreign` 
        FOREIGN KEY(`updated_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `teams_deleted_by_foreign` 
        FOREIGN KEY(`deleted_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL
);

ALTER TABLE `teams` ADD INDEX `teams_deleted_at_index`(`deleted_at`);
ALTER TABLE 'teams' ADD FULLTEXT INDEX 'teams_name_fulltext_index'('name');

-- ====================================================================================================
-- ROLES
CREATE TABLE `roles`(
    `id_roles` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,

	 PRIMARY KEY (`id_roles`)    
);

-- ====================================================================================================
-- USER TEAM ROLES
-- TODO INDEX DELETED AT 
CREATE TABLE `user_team_roles`(
    `id_user_team_roles` BIGINT NOT NULL,
    `id_roles` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_teams` BIGINT UNSIGNED NOT NULL,
    `id_users` BIGINT UNSIGNED NOT NULL,

    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL INVISIBLE,

    PRIMARY KEY (`id_user_team_roles`),
    UNIQUE INDEX (`id_teams`, `id_users`),

    CONSTRAINT `user_team_roles_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `user_team_roles_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `user_team_roles_id_roles_foreign` 
        FOREIGN KEY(`id_roles`) 
        REFERENCES `roles`(`id_roles`),

    CONSTRAINT `user_team_roles_id_teams_foreign` 
        FOREIGN KEY(`id_teams`) 
        REFERENCES `teams`(`id_teams`)
        ON DELETE CASCADE,
    
    CONSTRAINT `user_team_roles_id_users_foreign` 
        FOREIGN KEY(`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE 'user_team_roles' ADD INDEX 'user_team_roles_deleted_at_index'('deleted_at');

DELIMITER //
CREATE OR REPLACE PROCEDURE teams_soft_delete(
    IN `v_id_teams` BIGINT UNSIGNED,
    IN `v_deleted_by` BIGINT UNSIGNED
)
BEGIN 
    UPDATE `teams` 
        SET `deleted_at` = NOW(), `deleted_by` = `v_deleted_by`
        WHERE `id_teams` = `v_id_teams`;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `teams_set_created_at` 
    BEFORE INSERT ON `teams` FOR EACH ROW
    BEGIN
        SET NEW.created_at = NOW();
        SET NEW.updated_at = NOW();
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `teams_set_updated_at`
    BEFORE UPDATE ON `teams` FOR EACH ROW
    BEGIN
        IF NEW.deleted_at IS NULL THEN 
            SET NEW.updated_at = NOW();
        END IF; 
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE user_team_roles_soft_delete(
    IN `v_id_user_team_roles` BIGINT UNSIGNED
)
BEGIN 
    UPDATE `user_team_roles` 
        SET `deleted_at` = NOW() 
        WHERE `id_user_team_roles` = `v_id_user_team_roles`;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_team_roles_set_created_at` 
    BEFORE INSERT ON `user_team_roles` FOR EACH ROW
    BEGIN
        SET NEW.created_at = NOW();
        SET NEW.updated_at = NOW();
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_team_roles_set_updated_at`
    BEFORE UPDATE ON `user_team_roles` FOR EACH ROW
    BEGIN
        IF NEW.deleted_at IS NULL THEN 
            SET NEW.updated_at = NOW();
        END IF; 
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE team_soft_delete (
    IN 'v_id_teams' BIGINT UNSIGNED,
    IN 'v_id_users' BIGINT UNSIGED
)
BEGIN
    UPDATE 'teams'
    SET 'deleted_at' = NOW()
    WHERE 'id_teams' = 'v_id_teams';

    UPDATE 'team_dashboards'
    SET 'deleted_at' = NOW(), 'deleted_by' = 'v_id_users'
    WHERE 'id_teams' = 'v_id_team's;

    UPDATE 'user_team_roles'
    SET 'deleted_at' = NOW()
    WHERE 'id_teams' = 'v_id_teams';

    UPDATE 'leaderboards'
    SET 'deleted_at' = NOW()
    WHERE 'id_teams' = 'v_id_teams'
END;
//
DELIMITER ;