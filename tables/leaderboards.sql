
CREATE TABLE `leaderboards`(
    `id_leaderboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_teams` BIGINT NOT NULL,
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
    `leaderboards` ADD INDEX `leaderboards_id_teams_index`(`id_teams`);
ALTER TABLE
    `leaderboards` ADD INDEX `leaderboards_deleted_at_index`(`deleted_at`);

CREATE TABLE `leaderboard_entries`(
    `id_leaderboard_entries` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_users` BIGINT NOT NULL,
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
    `leaderboard_entries` ADD INDEX `leaderboard_entries_id_users_index`(`id_users`);
ALTER TABLE
    `leaderboard_entries` ADD INDEX `leaderboard_entries_training_type_id_index`(`training_type_id`);
ALTER TABLE
    `leaderboard_entries` ADD INDEX `leaderboard_entries_date_index`(`date`);
