-- ============================================================================
-- Event Booking - Global "Maximum tickets per booking" option
-- Adds a Booking Options setting (o_max_tickets, 0 = unlimited) that caps how
-- many tickets one customer can select for an event in the frontend.
-- Idempotent: safe to run more than once.
-- ============================================================================
START TRANSACTION;

-- --- Option row (Booking Options tab = 1, int, default 0 = unlimited) --------
INSERT INTO `options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`)
SELECT 1, 'o_max_tickets', 1, '0', NULL, 'int', 18, 1, NULL FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `foreign_id` = 1 AND `key` = 'o_max_tickets');

-- --- Backend label shown on the Booking Options form -------------------------
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'opt_o_max_tickets', 'backend', 'opt_o_max_tickets', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'opt_o_max_tickets');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'opt_o_max_tickets' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Maximum tickets per booking (0 = unlimited)', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

-- --- Frontend message shown when the limit is exceeded ({X} = the limit) -----
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_ebc_max_tickets', 'frontend', 'front_ebc_max_tickets', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_ebc_max_tickets');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_ebc_max_tickets' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'You can book up to {X} tickets per booking.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

COMMIT;
