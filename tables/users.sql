CREATE TABLE `users`(
    `id_users` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `active_configuration` BIGINT NOT NULL,
    `login` VARCHAR(255) NOT NULL,
    `password_sha256` BIGINT NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `surname` VARCHAR(255) NOT NULL,
    `language_code` ENUM('') NOT NULL,
    `account_type` ENUM('') NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL
);

ALTER TABLE
    `users` ADD INDEX `users_account_type_index`(`account_type`);
ALTER TABLE
    `users` ADD INDEX `users_deleted_at_index`(`deleted_at`);

CREATE TABLE `user_logins`(
    `id_user_logins` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_users` BIGINT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL
);
ALTER TABLE
    `user_logins` ADD INDEX `user_logins_id_users_index`(`id_users`);