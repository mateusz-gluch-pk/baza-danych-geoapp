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
CREATE TABLE `trainings`(
    `id_trainings` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `training_type_id` BIGINT NOT NULL,
    `start_timestamp` BIGINT NOT NULL,
    `end_timestamp` BIGINT NULL,
    `distance_m` DOUBLE NULL,
    `max_velocity_m_s` DOUBLE NULL,
    `mean_velocity_m_s` DOUBLE NULL,
    `mean_pace_s_m` DOUBLE NULL,
    `calories_kcal` DOUBLE NULL,
    `elevation_m` DOUBLE NULL,
    `altitude_max` DOUBLE NULL,
    `altitude_min` DOUBLE NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL
);
ALTER TABLE
    `trainings` ADD INDEX `trainings_user_id_index`(`user_id`);
ALTER TABLE
    `trainings` ADD INDEX `trainings_training_type_id_index`(`training_type_id`);
ALTER TABLE
    `trainings` ADD INDEX `trainings_start_timestamp_index`(`start_timestamp`);
ALTER TABLE
    `trainings` ADD INDEX `trainings_deleted_at_index`(`deleted_at`);
CREATE TABLE `training_types`(
    `id_training_types` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `split_interval_m` DOUBLE NOT NULL,
    `calorie_coefficient_velocity` DOUBLE NOT NULL,
    `calorie_coefficient_altitude` DOUBLE NOT NULL,
    `calorie_coefficient_distance` BIGINT NOT NULL
);
CREATE TABLE `training_splits`(
    `id_training_splits` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `training_id` BIGINT NOT NULL,
    `time_ms` BIGINT NOT NULL,
    `distance_m` DOUBLE NOT NULL,
    `velocity_m_s` DOUBLE NOT NULL,
    `max_velocity_m_s` DOUBLE NOT NULL,
    `mean_velocity_m_s` DOUBLE NOT NULL
);
ALTER TABLE
    `training_splits` ADD INDEX `training_splits_training_id_index`(`training_id`);
CREATE TABLE `training_localization`(
    `id_training_localization` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `training_id` BIGINT NOT NULL,
    `timestamp` BIGINT NOT NULL,
    `location_lat_lng` POINT NOT NULL,
    `altitude_m` DOUBLE NOT NULL,
    `velocity_m_s` DOUBLE NOT NULL
);
ALTER TABLE
    `training_localization` ADD INDEX `training_localization_training_id_index`(`training_id`);
ALTER TABLE
    `training_localization` ADD INDEX `training_localization_timestamp_index`(`timestamp`);
CREATE TABLE `user_configurations`(
    `id_user_configurations` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `configuration` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL
);
ALTER TABLE
    `user_configurations` ADD INDEX `user_configurations_user_id_index`(`user_id`);
ALTER TABLE
    `user_configurations` ADD INDEX `user_configurations_deleted_at_index`(`deleted_at`);
CREATE TABLE `user_logins`(
    `id_user_logins` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL
);
ALTER TABLE
    `user_logins` ADD INDEX `user_logins_user_id_index`(`user_id`);
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
CREATE TABLE `leaderboards`(
    `id_leaderboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `team_id` BIGINT NOT NULL,
    `position` BIGINT NOT NULL,
    `criterion` ENUM('') NOT NULL,
    `period_days` BIGINT NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `created_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `updated_by` BIGINT NOT NULL,
    `deleted_at` TIMESTAMP NULL,
    `deleted_by` BIGINT NULL
);
ALTER TABLE
    `leaderboards` ADD INDEX `leaderboards_team_id_index`(`team_id`);
ALTER TABLE
    `leaderboards` ADD INDEX `leaderboards_deleted_at_index`(`deleted_at`);
