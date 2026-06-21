-- =====================================================================
-- TRIGGERS  (readable reference — already included in ../mathbet_dump.sql)
-- =====================================================================
-- These two triggers enforce the platform's balance integrity:
--   1. A bet can only be placed if the stake is positive and the
--      customer can afford it; the stake is debited immediately.
--   2. When a game's result is entered, winning bets are credited
--      automatically to the customers' balances.
-- =====================================================================

DELIMITER $$

-- ---------------------------------------------------------------------
-- check_balance_before_bet
-- Fires BEFORE a new bet is inserted.
--   * rejects non-positive stakes
--   * rejects bets larger than the customer's balance
--   * otherwise debits the stake from the customer's account
-- ---------------------------------------------------------------------
CREATE TRIGGER check_balance_before_bet
BEFORE INSERT ON stoixhmata
FOR EACH ROW
BEGIN
    DECLARE ypoloipo DECIMAL(10,2);   -- ypoloipo = remaining balance

    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The bet amount must be positive.';
    END IF;

    SELECT acc_amount INTO ypoloipo
    FROM pelates
    WHERE customer_id = NEW.customers_id;

    IF NEW.amount > ypoloipo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance for this bet.';
    ELSE
        UPDATE pelates
        SET acc_amount = acc_amount - NEW.amount
        WHERE customer_id = NEW.customers_id;
    END IF;
END$$

-- ---------------------------------------------------------------------
-- update_winners_balance
-- Fires AFTER a game_event is updated.
-- When a result is set for the first time (NULL -> '1'/'X'/'2'),
-- every bet on that game whose prediction matches the result is
-- settled by crediting the customer with the bet's potential earnings.
-- ---------------------------------------------------------------------
CREATE TRIGGER update_winners_balance
AFTER UPDATE ON game_event
FOR EACH ROW
BEGIN
    IF OLD.results IS NULL AND NEW.results IS NOT NULL THEN
        UPDATE pelates p
        JOIN stoixhmata s ON p.customer_id = s.customers_id
        SET p.acc_amount = p.acc_amount + s.potential_earnings
        WHERE s.game_id = NEW.game_id
          AND s.results_prediction = NEW.results;
    END IF;
END$$

DELIMITER ;
