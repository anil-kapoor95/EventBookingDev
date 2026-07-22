
START TRANSACTION;

SET @label := 'Plugin PayPal Express / Label';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'plugin_paypal_express_payment_label', 'backend', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'backend', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'Label';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'plugin_paypal_express_payment_label' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

COMMIT;