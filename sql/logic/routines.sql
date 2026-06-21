-- =====================================================================
-- ROUTINES & EVENT  (readable reference — already in ../mathbet_dump.sql)
-- =====================================================================

DELIMITER $$

-- ---------------------------------------------------------------------
-- FUNCTION get_profit_or_loss(start_date, end_date, customer_id)
-- Returns a single customer's net profit/loss over a date range:
--   * winning bet  -> potential_earnings - stake
--   * losing bet   -> -stake
-- Only settled games (results IS NOT NULL) are counted.
-- ---------------------------------------------------------------------
CREATE FUNCTION get_profit_or_loss(
    in_start_date DATE,
    in_end_date   DATE,
    in_customer_id INT
) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_profit_loss DECIMAL(10,2);

    SELECT
        SUM(
            CASE
                WHEN s.results_prediction = g.results
                THEN s.potential_earnings - s.amount
                ELSE -s.amount
            END
        )
    INTO total_profit_loss
    FROM stoixhmata s
    JOIN game_event g ON s.game_id = g.game_id
    WHERE s.customers_id = in_customer_id
      AND s.bet_date BETWEEN in_start_date AND in_end_date
      AND g.results IS NOT NULL;

    RETURN IFNULL(total_profit_loss, 0);
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE top_k_profitable_games(start_date, end_date, k)
-- Returns the k games that were most profitable FOR THE COMPANY in a
-- date range. From the house's perspective:
--   * customer wins  -> company pays out  (-potential_earnings)
--   * customer loses -> company keeps stake (+amount)
-- ---------------------------------------------------------------------
CREATE PROCEDURE top_k_profitable_games(
    IN in_start_date DATE,
    IN in_end_date   DATE,
    IN in_k          INT
)
BEGIN
    SELECT
        g.game_id,
        g.sport_type,
        g.tournament,
        g.match_date,
        SUM(
            CASE
                WHEN s.results_prediction = g.results
                THEN -s.potential_earnings
                ELSE  s.amount
            END
        ) AS net_company_profit
    FROM stoixhmata s
    JOIN game_event g ON s.game_id = g.game_id
    WHERE g.match_date BETWEEN in_start_date AND in_end_date
      AND g.results IS NOT NULL
    GROUP BY g.game_id, g.sport_type, g.tournament, g.match_date
    ORDER BY net_company_profit DESC
    LIMIT in_k;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- EVENT calculate_daily_summary
-- Scheduled to run once a day. Aggregates the previous day's deposits
-- and withdrawals from `synalages` into the `daily_summary` table
-- (idempotent: skips if that day is already summarised).
-- Requires the MySQL event scheduler to be ON:  SET GLOBAL event_scheduler = ON;
-- ---------------------------------------------------------------------
DELIMITER $$

CREATE EVENT calculate_daily_summary
ON SCHEDULE EVERY 1 DAY STARTS '2025-04-22 00:01:00'
ON COMPLETION NOT PRESERVE ENABLE
DO
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM daily_summary
        WHERE summary_date = CURDATE() - INTERVAL 1 DAY
    ) THEN
        INSERT INTO daily_summary (summary_date, total_deposits, total_withdrawals)
        SELECT
            CURDATE() - INTERVAL 1 DAY,
            IFNULL(SUM(CASE WHEN typos = 'Katathesh' THEN ammountoftran ELSE 0 END), 0),
            IFNULL(SUM(CASE WHEN typos = 'Analhpsh'  THEN ammountoftran ELSE 0 END), 0)
        FROM synalages
        WHERE date_of_transaction >= CURDATE() - INTERVAL 1 DAY
          AND date_of_transaction <  CURDATE();
    END IF;
END$$

DELIMITER ;
