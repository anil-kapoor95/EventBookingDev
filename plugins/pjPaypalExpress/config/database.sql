
START TRANSACTION;

INSERT INTO `plugin_payment_options` (`payment_method`) VALUES ('paypal_express');

SET @label := 'Plugin PayPal Express / PayPal Express Checkout';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'payment_methods_ARRAY_paypal_express', 'arrays', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'arrays', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'PayPal Express Checkout';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'payment_methods_ARRAY_paypal_express' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

SET @label := 'Plugin PayPal Express / PayPal Express Checkout payment';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'plugin_paypal_express_payment_title', 'backend', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'backend', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'PayPal Express Checkout payment';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'plugin_paypal_express_payment_title' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

SET @label := 'Plugin PayPal Express / Allow PayPal Express Checkout payments';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'plugin_paypal_express_allow', 'backend', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'backend', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'Allow PayPal Express Checkout payments';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'plugin_paypal_express_allow' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

SET @label := 'Plugin PayPal Express / Client ID';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'plugin_paypal_express_merchant_id', 'backend', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'backend', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'Client ID';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'plugin_paypal_express_merchant_id' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

SET @label := 'Plugin PayPal Express / Profile ID';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'plugin_paypal_express_public_key', 'backend', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'backend', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'Profile ID';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'plugin_paypal_express_public_key' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

SET @label := 'Plugin PayPal Express / PayPal Express Checkout secret:';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'plugin_paypal_express_private_key', 'backend', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'backend', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'PayPal Express Checkout secret:';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'plugin_paypal_express_private_key' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

SET @label := 'Plugin PayPal Express / Your order is saved. Redirecting to PayPal Express Checkout...';
INSERT INTO `fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES (NULL, 'payment_plugin_messages_ARRAY_paypal_express', 'arrays', @label, 'plugin', NULL)
ON DUPLICATE KEY UPDATE `fields`.`type` = 'arrays', `label` = @label, `source` = 'plugin', `modified` = NULL;
SET @content := 'Your order is saved. Redirecting to PayPal Express Checkout...';
INSERT INTO `multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
SELECT NULL, `id`, 'pjCmsField', '::LOCALE::', 'title', @content, 'plugin' FROM `fields` WHERE `key` = 'payment_plugin_messages_ARRAY_paypal_express' ON DUPLICATE KEY UPDATE `multi_lang`.`content` = @content, `source` = 'plugin';

COMMIT;