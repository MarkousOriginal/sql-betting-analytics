-- =====================================================================
-- VIEWS  (readable reference — already included in ../mathbet_dump.sql)
-- Reformatted for readability; logic is identical to the dump.
-- =====================================================================

-- ---------------------------------------------------------------------
-- high_risk_customers
-- Customers whose average odds are above 2 (riskier betting behaviour).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW high_risk_customers AS
SELECT
    p.customer_id,
    p.name,
    AVG(s.odds) AS average_odds
FROM pelates p
JOIN stoixhmata s ON p.customer_id = s.customers_id
GROUP BY p.customer_id, p.name
HAVING AVG(s.odds) > 2;

-- ---------------------------------------------------------------------
-- high_earnings_customers
-- Customers whose total profit from winning bets is above the
-- average customer profit (correlated sub-query benchmark).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW high_earnings_customers AS
SELECT
    p.customer_id,
    p.name,
    SUM(s.potential_earnings - s.amount) AS total_profit
FROM pelates p
JOIN stoixhmata s ON p.customer_id = s.customers_id
JOIN game_event g ON s.game_id     = g.game_id
WHERE s.results_prediction = g.results
GROUP BY p.customer_id, p.name
HAVING total_profit > (
    SELECT AVG(sub.profit)
    FROM (
        SELECT
            s.customers_id,
            SUM(s.potential_earnings - s.amount) AS profit
        FROM stoixhmata s
        JOIN game_event g ON s.game_id = g.game_id
        WHERE s.results_prediction = g.results
        GROUP BY s.customers_id
    ) sub
);

-- ---------------------------------------------------------------------
-- view_etairia_kerdos  (company profit/loss per game & prediction)
-- From the house perspective: pays out winners (-potential_earnings),
-- keeps losers' stakes (+amount).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW view_etairia_kerdos AS
SELECT
    ge.game_id,
    s.results_prediction,
    ge.results AS actual_result,
    SUM(
        CASE
            WHEN s.results_prediction = ge.results
            THEN -s.potential_earnings
            ELSE  s.amount
        END
    ) AS company_profit_or_loss
FROM stoixhmata s
JOIN game_event ge ON s.game_id = ge.game_id
GROUP BY ge.game_id, s.results_prediction, ge.results;

-- ---------------------------------------------------------------------
-- game_event_odds_stats
-- Max / min offered odds per game.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW game_event_odds_stats AS
SELECT
    g.game_id,
    g.sport_type,
    g.tournament,
    g.match_date,
    MAX(s.odds) AS max_odds,
    MIN(s.odds) AS min_odds
FROM stoixhmata s
JOIN game_event g ON s.game_id = g.game_id
GROUP BY g.game_id, g.sport_type, g.tournament, g.match_date;

-- ---------------------------------------------------------------------
-- countries_excel  (deposits / withdrawals aggregated by country)
-- Feeds the Excel reporting layer.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW countries_excel AS
SELECT
    p.countryoforigin AS country,
    IFNULL(SUM(CASE WHEN s.typos = 'katathesh' THEN s.ammountoftran ELSE 0 END), 0) AS total_deposits,
    IFNULL(SUM(CASE WHEN s.typos = 'analhpsh'  THEN s.ammountoftran ELSE 0 END), 0) AS total_withdrawals
FROM pelates p
LEFT JOIN synalages s ON p.customer_id = s.customer_id
GROUP BY country;
