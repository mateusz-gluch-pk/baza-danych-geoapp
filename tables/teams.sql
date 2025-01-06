-- ====================================================================================================
-- TEAMS 
-- TODO: WYSZUKIWANIE PO NAZWIE TEAMU - INDEX FULL TEXT
-- TODO: procedura soft delete 
CREATE TABLE `teams`(
    `id_teams` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,

    `created_at` TIMESTAMP NOT NULL,
    `created_by` BIGINT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `updated_by` BIGINT NULL,
    `deleted_at` TIMESTAMP NULL,
    `deleted_by` BIGINT NULL

    PRIMARY KEY (`id_teams`),

    CONSTRAINT `teams_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `teams_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `teams_created_by_foreign` 
        FOREIGN KEY(`created_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `teams_updated_by_foreign` 
        FOREIGN KEY(`updated_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `teams_deleted_by_foreign` 
        FOREIGN KEY(`deleted_by`) 
        REFERENCES `users`(`id_users`)
        ON DELETE SET NULL
);

ALTER TABLE `teams` ADD INDEX `teams_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- ROLES
CREATE TABLE `roles`(
    `id_roles` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);

-- ====================================================================================================
-- USER TEAM ROLES
-- TODO INDEX DELETED AT
CREATE TABLE `user_team_roles`(
    `id_user_team_roles` BIGINT NOT NULL,
    `id_roles` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_teams` BIGINT NOT NULL,
    `id_users` BIGINT NOT NULL,

    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL,

    PRIMARY KEY(`id_user_team_roles`),

    CONSTRAINT UNIQUE(`id_teams`, `id_users`),

    CONSTRAINT `user_team_roles_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `user_team_roles_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `user_team_roles_id_roles_foreign` 
        FOREIGN KEY(`id_roles`) 
        REFERENCES `roles`(`id_roles`),

    CONSTRAINT `user_team_roles_id_teams_foreign` 
        FOREIGN KEY(`id_teams`) 
        REFERENCES `teams`(`id_teams`)
        ON DELETE CASCADE,
    
    CONSTRAINT `user_team_roles_id_users_foreign` 
        FOREIGN KEY(`id_users`) 
        REFERENCES `users`(`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE `user_team_roles` ADD UNIQUE `user_team_roles_id_teams_unique`(`id_teams`);
ALTER TABLE `user_team_roles` ADD UNIQUE `user_team_roles_id_users_unique`(`id_users`);

