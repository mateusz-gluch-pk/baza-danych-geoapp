-- ====================================================================================================
-- TEAMS DASHBOARDS
CREATE TABLE `team_dashboards`(
    `id_team_dashboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_teams` BIGINT NOT NULL,
    `dashboard` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `created_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `updated_by` BIGINT NOT NULL,
    `deleted_at` TIMESTAMP NULL,
    `deleted_by` BIGINT NULL

    PRIMARY KEY (`id_teams_dashboards`),

    CONSTRAINT `teams_dashboards_id_users_foreign` 
        FOREIGN KEY(`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE

);
ALTER TABLE
    `team_dashboards` ADD INDEX `team_dashboards_id_teams_index`(`id_teams`);
ALTER TABLE
    `team_dashboards` ADD INDEX `team_dashboards_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- TEAMS DASHBOARDS LOG
-- records created after trigger
CREATE TABLE `teams_dashboards_log`(
    `id_teams_dashboards_log` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_teams_dashboards` BIGINT NOT NULL,
    `id_teams` BIGINT NOT NULL,
    `id_users` BIGINT NOT NULL,
    `dashboard` BIGINT NOT NULL,
    `action` ENUM(`c`, `u`, `d`) NOT NULL,
    `timestamp` TIMESTAMP NOT NULL

    PRIMARY KEY (`id_teams_dashboards_log`),

    CONSTRAINT `teams_dashboards_log_id_teams_dashboards_foreign` 
        FOREIGN KEY(`id_teams_dashboards`) 
        REFERENCES `teams_dashboards`(`id_teams_dashboards`)
        ON DELETE CASCADE,

    CONSTRAINT `teams_dashboards_log_id_user_foreign` 
        FOREIGN KEY(`id_user`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE

);