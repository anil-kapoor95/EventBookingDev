<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjNotificationModel extends pjAppModel
{
	protected $primaryKey = 'id';
	
	protected $table = 'notifications';
	
	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
	    array('name' => 'foreign_id', 'type' => 'int', 'default' => '0'),
		array('name' => 'recipient', 'type' => 'enum', 'default' => ':NULL'),
		array('name' => 'transport', 'type' => 'enum', 'default' => ':NULL'),
		array('name' => 'variant', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'is_active', 'type' => 'tinyint', 'default' => 1),
	    array('name' => 'is_general', 'type' => 'tinyint', 'default' => '0'),
	);
	
	protected $validate = array();
	
	protected $i18n = array('subject', 'message');
	
	public static function factory($attr=array())
	{
		return new self($attr);
	}
	
	public function initConfirmation($foreign_id)
	{
		$pjNotificationModel = pjNotificationModel::factory();
	    $init_notify_arr = $pjNotificationModel->where('foreign_id', 0)->where('is_general', 0)->orderBy("id ASC")->findAll()->getData();
	    foreach ($init_notify_arr as $record)
	    {
	        $record['foreign_id'] = $foreign_id;
	        unset($record['id']);
	        $pjNotificationModel->reset()->setAttributes($record)->insert();
	    }
	}
}
?>