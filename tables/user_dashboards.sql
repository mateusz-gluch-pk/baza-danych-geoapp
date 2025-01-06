-- ====================================================================================================
-- USER DASHBOARDS
CREATE TABLE `user_dashboards`(
    `id_user_dashboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT NOT NULL,
    `dashboard` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL,

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
    `id_user_dashboards` BIGINT NOT NULL,
    `id_user` BIGINT NOT NULL,
    `dashboard` JSON NOT NULL,
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
