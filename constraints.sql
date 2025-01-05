ALTER TABLE
    `user_dashboards` ADD CONSTRAINT `user_dashboards_id_users_foreign` FOREIGN KEY(`id_users`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `team_dashboards` ADD CONSTRAINT `team_dashboards_deleted_by_foreign` FOREIGN KEY(`deleted_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `leaderboards` ADD CONSTRAINT `leaderboards_id_teams_foreign` FOREIGN KEY(`id_teams`) REFERENCES `teams`(`id_teams`);
ALTER TABLE
    `user_team_roles` ADD CONSTRAINT `user_team_roles_id_teams_foreign` FOREIGN KEY(`id_teams`) REFERENCES `teams`(`id_teams`);
ALTER TABLE
    `user_team_roles` ADD CONSTRAINT `user_team_roles_id_roles_foreign` FOREIGN KEY(`id_roles`) REFERENCES `roles`(`id_roles`);
ALTER TABLE
    `user_configurations` ADD CONSTRAINT `user_configurations_id_users_foreign` FOREIGN KEY(`id_users`) REFERENCES `users`(`id_users`);
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
    `user_dashboards_log` ADD CONSTRAINT `user_dashboards_log_id_user_foreign` FOREIGN KEY(`id_user`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `team_dashboards` ADD CONSTRAINT `team_dashboards_id_teams_foreign` FOREIGN KEY(`id_teams`) REFERENCES `teams`(`id_teams`);
ALTER TABLE
    `teams` ADD CONSTRAINT `teams_created_by_foreign` FOREIGN KEY(`created_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `user_team_roles` ADD CONSTRAINT `user_team_roles_id_users_foreign` FOREIGN KEY(`id_users`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `trainings` ADD CONSTRAINT `trainings_id_training_types_foreign` FOREIGN KEY(`id_training_types`) REFERENCES `training_types`(`id_training_types`);
ALTER TABLE
    `teams` ADD CONSTRAINT `teams_updated_by_foreign` FOREIGN KEY(`updated_by`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `training_localization` ADD CONSTRAINT `training_localization_id_trainings_foreign` FOREIGN KEY(`id_trainings`) REFERENCES `trainings`(`id_trainings`);
ALTER TABLE
    `training_splits` ADD CONSTRAINT `training_splits_id_trainings_foreign` FOREIGN KEY(`id_trainings`) REFERENCES `trainings`(`id_trainings`);
ALTER TABLE
    `leaderboard_entries` ADD CONSTRAINT `leaderboard_entries_id_users_foreign` FOREIGN KEY(`id_users`) REFERENCES `users`(`id_users`);
ALTER TABLE
    `user_dashboards_log` ADD CONSTRAINT `user_dashboards_log_id_user_dashboards_foreign` FOREIGN KEY(`id_user_dashboards`) REFERENCES `user_dashboards`(`id_user_dashboards`);
ALTER TABLE