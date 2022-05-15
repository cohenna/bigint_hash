DELIMITER $$
DROP FUNCTION IF EXISTS bigint_hash;
DROP FUNCTION IF EXISTS bigint_hash_with_algorithm;

/*
    Supports the following cryptographic hash functions: 
        MD5 (default)
        SHA1
        SHA2: SHA-512, SHA-384, SHA-256, SHA-224
*/
CREATE FUNCTION bigint_hash_with_algorithm(input_string text, algorithm varchar(8)) RETURNS BIGINT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE id BIGINT UNSIGNED DEFAULT 0;
    DECLARE hash_value TEXT;

    IF algorithm = 'SHA-512' THEN
        SET hash_value = SHA2(input_string, 512);
    ELSEIF algorithm = 'MD5' THEN
        SET hash_value = MD5(input_string);
    ELSEIF algorithm = 'SHA1' THEN
        SET hash_value = SHA1(input_string);
    ELSEIF algorithm = 'SHA-224' THEN
        SET hash_value = SHA2(input_string, 224);
    ELSEIF algorithm = 'SHA-256' THEN
        SET hash_value = SHA2(input_string, 256);
    ELSEIF algorithm = 'SHA-384' THEN
        SET hash_value = SHA2(input_string, 384);
    END IF;

    SET id= conv(substring(hash_value,1,8),16,10);

    RETURN (id);
END $$

CREATE FUNCTION bigint_hash(input_string text) RETURNS BIGINT UNSIGNED
DETERMINISTIC
BEGIN
RETURN (bigint_hash_with_algorithm(input_string, 'MD5'));
END $$

DELIMITER ;

