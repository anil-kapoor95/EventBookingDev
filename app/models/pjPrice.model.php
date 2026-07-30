<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjPriceModel extends pjAppModel
{
	protected $primaryKey = 'id';
	
	protected $table = 'prices';
	
	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'event_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'recurring', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'price', 'type' => 'decimal', 'default' => ':NULL'),
		array('name' => 'available', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'max_purchase', 'type' => 'int', 'default' => '0')
	);
	
	public $i18n = array('name');
	
	public static function factory($attr=array())
	{
		return new pjPriceModel($attr);
	}
	
	public function setPrice($current_id, $id, $post)
	{
		$pjMultiLangModel = pjMultiLangModel::factory();
	
		if(isset($post['index_arr']) && $post['index_arr'] != '')
		{
			$index_arr = explode("|", $post['index_arr']);
			foreach($index_arr as $k => $v)
			{
				if(strpos($v, 'ebc') !== false)
				{
					$price_data = array();
					$price_data['event_id'] = $id;
					$price_data['recurring'] = md5($current_id. $v . PJ_SALT);
					$price_data['price'] = $post['price'][$v];
					$price_data['available'] = $post['available'][$v];
						$price_data['max_purchase'] = isset($post['max_purchase'][$v]) ? (int) $post['max_purchase'][$v] : 0;
						
					$price_id = $this->reset()->setAttributes($price_data)->insert()->getInsertId();
					if ($price_id !== false && (int) $price_id > 0)
					{
						foreach ($post['i18n'] as $locale => $locale_arr)
						{
							foreach ($locale_arr as $field => $content)
							{
								if(is_array($content))
								{
									$insert_id = $pjMultiLangModel->reset()->setAttributes(array(
											'foreign_id' => $price_id,
											'model' => 'pjPrice',
											'locale' => $locale,
											'field' => $field,
											'content' => $content[$v],
											'source' => 'data'
									))->insert()->getInsertId();
								}
							}
						}
					}
				}
			}
		}
	}
	
	public function updatePrice($event_id, $post, $has_recurring)
	{
		$pjEventModel = pjEventModel::factory();
		$pjMultiLangModel = pjMultiLangModel::factory();
	
		$arr_i18n = array();
		if (isset($post['i18n']))
		{
			foreach ($post['i18n'] as $locale_id => $items) {
				foreach ($items as $k => $v) {
					if ($k == 'name') {
						$arr_i18n[$locale_id][$k] = $v;
					}
				}
			}
		}
		
		$index_arr = explode("|", $post['index_arr']);
		foreach($index_arr as $k => $v)
		{
			if(strpos($v, 'ebc') !== false)
			{
				if($has_recurring == 1)
				{
					$recurring_events_arr = $pjEventModel->reset()->where('recurring_id', $post['recurring_id'])->findAll()->getData();
						
					foreach ($recurring_events_arr as $event)
					{
						$price_data = array();
						$price_data['event_id'] = $event['id'];
						$price_data['recurring'] = md5($event_id. $v . PJ_SALT);
						$price_data['price'] = $post['price'][$v];
						$price_data['available'] = $post['available'][$v];
						$price_data['max_purchase'] = isset($post['max_purchase'][$v]) ? (int) $post['max_purchase'][$v] : 0;
						$price_id = $this->reset()->setAttributes($price_data)->insert()->getInsertId();
						if ($price_id !== false && (int) $price_id > 0)
						{
							foreach ($arr_i18n as $locale => $locale_arr)
							{
								foreach ($locale_arr as $field => $content)
								{
									if(is_array($content))
									{
										$insert_id = $pjMultiLangModel->reset()->setAttributes(array(
												'foreign_id' => $price_id,
												'model' => 'pjPrice',
												'locale' => $locale,
												'field' => $field,
												'content' => $content[$v],
												'source' => 'data'
										))->insert()->getInsertId();
									}
								}
							}
						}
					}
				}else{
					$price_data = array();
					$price_data['event_id'] = $event_id;
					$price_data['recurring'] = md5($event_id. $v . PJ_SALT);
					$price_data['price'] = $post['price'][$v];
					$price_data['available'] = $post['available'][$v];
						$price_data['max_purchase'] = isset($post['max_purchase'][$v]) ? (int) $post['max_purchase'][$v] : 0;
					$price_id = $this->reset()->setAttributes($price_data)->insert()->getInsertId();
					if ($price_id !== false && (int) $price_id > 0)
					{
						foreach ($arr_i18n as $locale => $locale_arr)
						{
							foreach ($locale_arr as $field => $content)
							{
								if(is_array($content))
								{
									$insert_id = $pjMultiLangModel->reset()->setAttributes(array(
											'foreign_id' => $price_id,
											'model' => 'pjPrice',
											'locale' => $locale,
											'field' => $field,
											'content' => $content[$v],
											'source' => 'data'
									))->insert()->getInsertId();
								}
							}
						}
					}
				}
			}else{
				if($has_recurring == 1)
				{
					$price = $this->reset()->find($v)->getData();
					$recurring_price_arr = $this->reset()->where('recurring', $price['recurring'])->findAll()->getData();
					foreach($recurring_price_arr as $rp)
					{
						$price_data = array();
						$price_data['price'] = $post['price'][$v];
						$price_data['available'] = $post['available'][$v];
						$price_data['max_purchase'] = isset($post['max_purchase'][$v]) ? (int) $post['max_purchase'][$v] : 0;
						$this->reset()->where('id', $rp['id'])->limit(1)->modifyAll($price_data);
	
						foreach ($arr_i18n as $locale => $locale_arr)
						{
							foreach ($locale_arr as $field => $content)
							{
								if(is_array($content))
								{
									$sql = sprintf("INSERT INTO `%1\$s` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
													VALUES (NULL, :foreign_id, :model, :locale, :field, :update_content, :source)
													ON DUPLICATE KEY UPDATE `content` = :update_content, `source` = :source;",
											$pjMultiLangModel->getTable()
									);
									$foreign_id = $rp['id'];
									$model = 'pjPrice';
									$source = 'data';
									$update_content = $content[$v];
									$modelObj = $pjMultiLangModel->reset()->prepare($sql)->exec(compact('foreign_id', 'model', 'locale', 'field', 'update_content', 'source'));
									if ($modelObj->getAffectedRows() > 0 || $modelObj->getInsertId() > 0)
									{
	
									}
								}
							}
						}
					}
				}else{
					$price_data = array();
					$price_data['price'] = $post['price'][$v];
					$price_data['available'] = $post['available'][$v];
						$price_data['max_purchase'] = isset($post['max_purchase'][$v]) ? (int) $post['max_purchase'][$v] : 0;
					$this->reset()->where('id', $v)->limit(1)->modifyAll($price_data);
					foreach ($arr_i18n as $locale => $locale_arr)
					{
						foreach ($locale_arr as $field => $content)
						{
							if(is_array($content))
							{
								$sql = sprintf("INSERT INTO `%1\$s` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`)
													VALUES (NULL, :foreign_id, :model, :locale, :field, :update_content, :source)
													ON DUPLICATE KEY UPDATE `content` = :update_content, `source` = :source;",
										$pjMultiLangModel->getTable()
								);
								$foreign_id = $v;
								$model = 'pjPrice';
								$source = 'data';
								$update_content = $content[$v];
								$modelObj = $pjMultiLangModel->reset()->prepare($sql)->exec(compact('foreign_id', 'model', 'locale', 'field', 'update_content', 'source'));
								if ($modelObj->getAffectedRows() > 0 || $modelObj->getInsertId() > 0)
								{
	
								}
							}
						}
					}
				}
	
			}
		}
		if(isset($post['remove_arr']) && $post['remove_arr'] != '')
		{
			$remove_arr = explode("|", $post['remove_arr']);
			if($has_recurring == 1)
			{
				$price_arr = $this->reset()->whereIn('id', $remove_arr)->findAll()->getData();
				foreach($price_arr as $price)
				{
					$recurring_price_arr = $this->reset()->where('recurring', $price['recurring'])->findAll()->getData();
					foreach($recurring_price_arr as $rp)
					{
						$pjMultiLangModel->reset()->where('model', 'pjPrice')->whereIn('foreign_id', $rp['id'])->eraseAll();
					}
					$this->reset()->where('recurring', $price['recurring'])->eraseAll();
				}
			}else{
				$pjMultiLangModel->reset()->where('model', 'pjPrice')->whereIn('foreign_id', $remove_arr)->eraseAll();
				$this->reset()->whereIn('id', $remove_arr)->eraseAll();
			}
		}
	}
	
}
?>