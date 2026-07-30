-- ============================================================================
-- Event Booking - Per-ticket-type "Max purchase" limit
-- Adds a per-price "Max purchase" (max quantity of that ticket type one
-- customer can buy in a single booking; 0 = unlimited) to the event's
-- Price and Recurring section, enforced on the frontend + server.
-- ============================================================================

-- --- Schema: max_purchase column on prices (0 = unlimited) -------------------
ALTER TABLE `prices` ADD COLUMN `max_purchase` int(10) unsigned NOT NULL DEFAULT 0 AFTER `available`;

-- --- Backend label: the "Max purchase" column header ------------------------
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'lblMaxPurchase', 'backend', 'lblMaxPurchase', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'lblMaxPurchase');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'lblMaxPurchase' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Max purchase', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

-- --- Frontend message when the per-ticket limit is exceeded ({X} = limit) ----
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_ebc_max_purchase', 'frontend', 'front_ebc_max_purchase', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_ebc_max_purchase');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_ebc_max_purchase' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'You can buy up to {X} of this ticket type per booking.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');
