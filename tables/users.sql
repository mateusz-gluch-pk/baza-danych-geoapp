CREATE TABLE `users`(
    `id_users` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `login` VARCHAR(255) NOT NULL,
    `password_sha256` BIGINT NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `surname` VARCHAR(255) NOT NULL,
    `language_code` ENUM('') NOT NULL,
    `account_type` ENUM('free', 'premium') NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP,

    PRIMARY KEY(`id_users`)
);

ALTER TABLE `users` ADD INDEX `users_account_type_index`(`account_type`);
ALTER TABLE `users` ADD INDEX `users_deleted_at_index`(`deleted_at`);

CREATE TABLE `user_logins`(
    `id_user_logins` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,

    PRIMARY KEY(`id_user_logins`),

    CONSTRAINT `user_logins_id_users_foreign` 
        FOREIGN KEY(`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE `user_logins` ADD INDEX `user_logins_id_users_index`(`id_users`);
ALTER TABLE `user_logins` ADD INDEX `user_logins_timestamp_index`(`timestamp`);
