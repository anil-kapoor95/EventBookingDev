<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjEventModel extends pjAppModel
{
	protected $primaryKey = 'id';
	
	protected $table = 'events';
	
	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'recurring_id', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'category_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'event_start_ts', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'event_end_ts', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'event_img', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'event_thumb', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'event_medium', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'o_show_start_time', 'type' => 'enum', 'default' => 'T'),
		array('name' => 'o_show_end_time', 'type' => 'enum', 'default' => 'T'),
		array('name' => 'ticket_img', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'status', 'type' => 'enum', 'default' => 'T')
	);
	
	public $i18n = array('title', 'description', 'location', 'terms', 'ticket_info', 'o_email_confirmation_subject', 'o_email_confirmation', 'o_email_payment_subject', 'o_email_payment', 'o_sms_confirmation', 'o_sms_payment');
	
	public static function factory($attr=array())
	{
		return new pjEventModel($attr);
	}
}
?>