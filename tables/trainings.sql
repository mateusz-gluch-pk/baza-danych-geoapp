DROP TABLE IF EXISTS `training_localization`;
DROP TABLE IF EXISTS `training_splits`;
DROP TABLE IF EXISTS `trainings`;
DROP TABLE IF EXISTS `training_types`;

-- ====================================================================================================
-- TRAINING TYPES
-- done
CREATE TABLE `training_types`(
    `id_training_types` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `split_interval_m` DOUBLE NOT NULL,
    `calorie_coefficient_velocity` DOUBLE NOT NULL,
    `calorie_coefficient_altitude` DOUBLE NOT NULL,
    `calorie_coefficient_distance` BIGINT NOT NULL,

    PRIMARY KEY(`id_training_types`)
);

-- ====================================================================================================
-- TRAININGS
-- TODO constraint żeby end timestamp był większy niż start timestamp
CREATE TABLE `trainings`(
    `id_trainings` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT UNSIGNED NOT NULL,
    `id_training_types` BIGINT UNSIGNED NOT NULL,

    `start_timestamp` BIGINT NOT NULL,
    `end_timestamp` BIGINT NULL,

    `distance_m` DOUBLE NULL CHECK (`distance_m` > 0),
    `max_velocity_m_s` DOUBLE NULL CHECK (`max_velocity_m_s` > 0),
    `mean_velocity_m_s` DOUBLE NULL CHECK (`mean_velocity_m_s` > 0),
    `mean_pace_s_m` DOUBLE NULL CHECK (`mean_pace_s_m` > 0),
    `calories_kcal` DOUBLE NULL CHECK (`calories_kcal` > 0),
    `elevation_m` DOUBLE NULL CHECK (`elevation_m` > 0),
    `altitude_max` DOUBLE NULL,
    `altitude_min` DOUBLE NULL,

    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NULL INVISIBLE,

    PRIMARY KEY(`id_trainings`),

    CONSTRAINT `trainings_end_gt_start_check` 
        CHECK (`start_timestamp` < `end_timestamp`),

    CONSTRAINT `trainings_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `trainings_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `trainings_id_training_types_foreign` 
        FOREIGN KEY (`id_training_types`)
        REFERENCES `training_types` (`id_training_types`),

    CONSTRAINT `trainings_id_users_foreign` 
        FOREIGN KEY (`id_users`)
        REFERENCES `users` (`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE `trainings` ADD INDEX `trainings_id_users_index` (`id_users`);
ALTER TABLE `trainings` ADD INDEX `trainings_id_training_types_index` (`id_training_types`);
ALTER TABLE `trainings` ADD INDEX `trainings_start_timestamp_index` (`start_timestamp`);
ALTER TABLE `trainings` ADD INDEX `trainings_deleted_at_index` (`deleted_at`);

-- ====================================================================================================
-- TRAINING SPLITS
CREATE TABLE `training_splits`(
    `id_training_splits` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_trainings` BIGINT UNSIGNED NOT NULL,
    `timestamp` BIGINT NOT NULL, 
    `time_ms` BIGINT NOT NULL,
    `distance_m` DOUBLE NOT NULL,
    `velocity_m_s` DOUBLE NOT NULL,
    `max_velocity_m_s` DOUBLE NOT NULL,
    `mean_velocity_m_s` DOUBLE NOT NULL,

    PRIMARY KEY(`id_training_splits`),

    CONSTRAINT `training_splits_id_trainings_foreign` 
        FOREIGN KEY (`id_trainings`)
        REFERENCES `trainings` (`id_trainings`)
        ON DELETE CASCADE    
);

ALTER TABLE `training_splits` ADD INDEX `training_splits_id_trainings_index`(`id_trainings`);

-- ====================================================================================================
-- TRAINING LOCALIZATION
-- partitioned table! note that MariaDB allows max 8192 partitions per table
-- TODO partycjonowanie - co dzień
-- TODO procedura tworzenia nowej pratycji jeśli na dany dzień jeszcze nie ma!
CREATE TABLE `training_localization`(
    `id_training_localization` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_trainings` BIGINT UNSIGNED NOT NULL,
    `timestamp` BIGINT NOT NULL,
    `location_lat_lng` POINT NOT NULL,
    `altitude_m` DOUBLE NOT NULL,
    `velocity_m_s` DOUBLE NOT NULL,

    CONSTRAINT `training_localization_id_trainings_foreign` 
        FOREIGN KEY (`id_trainings`)
        REFERENCES `trainings` (`id_trainings`)
        ON DELETE CASCADE
);

ALTER TABLE `training_localization` ADD INDEX `training_localization_id_trainings_index` (`id_trainings`);
ALTER TABLE `training_localization` ADD INDEX `training_localization_timestamp_index` (`timestamp`);
