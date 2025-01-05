CREATE TABLE `trainings`(
    `id_trainings` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_users` BIGINT NOT NULL,
    `id_training_types` BIGINT NOT NULL,
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
    `trainings` ADD INDEX `trainings_id_users_index`(`id_users`);
ALTER TABLE
    `trainings` ADD INDEX `trainings_id_training_types_index`(`id_training_types`);
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
    `id_trainings` BIGINT NOT NULL,
    `time_ms` BIGINT NOT NULL,
    `distance_m` DOUBLE NOT NULL,
    `velocity_m_s` DOUBLE NOT NULL,
    `max_velocity_m_s` DOUBLE NOT NULL,
    `mean_velocity_m_s` DOUBLE NOT NULL
);

ALTER TABLE
    `training_splits` ADD INDEX `training_splits_id_trainings_index`(`id_trainings`);

CREATE TABLE `training_localization`(
    `id_training_localization` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_trainings` BIGINT NOT NULL,
    `timestamp` BIGINT NOT NULL,
    `location_lat_lng` POINT NOT NULL,
    `altitude_m` DOUBLE NOT NULL,
    `velocity_m_s` DOUBLE NOT NULL
);

ALTER TABLE
    `training_localization` ADD INDEX `training_localization_id_trainings_index`(`id_trainings`);
ALTER TABLE
    `training_localization` ADD INDEX `training_localization_timestamp_index`(`timestamp`);
