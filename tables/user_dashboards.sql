-- ====================================================================================================
-- USER DASHBOARDS
CREATE TABLE `user_dashboards`(
    `id_user_dashboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT NOT NULL,
    `dashboard` JSON NOT NULL,
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    `deleted_at` TIMESTAMP NULL INVISIBLE,

    PRIMARY KEY (`id_user_dashboards`),

    CONSTRAINT `user_dashboards_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `user_dashboards_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `user_dashboards_id_users_foreign` 
        FOREIGN KEY(`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE `user_dashboards` ADD INDEX `user_dashboards_id_users_index`(`id_users`);
ALTER TABLE `user_dashboards` ADD INDEX `user_dashboards_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- USER DASHBOARDS LOG
-- TODO records created after trigger
CREATE TABLE `user_dashboards_log`(
    `id_user_dashboards_log` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_user_dashboards` BIGINT UNSIGNED NOT NULL,
    `id_user` BIGINT UNSIGNED NOT NULL,
    `action` ENUM(`create`, `update`, `delete`) NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,

    PRIMARY KEY (`id_user_dashboards_log`),

    CONSTRAINT `user_dashboards_log_id_user_dashboards_foreign` 
        FOREIGN KEY(`id_user_dashboards`) 
        REFERENCES `user_dashboards`(`id_user_dashboards`)
        ON DELETE CASCADE,

    CONSTRAINT `user_dashboards_log_id_user_foreign` 
        FOREIGN KEY(`id_user`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE
);

DELIMITER //
CREATE OR REPLACE PROCEDURE user_dashboards_log_insert(
    IN `v_id_user_dashboards` BIGINT UNSIGNED,
    IN `v_id_users` BIGINT UNSIGNED,
    IN `v_action` ENUM(`create`, `update`, `delete`),
)
BEGIN
    INSERT INTO user_dasboards_log (
        `id_user_dashboards`,
        `id_users`,
        `action`,
        `timestamp`
    ) VALUES (
        `v_id_user_dashboards`,
        `v_id_users`,
        `v_action`,
        NOW()
    )
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE user_dashboards_soft_delete(
    IN `v_id_user_dashboards` BIGINT UNSIGNED
)
BEGIN 
    UPDATE `user_dashboards` 
        SET `deleted_at` = NOW() 
        WHERE `id_user_dashboards` = `v_id_user_dashboards`;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_dashboards_set_created_at` 
    BEFORE INSERT ON `user_dashboards` FOR EACH ROW
    BEGIN
        SET NEW.created_at = NOW();
        SET NEW.updated_at = NOW();
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_dashboards_set_updated_at`
    BEFORE UPDATE ON `user_dashboards` FOR EACH ROW
    BEGIN
        IF NEW.deleted_at IS NULL THEN 
            SET NEW.updated_at = NOW();
        END IF; 
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_dashboards_create_log`
    AFTER INSERT ON `user_dashboards` FOR EACH ROW 
    BEGIN
        CALL user_dashboards_log_insert(
            NEW.id_user_dashboards,
            NEW.id_users,
            `create`
        );
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_dashboards_update_log`
    AFTER UPDATE ON `user_dashboards` FOR EACH ROW 
    BEGIN    
        CALL user_dashboards_log_insert(
            NEW.id_user_dashboards,
            NEW.id_users,
            `update`
        );
    END;      
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `user_dashboards_delete_log`
    AFTER DELETE ON `user_dashboards` FOR EACH ROW 
    BEGIN
        CALL user_dashboards_log_insert(
            OLD.id_user_dashboards,
            OLD.id_users,
            `delete`
        );
    END;
//
DELIMITER ;


