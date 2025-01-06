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

    PRIMARY KEY (`id_teams_dashboards`),

    CONSTRAINT `teams_dashboards_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `teams_dashboards_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `teams_dashboards_id_teams_foreign` 
        FOREIGN KEY(`id_teams`) 
        REFERENCES `teams`(`id_teams`)
        ON DELETE CASCADE,

    CONSTRAINT `teams_dashboards_created_by_foreign` 
        FOREIGN KEY(`created_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `teams_dashboards_updated_by_foreign` 
        FOREIGN KEY(`updated_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `teams_dashboards_deleted_by_foreign` 
        FOREIGN KEY(`deleted_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL
);

ALTER TABLE `team_dashboards` ADD INDEX `team_dashboards_id_teams_index`(`id_teams`);
ALTER TABLE `team_dashboards` ADD INDEX `team_dashboards_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- TEAMS DASHBOARDS LOG
-- TODO records created after trigger
CREATE TABLE `teams_dashboards_log`(
    `id_teams_dashboards_log` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_teams_dashboards` BIGINT NOT NULL,
    `id_teams` BIGINT NOT NULL,
    `id_users` BIGINT NOT NULL,

    `dashboard` BIGINT NOT NULL,
    `action` ENUM('create', 'update', 'delete') NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,

    PRIMARY KEY (`id_teams_dashboards_log`),

    CONSTRAINT `teams_dashboards_log_id_teams_dashboards_foreign` 
        FOREIGN KEY(`id_teams_dashboards`) 
        REFERENCES `teams_dashboards`(`id_teams_dashboards`)
        ON DELETE CASCADE,

    CONSTRAINT `teams_dashboards_log_id_user_foreign` 
        FOREIGN KEY(`id_user`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE,

    CONSTRAINT `teams_dashboards_id_users_foreign` 
        FOREIGN KEY(`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL
);