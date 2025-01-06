DROP TRIGGER IF EXISTS `leaderboards_set_created_at`;
DROP TRIGGER IF EXISTS `leaderboards_set_updated_at`;

DROP PROCEDURE IF EXISTS `leaderboards_soft_delete`;

DROP TABLE IF EXISTS `leaderboards`;
DROP TABLE IF EXISTS `leaderboard_entries`;

-- ====================================================================================================
-- LEADERBOARDS
-- TODO widoki leaderboardów 
CREATE TABLE `leaderboards`(
    `id_leaderboards` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_teams` BIGINT UNSIGNED NOT NULL,

    `priority` BIGINT NOT NULL CHECK (`priority` > 0),
    `period_days` BIGINT NOT NULL CHECK (`period_days` > 0),
    `criterion` ENUM(
        'training_count', 
        'training_time', 
        'length_max_km', 
        'length_sum_km', 
        'calories_sum_km', 
        'velocity_max_m_s', 
        'velocity_mean_m_s'
    ) NOT NULL,
    
    `created_at` TIMESTAMP NOT NULL,
    `created_by` BIGINT UNSIGNED NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `updated_by` BIGINT UNSIGNED NULL,
    `deleted_at` TIMESTAMP NULL INVISIBLE,
    `deleted_by` BIGINT UNSIGNED NULL INVISIBLE,

    PRIMARY KEY(`id_leaderboards`),

    UNIQUE(`id_teams`,`priority`),

    CONSTRAINT `leaderboards_updated_ge_created_check`
        CHECK (`updated_at` >= `created_at`),

    CONSTRAINT `leaderboards_deleted_ge_created_check`
        CHECK ((`deleted_at` >= `created_at`) OR (`deleted_at` IS NULL)),

    CONSTRAINT `leaderboards_id_teams_foreign` 
        FOREIGN KEY (`id_teams`) 
        REFERENCES `teams` (`id_teams`)
        ON DELETE CASCADE,

    CONSTRAINT `leaderboards_created_by_foreign` 
        FOREIGN KEY (`created_by`) 
        REFERENCES `users` (`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `leaderboards_updated_by_foreign` 
        FOREIGN KEY (`updated_by`) 
        REFERENCES `users` (`id_users`)
        ON DELETE SET NULL,

    CONSTRAINT `leaderboards_deleted_by_foreign` 
        FOREIGN KEY (`deleted_by`)
        REFERENCES `users` (`id_users`)
        ON DELETE SET NULL
);

ALTER TABLE `leaderboards` ADD INDEX `leaderboards_id_teams_index`(`id_teams`);
ALTER TABLE `leaderboards` ADD INDEX `leaderboards_deleted_at_index`(`deleted_at`);
ALTER TABLE `leaderboards` ADD INDEX `leaderboards_priority_index`(`priority`);

-- ====================================================================================================
-- LEADERBOARD ENTRIES
-- TODO rekordy tworzone po dziennym evencie
CREATE TABLE `leaderboard_entries`(
    `id_leaderboard_entries` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_users` BIGINT UNSIGNED NOT NULL,
    `id_training_types` BIGINT UNSIGNED NOT NULL,

    `date` DATE NOT NULL,

    `training_count` BIGINT NOT NULL CHECK (`training_count` > 0),
    `training_time_s` BIGINT NOT NULL CHECK (`training_time_s` > 0),
    `distance_max_m` DOUBLE NULL CHECK (`distance_max_m` > 0),
    `distance_sum_m` DOUBLE NULL CHECK (`distance_sum_m` > 0),
    `calories_sum` DOUBLE NULL CHECK (`calories_sum` > 0),
    `velocity_max_m_s` DOUBLE NULL CHECK (`velocity_max_m_s` > 0),
    `velocity_mean_m_s` DOUBLE NULL CHECK (`velocity_mean_m_s` > 0),

    PRIMARY KEY (`id_leaderboard_entries`),

    UNIQUE (`id_users`,`id_training_types`,`date`),

    CONSTRAINT `leaderboard_entries_id_training_types_foreign` 
        FOREIGN KEY (`id_training_types`) 
        REFERENCES `training_types` (`id_training_types`),

    CONSTRAINT `leaderboard_entries_id_users_foreign` 
        FOREIGN KEY (`id_users`) 
        REFERENCES `users` (`id_users`)
        ON DELETE CASCADE
);

ALTER TABLE `leaderboard_entries` ADD INDEX `leaderboard_entries_id_users_index`(`id_users`);
ALTER TABLE `leaderboard_entries` ADD INDEX `leaderboard_entries_id_training_types_index`(`id_training_types`);
ALTER TABLE `leaderboard_entries` ADD INDEX `leaderboard_entries_date_index`(`date`);


DELIMITER //
CREATE OR REPLACE PROCEDURE leaderboards_soft_delete(
    IN `v_id_leaderboards` BIGINT UNSIGNED,
    IN `v_deleted_by` BIGINT UNSIGNED
)
BEGIN 
    UPDATE `leaderboards` 
        SET `deleted_at` = NOW(), `deleted_by` = `v_deleted_by`
        WHERE `id_leaderboards` = `v_id_leaderboards`;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `leaderboards_set_created_at` 
    BEFORE INSERT ON `leaderboards` FOR EACH ROW
    BEGIN
        SET NEW.created_at = NOW();
        SET NEW.updated_at = NOW();
    END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `leaderboards_set_updated_at`
    BEFORE UPDATE ON `leaderboards` FOR EACH ROW
    BEGIN
        IF NEW.deleted_at IS NULL THEN 
            SET NEW.updated_at = NOW();
        END IF; 
    END;
//
DELIMITER ;