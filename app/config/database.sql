
DROP TABLE IF EXISTS `eventbooking_bookings`;
CREATE TABLE IF NOT EXISTS `eventbooking_bookings` (
	 `id` int(10) unsigned NOT NULL AUTO_INCREMENT,                                        
	 `unique_id` varchar(255) DEFAULT NULL,                                                
	 `event_id` int(10) unsigned DEFAULT NULL,                                             
	 `booking_total` decimal(9,2) unsigned DEFAULT NULL,                                   
	 `booking_deposit` decimal(9,2) unsigned DEFAULT NULL,                                 
	 `booking_tax` decimal(9,2) unsigned DEFAULT NULL,                                     
	 `booking_status` enum('pending','confirmed','cancelled') DEFAULT NULL,                
	 `payment_method` varchar(255) DEFAULT NULL,  
	 `payment_option` enum('deposit','total') DEFAULT NULL,                                
	 `customer_name` varchar(255) DEFAULT NULL,                                            
	 `customer_email` varchar(255) DEFAULT NULL,                                           
	 `customer_phone` varchar(255) DEFAULT NULL,                                           
	 `customer_country` int(10) unsigned DEFAULT NULL,                                     
	 `customer_city` varchar(255) DEFAULT NULL,                                            
	 `customer_state` varchar(255) DEFAULT NULL,                                           
	 `customer_zip` varchar(255) DEFAULT NULL,                                             
	 `customer_address` varchar(255) DEFAULT NULL,                                         
	 `customer_notes` text,                                                                
	 `customer_ip` varchar(255) DEFAULT NULL,                                              
	 `customer_people` smallint(5) unsigned DEFAULT NULL,                                  
	 `cc_type` varchar(255) DEFAULT NULL,                                                  
	 `cc_num` blob,                                                                        
	 `cc_exp` blob,                                                                        
	 `cc_code` blob,                                                                       
	 `txn_id` varchar(255) DEFAULT NULL,                                                   
	 `processed_on` datetime DEFAULT NULL,                                                 
	 `reminder_email` enum('T','F') NOT NULL DEFAULT 'F',                                  
	 `reminder_sms` enum('T','F') NOT NULL DEFAULT 'F',                                    
	 `created` datetime DEFAULT NULL,                                                      
	 `modified` datetime DEFAULT NULL,                                                     
	 PRIMARY KEY (`id`),                                                                   
	 KEY `event_id` (`event_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `eventbooking_bookings_details`;
CREATE TABLE IF NOT EXISTS `eventbooking_bookings_details` (
	`booking_id` int(10) unsigned NOT NULL DEFAULT '0',  
	`price_id` int(10) unsigned NOT NULL DEFAULT '0',    
	`price` decimal(9,2) unsigned DEFAULT NULL,          
	`unit_price` decimal(9,2) unsigned DEFAULT NULL,     
	`price_title` varchar(255) DEFAULT NULL,             
	`cnt` smallint(5) unsigned DEFAULT NULL,             
	PRIMARY KEY (`booking_id`,`price_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `eventbooking_bookings_tickets`;
CREATE TABLE IF NOT EXISTS `eventbooking_bookings_tickets` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,       
	`booking_id` int(10) unsigned NOT NULL DEFAULT '0',  
	`ticket_id` varchar(255) DEFAULT NULL,               
	`price_id` int(10) unsigned DEFAULT NULL,            
	`unit_price` decimal(9,2) unsigned DEFAULT NULL,     
	`price_title` varchar(255) DEFAULT NULL,             
	`is_used` enum('T','F') NOT NULL DEFAULT 'F',        
	PRIMARY KEY (`id`),                                  
	KEY `booking_id` (`ticket_id`,`booking_id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `eventbooking_categories`;
CREATE TABLE IF NOT EXISTS `eventbooking_categories` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`status` enum('T','F') NOT NULL DEFAULT 'T',    
	PRIMARY KEY (`id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `eventbooking_events`;
CREATE TABLE IF NOT EXISTS `eventbooking_events` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,             
	`recurring_id` varchar(255) DEFAULT NULL,                  
	`category_id` int(11) DEFAULT NULL,                        
	`event_start_ts` int(10) unsigned NOT NULL,                
	`event_end_ts` int(10) unsigned NOT NULL,                  
	`event_img` varchar(255) DEFAULT NULL,                     
	`event_thumb` varchar(255) DEFAULT NULL,                   
	`event_medium` varchar(255) DEFAULT NULL,                                                 
	`o_show_start_time` enum('T','F') DEFAULT 'T',             
	`o_show_end_time` enum('T','F') DEFAULT 'T',                                                          
	`ticket_img` varchar(255) DEFAULT NULL,                    
	`status` enum('T','F') NOT NULL DEFAULT 'T',               
	PRIMARY KEY (`id`)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `eventbooking_categories`;
CREATE TABLE IF NOT EXISTS `eventbooking_categories` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`status` enum('T','F') NOT NULL DEFAULT 'T',    
	PRIMARY KEY (`id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `eventbooking_options`;
CREATE TABLE IF NOT EXISTS `eventbooking_options` (
  `foreign_id` int(10) unsigned NOT NULL DEFAULT '0',
  `key` varchar(255) NOT NULL DEFAULT '',
  `tab_id` tinyint(3) unsigned DEFAULT NULL,
  `value` text,
  `label` text,
  `type` enum('string','text','int','float','enum','bool','color') NOT NULL DEFAULT 'string',
  `order` int(10) unsigned DEFAULT NULL,
  `is_visible` tinyint(1) unsigned DEFAULT '1',
  `style` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`foreign_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `eventbooking_options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES

(1,'o_enable_categories',1,'Yes|No::Yes',NULL,'enum',1,0,NULL),
(1,'o_enable_monthly_view',1,'Yes|No::Yes',NULL,'enum',2,1,NULL),
(1,'o_enable_list_view',1,'Yes|No::Yes',NULL,'enum',3,1,NULL),
(1,'o_events_per_page',1,'5',NULL,'int',4,1,NULL),
(1,'o_display_events',1,'below|replace::below','Below calendar|Replace calendar','enum',5,1,NULL),
(1,'o_event_title_position',1,'tooltip|hidden::tooltip','Tooltip|Hidden','enum',6,1,NULL),
(1,'o_display_available_tickets',1,'Yes|No::Yes',NULL,'enum',7,1,NULL),
(1,'o_default_status_if_not_paid',1,'confirmed|pending|cancelled::pending','Confirmed|Pending|Cancel','enum',8,1,NULL),
(1,'o_default_status_if_paid',1,'confirmed|pending|cancelled::confirmed','Confirmed|Pending|Cancel','enum',9,1,NULL),
(1,'o_deposit_payment',1,'10',NULL,'float',10,1,NULL),
(1,'o_tax_payment',1,'0',NULL,'float',11,1,NULL),
(1,'o_booking_before_hours',1,'0',NULL,'int',12,1,NULL),
(1,'o_require_all_within_days',1,'0',NULL,'int',13,1,NULL),
(1,'o_payment_disable',1,'Yes|No::No',NULL,'enum',14,1,NULL),
(1,'o_thankyou_page',1,'https://www.phpjabbers.com',NULL,'string',15,1,NULL),
(1,'o_cancel_booking_page',1,'https://www.phpjabbers.com',NULL,'string',16,1,NULL),
(1,'o_theme',1,'theme1|theme2|theme3|theme4|theme5|theme6|theme7|theme8|theme9|theme10::theme1','Theme 1|Theme 2|Theme 3|Theme 4|Theme 5|Theme 6|Theme 7|Theme 8|Theme 9|Theme 10','enum',17,0,NULL),

(1,'o_allow_authorize',2,'Yes|No::No',NULL,'enum',11,1,NULL),
(1,'o_allow_bank',2,'Yes|No::No',NULL,'enum',17,1,NULL),
(1,'o_allow_cash',2,'Yes|No::No',NULL,'enum',19,1,NULL),
(1,'o_allow_creditcard',2,'Yes|No::No',NULL,'enum',16,1,NULL),
(1,'o_allow_paypal',2,'Yes|No::Yes',NULL,'enum',9,1,NULL),
(1,'o_authorize_md5_hash',2,NULL,NULL,'string',15,1,NULL),
(1,'o_authorize_merchant_id',2,NULL,NULL,'string',12,1,NULL),
(1,'o_authorize_timezone',2,'-43200|-39600|-36000|-32400|-28800|-25200|-21600|-18000|-14400|-10800|-7200|-3600|0|3600|7200|10800|14400|18000|21600|25200|28800|32400|36000|39600|43200|46800::0','GMT-12:00|GMT-11:00|GMT-10:00|GMT-09:00|GMT-08:00|GMT-07:00|GMT-06:00|GMT-05:00|GMT-04:00|GMT-03:00|GMT-02:00|GMT-01:00|GMT|GMT+01:00|GMT+02:00|GMT+03:00|GMT+04:00|GMT+05:00|GMT+06:00|GMT+07:00|GMT+08:00|GMT+09:00|GMT+10:00|GMT+11:00|GMT+12:00|GMT+13:00','enum',14,1,NULL),
(1,'o_authorize_transkey',2,NULL,NULL,'string',13,1,NULL),
(1,'o_bank_account',2,NULL,NULL,'text',18,1,NULL),
(1,'o_paypal_address',2,'paypal_seller@example.com',NULL,'string',10,1,NULL),

(1,'o_bf_include_name',3,'1|2|3::3','No|Yes|Yes (required)','enum',1,1,NULL),
(1,'o_bf_include_email',3,'1|2|3::3','No|Yes|Yes (required)','enum',2,1,NULL),
(1,'o_bf_include_phone',3,'1|2|3::3','No|Yes|Yes (required)','enum',3,1,NULL),
(1,'o_bf_include_address',3,'1|2|3::2','No|Yes|Yes (required)','enum',4,1,NULL),
(1,'o_bf_include_country',3,'1|2|3::2','No|Yes|Yes (required)','enum',5,1,NULL),
(1,'o_bf_include_state',3,'1|2|3::2','No|Yes|Yes (required)','enum',6,1,NULL),
(1,'o_bf_include_city',3,'1|2|3::2','No|Yes|Yes (required)','enum',7,1,NULL),
(1,'o_bf_include_zip',3,'1|2|3::2','No|Yes|Yes (required)','enum',8,1,NULL),
(1,'o_bf_include_notes',3,'1|2|3::2','No|Yes|Yes (required)','enum',9,1,NULL),
(1,'o_bf_include_captcha',3,'1|2|3::3','No|Yes|Yes (required)','enum',10,1,NULL),

(1,'o_email_confirmation',4,'',NULL,'string',2,1,NULL),
(1,'o_email_confirmation_subject',4,'',NULL,'text',1,1,NULL),
(1,'o_email_payment',4,'',NULL,'string',4,1,NULL),
(1,'o_email_payment_subject',4,'',NULL,'text',3,1,NULL),

(1,'o_fields_index',99,'d874fcc5fe73b90d770a544664a3775d',NULL,'string',NULL,0,NULL),
(1,'o_multi_lang',99,'1|0::1','Yes|No','enum',NULL,1,NULL),
(1,'private_key',99,'NI4YgofKJtFVT+XV+4U+SfvutZHEN+phXpbJfY/fkt1MC8WnhAC6BTvi6eHegYKfwnEKGmglRj/IhGQXEJijX+vnHoWFSrHCuWWijd+EmYdQY2FY677guc9R7cRjFhDTD/7YzhERyW0SEqs3oBw9h8ROrDyP+cpZzsYqmk0UNbzXEz6aGwdUz1gCejuZ8c2JWT7DOg9tykRA647FZs8HR0OPGjyO7vHFx/eJ5PKnSP3BLZChHzhE+DNVXEeUOSELCalGfdYODyOpfqLv18MkCr6W8L29yfOn2nvhMw3jop5F0KoZCbhs7TCc0mC6GmCZ0YR9/3DjWaKJdGvuPJWTmg==',NULL,'string',NULL,1,NULL);

UPDATE `eventbooking_plugin_base_options` SET `value`='Yes|No::Yes' WHERE `key`='o_auto_backup';

DROP TABLE IF EXISTS `eventbooking_password`;
CREATE TABLE IF NOT EXISTS `eventbooking_password` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `calendar_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `format` enum('ical','xml', 'csv') NOT NULL DEFAULT 'ical',
  `delimiter` enum('comma','semicolon', 'tab') DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `type` enum('all','next','last') DEFAULT NULL,
  `period` enum('1','2','3','4','5','6') NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `eventbooking_notifications`;
CREATE TABLE IF NOT EXISTS `eventbooking_notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `foreign_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `recipient` enum('client','admin', 'owner') DEFAULT NULL,
  `transport` enum('email','sms') DEFAULT NULL,
  `variant` varchar(30) DEFAULT NULL,
  `is_active` tinyint(1) unsigned DEFAULT '1',
  `is_general` tinyint(1) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `recipient` (`foreign_id`,`recipient`,`transport`,`variant`, `is_general`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `eventbooking_prices`;
CREATE TABLE IF NOT EXISTS `eventbooking_prices` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,       
	`event_id` int(10) unsigned DEFAULT NULL,            
	`recurring` varchar(100) DEFAULT NULL,               
	`price` decimal(9,2) DEFAULT NULL,                   
	`available` int(11) DEFAULT NULL,                    
	PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT IGNORE INTO `eventbooking_notifications` (`id`, `recipient`, `transport`, `variant`, `is_active`) VALUES
(1, 'client', 'email', 'confirmation', 1),
(2, 'client', 'email', 'payment', 1),
(3, 'client', 'email', 'cancel', 1),
(4, 'client', 'sms', 'confirmation', 1),
(5, 'client', 'sms', 'payment', 1),
(6, 'client', 'sms', 'cancel', 1),
(7, 'admin', 'email', 'confirmation', 1),
(8, 'admin', 'email', 'payment', 1),
(9, 'admin', 'email', 'cancel', 1),
(10, 'admin', 'sms', 'confirmation', 1),
(11, 'admin', 'sms', 'payment', 1),
(12, 'admin', 'sms', 'cancel', 1);

INSERT INTO `eventbooking_plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`) VALUES
(NULL, 1, 'pjPayment', 1, 'creditcard', 'Credit Card', 'script'),
(NULL, 1, 'pjPayment', 1, 'cash', 'Cash', 'script'),
(NULL, 1, 'pjPayment', 1, 'bank', 'Bank Account', 'script');


INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'script_name', 'backend', 'Label / Script Name', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event Booking Calendar', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'addLocale', 'backend', 'Add language', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add language', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'adminForgot', 'backend', 'Forgot password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password reminder', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'adminLogin', 'backend', 'Admin Login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Admin Login', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'backend', 'backend', 'Backend titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-end titles', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnAdd', 'backend', 'Button Add', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnBack', 'backend', 'Button Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '&laquo; Back', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnBackup', 'backend', 'Button Backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnCancel', 'backend', 'Button Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnContinue', 'backend', 'Button Continue', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Continue', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnDelete', 'backend', 'Button Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnLogin', 'backend', 'Login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnReset', 'backend', 'Reset', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reset', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnSave', 'backend', 'Save', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnSearch', 'backend', 'Search', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Search', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnSend', 'backend', 'Button Send', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnUpdate', 'backend', 'Update', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'created', 'backend', 'Created', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'DateTime', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'email', 'backend', 'E-Mail', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'emailForgotBody', 'backend', 'Email / Forgot Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dear {Name},Your password: {Password}', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'emailForgotSubject', 'backend', 'Email / Forgot Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password reminder', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'frontend', 'backend', 'Front-end titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front-end titles', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridActionTitle', 'backend', 'Grid / Action Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Action confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridBtnCancel', 'backend', 'Grid / Button Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridBtnDelete', 'backend', 'Grid / Button Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridBtnOk', 'backend', 'Grid / Button OK', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'OK', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridChooseAction', 'backend', 'Grid / Choose Action', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose Action', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridConfirmationTitle', 'backend', 'Grid / Confirmation Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete selected record?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridDeleteConfirmation', 'backend', 'Grid / Delete confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridEmptyResult', 'backend', 'Grid / Empty resultset', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No records found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridGotoPage', 'backend', 'Grid / Go to page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Go to page:', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridItemsPerPage', 'backend', 'Grid / Items per page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Items per page', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridNext', 'backend', 'Grid / Next', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next &raquo;', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridNextPage', 'backend', 'Grid / Next page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next page', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridPrev', 'backend', 'Grid / Prev', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '&laquo; Prev', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridPrevPage', 'backend', 'Grid / Prev page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prev page', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'gridTotalItems', 'backend', 'Grid / Total items', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total items:', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingAddressBody', 'backend', 'Infobox / Listing Address Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Address Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingAddressTitle', 'backend', 'Infobox / Listing Address Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Address Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingBookingsBody', 'backend', 'Infobox / Listing Bookings Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Bookings Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingBookingsTitle', 'backend', 'Infobox / Listing Bookings Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Bookings Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingContactBody', 'backend', 'Infobox / Listing Contact Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Contact Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingContactTitle', 'backend', 'Infobox / Listing Contact Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Contact Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingExtendBody', 'backend', 'Infobox / Extend exp.date Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extend exp.date Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingExtendTitle', 'backend', 'Infobox / Extend exp.date Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extend exp.date Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingPricesBody', 'backend', 'Infobox / Listing Prices Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Prices Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoListingPricesTitle', 'backend', 'Infobox / Listing Prices Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Prices Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoLocalesArraysBody', 'backend', 'Locale / Languages Array Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Array Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoLocalesArraysTitle', 'backend', 'Locale / Languages Array Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Arrays Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoLocalesBackendBody', 'backend', 'Infobox / Locales Backend Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Backend Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoLocalesBackendTitle', 'backend', 'Infobox / Locales Backend Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Backend Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoLocalesBody', 'backend', 'Infobox / Locales Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoLocalesFrontendBody', 'backend', 'Infobox / Locales Frontend Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Frontend Body', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoLocalesFrontendTitle', 'backend', 'Infobox / Locales Frontend Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Frontend Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoLocalesTitle', 'backend', 'Infobox / Locales Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAddUser', 'backend', 'Add user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add user', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBackupDatabase', 'backend', 'Backup / Database', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup database', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBackupFiles', 'backend', 'Backup / Files', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup files', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblChoose', 'backend', 'Choose', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDays', 'backend', 'Days', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'days', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDelete', 'backend', 'Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblError', 'backend', 'Error', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Error', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblExport', 'backend', 'Export', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblForgot', 'backend', 'Forgot password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblIp', 'backend', 'IP address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'IP address', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblIsActive', 'backend', 'Is Active', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Is confirmed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblName', 'backend', 'Name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblNo', 'backend', 'No', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOption', 'backend', 'Option', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Option', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOptionList', 'backend', 'Option list', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Option list', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblRole', 'backend', 'Role', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Role', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblStatus', 'backend', 'Status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblType', 'backend', 'Type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Type', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUpdateUser', 'backend', 'Update user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update user', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUserCreated', 'backend', 'User / Registration Date & Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Registration date/time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblValue', 'backend', 'Value', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Value', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblYes', 'backend', 'Yes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lnkBack', 'backend', 'Link Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'localeArrays', 'backend', 'Locale / Arrays titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Arrays titles', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'locales', 'backend', 'Languages', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'locale_flag', 'backend', 'Locale / Flag', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flag', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'locale_is_default', 'backend', 'Locale / Is default', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Is default', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'locale_order', 'backend', 'Locale / Order', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Order', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'locale_title', 'backend', 'Locale / Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuBackup', 'backend', 'Menu Backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuDashboard', 'backend', 'Menu Dashboard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dashboard', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuLang', 'backend', 'Menu Multi lang', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Multi Lang', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuLocales', 'backend', 'Menu Languages', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuLogout', 'backend', 'Menu Logout', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Logout', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuOptions', 'backend', 'Menu Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Options', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuPlugins', 'backend', 'Menu Plugins', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Plugins', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuProfile', 'backend', 'Menu Profile', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Profile', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuUsers', 'backend', 'Menu Users', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Users', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'multilangTooltip', 'backend', 'MultiLang / Tooltip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_currency', 'backend', 'Options / Currency', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Currency', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_date_format', 'backend', 'Options / Date format', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date format', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_timezone', 'backend', 'Options / Timezone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Timezone', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_week_start', 'backend', 'Options / First day of the week', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'First day of the week', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pass', 'backend', 'Password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pec_active', 'backend', 'Active', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pec_delete_selected', 'backend', 'Delete selected', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete selected', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pec_email_taken', 'backend', 'Users / Email already taken', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email address is already in use', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pec_inactive', 'backend', 'Inactive', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'revert_status', 'backend', 'Revert status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Revert status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'url', 'backend', 'URL', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'URL', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'user', 'backend', 'Username', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Username', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_ARRAY_0', 'arrays', 'days_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sunday', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_ARRAY_1', 'arrays', 'days_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Monday', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_ARRAY_2', 'arrays', 'days_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tuesday', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_ARRAY_3', 'arrays', 'days_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Wednesday', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_ARRAY_4', 'arrays', 'days_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Thursday', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_ARRAY_5', 'arrays', 'days_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Friday', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_ARRAY_6', 'arrays', 'days_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Saturday', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_0', 'arrays', 'day_names_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'S', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_1', 'arrays', 'day_names_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'M', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_2', 'arrays', 'day_names_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'T', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_3', 'arrays', 'day_names_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'W', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_4', 'arrays', 'day_names_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'T', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_5', 'arrays', 'day_names_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'F', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_6', 'arrays', 'day_names_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'S', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA10', 'arrays', 'error_bodies_ARRAY_AA10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Given email address is not associated with any account.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA11', 'arrays', 'error_bodies_ARRAY_AA11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'For further instructions please check your mailbox.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA12', 'arrays', 'error_bodies_ARRAY_AA12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We''re sorry, please try again later.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA13', 'arrays', 'error_bodies_ARRAY_AA13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to your profile have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB01', 'arrays', 'error_bodies_ARRAY_AB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We recommend you to regularly back up your database and files to prevent any loss of information.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB02', 'arrays', 'error_bodies_ARRAY_AB02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All backup files have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB03', 'arrays', 'error_bodies_ARRAY_AB03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No option was selected.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB04', 'arrays', 'error_bodies_ARRAY_AB04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup not performed.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ALC01', 'arrays', 'error_bodies_ARRAY_ALC01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to titles have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO01', 'arrays', 'error_bodies_ARRAY_AO01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to options have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU01', 'arrays', 'error_bodies_ARRAY_AU01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to this user have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU03', 'arrays', 'error_bodies_ARRAY_AU03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to this user have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU04', 'arrays', 'error_bodies_ARRAY_AU04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry, but the user has not been added.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU08', 'arrays', 'error_bodies_ARRAY_AU08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User your looking for is missing.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA10', 'arrays', 'error_titles_ARRAY_AA10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account not found!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA11', 'arrays', 'error_titles_ARRAY_AA11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password send!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA12', 'arrays', 'error_titles_ARRAY_AA12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password not send!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA13', 'arrays', 'error_titles_ARRAY_AA13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Profile updated!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB01', 'arrays', 'error_titles_ARRAY_AB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB02', 'arrays', 'error_titles_ARRAY_AB02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup complete!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB03', 'arrays', 'error_titles_ARRAY_AB03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB04', 'arrays', 'error_titles_ARRAY_AB04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO01', 'arrays', 'error_titles_ARRAY_AO01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Options updated!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU01', 'arrays', 'error_titles_ARRAY_AU01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User updated!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU03', 'arrays', 'error_titles_ARRAY_AU03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User added!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU04', 'arrays', 'error_titles_ARRAY_AU04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User failed to add.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU08', 'arrays', 'error_titles_ARRAY_AU08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User not found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_active', 'arrays', 'filter_ARRAY_active', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_inactive', 'arrays', 'filter_ARRAY_inactive', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_1', 'arrays', 'login_err_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Wrong username or password', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_2', 'arrays', 'login_err_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Access denied', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_3', 'arrays', 'login_err_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account is disabled', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_1', 'arrays', 'months_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'January', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_10', 'arrays', 'months_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'October', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_11', 'arrays', 'months_ARRAY_11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'November', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_12', 'arrays', 'months_ARRAY_12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'December', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_2', 'arrays', 'months_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'February', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_3', 'arrays', 'months_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'March', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_4', 'arrays', 'months_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'April', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_5', 'arrays', 'months_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'May', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_6', 'arrays', 'months_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'June', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_7', 'arrays', 'months_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'July', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_8', 'arrays', 'months_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'August', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'months_ARRAY_9', 'arrays', 'months_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'September', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_dr', 'arrays', 'personal_titles_ARRAY_dr', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dr.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_miss', 'arrays', 'personal_titles_ARRAY_miss', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Miss', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_mr', 'arrays', 'personal_titles_ARRAY_mr', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mr.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_mrs', 'arrays', 'personal_titles_ARRAY_mrs', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mrs.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_ms', 'arrays', 'personal_titles_ARRAY_ms', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ms.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_other', 'arrays', 'personal_titles_ARRAY_other', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Other', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_prof', 'arrays', 'personal_titles_ARRAY_prof', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prof.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_rev', 'arrays', 'personal_titles_ARRAY_rev', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Rev.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_1', 'arrays', 'short_months_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Jan', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_10', 'arrays', 'short_months_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Oct', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_11', 'arrays', 'short_months_ARRAY_11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Nov', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_12', 'arrays', 'short_months_ARRAY_12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dec', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_2', 'arrays', 'short_months_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Feb', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_3', 'arrays', 'short_months_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mar', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_4', 'arrays', 'short_months_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Apr', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_5', 'arrays', 'short_months_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'May', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_6', 'arrays', 'short_months_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Jun', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_7', 'arrays', 'short_months_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Jul', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_8', 'arrays', 'short_months_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Aug', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_9', 'arrays', 'short_months_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sep', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_1', 'arrays', 'status_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You are not loged in.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_123', 'arrays', 'status_ARRAY_123', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your hosting account does not allow uploading such a large image.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_2', 'arrays', 'status_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Access denied. You have not requisite rights to.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_3', 'arrays', 'status_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Empty resultset.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_7', 'arrays', 'status_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The operation is not allowed in demo mode.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_996', 'arrays', 'status_ARRAY_996', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No property for the reservation found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_997', 'arrays', 'status_ARRAY_997', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No reservation found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_998', 'arrays', 'status_ARRAY_998', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No permisions to edit the reservation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_999', 'arrays', 'status_ARRAY_999', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No permisions to edit the property', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9997', 'arrays', 'status_ARRAY_9997', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'E-Mail address already exist', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9998', 'arrays', 'status_ARRAY_9998', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your registration was successfull. Your account needs to be approved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9999', 'arrays', 'status_ARRAY_9999', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your registration was successfull.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-10800', 'arrays', 'timezones_ARRAY_-10800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-03:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-14400', 'arrays', 'timezones_ARRAY_-14400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-04:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-18000', 'arrays', 'timezones_ARRAY_-18000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-05:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-21600', 'arrays', 'timezones_ARRAY_-21600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-06:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-25200', 'arrays', 'timezones_ARRAY_-25200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-07:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-28800', 'arrays', 'timezones_ARRAY_-28800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-08:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-32400', 'arrays', 'timezones_ARRAY_-32400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-09:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-3600', 'arrays', 'timezones_ARRAY_-3600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-01:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-36000', 'arrays', 'timezones_ARRAY_-36000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-10:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-39600', 'arrays', 'timezones_ARRAY_-39600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-11:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-43200', 'arrays', 'timezones_ARRAY_-43200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-12:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-7200', 'arrays', 'timezones_ARRAY_-7200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-02:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_0', 'arrays', 'timezones_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_10800', 'arrays', 'timezones_ARRAY_10800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+03:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_14400', 'arrays', 'timezones_ARRAY_14400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+04:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_18000', 'arrays', 'timezones_ARRAY_18000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+05:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_21600', 'arrays', 'timezones_ARRAY_21600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+06:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_25200', 'arrays', 'timezones_ARRAY_25200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+07:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_28800', 'arrays', 'timezones_ARRAY_28800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+08:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_32400', 'arrays', 'timezones_ARRAY_32400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+09:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_3600', 'arrays', 'timezones_ARRAY_3600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+01:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_36000', 'arrays', 'timezones_ARRAY_36000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+10:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_39600', 'arrays', 'timezones_ARRAY_39600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+11:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_43200', 'arrays', 'timezones_ARRAY_43200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+12:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_46800', 'arrays', 'timezones_ARRAY_46800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+13:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_7200', 'arrays', 'timezones_ARRAY_7200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+02:00', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'u_statarr_ARRAY_F', 'arrays', 'u_statarr_ARRAY_F', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'u_statarr_ARRAY_T', 'arrays', 'u_statarr_ARRAY_T', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, '_yesno_ARRAY_F', 'arrays', '_yesno_ARRAY_F', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, '_yesno_ARRAY_T', 'arrays', '_yesno_ARRAY_T', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuCalendar', 'backend', 'Menu / Calendar', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Calendar', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuEvents', 'backend', 'Menu / Events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuCategories', 'backend', 'Menu / Categories', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Categories', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAddCategory', 'backend', 'Add category', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add category', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCategory', 'backend', 'Label Category', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Category', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC01', 'arrays', 'error_titles_ARRAY_AC01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Category updated!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC03', 'arrays', 'error_titles_ARRAY_AC03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Category added!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC04', 'arrays', 'error_titles_ARRAY_AC04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Category failed to add.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC08', 'arrays', 'error_titles_ARRAY_AC08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Category not found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC01', 'arrays', 'error_bodies_ARRAY_AC01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to the category have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC03', 'arrays', 'error_bodies_ARRAY_AC03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to the category have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC04', 'arrays', 'error_bodies_ARRAY_AC04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry, but the category has not been added.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC08', 'arrays', 'error_bodies_ARRAY_AC08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Category your looking for is missing.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUpdateCategory', 'backend', 'Label Update category', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update category', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE01', 'arrays', 'error_titles_ARRAY_AE01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event updated!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE03', 'arrays', 'error_titles_ARRAY_AE03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event added!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE04', 'arrays', 'error_titles_ARRAY_AE04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event failed to add.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE08', 'arrays', 'error_titles_ARRAY_AE08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event not found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE01', 'arrays', 'error_bodies_ARRAY_AE01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to the event have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE03', 'arrays', 'error_bodies_ARRAY_AE03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to the event have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE04', 'arrays', 'error_bodies_ARRAY_AE04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry, but the event has not been added.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE08', 'arrays', 'error_bodies_ARRAY_AE08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Even your are looking for is missing.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAddEvent', 'backend', 'Label Add event', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEventDate', 'backend', 'Label Event date', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEventTime', 'backend', 'Label Event time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEventTitle', 'backend', 'Label Event title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEndTime', 'backend', 'Label End time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'End time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblStartTime', 'backend', 'Label Start time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Start time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_time_format', 'backend', 'Options / Time format', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Time format', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_layout', 'backend', 'Options / Layout', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Layout', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_enable_categories', 'backend', 'Options / Enable categories', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enable categories', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_enable_monthly_view', 'backend', 'Options / Enable monthly view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enable monthly view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_enable_list_view', 'backend', 'Options / Enable list view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enable list view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_default_view', 'backend', 'Options / Default view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDescription', 'backend', 'Description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Description', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblRepeat', 'backend', 'Labe Repeat', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Repeat', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'repeatarr_ARRAY_daily', 'arrays', 'repeatarr_ARRAY_daily', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Daily', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'repeatarr_ARRAY_weekly', 'arrays', 'repeatarr_ARRAY_weekly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Weekly', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'repeatarr_ARRAY_monthly', 'arrays', 'repeatarr_ARRAY_monthly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Monthly', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'repeatarr_ARRAY_quarterly', 'arrays', 'repeatarr_ARRAY_quarterly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Quarterly', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'repeatarr_ARRAY_yearly', 'arrays', 'repeatarr_ARRAY_yearly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yearly', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'repeatarr_ARRAY_custom', 'arrays', 'repeatarr_ARRAY_custom', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Custom', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'repeatarr_ARRAY_none', 'arrays', 'repeatarr_ARRAY_none', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'None', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEndRecurringOn', 'backend', 'Label End recurring on', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'End recurring on', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOrRepeat', 'backend', 'Label Or repeat', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Or repeat', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTimes', 'backend', 'Label Times', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'times', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEach', 'backend', 'Label each', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'each', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblRepeatEveryDay', 'backend', 'Label Repeat daily', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event will be repeated daily', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblRepeatEveryWeek', 'backend', 'Label Repeat weekly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event will be repeated weekly', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblRepeatEveryQuarter', 'backend', 'Label Repeat quarterly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event will be repeated quarterly', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblRepeatEveryYear', 'backend', 'Label Repeat yearly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event will be repeated yearly', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOn', 'backend', 'Label On', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'on', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOfTheMonth', 'backend', 'Label of the month', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'of the month', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOrEach', 'backend', 'Label Or each', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Or each', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_each_ARRAY_first', 'arrays', 'montly_each_ARRAY_first', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'First', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_each_ARRAY_second', 'arrays', 'montly_each_ARRAY_second', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Second', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_each_ARRAY_third', 'arrays', 'montly_each_ARRAY_third', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Third', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_each_ARRAY_fourth', 'arrays', 'montly_each_ARRAY_fourth', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fourth', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_0', 'arrays', 'monthly_date_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '--', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_1', 'arrays', 'monthly_date_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '1st', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_2', 'arrays', 'monthly_date_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '2nd', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_3', 'arrays', 'monthly_date_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '3rd', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_4', 'arrays', 'monthly_date_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '4th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_5', 'arrays', 'monthly_date_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '5th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_6', 'arrays', 'monthly_date_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '6th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_8', 'arrays', 'monthly_date_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '8th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_9', 'arrays', 'monthly_date_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '9th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_10', 'arrays', 'monthly_date_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '10th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_11', 'arrays', 'monthly_date_ARRAY_11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '11th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_12', 'arrays', 'monthly_date_ARRAY_12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '12th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_13', 'arrays', 'monthly_date_ARRAY_13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '13th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_14', 'arrays', 'monthly_date_ARRAY_14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '14th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_15', 'arrays', 'monthly_date_ARRAY_15', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '15th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_16', 'arrays', 'monthly_date_ARRAY_16', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '16th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_17', 'arrays', 'monthly_date_ARRAY_17', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '17th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_18', 'arrays', 'monthly_date_ARRAY_18', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '18th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_19', 'arrays', 'monthly_date_ARRAY_19', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '19th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_20', 'arrays', 'monthly_date_ARRAY_20', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '20th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_21', 'arrays', 'monthly_date_ARRAY_21', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '21st', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_22', 'arrays', 'monthly_date_ARRAY_22', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '22nd', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_23', 'arrays', 'monthly_date_ARRAY_23', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '23rd', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_24', 'arrays', 'monthly_date_ARRAY_24', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '24th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_25', 'arrays', 'monthly_date_ARRAY_25', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '25th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_26', 'arrays', 'monthly_date_ARRAY_26', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '26th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_27', 'arrays', 'monthly_date_ARRAY_27', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '27th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_28', 'arrays', 'monthly_date_ARRAY_28', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '28th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_29', 'arrays', 'monthly_date_ARRAY_29', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '29th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_30', 'arrays', 'monthly_date_ARRAY_30', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '30th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_31', 'arrays', 'monthly_date_ARRAY_31', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '31st', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lnkAddTime', 'backend', 'Link Add time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lnkAddStartTime', 'backend', 'Link Add start time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add start time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lnkAddEndTime', 'backend', 'Link Add end time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add end time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lnkRemoveTime', 'backend', 'Link Remove time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Remove time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUpdateEvent', 'backend', 'Label Update event', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblApplyRecurring', 'backend', 'Label Apply recurring', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is recurring event. Check if you want to update all the {numevents} repeats or leave unchecked if you only want to update this current event.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_choose', 'frontend', 'Front Label Choose', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuInstall', 'backend', 'Menu / Install', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install & Preview', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstall', 'backend', 'Label Install', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallPhp1Title', 'backend', 'Label instruction title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Using the code below you can put that specific event on any of your website web pages. Your website visitors will only view and be able to book this event only.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstall_1', 'backend', 'Install step 1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Step 1: Customize the layout for your booking calendar. You can click on the Preview button to view how it will look.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstall_2', 'backend', 'Step 2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Step 2: Copy the code below and put it in your web page where you want the calendar to appear.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_events_per_page', 'backend', 'Options / Events per page for list view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Number of events per page for list view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_display_events', 'backend', 'Options / Display events for calendar view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Display events for calendar view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblView', 'backend', 'Label / View', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'View', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblHideSwitchIcons', 'backend', 'Label / Hide view switch icons', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Hide view switch icons', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblHideCategories', 'backend', 'Label / Hide categories', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Hide category selection', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCSSFile', 'backend', 'Label / CSS file', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CSS file', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'install_view_ARRAY_default', 'arrays', 'install_view_ARRAY_default', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'install_view_ARRAY_list', 'arrays', 'install_view_ARRAY_list', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'install_view_ARRAY_calendar', 'arrays', 'install_view_ARRAY_calendar', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Calendar', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'install_view_ARRAY_monthly', 'arrays', 'install_view_ARRAY_monthly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Monthly', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstall_0', 'backend', 'Install / Preparation step', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preparation step: Please do any customization to have your desired PHP event calendar. ', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCalendarView', 'backend', 'Label Calendar view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Calendar view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblListView', 'backend', 'Label / List view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblMonthlyView', 'backend', 'Label / Monthly view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Monthly view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallCSSExplanation', 'backend', 'Label / Install CSS explanation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '{DefaultCSS} is the default css file for the layout, but if you want you can save it under a new name, then change the textbox here and use the new file.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuPreview', 'backend', 'Menu / Preview', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblNoEventFound', 'backend', 'Label / No event found', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No event found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTime', 'backend', 'Label / Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDashLastLogin', 'backend', 'Label / Last login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last login', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTodayEvents', 'backend', 'Label / Today events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Today events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTotalEvents', 'backend', 'Label / Total events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUpcomingEvents', 'backend', 'Label / Upcoming events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Upcoming events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUsers', 'backend', 'Label / Users', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Users', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'layouts_ARRAY_layout_1', 'arrays', 'layouts_ARRAY_layout_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Layout 1', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'layouts_ARRAY_layout_2', 'arrays', 'layouts_ARRAY_layout_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Layout 2', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'layouts_ARRAY_layout_3', 'arrays', 'layouts_ARRAY_layout_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Layout 3', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'layouts_ARRAY_layout_4', 'arrays', 'layouts_ARRAY_layout_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Layout 4', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'layouts_ARRAY_layout_5', 'arrays', 'layouts_ARRAY_layout_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Layout 5', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pec_delete_confirmation', 'backend', 'pec_delete_confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete selected record(s)?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_event_title_position', 'backend', 'Options / Event title position', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event title position', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblPrice', 'backend', 'Label / Price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAvailable', 'backend', 'Label / Available tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_send_email', 'backend', 'Options / Send email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_host', 'backend', 'Options / SMTP Host', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Host', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_pass', 'backend', 'Options / SMTP Password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Password', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_port', 'backend', 'Options / SMTP Port', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Port', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_user', 'backend', 'Options / SMTP Username', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Username', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_active', 'backend', 'Label / Active', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_inactive', 'backend', 'Label / Inactive', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_delete_selected', 'backend', 'ebc_delete_selected', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete selected', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_delete_confirmation', 'backend', 'ebc_delete_confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure that you want to delete the selected record(s)?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnRemove', 'backend', 'Buttons/ Remove', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Remove', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'monthly_date_ARRAY_7', 'arrays', 'monthly_date_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '7th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuBooking', 'backend', 'Menus / Booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'submenuGenerals', 'backend', 'Submenus / Generals', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Generals', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'submenuBookingForm', 'backend', 'Submenus / Booking Form', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Form', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'submenuConfirmation', 'backend', 'Submenus / Confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_default_status_if_paid', 'backend', 'Options / Status if paid', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default status for bookings if paid', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_default_status_if_paid_text', 'backend', 'Options / Status if paid', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All bookings which are made and paid will be set with the following status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_default_status_if_not_paid', 'backend', 'Options / Status if not paid', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default status for bookings if not paid', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_default_status_if_not_paid_text', 'backend', 'Options / Status if not paid', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All bookings which are only made but NOT paid will be set with the following status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_tax_payment', 'backend', 'Options / Tax payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tax amount to be collected for each booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_require_all_within_days', 'backend', 'Options / Required if within X days', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Require full payment if the booking is made X days before the event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_require_all_within_days_text', 'backend', 'Options / Required if within X days', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'days', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_allow_paypal', 'backend', 'Options / Allow paypal', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Allow payments with Paypal', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_paypal_address', 'backend', 'Options / Paypal address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Paypal email address', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_allow_authorize', 'backend', 'Options / Allow Authorize.net', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Allow payments with Authorize.net', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_merchant_id', 'backend', 'Options / Authorize Merchant ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Authorize.net merchant ID', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_transkey', 'backend', 'Options / Authorize Transaction Key', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Authorize.net transaction key', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_timezone', 'backend', 'Options / Authorize Timezone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Authorize.net time zone', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_allow_creditcard', 'backend', 'Options / Allow Credit Card', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Collect Credit Card details for offline processing', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_allow_bank', 'backend', 'Options / Allow Bank Account', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Provide Bank account details for wire transfers', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bank_account', 'backend', 'Options / Bank account', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bank Account', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_thankyou_page', 'backend', 'Options / Thank you page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'URL redirects after payment', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_thankyou_page_text', 'backend', 'Options / Thank you page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'URL of the web page where your clients will be redirected to after online payment', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_name', 'backend', 'Options / Name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_email', 'backend', 'Options / Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_phone', 'backend', 'Options / Phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_adults', 'backend', 'Options / Adults', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Adults', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_children', 'backend', 'Options / Children', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Children', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_address', 'backend', 'Options / Address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_country', 'backend', 'Options / Country', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_state', 'backend', 'Options / State', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'State', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_city', 'backend', 'Options / City', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'City', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_zip', 'backend', 'Options / Zip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Zip', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_notes', 'backend', 'Options / Notes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_captcha', 'backend', 'Options / Captcha', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblConfirmationEmail', 'backend', 'Label / Confirmation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmation email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblConfirmationEmailTip', 'backend', 'Label / Confirmation email tip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is the email message which will be sent to people who book an event right after booking form is submitted.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblPaymentEmail', 'backend', 'Label / Payment email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblPaymentEmailTip', 'backend', 'Label / Payment email tip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is the email message which will be sent to people who book an event right after payment is made.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingFormTitle', 'backend', 'Infobox / Booking form title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking form', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingFormBody', 'backend', 'Infobox / Booking form body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose the fields that should be available on the booking form.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoConfirmationTitle', 'backend', 'Infobox / Confirmation email title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email confirmations', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoConfirmationBody', 'backend', 'Infobox / Confirmation email body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are 2 type of email confirmations - one after booking form is submitted and one after payment is made. Use the available tokens to personalize the email messages.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO02', 'arrays', 'error_titles_ARRAY_AO02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking setting updated', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO02', 'arrays', 'error_bodies_ARRAY_AO02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the booking configuration settings have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO03', 'arrays', 'error_titles_ARRAY_AO03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking form setting updated', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO03', 'arrays', 'error_bodies_ARRAY_AO03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the booking form settings have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO04', 'arrays', 'error_titles_ARRAY_AO04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmation email updated', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO04', 'arrays', 'error_bodies_ARRAY_AO04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All confirmation email settings have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_button_buy_ticket', 'frontend', 'Buttons / Buy ticket', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Buy ticket', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_lable_name', 'frontend', 'Label / Name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_email', 'frontend', 'Label / Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_phone', 'frontend', 'Label / Phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_country', 'frontend', 'Label / Country', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_city', 'frontend', 'Label / City', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'City', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_state', 'frontend', 'Label / State', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'State', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_zip', 'frontend', 'Label / Zip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Zip', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_address', 'frontend', 'Label / Address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_notes', 'frontend', 'Label / Notes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_payment_method', 'frontend', 'Label / Payment method', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment method', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_cc_type', 'backend', 'Label / CC type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC type', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_cc_number', 'frontend', 'Label / CC number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC number', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_cc_expiration_date', 'frontend', 'Label / CC expiration date', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC expiration date', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_cc_code', 'frontend', 'Label / CC security code', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC security code', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_captcha', 'frontend', 'Label / Captcha', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_name', 'arrays', 'front_required_ARRAY_name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_email', 'arrays', 'front_required_ARRAY_email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_phone', 'arrays', 'front_required_ARRAY_phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_address', 'arrays', 'front_required_ARRAY_address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Address is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_country', 'arrays', 'front_required_ARRAY_country', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_city', 'arrays', 'front_required_ARRAY_city', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'City is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_state', 'arrays', 'front_required_ARRAY_state', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'State is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_zip', 'arrays', 'front_required_ARRAY_zip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Zip is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_notes', 'arrays', 'front_required_ARRAY_notes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notes is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_captcha', 'arrays', 'front_required_ARRAY_captcha', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_cc_type', 'arrays', 'front_required_ARRAY_cc_type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card type is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_cc_number', 'arrays', 'front_required_ARRAY_cc_number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card number is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_cc_exp_month', 'arrays', 'front_required_ARRAY_cc_exp_month', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card expiration month is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_cc_exp_year', 'arrays', 'front_required_ARRAY_cc_exp_year', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card expiration year is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_cc_code', 'arrays', 'front_required_ARRAY_cc_code', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card security code is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_error_ARRAY_title', 'arrays', 'front_error_ARRAY_title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You failed to fill in correctly the booking form.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_error_ARRAY_email', 'arrays', 'front_error_ARRAY_email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email is invalid.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_error_ARRAY_captcha', 'arrays', 'front_error_ARRAY_captcha', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha is wrong.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_error_ARRAY_payment', 'arrays', 'front_error_ARRAY_payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please select a payment option.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_error_ARRAY_max', 'arrays', 'front_error_ARRAY_max', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Max allowed people attending  is {max}.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_error_ARRAY_min', 'arrays', 'front_error_ARRAY_min', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You must select at least one ticket.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_1', 'arrays', 'front_message_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Loading event list ...', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_2', 'arrays', 'front_message_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Loading booking form ...', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_3', 'arrays', 'front_message_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Loading booking summary ...', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_4', 'arrays', 'front_message_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Loading calendar ...', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_5', 'arrays', 'front_message_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Processing booking. Please wait ...', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_6', 'arrays', 'front_message_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation was saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_7', 'arrays', 'front_message_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation failed to saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_creditcard', 'arrays', 'payment_methods_ARRAY_creditcard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cc_types_ARRAY_Visa', 'arrays', 'cc_types_ARRAY_Visa', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Visa', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cc_types_ARRAY_MasterCard', 'arrays', 'cc_types_ARRAY_MasterCard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'MasterCard', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cc_types_ARRAY_Maestro', 'arrays', 'cc_types_ARRAY_Maestro', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Maestro', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cc_types_ARRAY_AmericanExpress', 'arrays', 'cc_types_ARRAY_AmericanExpress', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'AmericanExpress', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_paypal', 'backend', 'payment_methods_ARRAY_paypal', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'PayPal', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_past_event', 'frontend', 'Label / Past event', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event in the past cannot be reserved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_full_event', 'frontend', 'Label / Full event', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The event is fully booked.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_button_submit', 'frontend', 'Buttons / Submit', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Submit', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_button_cancel', 'frontend', 'Buttons / Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_price', 'frontend', 'Label / Price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_tax', 'frontend', 'Label / Tax', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tax', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_total_price', 'frontend', 'Label / Total price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total price', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_name', 'frontend', 'Label / Name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_8', 'arrays', 'front_message_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please wait while redirect to secure payment processor webpage complete...', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuBookings', 'backend', 'Menus / Bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_confirmed', 'arrays', 'booking_statuses_ARRAY_confirmed', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_pending', 'arrays', 'booking_statuses_ARRAY_pending', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pending', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_cancelled', 'arrays', 'booking_statuses_ARRAY_cancelled', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancelled', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEvent', 'backend', 'Label / Event', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAddBooking', 'backend', 'Label / Add booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingEvent', 'backend', 'Label / Event', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingStatus', 'backend', 'Label / Status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingPayment', 'backend', 'Label / Payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingCCType', 'backend', 'Label / CC type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card type', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingCCNum', 'backend', 'Label / CC Number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card number', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingCCCode', 'backend', 'Label / Credit card code', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card code', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingCCExp', 'backend', 'Label / CC expiration', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card expiration', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingAmount', 'backend', 'Label / Amount', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Amount', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingTax', 'backend', 'Label / Tax', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tax', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingName', 'backend', 'Label / Name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingEmail', 'backend', 'Label / Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingPhone', 'backend', 'Label / Phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingNotes', 'backend', 'Label / Notes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingCountry', 'backend', 'Label / Country', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingCity', 'backend', 'Label / City', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'City', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingState', 'backend', 'Label / State', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'State', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingZip', 'backend', 'Label / Zip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Zip', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingPrice', 'backend', 'Label / Price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingTotal', 'backend', 'Label / Total', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR01', 'arrays', 'error_titles_ARRAY_AR01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking updated', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR03', 'arrays', 'error_titles_ARRAY_AR03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking added', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR04', 'arrays', 'error_titles_ARRAY_AR04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking failed to add', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR08', 'arrays', 'error_titles_ARRAY_AR08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking not found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR01', 'arrays', 'error_bodies_ARRAY_AR01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the booking have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR03', 'arrays', 'error_bodies_ARRAY_AR03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'A new booking has been added to the booking list.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR04', 'arrays', 'error_bodies_ARRAY_AR04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'An error occurred, the booking has not been added.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR08', 'arrays', 'error_bodies_ARRAY_AR08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The booking you are looking for is missing.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR09', 'arrays', 'error_titles_ARRAY_AR09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Associate event not found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR10', 'arrays', 'error_titles_ARRAY_AR10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Associate event forbidden', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR09', 'arrays', 'error_bodies_ARRAY_AR09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The event for this booking not found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR10', 'arrays', 'error_bodies_ARRAY_AR10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The event for this booking belongs to somebody else but not you.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUpdateBooking', 'backend', 'Label / Update booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEventBookings', 'backend', 'Label / Bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingTickets', 'backend', 'Label / Tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblReservationDetails', 'backend', 'Label / Booking details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAmount', 'backend', 'Label / Amount', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Amount', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblClientDetails', 'backend', 'Label / Client details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUniqueID', 'backend', 'Label / Unique ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Unique ID', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_total_amount', 'frontend', 'Label / Total price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total price', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabDetails', 'backend', 'Tabs / Details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabConfirmation', 'backend', 'Tabs / Confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabTerms', 'backend', 'Tabs / Terms', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabUsedTickets', 'backend', 'Tabs / Used tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Used tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTerms', 'backend', 'Label / Terms', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTermsTip', 'backend', 'Label / Terms tips', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Type in event terms and conditions', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTicketImage', 'backend', 'Label / Ticket image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ticket image', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoTermsTitle', 'backend', 'Infobox / Terms title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms and conditions', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoTermsBody', 'backend', 'Infobox / Terms Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'People who book the event will see these Terms and Conditions and will have to agree to them before making a booking.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoUsedTicketsTitle', 'backend', 'Infobox / Tickets Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Used tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoUsedTicketsBody', 'backend', 'Infobox / Tickets Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below you can see all the tickets used already.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE09', 'arrays', 'error_titles_ARRAY_AE09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File not allowed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE09', 'arrays', 'error_bodies_ARRAY_AE09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Only file with extensions jpg|jpeg|pjpeg is allowed.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE10', 'arrays', 'error_titles_ARRAY_AE10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File size error', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE10', 'arrays', 'error_bodies_ARRAY_AE', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The ticket image should be in size of 510 x 280 (pixels).', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblID', 'backend', 'Label / ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'ID', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblNumberOfTickets', 'backend', 'Label / Number of tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Number of tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblFrom', 'backend', 'Label / from', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'from', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTo', 'backend', 'Label / to', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'to', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTotalPrice', 'backend', 'Label / Total price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total price', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAdministration', 'backend', 'Label / Administration', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Administration', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingDateTime', 'backend', 'Label / Date time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblIpAddress', 'backend', 'Label / Ip address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'IP address', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblResendConfirmation', 'backend', 'Label / Re-send confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Re-send confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblPrintTickets', 'backend', 'Label / Print tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCreateInvoice', 'backend', 'Label / Create invoice', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Create invoice', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoResendTitle', 'backend', 'Infobox / Resend Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Re-send confirmation email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoResendBody', 'backend', 'Infobox / Resend Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You are about to re-send the confirmation email to client who made the booking. Please click on the button Send of which email you refer to.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingID', 'backend', 'Label / Booking ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking ID', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblSubject', 'backend', 'Label / Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblMessage', 'backend', 'Label / Message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ARS01', 'arrays', 'error_titles_ARRAY_ARS01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email not sent', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ARS01', 'arrays', 'error_bodies_ARRAY_ARS01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The email of client could not be found in the booking.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ARS02', 'arrays', 'error_titles_ARRAY_ARS02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email sent', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ARS02', 'arrays', 'error_bodies_ARRAY_ARS02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The email was re-sent to client email successfully.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_accept_terms', 'frontend', 'Accept terms of booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Accept terms of booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_accept_terms', 'arrays', 'front_required_ARRAY_accept_terms', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please check accept terms of booking.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTicketInfo', 'backend', 'Label / Ticket information', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ticket information', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTicketTokens', 'backend', 'Label / Ticket tokens', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available tokens:
<br/><br/>
Customer name: {Name}<br/>
Customer email: {Email}<br/>
Customer phone: {Phone}<br/>
Customer city: {City}<br/>
Customer state: {State}<br/>
Customer zip: {Zip}<br/>
Customer address: {Address}<br/><br/>

Ticket price: {Price} </br>', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAvailabeTokens', 'backend', 'Label / Available tokens', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available tokens:<br/><br/>Name: {Name}<br/>Email: {Email}<br/>Phone: {Phone}<br/>City: {City}<br/>State: {State}<br/>Zip: {Zip}<br/>Address: {Address}<br/>Notes: {Notes}<br/>Tickets: {Tickets}<br/>PDF Ticket: {PDF_Tickets}<br/><br/>CC type: {CCType}<br/>CC number: {CCNum}<br/>CC expiration: {CCExp}<br/>CC code: {CCSec}<br/>Payment: {PaymentMethod}<br/>Event: {Event}<br/>Event Title: {EventTitle}<br/>Event Date/time: {EventDateTime}<br/>Event Location: {EventLocation}<br/>Total price: {Total} </br>Tax: {Tax} </br>Deposit: {Deposit} </br>Remaining Balance: {Balance} </br>Booking ID: {BookingID} </br>Cancel URL: {CancelURL}', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTicket', 'backend', 'Label / ticket', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'ticket', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBarcodeReader', 'backend', 'Label / Barcode reader', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Barcode reader', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoReadBarcodeTitle', 'backend', 'Infobox / Read Barcode Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bar code reader', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoReadBarcodeBody', 'backend', 'Infobox / Read Barcode Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use your bar code scanner to read the barcodes and fill in the ticket ID into the text below. Then click on Check button to read ticket details and confirm it.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBarcodeDetails', 'backend', 'Label / Barcode details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Barcode details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnCheck', 'backend', 'Buttons / Check', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Check', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ARB01', 'arrays', 'error_titles_ARRAY_ARB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid barcode', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ARB01', 'arrays', 'error_bodies_ARRAY_ARB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the system could not find out your ticket.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDateTime', 'backend', 'Label / Date time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date / time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEditBooking', 'backend', 'Label / Edit booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabBookings', 'backend', 'Tabs / Bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCurrentDateTime', 'backend', 'Label / Current date time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Current date / time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTotalBookings', 'backend', 'Label / Total bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTotalTickets', 'backend', 'Label / Total tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnPrint', 'backend', 'Buttons / Print', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTickets', 'backend', 'Label / Tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_adults', 'frontend', 'Label / Adults', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Adults', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_children', 'frontend', 'Label / Children', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Children', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_adults', 'arrays', 'front_required_ARRAY_adults', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Adults is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_required_ARRAY_children', 'arrays', 'front_required_ARRAY_children', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Children is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingAdults', 'backend', 'Label / Adults', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Adults', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingChildren', 'backend', 'Label / Children', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Children', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblStartDateTime', 'backend', 'Label / Start date time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Start date time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEndDateTime', 'backend', 'Label / End date time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'End date time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblRegular', 'backend', 'Label / Regular', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Regular', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_shortnames_ARRAY_0', 'arrays', 'day_shortnames_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sun', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_shortnames_ARRAY_1', 'arrays', 'day_shortnames_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mon', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_shortnames_ARRAY_2', 'arrays', 'day_shortnames_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tue', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_shortnames_ARRAY_3', 'arrays', 'day_shortnames_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Wed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_shortnames_ARRAY_4', 'arrays', 'day_shortnames_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Thu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_shortnames_ARRAY_5', 'arrays', 'day_shortnames_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fri', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'day_shortnames_ARRAY_6', 'arrays', 'day_shortnames_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sat', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabInstall', 'backend', 'Tabs / Install', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblImage', 'backend', 'Label / Image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Image', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteImageTitle', 'backend', 'Label / Delete event image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete event image', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteImageBody', 'backend', 'Label / Delete event image body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure that you want to delete the event image?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lnkDelete', 'backend', 'Links / Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ticket_statuses_ARRAY_1', 'arrays', 'ticket_statuses_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The ticket is valid.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ticket_statuses_ARRAY_2', 'arrays', 'ticket_statuses_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation is not confirmed yet.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ticket_statuses_ARRAY_3', 'arrays', 'ticket_statuses_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The ticket was already used.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ticket_statuses_ARRAY_4', 'arrays', 'ticket_statuses_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The ticket could not be found in the system.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTicketConfirmationTitle', 'backend', 'Label / Ticket confirm title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ticket confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTicketConfirmationBody', 'backend', 'Label / Ticket confirm body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure that you want to set this ticket as used.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUseTicket', 'backend', 'Label / Use ticket', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'use ticket', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabTicket', 'backend', 'Tabs / Ticket', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ticket', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblUsedTickets', 'backend', 'Label / Used tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Used tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingsTitle', 'backend', 'Infobox / Booking title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingsBody', 'backend', 'Infobox / Booking body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below you can see a list with all bookings made for this event.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoTicketsImageTitle', 'backend', 'Infobox / Ticket image title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ticket', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoTicketsImageBody', 'backend', 'Infobox / Ticket image body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Upload JPG image which will be used for the generated PDF tickets for each booking made. If you want to include event details on the ticket you can just create a JPG image for your event and put the details there. See ticket example [STARTTAG]here[ENDTAG]. You can also edit booking details which will be printed on the ticket.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblLatestBookings', 'backend', 'Label / Latest bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Latest bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTicketType', 'backend', 'Label / Ticket type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ticket type', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblHideTime', 'backend', 'Label / hide time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Check if you want to only show date for the event and not time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInvalidPrice', 'backend', 'Label / Invalid price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid price.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblFieldRequired', 'backend', 'Label / This field is required', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This field is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAtLeastPrice', 'backend', 'Label / At least ticket', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You must select at one ticket.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblSameCatgory', 'backend', 'Label / Same category', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Category name was alaredy used.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_bank', 'arrays', 'payment_methods_ARRAY_bank', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bank account', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_bank_account', 'frontend', 'Label / Bank account', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bank account', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cancel_statuses_ARRAY_1', 'arrays', 'cancel_statues_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel URL is invalid. Parameters are missing.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cancel_statuses_ARRAY_2', 'arrays', 'cancel_statues_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking with such ID does not exists.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_cancel_booking_page', 'backend', 'Label / Cancel booking page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'URL after cancel a booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_cancel_booking_page_text', 'backend', 'Label / Cancel booking page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'URL of the web page where your clients will be redirected to after they cancel a booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'emailCancelSubject', 'frontend', 'Label / Email cancel subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'A booking cancelled', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'emailCancelBody', 'frontend', 'Label / Email cancel body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dear ,

There is a booking cancelled:

Booking ID: {BookingID}
 
Thank you', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_cancel_text', 'frontend', 'Label / Cancel text', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You are about to cancel the booking for the event:', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_cancel_confirm', 'frontend', 'Label / Cancel confirm', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure that you want to cancel this booking?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_cancel_title_page', 'frontend', 'Label / Cancel booking title page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancelling booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_event_title', 'frontend', 'Label / Event title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_event_date_time', 'frontend', 'Label / Event date time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event date time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_event_description', 'frontend', 'Label / Event description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event description', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cancel_statuses_ARRAY_3', 'arrays', 'cancel_statues_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Security hash does not match.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cancel_statuses_ARRAY_4', 'arrays', 'cancel_statues_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking was already cancelled.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'cancel_statuses_ARRAY_200', 'arrays', 'cancel_statues_ARRAY_200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking has been cancelled successfully.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_payment_disable', 'backend', 'Label / Disable payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Disable payments', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_payment_disable_text', 'backend', 'Label / Disable payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select "Yes" if you want to disable payments and only collect booking details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_list_view', 'frontend', 'Label / List view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_monthly_view', 'frontend', 'Label / Monthly view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Monthly view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_calendar_view', 'frontend', 'Label / Calendar view', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Calendar view', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingAddress', 'backend', 'Label / Address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_display_available_tickets', 'backend', 'Label / Display available tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Display available tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_available_tickets', 'frontend', 'Label / Available tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_md5_hash', 'backend', 'Label / Authorize.net MD5 hash', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Authorize.net MD5 hash', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoCategoriesTitle', 'backend', 'Infobox / Category list title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Category list', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoCategoriesDesc', 'backend', 'Infobox / Category list desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is the list of categories. Let click on the Add Category tab to define new category. You can also Edit or Delete a specific category by clicking on the corresponding row.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoAddCategoryTitle', 'backend', 'Infobox / Add category title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add new category', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoAddCategoryDesc', 'backend', 'Infobox / Add category desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please fill out the form below and click Save button to add new category. Or click on the Cancel button the go back to the category list.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEditCategoryTitle', 'backend', 'Infobox / Edit category title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit category', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEditCategoryDesc', 'backend', 'Infobox / Edit category desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can make any change you wont on the form below and click Save button to update category name', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoUsersTitle', 'backend', 'Infobox / User list title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User list', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoUserDesc', 'backend', 'Infobox / User list desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is the list of user. Let click on the Add User tab to add new user. You can also Edit or Delete a specific user by clicking on the corresponding row.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoAddUserTitle', 'backend', 'Infobox / Add user title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add new user', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoAddUserDesc', 'backend', 'Infobox / Add user desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please fill out the form below and click Save button to add new user.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEditUserTitle', 'backend', 'Infobox / Edit user title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit user', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEditUserDesc', 'backend', 'Infobox / Edit user desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can make any change you wont on the form below and click Save button to update user information', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEventTimeTitle', 'backend', 'Infobox / Event time title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEventTimeDesc', 'backend', 'Infobox / Event time desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter event title, date and time, category, location and description. You can also upload an image for the event.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEventPriceTitle', 'backend', 'Infobox / Event price title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price and Recurring', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEventPriceDesc', 'backend', 'Infobox / Event price desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can add different prices for the event. Just click on ADD button and enter new price. You can also set number of available tickets for each group price (e.g. Adult tickets, Children tickets, ...). Also set if the event is recurring or not. ', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblLocation', 'backend', 'Label / Location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Location', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_from', 'frontend', 'Label / from', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'from', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_till', 'frontend', 'Label / till', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'till', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_event_details', 'frontend', 'Label / Event Details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event Details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_select_tickets', 'frontend', 'Label / select tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select ticket types that you want to buy', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_fill_in', 'frontend', 'Label / fill in', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fill in your details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_message_ARRAY_9', 'arrays', 'front_message_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Load event details ...', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_all', 'frontend', 'Label / All', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_today', 'frontend', 'Label / Today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Today', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_tomorrow', 'frontend', 'Label / Tomorrow', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tomorrow', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_this_weekend', 'frontend', 'Label / This Weekend', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This Weekend', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_next_7_days', 'frontend', 'Label / Next 7 Days', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next 7 Days', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_next_30_days', 'frontend', 'Label / Next 30 Days', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next 30 Days', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_all_events', 'frontend', 'Label / All Events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All Events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_view_details', 'frontend', 'Label / View Details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'View Details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_button_back', 'frontend', 'Button / Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_deposit_payment', 'backend', 'Options / Deposit payment (%)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Deposit amount in % to be collected', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_deposit_payment_text', 'backend', 'Options / Deposit payment (%)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set deposit in % from booking full amount to be collected for each booking. Set it to 100 if you want to collect full payment for each booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingDeposit', 'backend', 'Booking / Deposit', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Deposit', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_label_deposit', 'frontend', 'Label / Deposit', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Deposit', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_booking_before_hours', 'backend', 'Options / Stop booking x hour before', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Do not accept new bookings X hours before event start time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_booking_before_hours_text', 'backend', 'Options / Stop booking x hour before', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'hours', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblHours', 'backend', 'Label / hours', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'hours', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTotalAvailable', 'backend', 'Label / Total tickets available', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total tickets available', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookedTickets', 'backend', 'Label / Booked tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booked tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOf', 'backend', 'Label / of', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'of', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEventTickets', 'backend', 'Label / Tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_no_event', 'frontend', 'Label / No events found', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No events found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_buy_ticket_notes', 'frontend', 'Label / Buy ticket notes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You need to select number of tickets first.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstall_2a', 'backend', 'Install / text for event installation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Copy the code below and put it in your web page where you want the event to appear.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblShowSpecificCategory', 'backend', 'Label / Show specific category', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show specific category', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallTitle', 'backend', 'Label / Install title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Follow the steps below to put the events booking module on your website. Please, note that the JS code found below should be used on a web page from the same domain where script is installed.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCopyEvent', 'backend', 'Label / Copy event', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Copy event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_allow_cash', 'backend', 'Options / Allow payments with cash', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Allow payments with cash', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_cash', 'arrays', 'payment_methods_ARRAY_cash', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cash', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblTicketDetails', 'backend', 'Ticket details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ticket details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblImageTokens', 'backend', 'Image tokents', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event Title: {EventTitle}<br/>
Event Date/time: {EventDateTime}<br/>
Name: {Name}<br/>
Email: {Email}<br/>
Ticket info: {Ticket}', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_languages', 'backend', 'Locale plugin / Languages', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_titles', 'backend', 'Locale plugin / Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Translate', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_index_title', 'backend', 'Locale plugin / Languages info title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_index_body', 'backend', 'Locale plugin / Languages info body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add as many languages as you need to your script. For each of the languages added you need to translate all the text titles.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_titles_title', 'backend', 'Locale plugin / Titles info title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Titles', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_titles_body', 'backend', 'Locale plugin / Titles info body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Using the form below you can edit all the text in the software.<br /><br />Each piece of text used in the software is saved in the database and has its own unique ID. In the first column below you can see the ID for each piece of text. To show these IDs in the script itself check the \"Show IDs\" checkbox and click Save button next to it. This will show the corresponding :ID: for each text message. Please, note that ONLY you will see these IDs. Now you can search for any ID and easily change and/or translate the text. Have in the mind that you should use : before and after the ID when you search for it.  <br /><br />Check our <a target=\"_blank\" href=\"http://www.phpjabbers.com/knowledgebase/other\">knowledgebase</a> and watch video tutorial how to change and/or translate the text.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_title', 'backend', 'Locale plugin / Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_flag', 'backend', 'Locale plugin / Flag', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flag', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_is_default', 'backend', 'Locale plugin / Is default', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Is default', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_order', 'backend', 'Locale plugin / Order', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Order', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_add_lang', 'backend', 'Locale plugin / Add Language', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add Language', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_field', 'backend', 'Locale plugin / Field', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Field', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_value', 'backend', 'Locale plugin / Value', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Value', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_type_backend', 'backend', 'Locale plugin / Back-end title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-end title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_type_frontend', 'backend', 'Locale plugin / Front-end title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front-end title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_type_arrays', 'backend', 'Locale plugin / Special title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Special title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL01', 'arrays', 'Locale plugin / Status title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Titles Updated', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL01', 'arrays', 'Locale plugin / Status body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to titles have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_rows', 'backend', 'Locale plugin / Per page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Per page', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL02', 'arrays', 'Locale plugin / Status title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import error', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL02', 'arrays', 'Locale plugin / Status body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed due missing parameters.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL03', 'arrays', 'Locale plugin / Status title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import complete', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL03', 'arrays', 'Locale plugin / Status body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The import was performed successfully.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL04', 'arrays', 'Locale plugin / Status title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import error', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL04', 'arrays', 'Locale plugin / Status body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed due empty data.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL05', 'arrays', 'Locale plugin / Status title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import error', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL05', 'arrays', 'Locale plugin / Status body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed because file cannot be open.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_import_export', 'backend', 'Locale plugin / Import Export menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import / Export', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_import', 'backend', 'Locale plugin / Import', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_export', 'backend', 'Locale plugin / Export', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_browse', 'backend', 'Locale plugin / Browse your computer', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Browse your computer', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_ie_title', 'backend', 'Locale plugin / Import Export (title)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import / Export', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_ie_body', 'backend', 'Locale plugin / Import Export (body)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use form below to Import or Export CSV with all titles. Please, do not change first row and first and second column in the CSV file.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_separator', 'backend', 'Locale plugin / Delimiter', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delimiter', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_separators_ARRAY_comma', 'arrays', 'Locale plugin / Delimiter: comma', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Comma', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_separators_ARRAY_semicolon', 'arrays', 'Locale plugin / Delimiter: semicolon', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Semicolon', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_separators_ARRAY_tab', 'arrays', 'Locale plugin / Delimiter: tab', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tab', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL20', 'arrays', 'error_bodies_ARRAY_PAL20', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The following languages have been found. Select those you want to import.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL20', 'arrays', 'error_titles_ARRAY_PAL20', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL11', 'arrays', 'error_titles_ARRAY_PAL11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL11', 'arrays', 'error_bodies_ARRAY_PAL11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Missing, empty or invalid parameters.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL12', 'arrays', 'error_titles_ARRAY_PAL12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL12', 'arrays', 'error_bodies_ARRAY_PAL12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File have not been uploaded.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL13', 'arrays', 'error_titles_ARRAY_PAL13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL13', 'arrays', 'error_bodies_ARRAY_PAL13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Uploaded file cannot open for reading.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL14', 'arrays', 'error_titles_ARRAY_PAL14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL14', 'arrays', 'error_bodies_ARRAY_PAL14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New line(s) have been found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL15', 'arrays', 'error_titles_ARRAY_PAL15', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL15', 'arrays', 'error_bodies_ARRAY_PAL15', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Uploaded file doesn''t contain the necessary columns.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL16', 'arrays', 'error_titles_ARRAY_PAL16', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL16', 'arrays', 'error_bodies_ARRAY_PAL16', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Number of columns are not equal on every row.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL17', 'arrays', 'error_titles_ARRAY_PAL17', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL17', 'arrays', 'error_bodies_ARRAY_PAL17', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid data found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL18', 'arrays', 'error_titles_ARRAY_PAL18', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL18', 'arrays', 'error_bodies_ARRAY_PAL18', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Missing columns.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAL19', 'arrays', 'error_titles_ARRAY_PAL19', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAL19', 'arrays', 'error_bodies_ARRAY_PAL19', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid data found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_id', 'backend', 'Label / ID:', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'ID:', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_show_id', 'backend', 'Label / Show ID in all titles to easily locate them', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show IDs', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_showid_dialog_title', 'backend', 'Label / Show IDs', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show IDs', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_showid_dialog_desc', 'backend', 'Label / Show IDs', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'ID will be displayed next to each text found in the software. You can then search for an ID to easily change or translate the text.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_button_confirm', 'backend', 'Button / Confirm', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirm', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_button_cancel', 'backend', 'Button / Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_default', 'backend', 'Label / default', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'default', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_dir', 'backend', 'Locale plugin / Text direction', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Text direction', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_fend', 'backend', 'Locale plugin / Front-end title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front-end title', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_dir_ARRAY_ltr', 'arrays', 'Locale plugin / Left to Right', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Left to Right', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_dir_ARRAY_rtl', 'arrays', 'Locale plugin / Right to Left', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Right to Left', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_flag_reset_title', 'backend', 'Locale plugin / Reset flag', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reset flag', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_flag_reset_content', 'backend', 'Locale plugin / Reset flag: confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to reset selected flag?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_btn_reset', 'backend', 'Locale plugin / Button: Reset', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reset', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_tooltip_upload', 'backend', 'Locale plugin / Upload tooltip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Click to upload', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_tooltip_reset', 'backend', 'Locale plugin / Reset tooltip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Click to reset', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_lbl_language', 'backend', 'Locale plugin / Language', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Language', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_btn_close', 'backend', 'Locale plugin / Button: Close', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Close', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_flag_info_title', 'backend', 'Locale plugin / Info message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Info message', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_locale_error_line', 'backend', 'Label / Error found at line', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The error was found at line: %s', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PBU01', 'arrays', 'error_titles_ARRAY_PBU01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PBU02', 'arrays', 'error_titles_ARRAY_PBU02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup complete!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PBU03', 'arrays', 'error_titles_ARRAY_PBU03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PBU04', 'arrays', 'error_titles_ARRAY_PBU04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PBU01', 'arrays', 'error_bodies_ARRAY_PBU01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We recommend you to regularly back up your database and files to prevent any loss of information.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PBU02', 'arrays', 'error_bodies_ARRAY_PBU02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All backup files have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PBU03', 'arrays', 'error_bodies_ARRAY_PBU03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No option was selected.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PBU04', 'arrays', 'error_bodies_ARRAY_PBU04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup not performed.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_menu_backup', 'backend', 'Backup plugin / Menu Backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_database', 'backend', 'Backup plugin / Backup database', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup database', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_files', 'backend', 'Backup plugin / Backup files', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup files', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_btn_backup', 'backend', 'Backup plugin / Backup button', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PBU05', 'arrays', 'error_titles_ARRAY_PBU05', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PBU05', 'arrays', 'error_bodies_ARRAY_PBU05', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup folder not found. Please ensure that \"app/web/backup\" folder exists.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PBU06', 'arrays', 'error_titles_ARRAY_PBU06', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PBU06', 'arrays', 'error_bodies_ARRAY_PBU06', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You need to set write permissions (chmod 777) to \"app/web/backup\" folder.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_datetime', 'backend', 'Label / Date/time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date/time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_type', 'backend', 'Label / Type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Type', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_file', 'backend', 'Label / File', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_delete_confirmation', 'backend', 'Backup plugin / Delete confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete selected file?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_delete_selected', 'backend', 'Backup plugin / Delete selected', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete selected', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_size', 'backend', 'Plugin / Size', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Size', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_backup_sizeXXXXXX', 'backend', 'Plugin / Size', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SizeXXXX', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_log_menu_log', 'backend', 'Log plugin / Menu Log', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Log', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_log_menu_config', 'backend', 'Log plugin / Menu Config', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Config log', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_log_btn_empty', 'backend', 'Log plugin / Empty button', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Empty log', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PLG01', 'arrays', 'error_titles_ARRAY_PLG01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Config log updated.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PLG01', 'arrays', 'error_bodies_ARRAY_PLG01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The config log have been updated.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_one_admin_menu_index', 'backend', 'One Admin plugin / List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_one_admin_btn_add', 'backend', 'One Admin plugin / Add button', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '+ Add', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_POA01', 'arrays', 'error_titles_ARRAY_POA01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Information', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_POA01', 'arrays', 'error_bodies_ARRAY_POA01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please, note that after changing the scripts in the list below you will need to refresh the page to apply the new updates in the \"One admiN\" menu.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_name', 'backend', 'Country plugin / Country name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country name', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_alpha_2', 'backend', 'Country plugin / Alpha 2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Alpha 2', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_alpha_3', 'backend', 'Country plugin / Alpha 3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Alpha 3', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_status', 'backend', 'Country plugin / Status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_btn_add', 'backend', 'Country plugin / Button Add', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add +', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_statuses_ARRAY_T', 'arrays', 'Country plugin / Status (active)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_statuses_ARRAY_F', 'arrays', 'Country plugin / Status (inactive)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_btn_save', 'backend', 'Country plugin / Button Save', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_btn_cancel', 'backend', 'Country plugin / Button Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_menu_countries', 'backend', 'Country plugin / Menu Countries', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Countries', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PCY01', 'arrays', 'error_titles_ARRAY_PCY01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country updated', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PCY03', 'arrays', 'error_titles_ARRAY_PCY03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country added', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PCY04', 'arrays', 'error_titles_ARRAY_PCY04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country failed to add', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PCY08', 'arrays', 'error_titles_ARRAY_PCY08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country not found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PCY10', 'arrays', 'error_titles_ARRAY_PCY10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add country', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PCY11', 'arrays', 'error_titles_ARRAY_PCY11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update country', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PCY12', 'arrays', 'error_titles_ARRAY_PCY12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Manage countries', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PCY01', 'arrays', 'error_bodies_ARRAY_PCY01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country has been updated successfully.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PCY03', 'arrays', 'error_bodies_ARRAY_PCY03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country has been added successfully.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PCY04', 'arrays', 'error_bodies_ARRAY_PCY04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country has not been added successfully.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PCY08', 'arrays', 'error_bodies_ARRAY_PCY08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country you are looking for has not been found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PCY10', 'arrays', 'error_bodies_ARRAY_PCY10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use form below to add a country.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PCY11', 'arrays', 'error_bodies_ARRAY_PCY11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use form below to update a country.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PCY12', 'arrays', 'error_bodies_ARRAY_PCY12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use grid below to organize your country list.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_delete_confirmation', 'backend', 'Country plugin / Delete confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete selected country?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_delete_selected', 'backend', 'Country plugin / Delete selected', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete selected', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_btn_all', 'backend', 'Country plugin / Button All', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_btn_search', 'backend', 'Country plugin / Button Search', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Search', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_country_revert_status', 'backend', 'Plugin / Revert status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Revert status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_sms_menu_sms', 'backend', 'SMS plugin / Menu SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_sms_config', 'backend', 'SMS plugin / SMS config', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS Config', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_sms_number', 'backend', 'SMS plugin / Number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone number', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_sms_text', 'backend', 'SMS plugin / Text', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_sms_status', 'backend', 'SMS plugin / Status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_sms_created', 'backend', 'SMS plugin / Date & Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date/Time sent', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'plugin_sms_api', 'backend', 'SMS plugin / API Key', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'API Key', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PSS01', 'arrays', 'SMS plugin / Info title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PSS01', 'arrays', 'SMS plugin / Info body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To send SMS you need a valid API Key from <a href="https://clicksend.com/?u=366773">ClickSend</a>. If you have one, enter it in the box below. Click on "Verify your key" button to check if key is valid. Click on "Send a test message" button to send a test message to your phone.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PSS02', 'arrays', 'SMS plugin / API key updates info title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS API key updated!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PSS02', 'arrays', 'SMS plugin / API key updates info body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes have been saved.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCustomizeLayout', 'backend', 'Label / Customer layout', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Customer layout', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallLanguage', 'backend', 'Label / Language', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Language', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblHideLanguageSelector', 'backend', 'Label / Hide language selector', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Hide language selector', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblNoBookingFound', 'backend', 'Labe / No bookings found.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No bookings found.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteSingleEvent', 'backend', 'Labe / Are you sure that you want to delete this event.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure that you want to delete this event?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteRecurringEvent', 'backend', 'Labe / This is recurring event. Do you want to delete all events OR this one only?', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is recurring event. Do you want to delete all events OR this one only?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_delete_all', 'arrays', 'buttons_ARRAY_delete_all', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete all', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_delete_this', 'arrays', 'buttons_ARRAY_delete_this', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete this only', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_cancel', 'arrays', 'buttons_ARRAY_cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_delete', 'arrays', 'buttons_ARRAY_delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE13', 'arrays', 'error_titles_ARRAY_AE13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Image size too large', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE13', 'arrays', 'error_bodies_ARRAY_AE13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event could not be updated because image size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller image.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE12', 'arrays', 'error_titles_ARRAY_AE12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Upload error', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE12', 'arrays', 'error_bodies_ARRAY_AE12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ticket image could not be uploaded successfully. Maximum allowed size is {MAXSIZE}. Please, upload smaller image.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'opt_o_theme', 'backend', 'Options / Theme', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_1', 'arrays', 'option_themes_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 1', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_2', 'arrays', 'option_themes_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 2', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_3', 'arrays', 'option_themes_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 3', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_4', 'arrays', 'option_themes_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 4', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_5', 'arrays', 'option_themes_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 5', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_6', 'arrays', 'option_themes_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 6', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_7', 'arrays', 'option_themes_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 7', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_8', 'arrays', 'option_themes_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 8', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_9', 'arrays', 'option_themes_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 9', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_10', 'arrays', 'option_themes_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 10', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR21', 'arrays', 'error_titles_ARRAY_AR21', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR21', 'arrays', 'error_bodies_ARRAY_AR21', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can export bookings in different formats. You can either download a file with bookings details or use a link for a feed which load all the bookings.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'export_formats_ARRAY_ical', 'arrays', 'export_formats_ARRAY_ical', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'iCal', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'export_formats_ARRAY_xml', 'arrays', 'export_formats_ARRAY_xml', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'XML', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'export_formats_ARRAY_csv', 'arrays', 'export_formats_ARRAY_csv', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CSV', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'export_types_ARRAY_file', 'arrays', 'export_types_ARRAY_file', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'export_types_ARRAY_feed', 'arrays', 'export_types_ARRAY_feed', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Feed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'export_periods_ARRAY_next', 'arrays', 'export_periods_ARRAY_next', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Coming', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'export_periods_ARRAY_last', 'arrays', 'export_periods_ARRAY_last', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Created or Modified', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblFormat', 'backend', 'Label / Format', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Format', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEnterPassword', 'backend', 'Label / Enter password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter password', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_1', 'arrays', 'coming_arr_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Today', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_2', 'arrays', 'coming_arr_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tomorrow', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_3', 'arrays', 'coming_arr_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This week', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_4', 'arrays', 'coming_arr_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next week', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_5', 'arrays', 'coming_arr_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This month', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_6', 'arrays', 'coming_arr_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next month', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_1', 'arrays', 'made_arr_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Today', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_2', 'arrays', 'made_arr_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yesterday', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_3', 'arrays', 'made_arr_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This week', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_4', 'arrays', 'made_arr_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last week', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_5', 'arrays', 'made_arr_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This month', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_6', 'arrays', 'made_arr_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last month', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnExport', 'backend', 'Button / Export', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnGetFeedURL', 'backend', 'Button / Get Feed URL', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Get Feed URL', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblNoAccessToFeed', 'backend', 'Label / No access to feed', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No access to feed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingsFeedTitle', 'backend', 'Infobox / Bookings Feed URL', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings Feed URL', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingsFeedDesc', 'backend', 'Infobox / Bookings Feed URL', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use the URL below to have access to all bookings. Please, note that if you change the password the URL will change too as password is used in the URL itself so no one else can open it.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoInstallPreviewTitle', 'backend', 'Infobox / Preview front end and install on your website', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview front-end and install on your site', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoInstallPreviewDesc', 'backend', 'Infobox / Preview front end and install on your website', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are multiple color schemes available for the front-end UI. You can setup some following Front End options. Then click on each of the thumbnails below to preview it. Click on \"Use this theme\" to change the script colors. Then scroll down and copy/paste the Install code on your web page.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblFrontEndOptions', 'backend', 'Label / Front End options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front End options', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblChooseTheme', 'backend', 'Label / Choose theme', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose theme', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCurrentlyInUse', 'backend', 'Label / Currently in use', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Currently in use', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnUseThisTheme', 'backend', 'Button / Use this theme', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use this theme', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoInstalCodeTitle', 'backend', 'Infobox / Install code', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install code', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoInstalCodeDesc', 'backend', 'Infobox / Install code', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Copy the code below and put it on your web page. it will show the front end booking engine.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnAddEvent', 'backend', 'Button / Add event', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEventsTitle', 'backend', 'Infobox / Events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoEventsDesc', 'backend', 'Infobox / Events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is the list of events. Please click on the button \"+ Add event\" if you want to add new event. If you want to edit an exiting event, you can also click on the pencil icon on the corresponding row.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnAddCategory', 'backend', 'Button / Add category', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add category', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAll', 'backend', 'Label / All', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnAddBooking', 'backend', 'Button / Add booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoAddBookingTitle', 'backend', 'Infobox / Add booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoAddBookingDesc', 'backend', 'Infobox / Add booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fill in the form below and click \"save\" to add new booking.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoUpdateBookingTitle', 'backend', 'Infobox / Update booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoUpdateBookingDesc', 'backend', 'Infobox / Update booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can make any changes on the form below and click \"save\" to update booking information. You can also re-send confirmation email to your clients.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEvents', 'backend', 'Label / Events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEmailAvailableTokens', 'backend', 'Label / Available tokens', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<div class=\"w200 float_left\">Name: {Name}<br>Email: {Email}<br>Phone: {Phone}<br>City: {City}<br>State: {State}<br>Zip: {Zip}<br>Address: {Address}<br>Notes: {Notes}<br>Tickets: {Tickets}</div><div class=\"w250 float_left\">PDF Ticket: {PDF_Tickets}<br>CC type: {CCType}<br>CC number: {CCNum}<br>CC expiration: {CCExp}<br>CC code: {CCSec}<br>Payment: {PaymentMethod}<br>Event: {Event}<br>Event Title: {EventTitle}</div><div class=\"w250 float_left\">Event Date/time: {EventDateTime}<br>Event Location: {EventLocation}<br>Total price: {Total}<br>Tax: {Tax}<br>Deposit: {Deposit}<br>Remaining Balance: {Balance}<br>Booking ID: {BookingID}<br>Cancel URL: {CancelURL}</div>', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabEmail', 'backend', 'Tab / Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabSMS', 'backend', 'Tab / SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoSMSConfirmationTitle', 'backend', 'SMS confirmations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS confirmations', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoSMSConfirmationBody', 'backend', 'SMS confirmations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are 2 types of SMS confirmations - one after booking form is submitted and one after payment is made. Use the available tokens to personalize the SMS messages.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblSMSAvailableTokens', 'backend', 'Label / Available tokens', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<div class=\"w200 float_left\">Name: {Name}<br>Email: {Email}<br>Phone: {Phone}</div><div class=\"w250 float_left\">Booking ID: {BookingID}<br/>Event Title: {EventTitle}<br>Event Date/time: {EventDateTime}</div><div class=\"w250 float_left\">Total price: {Total}<br>Tax: {Tax}<br>Deposit: {Deposit}</div>', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblConfirmationSMS', 'backend', 'Label / Confirmation SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmation SMS', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblConfirmationSMSTip', 'backend', 'Label / Confirmation SMS tip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is the SMS which will be sent to people who book an event right after booking form is submitted.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblPaymentSMS', 'backend', 'Label / Payment SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment SMS', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblPaymentSMSTip', 'backend', 'Label / Payment SMS tip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is the SMs which will be sent to people who book an event right after payment is made.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabPayments', 'backend', 'Tab / Payments', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payments', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblQuickLinks', 'backend', 'Label / / Quick links', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Quick links', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_export_bookings', 'backend', 'Label / / Export bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export Bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_barcode_reader', 'backend', 'Label / Bar code reader', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bar Code Reader', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_preview_calendar', 'backend', 'Label / Preview calendar', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview Calendar', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_payment_options', 'backend', 'Label / Payment Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Options', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_configure_booking_form', 'backend', 'Label / Configure Booking Form', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Configure Booking Form', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingsMade', 'backend', 'Label / Bookings made', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings made', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_back_to_calendar', 'frontend', 'Label / Back to calendar', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back to calendar', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_back_to_list', 'frontend', 'Label / Back to list', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back to list', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteAllImagesBody', 'backend', 'Label / Delete recurring images', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is recurring event. If you want to delete all images, click on the button \"Delete all\". Otherwise if you want to delete only the image of this event, click on the button \"Delete one\".', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnClose', 'backend', 'Button / Close', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Close', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblAtLeastTheseTwo', 'backend', 'Label / At least one of these 2 should be set.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'At least one of these 2 should be set.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_unavailable_ticket_msg', 'frontend', 'Label / unavailable message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The tickets you have booked are not available anymore because someone has already booked during the time you process your booking.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_short_ARRAY_0', 'arrays', 'Days short / Sun', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sun', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_short_ARRAY_1', 'arrays', 'Days short / Mon', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mon', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_short_ARRAY_2', 'arrays', 'Days short / Tue', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tue', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_short_ARRAY_3', 'arrays', 'Days short / Wed', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Wed', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_short_ARRAY_4', 'arrays', 'Days short / Thu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Thu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_short_ARRAY_5', 'arrays', 'Days short / Fri', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fri', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'days_short_ARRAY_6', 'arrays', 'Days short / Sat', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sat', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOrderedProducts', 'backend', 'Label / Products', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Products', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOrderNotFound', 'backend', 'Info / Order not found!', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Order not found!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOrderExtras', 'backend', 'Label / Extras', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extras', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_today', 'backend', 'Label / today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'today', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_new_bookings', 'backend', 'Label / New bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_this_month', 'backend', 'Label / this month', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'this month', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_total_bookings', 'backend', 'Label / Total bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDashUsers', 'backend', 'Label / Users', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Users', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDashEvents', 'backend', 'Label / Events', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_latest_bookings', 'backend', 'Label / Latest Bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Latest Bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_bookings_made', 'backend', 'Label / bookings made', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'bookings made', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_booking_made', 'backend', 'Label / booking made', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'booking made', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_total', 'backend', 'Label / total', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'total', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_view_all_bookings', 'backend', 'Label / View All Bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'View All Bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_event_date', 'backend', 'Label / Event/Date', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Event/Date', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_client', 'backend', 'Label / Client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_tickets', 'backend', 'Label / Tickets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tickets', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_status', 'backend', 'Label / Status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_price', 'backend', 'Label / Price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_no_bookings_found', 'backend', 'Label / No bookings found', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No bookings found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'dash_no_events_found', 'backend', 'Label / No events found', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No events found', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuBookingsList', 'backend', 'Menu / Bookings List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings List', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuReadBarcode', 'backend', 'Menu / Barcode Reader', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Barcode Reader', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuExport', 'backend', 'Menu / Export', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'script_menu_settings', 'backend', 'Menu / Settings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Settings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuPayments', 'backend', 'Menu / Payments', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payments', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuBookingForm', 'backend', 'Menu / Booking Form', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Form', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'menuIntegrationCode', 'backend', 'Menu / Install', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_field_required', 'backend', 'Label / This field is required.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This field is required.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblCategoryName', 'backend', 'Label / Name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoAddEventTitle', 'backend', 'Info / Add new event title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add new event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoAddEventDesc', 'backend', 'Info / Add new event desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use the form below to add events to the system. You can add event title, date and time, category, location and description. You can also upload an image for the event.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoUpdateEventTitle', 'backend', 'Info / Update event title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoUpdateEventDesc', 'backend', 'Info / Update event desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit event details and click on the ''Save'' button to update it.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblOnlyShowDateForEvent', 'backend', 'Label / Only show date for the event and not time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Only show date for the event and not time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_0', 'arrays', 'short_days_ARRAY_0', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Su', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_1', 'arrays', 'short_days_ARRAY_1', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mo', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_2', 'arrays', 'short_days_ARRAY_2', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_3', 'arrays', 'short_days_ARRAY_3', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_4', 'arrays', 'short_days_ARRAY_4', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Th', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_5', 'arrays', 'short_days_ARRAY_5', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fr', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_6', 'arrays', 'short_days_ARRAY_6', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sa', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_event_end_datetime_invalid', 'backend', 'Error / End date time must be greater than start date time', 'script', '2020-12-14 07:04:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'End date time must be greater than start date time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblSelectImage', 'backend', 'lblSelectImage', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select image', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblChangeImage', 'backend', 'lblChangeImage', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Change image', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'prices_invalid_input', 'backend', 'Label / The price value cannot be greater than 99999999999999.99', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The price value cannot be greater than 99999999999999.99', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'prices_invalid_price', 'backend', 'Label / Please enter a valid price.', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a valid price.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'price_err_ARRAY_100', 'arrays', 'price_err_ARRAY_100', 'script', '2019-08-26 08:17:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The price cannot be greater than 99999999999999.99.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'event_invalid_datetime_from', 'backend', 'Error / Start date time must be lesser than end date time', 'script', '2019-08-26 08:17:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Start date time must be lesser than end date time', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'event_invalid_datetime_to', 'backend', 'Error / End date time must be greater than start date time', 'script', '2019-08-26 08:17:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'End date time must be greater than start date time', 'script');




INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingOptionsTitle', 'backend', 'Info / Booking Options Title', 'script', '2019-08-26 08:17:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Options', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingOptionsBody', 'backend', 'Info / Booking Options Description', 'script', '2019-08-26 08:17:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use the form below to set your payment and booking process options. It is important to define the deposit payment setting if you enable online payments, because this option will define the amount that customers will be charged online.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoInstallCodeTitle', 'backend', 'infoInstallCodeTitle', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install Code', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoInstallDesc', 'backend', 'infoInstallDesc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Follow the instructions below to install the script on your website.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoInstallTitle', 'backend', 'infoInstallTitle', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Integration Code', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallConfig', 'backend', 'lblInstallConfig', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Language configuration', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallConfigHide', 'backend', 'lblInstallConfigHide', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Hide language selector', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallConfigLocale', 'backend', 'lblInstallConfigLocale', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select language', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_body', 'backend', 'lblInstallJs1_body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Copy the code below and put it on your web page. It will show the front end booking engine.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_title', 'backend', 'lblInstallJs1_title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview front end and install on your website', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallFrontEndConfig', 'backend', 'lblInstallFrontEndConfig', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front End options', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_client', 'arrays', 'recipients_ARRAY_client', 'script', '2020-11-12 03:38:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_admin', 'arrays', 'recipients_ARRAY_admin', 'script', '2020-10-26 05:40:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Administrator', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoNotificationsTitle', 'backend', 'Infobox / Notifications', 'script', '2020-10-20 06:56:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoNotificationsDesc', 'backend', 'Infobox / Notifications', 'script', '2020-10-20 06:58:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email notifications will be sent to administrator after new reservation made. If you leave subject field blank no email will be sent.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_recipient', 'backend', 'Label / Messages sent to', 'script', '2020-10-26 05:41:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_client', 'backend', 'notifications_msg_to_client', 'script', '2020-10-26 05:54:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Client', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_admin', 'backend', 'notifications_msg_to_admin', 'script', '2020-10-26 05:54:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Admin', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_default', 'backend', 'notifications_msg_to_default', 'script', '2020-10-26 05:55:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_send', 'backend', 'notifications_send', 'script', '2020-10-26 05:55:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_do_not_send', 'backend', 'notifications_do_not_send', 'script', '2020-10-26 05:55:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Do not send', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_confirmation', 'arrays', 'notifications_ARRAY_client_email_confirmation', 'plugin', '2020-08-03 19:43:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send booking confirmation email', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_payment', 'arrays', 'notifications_ARRAY_client_email_payment', 'plugin', '2020-08-03 19:44:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_cancel', 'arrays', 'notifications_ARRAY_client_email_cancel', 'plugin', '2020-08-03 19:44:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_confirmation', 'arrays', 'notifications_ARRAY_admin_email_confirmation', 'plugin', '2020-08-03 19:54:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send booking confirmation email', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_payment', 'arrays', 'notifications_ARRAY_admin_email_payment', 'plugin', '2020-08-03 19:54:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_cancel', 'arrays', 'notifications_ARRAY_admin_email_cancel', 'plugin', '2020-08-03 19:54:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_sms_confirmation', 'arrays', 'notifications_ARRAY_admin_sms_confirmation', 'plugin', '2020-08-03 19:55:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send booking confirmation SMS', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_sms_payment', 'arrays', 'notifications_ARRAY_admin_sms_payment', 'plugin', '2020-08-03 19:55:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation SMS', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_sms_cancel', 'arrays', 'notifications_ARRAY_admin_sms_cancel', 'plugin', '2020-08-03 19:55:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send booking cancel SMS', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_sms_confirmation', 'arrays', 'notifications_titles_ARRAY_admin_sms_confirmation', 'plugin', '2020-08-03 20:13:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Confirmation SMS sent to Admin', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_sms_confirmation', 'arrays', 'notifications_subtitles_ARRAY_admin_sms_confirmation', 'plugin', '2020-08-03 20:13:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to the Admin when a booking made.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_sms_payment', 'arrays', 'notifications_titles_ARRAY_admin_sms_payment', 'plugin', '2020-08-03 20:14:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Confirmation SMS sent to Admin', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_sms_payment', 'arrays', 'notifications_subtitles_ARRAY_admin_sms_payment', 'plugin', '2020-08-03 20:14:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to the Admin when the payment made for new booking.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_sms_cancel', 'arrays', 'notifications_titles_ARRAY_admin_sms_cancel', 'plugin', '2020-08-03 20:14:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation cancelled SMS sent to Admin', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_sms_cancel', 'arrays', 'notifications_subtitles_ARRAY_admin_sms_cancel', 'plugin', '2020-08-03 20:14:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to the admin when the client cancels a reservation.', 'plugin');


INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_sms_confirmation', 'arrays', 'notifications_ARRAY_client_sms_confirmation', 'plugin', '2020-08-03 19:55:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send booking confirmation SMS', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_sms_payment', 'arrays', 'notifications_ARRAY_client_sms_payment', 'plugin', '2020-08-03 19:55:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation SMS', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_sms_cancel', 'arrays', 'notifications_ARRAY_client_sms_cancel', 'plugin', '2020-08-03 19:55:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send booking cancel SMS', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_sms_confirmation', 'arrays', 'notifications_titles_ARRAY_client_sms_confirmation', 'plugin', '2020-08-03 20:13:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Confirmation SMS sent to Client', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_sms_confirmation', 'arrays', 'notifications_subtitles_ARRAY_client_sms_confirmation', 'plugin', '2020-08-03 20:13:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to the Client when a booking made.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_sms_payment', 'arrays', 'notifications_titles_ARRAY_client_sms_payment', 'plugin', '2020-08-03 20:14:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Confirmation SMS sent to Client', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_sms_payment', 'arrays', 'notifications_subtitles_ARRAY_client_sms_payment', 'plugin', '2020-08-03 20:14:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to the Client when the payment made for new booking.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_sms_cancel', 'arrays', 'notifications_titles_ARRAY_client_sms_cancel', 'plugin', '2020-08-03 20:14:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation cancelled SMS sent to Client', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_sms_cancel', 'arrays', 'notifications_subtitles_ARRAY_client_sms_cancel', 'plugin', '2020-08-03 20:14:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to the Client when the client cancels a reservation.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subject', 'backend', 'Label / Subject', 'plugin', '2020-08-03 20:01:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_messages', 'backend', 'Label / Messages', 'plugin', '2020-08-03 20:02:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_is_active', 'backend', 'Label / Send this message', 'plugin', '2020-08-03 20:03:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send this message', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_confirmation', 'arrays', 'notifications_titles_ARRAY_client_email_confirmation', 'plugin', '2020-08-03 20:04:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Confirmation email sent to Client', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_confirmation', 'arrays', 'notifications_subtitles_ARRAY_client_email_confirmation', 'plugin', '2020-08-03 20:05:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to client when a new booking is made.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_payment', 'arrays', 'notifications_titles_ARRAY_client_email_payment', 'plugin', '2020-08-03 20:05:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Confirmation email sent to Client', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_payment', 'arrays', 'notifications_subtitles_ARRAY_client_email_payment', 'plugin', '2020-08-03 20:06:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when a payment is made for a new booking.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_cancel', 'arrays', 'notifications_titles_ARRAY_client_email_cancel', 'plugin', '2020-08-03 20:06:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Cancellation email sent to Client', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_cancel', 'arrays', 'notifications_subtitles_ARRAY_client_email_cancel', 'plugin', '2020-08-03 20:07:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when a client cancels a booking.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_confirmation', 'arrays', 'notifications_titles_ARRAY_admin_email_confirmation', 'plugin', '2020-08-03 20:10:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Confirmation email sent to Admin', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_confirmation', 'arrays', 'notifications_subtitles_ARRAY_admin_email_confirmation', 'plugin', '2020-08-03 20:10:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to Admin when a new booking is made.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_payment', 'arrays', 'notifications_titles_ARRAY_admin_email_payment', 'plugin', '2020-08-03 20:11:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Confirmation email sent to Admin', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_payment', 'arrays', 'notifications_subtitles_ARRAY_admin_email_payment', 'plugin', '2020-08-03 20:11:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the Admin when a payment is made for a new booking.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_cancel', 'arrays', 'notifications_titles_ARRAY_admin_email_cancel', 'plugin', '2020-08-03 20:12:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Cancellation email sent to Admin', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_cancel', 'arrays', 'notifications_subtitles_ARRAY_admin_email_cancel', 'plugin', '2020-08-03 20:12:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the Admin when a booking cancelled.', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_sms_na', 'backend', 'Label / Subject', 'plugin', '2020-08-03 20:18:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS notifications are currently not available for your website. See details', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_sms_na_here', 'backend', 'Label / Subject', 'plugin', '2020-08-03 20:18:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'here', 'plugin');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_main_title', 'backend', 'notifications_main_title', 'script', '2020-10-26 08:00:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_main_subtitle', 'backend', 'notifications_main_subtitle', 'script', '2020-10-26 08:01:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Automated messages are sent both to owner and administrator on specific events. Select message type to edit it - enable/disable or just change message text. For SMS notifications you need to enable SMS service. See more <a href="https://www.phpjabbers.com/web-sms/" target="_blank">here</a>.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_tokens', 'backend', 'notifications_tokens', 'script', '2020-10-26 08:06:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available Tokens', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_tokens_note', 'backend', 'notifications_tokens_note', 'script', '2020-10-26 08:06:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Personalize the message by including any of the available tokens and it will be replaced with corresponding data.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteTicketImageTitle', 'backend', 'Info / Delete ticket image title', 'script', '2020-11-12 03:38:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete ticket image', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteTicketImageBody', 'backend', 'Info / Delete ticket image body', 'script', '2020-10-26 05:40:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete this ticket image?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallPhp1PerEventTitle', 'backend', 'Info / Install code per event title', 'script', '2020-11-12 03:38:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install code per event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblInstallPhp1PerEventBody', 'backend', 'Info / Install code per event body', 'script', '2020-10-26 05:40:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Using the code below you can put that specific event on any of your website web pages. Your website visitors will only view and be able to book this event only.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteEventTitle', 'backend', 'Info / Delete confirmation', 'script', '2020-11-12 03:38:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteEventBody', 'backend', 'Info / Delete confirmation body', 'script', '2020-10-26 05:40:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete selected record?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteRecurringEventTitle', 'backend', 'Info / Delete confirmation', 'script', '2020-11-12 03:38:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteRecurringEventBody', 'backend', 'Info / Delete confirmation body', 'script', '2020-10-26 05:40:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is recurring event. Do you want to delete all events OR this one only?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnDeleteThisOnly', 'backend', 'Button / Delete this only', 'script', '2020-11-12 03:38:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete this only', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnDeleteAll', 'backend', 'Button / Delete all', 'script', '2020-10-26 05:40:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete all', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDeleteAll', 'backend', 'Label / Delete all', 'script', '2020-10-26 05:40:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete all', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoPreviewTitle', 'backend', 'Infobox / Preview front end', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview front end', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoPreviewDesc', 'backend', 'Infobox / Preview front end', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Here is how the Front-End look like.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'script_change_labels', 'backend', 'Label / Change Labels', 'script', '2020-08-13 11:15:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Change Labels', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'script_preview_your_website', 'backend', 'Label / Preview your website', 'script', '2020-08-13 11:19:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Open in new window', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'script_install_your_website', 'backend', 'Label / Install your website', 'script', '2020-08-13 11:19:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install your website', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnPreview', 'backend', 'Button / Preview', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingsListTitle', 'backend', 'Infobox / List of bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'List of bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'infoBookingsListDesc', 'backend', 'Infobox / List of bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can find below the list of bookings made on the system. If you want to add new booking, click on the button "+ Add booking".', 'script');
	
INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnAdvancedSearch', 'backend', 'Button / Advanced search', 'script', '2020-10-30 08:30:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Advanced search', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'tabClient', 'backend', 'Tab / Client', 'script', '2020-10-30 08:30:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblDuplicatedUniqueID', 'backend', 'Label / There is another booking with such ID.', 'script', '2021-02-03 08:52:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There is another booking with such ID.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'script_online_payment_gateway', 'backend', 'Label / Online payments', 'script', '2020-11-09 14:41:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Online payments', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'script_offline_payment', 'backend', 'Label / Offline payments', 'script', '2020-11-09 14:41:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Offline payments', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingDetailsDesc', 'backend', 'Info / Booking details', 'script', '2020-11-09 14:41:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking details', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingPriceDetailsDesc', 'backend', 'Info / Booking price details', 'script', '2020-11-09 14:41:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is price details of booking. ', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingTotalPrice', 'backend', 'Label / Total Price', 'script', '2020-11-09 14:41:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total Price', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingPaymentMade', 'backend', 'Label / Payment Made', 'script', '2020-11-09 14:41:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Made', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingPaymentDue', 'backend', 'Label / Payment Due', 'script', '2020-11-09 14:41:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Due', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingConfirmationResend', 'backend', 'Booking / Send confirmation email', 'script', '2021-02-03 08:52:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send confirmation email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingPaymentResend', 'backend', 'Booking / Send payment confirmation email', 'script', '2021-02-03 08:52:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblBookingCancelledResend', 'backend', 'Booking / Send cancellation email', 'script', '2021-02-03 08:52:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_email_confirmation', 'backend', 'Label / Email confirmation', 'script', '2020-11-13 01:55:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_email_payment', 'backend', 'Label / Email payment confirmation', 'script', '2020-11-13 01:55:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email payment confirmation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'ebc_email_cancellation', 'backend', 'Label / Email cancellation', 'script', '2020-11-13 01:55:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email cancellation', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEmailNotificationNotSet', 'backend', 'Label / Email notification is not set.', 'script', '2020-11-13 03:23:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email notification is not set.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEmailPaymentNotificationNotSet', 'backend', 'Label / Email payment notification is not set.', 'script', '2020-11-13 03:23:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email payment notification is not set.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblEmailCancellationNotSet', 'backend', 'Label / Email cancellation is not set.', 'script', '2020-11-13 03:48:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email cancellation is not set.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'lblExportSelected', 'backend', 'Label / Export selected', 'script', '2020-11-13 01:55:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export selected', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnMarkTicketAsUsed', 'backend', 'Button / Mark ticket as used', 'script', '2020-11-13 01:55:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mark ticket as used', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'alert_mark_ticket_used_title', 'backend', 'Info / Mark ticket as used title', 'script', '2020-11-13 01:55:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mark ticket as used', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'alert_mark_ticket_used_text', 'backend', 'Info / Mark ticket as used text', 'script', '2020-11-13 01:55:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to mark this ticket as used?', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'btnYes', 'backend', 'Button / Yes', 'script', '2020-11-13 01:55:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_cron_completed', 'backend', 'Label / Cron has been excuted!', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cron has been excuted!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'double_check_error_ARRAY_101', 'backend', 'double_check_error_ARRAY_101', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha is missing.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'double_check_error_ARRAY_102', 'backend', 'double_check_error_ARRAY_102', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha cannot be empty.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'double_check_error_ARRAY_103', 'backend', 'double_check_error_ARRAY_103', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha is not correct.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'double_check_error_ARRAY_104', 'backend', 'double_check_error_ARRAY_104', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid Data!', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'co_v_captcha_remote', 'frontend', 'Checkout / Validation / Captcha remote', 'script', '2014-06-24 07:27:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha is wrong', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_ip_address_blocked', 'frontend', 'front_ip_address_blocked', 'script', '2020-10-21 08:17:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your IP address has been blocked.', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'front_select_payment', 'frontend', 'front_select_payment', 'script', '2020-10-21 08:17:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select payment method', 'script');




INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'notifications_tokens_list', 'backend', 'notifications_tokens_list', 'script', '2020-10-26 08:06:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<div><small><strong>{Name}</strong> - customer''s name</small></div>
<div><small><strong>{Email}</strong> - customer''s email</small></div>
<div><small><strong>{Phone}</strong> - customer''s phone number</small></div>
<div><small><strong>{Address}</strong> - customer''s address</small></div>
<div><small><strong>{City}</strong> - customer''s city</small></div>
<div><small><strong>{State}</strong> - customer''s state</small></div>
<div><small><strong>{Zip}</strong> - customer''s zip code</small></div>
<div><small><strong>{Country}</strong> - customer''s country</small></div>
<div><small><strong>{Notes}</strong> - any additional notes</small></div>
<div><small><strong>{PaymentMethod}</strong> - payment method</small></div>
<div><small><strong>{Tickets}</strong> - tickets</small></div>
<div><small><strong>{PDF_Tickets}</strong> - PDF tickets</small></div>
<div><small><strong>{Event}</strong> - event</small></div>
<div><small><strong>{EventTitle}</strong> - event title</small></div>
<div><small><strong>{EventDateTime}</strong> - event date/time</small></div>            						
<div><small><strong>{EventLocation}</strong> - event location</small></div>
<div><small><strong>{Total}</strong> - total price;</small></div>
<div><small><strong>{Tax}</strong> - tax</small></div>
<div><small><strong>{Deposit}</strong> - deposit</small></div>            						
<div><small><strong>{Balance}</strong> - balance</small></div>
<div><small><strong>{BookingID}</strong> - booking ID</small></div>
<div><small><strong>{CancelURL}</strong> - cancel URL</small></div>', 'script');



INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdmin_pjActionIndex');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdmin_pjActionIndex', 'backend', 'Label / Dashboard Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dashboard Menu', 'script');


INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminCategories');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminCategories_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminCategories_pjActionCreateForm');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminCategories_pjActionUpdateForm');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminCategories_pjActionDeleteCategory');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminCategories_pjActionDeleteCategoryBulk');
	

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminCategories', 'backend', 'pjAdminCategories', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Categories Menu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminCategories_pjActionIndex', 'backend', 'pjAdminCategories_pjActionIndex', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Categories List', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminCategories_pjActionCreateForm', 'backend', 'pjAdminCategories_pjActionCreateForm', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add categories', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminCategories_pjActionUpdateForm', 'backend', 'pjAdminCategories_pjActionUpdateForm', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit categories', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminCategories_pjActionDeleteCategory', 'backend', 'pjAdminCategories_pjActionDeleteCategory', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single product', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminCategories_pjActionDeleteCategoryBulk', 'backend', 'pjAdminCategories_pjActionDeleteCategoryBulk', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple categories', 'script');


	
INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminEvents');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminEvents_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEvents_pjActionCreate');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEvents_pjActionUpdate');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEvents_pjActionDeleteEvent');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEvents_pjActionDeleteEventBulk');
	INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEvents_pjActionExportEvent');
	INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEvents_pjActionStatusEvent');
	

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminEvents', 'backend', 'pjAdminEvents', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Events Menu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminEvents_pjActionIndex', 'backend', 'pjAdminEvents_pjActionIndex', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Events List', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminEvents_pjActionCreate', 'backend', 'pjAdminEvents_pjActionCreate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminEvents_pjActionUpdate', 'backend', 'pjAdminEvents_pjActionUpdate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminEvents_pjActionDeleteEvent', 'backend', 'pjAdminEvents_pjActionDeleteEvent', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single event', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminEvents_pjActionDeleteEventBulk', 'backend', 'pjAdminEvents_pjActionDeleteEventBulk', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminEvents_pjActionExportEvent', 'backend', 'pjAdminEvents_pjActionExportEvent', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export events', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminEvents_pjActionStatusEvent', 'backend', 'pjAdminEvents_pjActionStatusEvent', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Revert status of the events', 'script');


INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionBooking'); 
  INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjPayments_pjActionIndex');
  INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionBookingForm'); 
  
INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions_pjActionPreview');
INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions_pjActionInstall');


INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminOptions', 'backend', 'pjAdminOptions', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Settings Menu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionBooking', 'backend', 'pjAdminOptions_pjActionBooking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Options', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjPayments_pjActionIndex', 'backend', 'pjPayments_pjActionIndex', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Options', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionBookingForm', 'backend', 'pjAdminOptions_pjActionBookingForm', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Form', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionInstall', 'backend', 'pjAdminOptions_pjActionInstall', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Integration Code Menu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionPreview', 'backend', 'pjAdminOptions_pjActionPreview', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview Menu', 'script');


INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminBookings');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminBookings_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionCreate');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionUpdate');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionDeleteBooking');
    INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionDeleteBookingBulk');
	INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionExportBooking');
	
  INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminBookings_pjActionReadBarcode');
  INSERT INTO `eventbooking_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminBookings_pjActionExport');
	

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings', 'backend', 'pjAdminBookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings Menu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionIndex', 'backend', 'pjAdminBookings_pjActionIndex', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings List', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionCreate', 'backend', 'pjAdminBookings_pjActionCreate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionUpdate', 'backend', 'pjAdminBookings_pjActionUpdate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionDeleteBooking', 'backend', 'pjAdminBookings_pjActionDeleteBooking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single booking', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionDeleteBookingBulk', 'backend', 'pjAdminBookings_pjActionDeleteBookingBulk', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionExportBooking', 'backend', 'pjAdminBookings_pjActionExportBooking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export bookings', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionReadBarcode', 'backend', 'pjAdminBookings_pjActionReadBarcode', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Barcode Reader Menu', 'script');

INSERT INTO `eventbooking_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionExport', 'backend', 'pjAdminBookings_pjActionExport', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `eventbooking_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export Menu', 'script');

