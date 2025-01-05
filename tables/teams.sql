-- ====================================================================================================
-- TEAMS 
CREATE TABLE `teams`(
    `id_teams` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `created_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `updated_by` BIGINT NOT NULL,
    `deleted_at` TIMESTAMP NULL,
    `deleted_by` BIGINT NULL
);
ALTER TABLE
    `teams` ADD INDEX `teams_deleted_at_index`(`deleted_at`);

-- ====================================================================================================
-- ROLES
CREATE TABLE `roles`(
    `id_roles` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);

-- ====================================================================================================
-- USER TEAM ROLES
CREATE TABLE `user_team_roles`(
    `id_user_team_roles` BIGINT NOT NULL,
    `id_roles` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_teams` BIGINT NOT NULL,
    `id_users` BIGINT NOT NULL,

    PRIMARY KEY(`id_user_team_roles`)
);

ALTER TABLE `user_team_roles` ADD UNIQUE `user_team_roles_id_teams_unique`(`id_teams`);
ALTER TABLE `user_team_roles` ADD UNIQUE `user_team_roles_id_users_unique`(`id_users`);

