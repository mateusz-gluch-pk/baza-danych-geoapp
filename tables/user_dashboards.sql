-- ====================================================================================================
-- USER DASHBOARDS
CREATE TABLE `user_dashboards`(
    `id_user_dashboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_users` BIGINT NOT NULL,
    `dashboard` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL
);

ALTER TABLE `user_dashboards` ADD INDEX `user_dashboards_id_users_index`(`id_users`);
ALTER TABLE `user_dashboards` ADD INDEX `user_dashboards_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- USER DASHBOARDS LOG
-- records created after trigger
CREATE TABLE `user_dashboards_log`(
    `id_user_dashboards_log` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_user_dashboards` BIGINT NOT NULL,
    `id_user` BIGINT NOT NULL,
    `dashboard` BIGINT NOT NULL,
    `action` ENUM(`c`, `u`, `d`) NOT NULL,
    `timestamp` TIMESTAMP NOT NULL
);