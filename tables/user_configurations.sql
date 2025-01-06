DROP TRIGGER IF EXISTS `user_configurations_delete_log`;
DROP TRIGGER IF EXISTS `user_configurations_create_log`;
DROP TRIGGER IF EXISTS `user_configurations_update_log`;
DROP TRIGGER IF EXISTS `user_configurations_set_created_at`;
DROP TRIGGER IF EXISTS `user_configurations_set_updated_at`;

DROP PROCEDURE IF EXISTS `user_configurations_soft_delete`;
DROP PROCEDURE IF EXISTS `user_configurations_log_insert`;

DROP TABLE IF EXISTS `user_configurations_log`;
DROP TABLE IF EXISTS `user_configurations`;


-- ====================================================================================================
-- USER CONFIGURATIONS
CREATE TABLE `user_configurations`(
    `id_user_configurations` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT UNSIGNED NOT NULL,
    `configuration` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL INVISIBLE,

    PRIMARY KEY (`id_user_configurations`),
    UNIQUE (`id_users`),

    CONSTRAINT `user_configurations_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `user_configurations_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `user_configurations_id_users_foreign` 
        FOREIGN KEY (`id_users`) 
        REFERENCES `users` (`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE `user_configurations` ADD INDEX `user_configurations_id_users_index`(`id_users`);
ALTER TABLE `user_configurations` ADD INDEX `user_configurations_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- USER CONFIGURATIONS LOG
-- TODO records created after trigger
CREATE TABLE `user_configurations_log`(
    `id_user_configurations_log` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_user_configurations` BIGINT UNSIGNED NOT NULL,
    `id_users` BIGINT UNSIGNED NOT NULL,
    `action` ENUM('create', 'update', 'delete') NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,

    PRIMARY KEY (`id_user_configurations_log`),

    CONSTRAINT `user_configurations_log_id_user_configurations_foreign` 
        FOREIGN KEY (`id_user_configurations`) 
        REFERENCES `user_configurations` (`id_user_configurations`)
        ON DELETE CASCADE,

    CONSTRAINT `user_configurations_log_id_user_foreign` 
        FOREIGN KEY (`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE
);


DELIMITER //
CREATE OR REPLACE PROCEDURE user_configurations_log_insert(
    IN `v_id_user_configurations` BIGINT UNSIGNED,
    IN `v_id_users` BIGINT UNSIGNED,
    IN `v_action` ENUM('create', 'update', 'delete')
)
BEGIN
    INSERT INTO user_configurations_log (
    	`id_user_configurations`, `id_users`, `action`, `timestamp`
    ) VALUES (
        `v_id_user_configurations`, `v_id_users`, `v_action`, NOW()
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE user_configurations_soft_delete(
    IN `v_id_user_configurations` BIGINT UNSIGNED
)
BEGIN 
    UPDATE `user_configurations` 
        SET `deleted_at` = NOW() 
        WHERE `id_user_configurations` = `v_id_user_configurations`;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_configurations_set_created_at` 
    BEFORE INSERT ON `user_configurations` FOR EACH ROW
    BEGIN
        SET NEW.created_at = NOW();
        SET NEW.updated_at = NOW();
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_configurations_set_updated_at`
    BEFORE UPDATE ON `user_configurations` FOR EACH ROW
    BEGIN
        IF NEW.deleted_at IS NULL THEN 
            SET NEW.updated_at = NOW();
        END IF; 
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_configurations_create_log`
    AFTER INSERT ON `user_configurations` FOR EACH ROW 
    BEGIN
        CALL user_configurations_log_insert(
            NEW.id_user_configurations,
            NEW.id_users,
            'create'
        );
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_configurations_update_log`
    AFTER UPDATE ON `user_configurations` FOR EACH ROW 
    BEGIN    
        CALL user_configurations_log_insert(
            NEW.id_user_configurations,
            NEW.id_users,
            'update'
        );
    END;      
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_configurations_delete_log`
    AFTER DELETE ON `user_configurations` FOR EACH ROW 
    BEGIN
        CALL user_configurations_log_insert(
            OLD.id_user_configurations,
            OLD.id_users,
            'delete'
        );
    END;
//
DELIMITER ;