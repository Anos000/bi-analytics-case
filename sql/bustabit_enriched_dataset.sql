SELECT
    id,
    gameid,
    username,
    playdate,

    DATE(playdate) AS bet_date,
    STRFTIME('%Y-%m', playdate) AS bet_month,
    CAST(STRFTIME('%H', playdate) AS INTEGER) AS bet_hour,

    bet,
    cashedout,
    bonus,
    profit,
    bustedat,

    CASE
        WHEN profit IS NOT NULL THEN 'Win'
        ELSE 'Loss'
    END AS result,

    CASE
        WHEN profit IS NOT NULL THEN profit
        ELSE -bet
    END AS net_profit,

    CASE
        WHEN profit IS NOT NULL THEN -profit
        ELSE bet
    END AS platform_ggr,

    CASE
        WHEN profit IS NOT NULL THEN bet + profit
        ELSE 0
    END AS payout,

    CASE
        WHEN bet > 0 AND profit IS NOT NULL THEN profit / bet
        WHEN bet > 0 AND profit IS NULL THEN -1
        ELSE 0
    END AS roi,

    CASE
        WHEN bet < 10 THEN '1. Micro'
        WHEN bet < 50 THEN '2. Small'
        WHEN bet < 100 THEN '3. Medium'
        WHEN bet < 500 THEN '4. Large'
        ELSE '5. Whale'
    END AS bet_size_segment,

    CASE
        WHEN bustedat < 1.5 THEN '1. Low crash'
        WHEN bustedat < 2 THEN '2. Medium crash'
        WHEN bustedat < 5 THEN '3. High crash'
        ELSE '4. Extreme crash'
    END AS crash_segment,

    CASE
        WHEN cashedout IS NULL THEN '0. No cashout'
        WHEN cashedout < 1.5 THEN '1. Low cashout'
        WHEN cashedout < 2 THEN '2. Medium cashout'
        WHEN cashedout < 5 THEN '3. High cashout'
        ELSE '4. Extreme cashout'
    END AS cashout_segment

FROM bustabit_bet;
