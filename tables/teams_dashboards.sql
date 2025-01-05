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
);
ALTER TABLE
    `team_dashboards` ADD INDEX `team_dashboards_id_teams_index`(`id_teams`);
ALTER TABLE
    `team_dashboards` ADD INDEX `team_dashboards_deleted_at_index`(`deleted_at`);
CREATE TABLE `roles`(
    `id_roles` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);