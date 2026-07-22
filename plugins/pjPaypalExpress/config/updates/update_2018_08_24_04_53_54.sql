
START TRANSACTION;

SET @label := 'Plugin PayPal Express / Yes';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'plugin_paypal_express_yesno_ARRAY_T', 'arrays', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'arrays', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'Yes';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'plugin_paypal_express_yesno_ARRAY_T' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

SET @label := 'Plugin PayPal Express / No';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'plugin_paypal_express_yesno_ARRAY_F', 'arrays', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'arrays', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'No';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'plugin_paypal_express_yesno_ARRAY_F' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

COMMIT;