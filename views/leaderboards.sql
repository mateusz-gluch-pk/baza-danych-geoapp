CREATE VIEW `leaderboards_by_criterion_bieganie` AS
SELECT
    ld.id_leaderboards,
    lde.id_leaderboard_entries,
    utr.id_teams,
    utr.id_users,
    lde.date,

    tt.name,
    lde.id_training_types,
    lde.training_count,
    lde.training_time_s,
    lde.distance_max_m,
    lde.distance_sum_m,
    lde.calories_sum,
    lde.velocity_max_m_s,
    lde.velocity_mean_m_s

FROM leaderboards ld
INNER JOIN user_team_roles utr
    ON ld.id_teams = utr.id_teams
LEFT JOIN leaderboard_entries lde
    ON utr.id_users = lde.id_users
LEFT JOIN training_types tt
    ON lde.id_training_types = tt.id_training_types

WHERE ld.deleted_at IS NULL
AND ld.criterion_type = 'bieganie';


CREATE VIEW `leaderboards_by_criterion_rower_szosowy` AS
SELECT
    ld.id_leaderboards,
    lde.id_leaderboard_entries,
    utr.id_teams,
    utr.id_users,
    lde.date,

    tt.name,
    lde.id_training_types,
    lde.training_count,
    lde.training_time_s,
    lde.distance_max_m,
    lde.distance_sum_m,
    lde.calories_sum,
    lde.velocity_max_m_s,
    lde.velocity_mean_m_s

FROM leaderboards ld
INNER JOIN user_team_roles utr
    ON ld.id_teams = utr.id_teams
LEFT JOIN leaderboard_entries lde
    ON utr.id_users = lde.id_users
LEFT JOIN training_types tt
    ON lde.id_training_types = tt.id_training_types

WHERE ld.deleted_at IS NULL
AND ld.criterion_type = 'rower szosowy';


CREATE VIEW `leaderboards_by_criterion_rower_gorski` AS
SELECT
    ld.id_leaderboards,
    lde.id_leaderboard_entries,
    utr.id_teams,
    utr.id_users,
    lde.date,

    tt.name,
    lde.id_training_types,
    lde.training_count,
    lde.training_time_s,
    lde.distance_max_m,
    lde.distance_sum_m,
    lde.calories_sum,
    lde.velocity_max_m_s,
    lde.velocity_mean_m_s

FROM leaderboards ld
INNER JOIN user_team_roles utr
    ON ld.id_teams = utr.id_teams
LEFT JOIN leaderboard_entries lde
    ON utr.id_users = lde.id_users
LEFT JOIN training_types tt
    ON lde.id_training_types = tt.id_training_types

WHERE ld.deleted_at IS NULL
AND ld.criterion_type = 'rower gorski';


CREATE VIEW `leaderboards_by_criterion_trekking` AS
SELECT
    ld.id_leaderboards,
    lde.id_leaderboard_entries,
    utr.id_teams,
    utr.id_users,
    lde.date,

    tt.name,
    lde.id_training_types,
    lde.training_count,
    lde.training_time_s,
    lde.distance_max_m,
    lde.distance_sum_m,
    lde.calories_sum,
    lde.velocity_max_m_s,
    lde.velocity_mean_m_s

FROM leaderboards ld
INNER JOIN user_team_roles utr
    ON ld.id_teams = utr.id_teams
LEFT JOIN leaderboard_entries lde
    ON utr.id_users = lde.id_users
LEFT JOIN training_types tt
    ON lde.id_training_types = tt.id_training_types

WHERE ld.deleted_at IS NULL
AND ld.criterion_type = 'trekking';