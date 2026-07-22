<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjVoucherEventModel extends pjAppModel
{
	protected $primaryKey = null;

	protected $table = 'vouchers_events';

	protected $schema = array(
		array('name' => 'voucher_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'event_id', 'type' => 'int', 'default' => ':NULL')
	);

	public static function factory($attr=array())
	{
		return new pjVoucherEventModel($attr);
	}
}
?>