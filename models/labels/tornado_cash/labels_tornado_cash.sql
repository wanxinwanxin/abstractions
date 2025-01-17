{{config(alias='tornado_cash')}}

WITH tornado_addresses AS (
SELECT
    lower(blockchain) as blockchain,
    tx_hash,
    depositor AS address,
    'Depositor' as name
FROM {{ ref('tornado_cash_deposits') }}
UNION
SELECT
    lower(blockchain) as blockchain,
    tx_hash,
    recipient AS address,
    'Recipient' as name
FROM {{ ref('tornado_cash_withdrawals') }}
)

SELECT
    collect_set(blockchain) as blockchain,
    address,
    'Tornado Cash ' || array_join(collect_set(name),' and ') AS name,
    'tornado_cash' AS category,
    'soispoke' AS contributor,
    'query' AS source,
    timestamp('2022-10-01') as created_at,
    now() as updated_at
FROM tornado_addresses
GROUP BY address