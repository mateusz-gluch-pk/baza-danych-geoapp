DROP TRIGGER IF EXISTS `trainings_set_created_at`;
DROP TRIGGER IF EXISTS `trainings_set_updated_at`;

DROP PROCEDURE IF EXISTS `trainings_soft_delete`;

DROP TABLE IF EXISTS `training_localization`;
DROP TABLE IF EXISTS `training_splits`;
DROP TABLE IF EXISTS `trainings`;
DROP TABLE IF EXISTS `training_types`;

-- ====================================================================================================
-- TRAINING TYPES
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
CREATE TABLE `trainings`(
    `id_trainings` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT UNSIGNED NOT NULL,
    `id_training_types` BIGINT UNSIGNED NOT NULL,

    `start_timestamp` BIGINT NOT NULL,
    `end_timestamp` BIGINT NULL,

    `distance_m` DOUBLE NULL DEFAULT 0 CHECK (`distance_m` >= 0),
    `max_velocity_m_s` DOUBLE NULL DEFAULT 0 CHECK (`max_velocity_m_s` >= 0),
    `mean_velocity_m_s` DOUBLE NULL DEFAULT 0 CHECK (`mean_velocity_m_s` >= 0),
    `mean_pace_s_m` DOUBLE NULL DEFAULT 0 CHECK (`mean_pace_s_m` >= 0),
    `calories_kcal` DOUBLE NULL DEFAULT 0 CHECK (`calories_kcal` >= 0),
    `elevation_m` DOUBLE NULL DEFAULT 0 CHECK (`elevation_m` >= 0),
    `altitude_max` DOUBLE NULL DEFAULT 0,
    `altitude_min` DOUBLE NULL DEFAULT 0,

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
    `id_training_localization` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_trainings` BIGINT UNSIGNED NOT NULL,
    `training_day_part` DATE NULL INVISIBLE DEFAULT '1970-01-01',
    `timestamp` BIGINT NOT NULL,
    `location_lat` DOUBLE NOT NULL,
    `location_lng` DOUBLE NOT NULL,
    `altitude_m` DOUBLE NOT NULL,
    `velocity_m_s` DOUBLE NOT NULL,
    
    PRIMARY KEY(`id_training_localization`, `training_day_part`)
    
--     CONSTRAINT `training_localization_id_trainings_foreign` 
--         FOREIGN KEY (`id_trainings`)
--         REFERENCES `trainings` (`id_trainings`)
--         ON DELETE CASCADE
)
PARTITION BY KEY(`training_day_part`) 
PARTITIONS 365;

-- automatic partition assignment
DELIMITER //
CREATE OR REPLACE FUNCTION training_day(
	`v_id_trainings` BIGINT UNSIGNED
) RETURNS DATE READS SQL DATA
BEGIN
	DECLARE ts BIGINT;
	SELECT `start_timestamp` 
		FROM `trainings` 
		WHERE `id_trainings` = `v_id_trainings`
		LIMIT 1 INTO ts;

	RETURN CAST(TIMESTAMPADD(SECOND,ts,'1970-01-01') AS DATE);
END;
//
DELIMITER ;

-- foreign key implementation using trigger and user fcn
DELIMITER //
CREATE OR REPLACE FUNCTION training_exists(
	`v_id_trainings` BIGINT UNSIGNED
) RETURNS BOOL READS SQL DATA
BEGIN
	DECLARE v_cnt INT;
	SELECT COUNT(1) 
		FROM `trainings` 
		WHERE `id_trainings` = `v_id_trainings`
		LIMIT 1 INTO @v_cnt;
	RETURN @v_cnt = 1;
END;
//
DELIMITER ;

SHOW FUNCTION STATUS LIKE 'training%';

DELIMITER //
CREATE OR REPLACE TRIGGER `training_localization_id_trainings_foreign`
    BEFORE INSERT ON `training_localization` FOR EACH ROW
    BEGIN
	    IF !training_exists(NEW.id_trainings)  THEN
	    	SIGNAL SQLSTATE '45000' SET
	    	MYSQL_ERRNO=1234,
	    	MESSAGE_TEXT='Foreign Key training_localization_id_trainings_foreign violation';
	    END IF;
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `training_localization_assign_partition`
    BEFORE INSERT ON `training_localization` FOR EACH ROW
    FOLLOWS `training_localization_id_trainings_foreign`
    BEGIN
	    IF NEW.training_day_part IS NULL THEN
	    	SET NEW.training_day_part = training_day(NEW.id_trainings);
	    END IF;
	END;
//
DELIMITER ;

ALTER TABLE `training_localization` ADD INDEX `training_localization_id_trainings_index` (`id_trainings`);
ALTER TABLE `training_localization` ADD INDEX `training_localization_timestamp_index` (`timestamp`);

DELIMITER //
CREATE OR REPLACE PROCEDURE trainings_soft_delete(
    IN `v_id_trainings` BIGINT UNSIGNED
)
BEGIN 
    UPDATE `trainings` 
        SET `deleted_at` = NOW()
        WHERE `id_trainings` = `v_id_trainings`;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `trainings_set_created_at` 
    BEFORE INSERT ON `trainings` FOR EACH ROW
    BEGIN
        SET NEW.created_at = NOW();
        SET NEW.updated_at = NOW();
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `trainings_set_updated_at`
    BEFORE UPDATE ON `trainings` FOR EACH ROW
    BEGIN
        IF NEW.deleted_at IS NULL THEN 
            SET NEW.updated_at = NOW();
        END IF; 
    END;
//
DELIMITER ;



