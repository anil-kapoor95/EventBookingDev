-- ============================================================================
-- Event Booking - Discount codes / Voucher module
-- Ported from the PHPJabbers Shopping Cart voucher module.
-- Applied by the built-in updater (unprefixed table names are auto-prefixed).
-- Adds: vouchers + vouchers_events tables, booking discount columns,
--       admin ACL + menu permissions, and all UI language strings.
-- ============================================================================

-- --- Schema: booking discount columns (run once) ---------------------------
ALTER TABLE `bookings` ADD COLUMN `booking_discount` decimal(9,2) unsigned DEFAULT NULL AFTER `booking_tax`;
ALTER TABLE `bookings` ADD COLUMN `voucher_code` varchar(255) DEFAULT NULL AFTER `booking_discount`;

-- --- Schema: voucher tables -------------------------------------------------
CREATE TABLE IF NOT EXISTS `vouchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `type` enum('amount','percent') DEFAULT NULL,
  `apply` enum('total','each') DEFAULT 'each',
  `discount` decimal(9,2) unsigned DEFAULT NULL,
  `valid` enum('fixed','period','recurring') DEFAULT NULL,
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  `time_from` time DEFAULT NULL,
  `time_to` time DEFAULT NULL,
  `every` enum('monday','tuesday','wednesday','thursday','friday','saturday','sunday') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `vouchers_events` (
  `voucher_id` int(10) unsigned NOT NULL,
  `event_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`voucher_id`,`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --- Access control: permission tree ---------------------------------------
INSERT INTO `plugin_auth_permissions` (`id`, `parent_id`, `key`)
SELECT NULL, NULL, 'pjAdminVouchers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers');
SET @vouchers_l1 := (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers' LIMIT 1);

INSERT INTO `plugin_auth_permissions` (`id`, `parent_id`, `key`)
SELECT NULL, @vouchers_l1, 'pjAdminVouchers_pjActionIndex' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionIndex');
SET @vouchers_l2 := (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionIndex' LIMIT 1);

INSERT INTO `plugin_auth_permissions` (`id`, `parent_id`, `key`)
SELECT NULL, @vouchers_l2, 'pjAdminVouchers_pjActionCreate' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionCreate');

INSERT INTO `plugin_auth_permissions` (`id`, `parent_id`, `key`)
SELECT NULL, @vouchers_l2, 'pjAdminVouchers_pjActionUpdate' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionUpdate');

INSERT INTO `plugin_auth_permissions` (`id`, `parent_id`, `key`)
SELECT NULL, @vouchers_l2, 'pjAdminVouchers_pjActionDeleteVoucher' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucher');

INSERT INTO `plugin_auth_permissions` (`id`, `parent_id`, `key`)
SELECT NULL, @vouchers_l2, 'pjAdminVouchers_pjActionDeleteVoucherBulk' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucherBulk');

-- --- Grant voucher permissions to roles that already manage events ----------
INSERT INTO `plugin_auth_roles_permissions` (`id`, `role_id`, `permission_id`)
SELECT NULL, r.role_id, (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers' LIMIT 1)
FROM `plugin_auth_roles_permissions` r
WHERE r.permission_id IN (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminEvents')
AND NOT EXISTS (SELECT 1 FROM `plugin_auth_roles_permissions` x WHERE x.role_id = r.role_id AND x.permission_id = (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers' LIMIT 1));

INSERT INTO `plugin_auth_roles_permissions` (`id`, `role_id`, `permission_id`)
SELECT NULL, r.role_id, (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionIndex' LIMIT 1)
FROM `plugin_auth_roles_permissions` r
WHERE r.permission_id IN (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminEvents')
AND NOT EXISTS (SELECT 1 FROM `plugin_auth_roles_permissions` x WHERE x.role_id = r.role_id AND x.permission_id = (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionIndex' LIMIT 1));

INSERT INTO `plugin_auth_roles_permissions` (`id`, `role_id`, `permission_id`)
SELECT NULL, r.role_id, (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionCreate' LIMIT 1)
FROM `plugin_auth_roles_permissions` r
WHERE r.permission_id IN (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminEvents')
AND NOT EXISTS (SELECT 1 FROM `plugin_auth_roles_permissions` x WHERE x.role_id = r.role_id AND x.permission_id = (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionCreate' LIMIT 1));

INSERT INTO `plugin_auth_roles_permissions` (`id`, `role_id`, `permission_id`)
SELECT NULL, r.role_id, (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionUpdate' LIMIT 1)
FROM `plugin_auth_roles_permissions` r
WHERE r.permission_id IN (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminEvents')
AND NOT EXISTS (SELECT 1 FROM `plugin_auth_roles_permissions` x WHERE x.role_id = r.role_id AND x.permission_id = (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionUpdate' LIMIT 1));

INSERT INTO `plugin_auth_roles_permissions` (`id`, `role_id`, `permission_id`)
SELECT NULL, r.role_id, (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucher' LIMIT 1)
FROM `plugin_auth_roles_permissions` r
WHERE r.permission_id IN (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminEvents')
AND NOT EXISTS (SELECT 1 FROM `plugin_auth_roles_permissions` x WHERE x.role_id = r.role_id AND x.permission_id = (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucher' LIMIT 1));

INSERT INTO `plugin_auth_roles_permissions` (`id`, `role_id`, `permission_id`)
SELECT NULL, r.role_id, (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucherBulk' LIMIT 1)
FROM `plugin_auth_roles_permissions` r
WHERE r.permission_id IN (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminEvents')
AND NOT EXISTS (SELECT 1 FROM `plugin_auth_roles_permissions` x WHERE x.role_id = r.role_id AND x.permission_id = (SELECT `id` FROM `plugin_auth_permissions` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucherBulk' LIMIT 1));

-- --- Backend labels for the permission tree (role editor) -------------------
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'pjAdminVouchers', 'backend', 'pjAdminVouchers', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount codes Menu', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'pjAdminVouchers_pjActionIndex', 'backend', 'pjAdminVouchers_pjActionIndex', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionIndex');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionIndex' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount codes List', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'pjAdminVouchers_pjActionCreate', 'backend', 'pjAdminVouchers_pjActionCreate', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionCreate');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionCreate' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Add discount code', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'pjAdminVouchers_pjActionUpdate', 'backend', 'pjAdminVouchers_pjActionUpdate', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionUpdate');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionUpdate' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Edit discount code', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'pjAdminVouchers_pjActionDeleteVoucher', 'backend', 'pjAdminVouchers_pjActionDeleteVoucher', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucher');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucher' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Delete single discount code', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'pjAdminVouchers_pjActionDeleteVoucherBulk', 'backend', 'pjAdminVouchers_pjActionDeleteVoucherBulk', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucherBulk');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'pjAdminVouchers_pjActionDeleteVoucherBulk' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Delete multiple discount codes', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

-- --- Admin voucher UI language strings --------------------------------------
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'menuVouchers', 'backend', 'menuVouchers', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'menuVouchers');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'menuVouchers' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount codes', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'infoVouchersTitle', 'backend', 'infoVouchersTitle', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'infoVouchersTitle');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'infoVouchersTitle' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'List of discount codes', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'infoVouchersDesc', 'backend', 'infoVouchersDesc', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'infoVouchersDesc');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'infoVouchersDesc' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'You can find below the list of discount codes. Click the pencil icon to view or edit a discount code, or click the "+ Add discount code" button to create a new one. The discount code is what customers type when booking; the rule value is how much is taken off.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'lblApplyDiscountFor', 'backend', 'lblApplyDiscountFor', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'lblApplyDiscountFor');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'lblApplyDiscountFor' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Apply discount for', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'lblValidateTime', 'backend', 'lblValidateTime', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'lblValidateTime');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'lblValidateTime' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'End time must be greater than start time.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_choose', 'backend', 'voucher_choose', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_choose');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_choose' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', '-- Choose --', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_code', 'backend', 'voucher_code', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_code');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_code' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount code', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_code_exist', 'backend', 'voucher_code_exist', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_code_exist');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_code_exist' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'The discount code is already used.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_create', 'backend', 'voucher_create', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_create');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_create' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Add discount code', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_date', 'backend', 'voucher_date', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_date');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_date' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Date', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_date_from', 'backend', 'voucher_date_from', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_date_from');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_date_from' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'From date/time', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_date_to', 'backend', 'voucher_date_to', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_date_to');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_date_to' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'To date/time', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_discount', 'backend', 'voucher_discount', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_discount');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_discount' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Rule value', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_discount_hint', 'backend', 'voucher_discount_hint', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_discount_hint');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_discount_hint' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'How much this code removes: a percentage or a fixed amount (see Type). This sets the rule, not the final booking total.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_every', 'backend', 'voucher_every', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_every');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_every' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Every', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_events', 'backend', 'voucher_events', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_events');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_events' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Events', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_time_from', 'backend', 'voucher_time_from', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_time_from');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_time_from' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Time from', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_time_to', 'backend', 'voucher_time_to', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_time_to');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_time_to' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Time to', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_type', 'backend', 'voucher_type', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_type');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_type' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Type', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_valid', 'backend', 'voucher_valid', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_valid');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_valid' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Valid', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_validate_datetime', 'backend', 'voucher_validate_datetime', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_validate_datetime');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_validate_datetime' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'To date/time must be greater than From date/time.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_validate_time', 'backend', 'voucher_validate_time', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_validate_time');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_validate_time' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'End time must be greater than start time.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_validate_time', 'backend', 'vouchers_validate_time', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_validate_time');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_validate_time' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'End time must be greater than start time.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_infobox_add_voucher_title', 'backend', 'vouchers_infobox_add_voucher_title', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_infobox_add_voucher_title');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_infobox_add_voucher_title' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Add discount code', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_infobox_add_voucher_desc', 'backend', 'vouchers_infobox_add_voucher_desc', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_infobox_add_voucher_desc');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_infobox_add_voucher_desc' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Please fill out the form below to add a discount code. You can add a discount code for a specific date, a day of the week, or a date range.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_infobox_update_voucher_title', 'backend', 'vouchers_infobox_update_voucher_title', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_infobox_update_voucher_title');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_infobox_update_voucher_title' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Update discount code', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_infobox_update_voucher_desc', 'backend', 'vouchers_infobox_update_voucher_desc', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_infobox_update_voucher_desc');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_infobox_update_voucher_desc' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Please make any change you want on the form below to update the discount code information and click the SAVE button.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

-- --- Admin voucher dropdown/array language strings -------------------------
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'apply_arr_ARRAY_each', 'backend', 'apply_arr_ARRAY_each', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'apply_arr_ARRAY_each');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'apply_arr_ARRAY_each' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Each ticket', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'apply_arr_ARRAY_total', 'backend', 'apply_arr_ARRAY_total', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'apply_arr_ARRAY_total');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'apply_arr_ARRAY_total' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Tickets total amount', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_types_ARRAY_amount', 'backend', 'voucher_types_ARRAY_amount', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_types_ARRAY_amount');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_types_ARRAY_amount' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Amount', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_types_ARRAY_percent', 'backend', 'voucher_types_ARRAY_percent', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_types_ARRAY_percent');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_types_ARRAY_percent' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Percent', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_types_ARRAY_amount', 'backend', 'vouchers_types_ARRAY_amount', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_types_ARRAY_amount');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_types_ARRAY_amount' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Amount', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_types_ARRAY_percent', 'backend', 'vouchers_types_ARRAY_percent', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_types_ARRAY_percent');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_types_ARRAY_percent' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Percent', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_valids_ARRAY_fixed', 'backend', 'voucher_valids_ARRAY_fixed', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_valids_ARRAY_fixed');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_valids_ARRAY_fixed' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Fixed date', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_valids_ARRAY_period', 'backend', 'voucher_valids_ARRAY_period', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_valids_ARRAY_period');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_valids_ARRAY_period' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Period', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'voucher_valids_ARRAY_recurring', 'backend', 'voucher_valids_ARRAY_recurring', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'voucher_valids_ARRAY_recurring');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'voucher_valids_ARRAY_recurring' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Recurring', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_days_ARRAY_monday', 'backend', 'vouchers_days_ARRAY_monday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_monday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_monday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Monday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'daynames_ARRAY_monday', 'backend', 'daynames_ARRAY_monday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_monday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_monday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Monday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_days_ARRAY_tuesday', 'backend', 'vouchers_days_ARRAY_tuesday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_tuesday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_tuesday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Tuesday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'daynames_ARRAY_tuesday', 'backend', 'daynames_ARRAY_tuesday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_tuesday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_tuesday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Tuesday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_days_ARRAY_wednesday', 'backend', 'vouchers_days_ARRAY_wednesday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_wednesday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_wednesday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Wednesday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'daynames_ARRAY_wednesday', 'backend', 'daynames_ARRAY_wednesday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_wednesday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_wednesday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Wednesday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_days_ARRAY_thursday', 'backend', 'vouchers_days_ARRAY_thursday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_thursday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_thursday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Thursday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'daynames_ARRAY_thursday', 'backend', 'daynames_ARRAY_thursday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_thursday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_thursday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Thursday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_days_ARRAY_friday', 'backend', 'vouchers_days_ARRAY_friday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_friday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_friday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Friday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'daynames_ARRAY_friday', 'backend', 'daynames_ARRAY_friday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_friday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_friday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Friday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_days_ARRAY_saturday', 'backend', 'vouchers_days_ARRAY_saturday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_saturday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_saturday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Saturday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'daynames_ARRAY_saturday', 'backend', 'daynames_ARRAY_saturday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_saturday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_saturday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Saturday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'vouchers_days_ARRAY_sunday', 'backend', 'vouchers_days_ARRAY_sunday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_sunday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'vouchers_days_ARRAY_sunday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Sunday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'daynames_ARRAY_sunday', 'backend', 'daynames_ARRAY_sunday', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_sunday');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'daynames_ARRAY_sunday' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Sunday', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

-- --- Admin result messages (error_titles / error_bodies) -------------------
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_titles_ARRAY_AV01', 'backend', 'error_titles_ARRAY_AV01', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV01');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV01' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount code has been added', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_bodies_ARRAY_AV01', 'backend', 'error_bodies_ARRAY_AV01', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV01');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV01' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'The discount code has been created successfully.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_titles_ARRAY_AV02', 'backend', 'error_titles_ARRAY_AV02', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV02');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV02' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount code has not been added', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_bodies_ARRAY_AV02', 'backend', 'error_bodies_ARRAY_AV02', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV02');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV02' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Sorry, but the discount code has not been added.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_titles_ARRAY_AV05', 'backend', 'error_titles_ARRAY_AV05', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV05');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV05' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount code has been updated', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_bodies_ARRAY_AV05', 'backend', 'error_bodies_ARRAY_AV05', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV05');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV05' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'All the changes made to this discount code have been saved.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_titles_ARRAY_AV06', 'backend', 'error_titles_ARRAY_AV06', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV06');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV06' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount code has not been updated', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_bodies_ARRAY_AV06', 'backend', 'error_bodies_ARRAY_AV06', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV06');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV06' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Sorry, but the discount code has not been updated.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_titles_ARRAY_AV08', 'backend', 'error_titles_ARRAY_AV08', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV08');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_titles_ARRAY_AV08' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount code does not exist', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'error_bodies_ARRAY_AV08', 'backend', 'error_bodies_ARRAY_AV08', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV08');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'error_bodies_ARRAY_AV08' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Sorry, but the discount code you are trying to edit does not exist.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

-- --- Frontend voucher language strings --------------------------------------
INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_label_discount_code', 'frontend', 'front_label_discount_code', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_label_discount_code');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_label_discount_code' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount code', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_label_discount', 'frontend', 'front_label_discount', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_label_discount');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_label_discount' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_button_apply', 'frontend', 'front_button_apply', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_button_apply');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_button_apply' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Apply', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_button_remove', 'frontend', 'front_button_remove', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_button_remove');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_button_remove' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Remove', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_voucher_missing', 'frontend', 'front_voucher_missing', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_voucher_missing');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_voucher_missing' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Please enter a discount code.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_voucher_not_found', 'frontend', 'front_voucher_not_found', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_voucher_not_found');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_voucher_not_found' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'The discount code you entered is not valid.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_voucher_expired', 'frontend', 'front_voucher_expired', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_voucher_expired');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_voucher_expired' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'This discount code is not valid at this time.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_voucher_applied', 'frontend', 'front_voucher_applied', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_voucher_applied');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_voucher_applied' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'Discount code applied.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

INSERT INTO `plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`)
SELECT NULL, 'front_voucher_not_for_event', 'frontend', 'front_voucher_not_for_event', 'script', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `plugin_base_fields` WHERE `key` = 'front_voucher_not_for_event');
SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'front_voucher_not_for_event' LIMIT 1);
INSERT INTO `plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, @id, 'pjBaseField', l.id, 'title', 'This discount code cannot be used for this event.', 'script'
FROM `plugin_base_locale` l
WHERE @id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `plugin_base_multi_lang` m WHERE m.`foreign_id` = @id AND m.`model` = 'pjBaseField' AND m.`locale` = l.id AND m.`field` = 'title');

