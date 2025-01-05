-- ====================================================================================================
-- USER CONFIGURATIONS
CREATE TABLE `user_configurations`(
    `id_user_configurations` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT NOT NULL,
    `configuration` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL,

    PRIMARY KEY (`id_user_configurations`),

    CONSTRAINT `user_configurations_id_users_foreign` 
        FOREIGN KEY(`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE `user_configurations` ADD INDEX `user_configurations_id_users_index`(`id_users`);
ALTER TABLE `user_configurations` ADD INDEX `user_configurations_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- USER CONFIGURATIONS LOG
-- records created after trigger
CREATE TABLE `user_configurations_log`(
    `id_user_configurations_log` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_user_configurations` BIGINT NOT NULL,
    `id_user` BIGINT NOT NULL,
    `dashboard` BIGINT NOT NULL,
    `action` ENUM(`c`, `u`, `d`) NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,

    PRIMARY KEY (`id_user_configurations_log`),

    CONSTRAINT `user_configurations_log_id_user_configurations_foreign` 
        FOREIGN KEY(`id_user_configurations`) 
        REFERENCES `user_configurations`(`id_user_configurations`)
        ON DELETE CASCADE,

    CONSTRAINT `user_configurations_log_id_user_foreign` 
        FOREIGN KEY(`id_user`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE
);