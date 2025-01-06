DROP TRIGGER IF EXISTS `team_configurations_delete_log`;
DROP TRIGGER IF EXISTS `team_configurations_create_log`;
DROP TRIGGER IF EXISTS `team_configurations_update_log`;
DROP TRIGGER IF EXISTS `team_configurations_set_created_at`;
DROP TRIGGER IF EXISTS `team_configurations_set_updated_at`;

DROP PROCEDURE IF EXISTS `team_configurations_soft_delete`;
DROP PROCEDURE IF EXISTS `team_configurations_log_insert`;

DROP TABLE IF EXISTS `team_configurations_log`;
DROP TABLE IF EXISTS `team_configurations`;

-- ====================================================================================================
-- TEAMS DASHBOARDS
CREATE TABLE `team_dashboards`(
    `id_team_dashboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_teams` BIGINT NOT NULL,
    `dashboard` JSON NOT NULL,

    `created_at` TIMESTAMP NOT NULL,
    `created_by` BIGINT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `updated_by` BIGINT NULL,
    `deleted_at` TIMESTAMP NULL INVISIBLE,
    `deleted_by` BIGINT NULL INVISIBLE,

    PRIMARY KEY (`id_team_dashboards`),

    CONSTRAINT `team_dashboards_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `team_dashboards_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `team_dashboards_id_teams_foreign` 
        FOREIGN KEY(`id_teams`) 
        REFERENCES `teams`(`id_teams`)
        ON DELETE CASCADE,

    CONSTRAINT `team_dashboards_created_by_foreign` 
        FOREIGN KEY(`created_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `team_dashboards_updated_by_foreign` 
        FOREIGN KEY(`updated_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `team_dashboards_deleted_by_foreign` 
        FOREIGN KEY(`deleted_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL
);

ALTER TABLE `team_dashboards` ADD INDEX `team_dashboards_id_teams_index`(`id_teams`);
ALTER TABLE `team_dashboards` ADD INDEX `team_dashboards_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- TEAMS DASHBOARDS LOG
-- TODO records created after trigger
CREATE TABLE `team_dashboards_log`(
    `id_team_dashboards_log` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_team_dashboards` BIGINT NOT NULL,
    `id_teams` BIGINT NOT NULL,
    `id_users` BIGINT NOT NULL,

    `action` ENUM('create', 'update', 'delete') NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,

    PRIMARY KEY (`id_team_dashboards_log`),

    CONSTRAINT `team_dashboards_log_id_team_dashboards_foreign` 
        FOREIGN KEY(`id_team_dashboards`) 
        REFERENCES `team_dashboards`(`id_team_dashboards`)
        ON DELETE CASCADE,

    CONSTRAINT `team_dashboards_log_id_user_foreign` 
        FOREIGN KEY(`id_user`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE,

    CONSTRAINT `team_dashboards_id_users_foreign` 
        FOREIGN KEY(`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL
);

DELIMITER //
CREATE OR REPLACE PROCEDURE team_dashboards_log_insert(
    IN `v_id_team_dashboards` BIGINT UNSIGNED,
    IN `v_id_teams` BIGINT UNSIGNED,
    IN `v_id_users` BIGINT UNSIGNED,
    IN `v_action` ENUM('create', 'update', 'delete')
)
BEGIN
    INSERT INTO team_dashboards_log (
    	`id_team_dashboards`, `id_teams`, `id_users`, `action`, `timestamp`
    ) VALUES (
        `v_id_team_dashboards`, `v_id_teams`, `v_id_users`, `v_action`, NOW()
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE team_dashboards_soft_delete(
    IN `v_id_team_dashboards` BIGINT UNSIGNED,
    IN `v_deleted_by` BIGINT UNSIGNED
)
BEGIN 
    UPDATE `team_dashboards` 
        SET `deleted_at` = NOW(), `deleted_by` = `v_deleted_by`
        WHERE `id_team_dashboards` = `v_id_team_dashboards`;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `team_dashboards_set_created_at` 
    BEFORE INSERT ON `team_dashboards` FOR EACH ROW
    BEGIN
        SET NEW.created_at = NOW();
        SET NEW.updated_at = NOW();
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `team_dashboards_set_updated_at`
    BEFORE UPDATE ON `team_dashboards` FOR EACH ROW
    BEGIN
        IF NEW.deleted_at IS NULL THEN 
            SET NEW.updated_at = NOW();
        END IF; 
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `team_dashboards_create_log`
    AFTER INSERT ON `team_dashboards` FOR EACH ROW 
    BEGIN
        CALL team_dashboards_log_insert(
            NEW.id_team_dashboards,
            NEW.id_teams,
            NEW.id_users,
            'create'
        );
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `team_dashboards_update_log`
    AFTER UPDATE ON `team_dashboards` FOR EACH ROW 
    BEGIN    
        CALL team_dashboards_log_insert(
            NEW.id_team_dashboards,
            NEW.id_teams,
            NEW.id_users,
            'update'
        );
    END;      
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `team_dashboards_delete_log`
    AFTER DELETE ON `team_dashboards` FOR EACH ROW 
    BEGIN
        CALL team_dashboards_log_insert(
            OLD.id_team_dashboards,
            OLD.id_teams,
            OLD.id_users,
            'delete'
        );
    END;
//
DELIMITER ;