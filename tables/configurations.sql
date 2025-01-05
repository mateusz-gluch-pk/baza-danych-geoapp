
CREATE TABLE `user_configurations`(
    `id_user_configurations` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_users` BIGINT NOT NULL,
    `configuration` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL
);
ALTER TABLE
    `user_configurations` ADD INDEX `user_configurations_id_users_index`(`id_users`);
ALTER TABLE
    `user_configurations` ADD INDEX `user_configurations_deleted_at_index`(`deleted_at`);
CREATE TABLE `user_logins`(
    `id_user_logins` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_users` BIGINT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL
);
ALTER TABLE
    `user_logins` ADD INDEX `user_logins_id_users_index`(`id_users`);