CREATE TABLE `user_dashboards`(
    `id_user_dashboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `dashboard` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL
);
ALTER TABLE
    `user_dashboards` ADD INDEX `user_dashboards_user_id_index`(`user_id`);
ALTER TABLE
    `user_dashboards` ADD INDEX `user_dashboards_deleted_at_index`(`deleted_at`);
CREATE TABLE `team_dashboards`(
    `id_team_dashboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `team_id` BIGINT NOT NULL,
    `dashboard` JSON NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `created_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `updated_by` BIGINT NOT NULL,
    `deleted_at` TIMESTAMP NULL,
    `deleted_by` BIGINT NULL
);
ALTER TABLE
    `team_dashboards` ADD INDEX `team_dashboards_team_id_index`(`team_id`);
ALTER TABLE
    `team_dashboards` ADD INDEX `team_dashboards_deleted_at_index`(`deleted_at`);
CREATE TABLE `roles`(
    `id_roles` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE `user_team_roles`(
    `id_user_team_roles` BIGINT NOT NULL,
    `role_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `team_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    PRIMARY KEY(`id_user_team_roles`)
);
ALTER TABLE
    `user_team_roles` ADD UNIQUE `user_team_roles_team_id_unique`(`team_id`);
ALTER TABLE
    `user_team_roles` ADD UNIQUE `user_team_roles_user_id_unique`(`user_id`);
CREATE TABLE `leaderboard_entries`(
    `id_leaderboard_entries` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `training_type_id` BIGINT NOT NULL,
    `date` DATE NOT NULL,
    `training_count` BIGINT NOT NULL,
    `training_time` BIGINT NOT NULL,
    `length_max_km` DOUBLE NULL,
    `length_sum_km` DOUBLE NULL,
    `calories_sum_km` DOUBLE NULL,
    `velocity_max_m_s` DOUBLE NULL,
    `velocity_mean_m_s` DOUBLE NULL
);
ALTER TABLE
    `leaderboard_entries` ADD INDEX `leaderboard_entries_user_id_index`(`user_id`);
ALTER TABLE
    `leaderboard_entries` ADD INDEX `leaderboard_entries_training_type_id_index`(`training_type_id`);
ALTER TABLE
    `leaderboard_entries` ADD INDEX `leaderboard_entries_date_index`(`date`);
ALTER TABLE
    `user_dashboards` ADD CONSTRAINT `user_dashboards_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `team_dashboards` ADD CONSTRAINT `team_dashboards_deleted_by_foreign` FOREIGN KEY(`deleted_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `leaderboards` ADD CONSTRAINT `leaderboards_team_id_foreign` FOREIGN KEY(`team_id`) REFERENCES `teams`(`id_teams`);
ALTER TABLE
    `user_logins` ADD CONSTRAINT `user_logins_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `user_team_roles` ADD CONSTRAINT `user_team_roles_team_id_foreign` FOREIGN KEY(`team_id`) REFERENCES `teams`(`id_teams`);
ALTER TABLE
    `user_team_roles` ADD CONSTRAINT `user_team_roles_role_id_foreign` FOREIGN KEY(`role_id`) REFERENCES `roles`(`id_roles`);
ALTER TABLE
    `user_configurations` ADD CONSTRAINT `user_configurations_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `team_dashboards` ADD CONSTRAINT `team_dashboards_created_by_foreign` FOREIGN KEY(`created_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `teams` ADD CONSTRAINT `teams_deleted_by_foreign` FOREIGN KEY(`deleted_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `users` ADD CONSTRAINT `users_active_configuration_foreign` FOREIGN KEY(`active_configuration`) REFERENCES `user_configurations`(`id_user_configurations`);
ALTER TABLE
    `leaderboard_entries` ADD CONSTRAINT `leaderboard_entries_training_type_id_foreign` FOREIGN KEY(`training_type_id`) REFERENCES `training_types`(`id_training_types`);
ALTER TABLE
    `team_dashboards` ADD CONSTRAINT `team_dashboards_updated_by_foreign` FOREIGN KEY(`updated_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `team_dashboards` ADD CONSTRAINT `team_dashboards_team_id_foreign` FOREIGN KEY(`team_id`) REFERENCES `teams`(`id_teams`);
ALTER TABLE
    `teams` ADD CONSTRAINT `teams_created_by_foreign` FOREIGN KEY(`created_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `user_team_roles` ADD CONSTRAINT `user_team_roles_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `trainings` ADD CONSTRAINT `trainings_training_type_id_foreign` FOREIGN KEY(`training_type_id`) REFERENCES `training_types`(`id_training_types`);
ALTER TABLE
    `teams` ADD CONSTRAINT `teams_updated_by_foreign` FOREIGN KEY(`updated_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `training_localization` ADD CONSTRAINT `training_localization_training_id_foreign` FOREIGN KEY(`training_id`) REFERENCES `trainings`(`id_trainings`);
ALTER TABLE
    `training_splits` ADD CONSTRAINT `training_splits_training_id_foreign` FOREIGN KEY(`training_id`) REFERENCES `trainings`(`id_trainings`);
ALTER TABLE
    `leaderboard_entries` ADD CONSTRAINT `leaderboard_entries_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `trainings` ADD CONSTRAINT `trainings_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`id_users`);