-- cryptocom 改为 crypto.com
update transactions set dealers=replace(dealers, 'cryptocom', 'crypto.com') where dealers like '%cryptocom';
update quotes set dealers=replace(dealers, 'cryptocom', 'crypto.com') where dealers like '%cryptocom';
update fills set dealers=replace(dealers, 'cryptocom', 'crypto.com') where dealers like '%cryptocom';

-- 整理 transactions 中的 add_date 字段
-- 新增 add_new_date 字段并设置默认值为 CURRENT_TIMESTAMP
ALTER TABLE transactions ADD COLUMN add_new_date TIMESTAMP;
ALTER TABLE transactions ALTER COLUMN add_new_date SET DEFAULT CURRENT_TIMESTAMP;

-- 按照之前的 add_date 更新 add_new_date,刷新老数据
UPDATE transactions set add_new_date = cast(to_char(to_timestamp(add_date/1000), 'YYYY-MM-DD hh24:mi:ss') AS TIMESTAMP);

-- 删除 add_date 字段，并将 add_new_date 字段更名为 add_date
ALTER TABLE transactions DROP COLUMN add_date;
ALTER TABLE transactions RENAME COLUMN add_new_date to add_date;

-- 需要新增 add_date 字段的数据表：fills、deposits、withdrawals、single_trade_limits、exposure_limits；
-- 新增 add_date 字段并设置默认值为 CURRENT_TIMESTAMP
ALTER TABLE fills ADD COLUMN add_date TIMESTAMP;
ALTER TABLE fills ALTER COLUMN add_date SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE deposits ADD COLUMN add_date TIMESTAMP;
ALTER TABLE deposits ALTER COLUMN add_date SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE withdrawals ADD COLUMN add_date TIMESTAMP;
ALTER TABLE withdrawals ALTER COLUMN add_date SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE single_trade_limits ADD COLUMN add_date TIMESTAMP;
ALTER TABLE single_trade_limits ALTER COLUMN add_date SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE exposure_limits ADD COLUMN add_date TIMESTAMP;
ALTER TABLE exposure_limits ALTER COLUMN add_date SET DEFAULT CURRENT_TIMESTAMP;

-- transactionshistory 表 user_id 字段默认值
ALTER TABLE transactionshistory ALTER COLUMN user_id SET DEFAULT '';

-- 按照之前的 created_at 更新 add_date,刷新老数据
UPDATE fills set add_date = cast(to_char(to_timestamp(created_at/1000), 'YYYY-MM-DD hh24:mi:ss') AS TIMESTAMP);
UPDATE deposits set add_date = cast(to_char(to_timestamp(created_at/1000), 'YYYY-MM-DD hh24:mi:ss') AS TIMESTAMP);
UPDATE withdrawals set add_date = cast(to_char(to_timestamp(created_at/1000), 'YYYY-MM-DD hh24:mi:ss') AS TIMESTAMP);
UPDATE single_trade_limits set add_date = cast(to_char(to_timestamp(created_at/1000), 'YYYY-MM-DD hh24:mi:ss') AS TIMESTAMP);
UPDATE exposure_limits set add_date = cast(to_char(to_timestamp(created_at/1000), 'YYYY-MM-DD hh24:mi:ss') AS TIMESTAMP);

-- dealers 需要支持多个，长度需要修改
ALTER TABLE orders ALTER COLUMN dealers TYPE VARCHAR(255);

-- 将minimum_settlement_amount字段的非空属性去掉
ALTER TABLE lp_config ALTER minimum_settlement_amount drop not null;

-- 插入新的七条数据
INSERT INTO lp_config ( liquidity_provider_name, minimum_settlement_amount, status, created_at, update_at, add_date )
VALUES
	( 'cumberland', '100000', 'active', 1668662680, 1668662680, '2022-11-17 13:24:39' ),
	( '24exchange', NULL, 'active', 1668662680, 1668662680, '2022-11-17 13:24:39' ),
	( 'galaxy', NULL, 'active', 1668662680, 1668662680, '2022-11-17 13:24:39' ),
	( 'okcoin', NULL, 'active', 1668662680, 1668662680, '2022-11-17 13:24:39' ),
	( 'flowtraders', '100000', 'active', 1668662680, 1668662680, '2022-11-17 13:24:39' ),
	( 'binance', NULL, 'active', 1668662680, 1668662680, '2022-11-17 13:24:39' ),
	( 'kucoin', NULL, 'active', 1668662680, 1668662680, '2022-11-17 13:24:39' );

-- 修改 DAI/EUR 的下单数量小数位限制
update symbols set qty_sig=2 where ticker='DAI/EUR';