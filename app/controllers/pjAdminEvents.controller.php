<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminEvents extends pjAdmin
{
	public function pjActionCheckPrices()
    {
        $this->setAjax(true);
        
    	if($str_index = $this->_post->toString('index_arr'))
		{
			$post = $this->_post->raw();
			$index_arr = explode("|", $str_index);
			foreach($index_arr as $k => $v)
			{
				if(strpos($v, 'ebc') !== false)
				{
					if($post['price'][$v] > 99999999999999.99)
					{
						self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => __('price_err_ARRAY_100', true)));
					}
				}
			}
		}
        self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
    }
	
	public function pjActionCreate()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
	    $post_max_size = pjUtil::getPostMaxSize();
		if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SERVER['CONTENT_LENGTH']) && (int) $_SERVER['CONTENT_LENGTH'] > $post_max_size)
	    {
	        pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminEvents&action=pjActionIndex&err=AE05");
	    }
	    
	    if (self::isPost() && $this->_post->toInt('event_create'))
	    {
	    	$pjEventModel = pjEventModel::factory();
			$pjPriceModel = pjPriceModel::factory();
			
			$data = array();
			$range_days = 0;
			$one_day = 60 * 60 * 24;
			
			$_start = $this->_post->toString('event_start_ts');
			$_end = $this->_post->toString('event_end_ts');
			
			if(count(explode(" ", $_start)) == 3)
			{
				list($_start_date, $_start_time, $_start_period) = explode(" ", $_start);
				list($_end_date, $_end_time, $_end_period) = explode(" ", $_end);
				$_start_time = pjDateTime::formatTime($_start_time . ' ' . $_start_period, $this->option_arr['o_time_format']);
				$_end_time = pjDateTime::formatTime($_end_time . ' ' . $_end_period, $this->option_arr['o_time_format']);
			}else{
				list($_start_date, $_start_time) = explode(" ", $_start);
				list($_end_date, $_end_time) = explode(" ", $_end);
				$_start_time = pjDateTime::formatTime($_start_time, $this->option_arr['o_time_format']);
				$_end_time = pjDateTime::formatTime($_end_time, $this->option_arr['o_time_format']);
			}
			
			$data['event_start_ts'] = strtotime(pjDateTime::formatDate($_start_date, $this->option_arr['o_date_format']) . ' ' . $_start_time);
			$data['event_end_ts'] = strtotime(pjDateTime::formatDate($_end_date, $this->option_arr['o_date_format']) . ' ' . $_end_time);
			
			$event_start_ts = $data['event_start_ts'];
			$event_end_ts = $data['event_end_ts'];
			$data['status'] = $this->_post->check('status') ? 'T' : 'F';
			$data['o_show_start_time'] = $this->_post->check('o_show_start_time') ? 'F' : 'T';
			$data['o_show_end_time'] = $this->_post->check('o_show_end_time') ? 'F' : 'T';
			$id = $pjEventModel->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
			
			if ($id !== false && (int) $id > 0)
			{
				if (isset($_FILES['event_img']) && !empty($_FILES['event_img']['tmp_name']))
				{
					if($_FILES['event_img']['error'] == 0)
					{
						if(getimagesize($_FILES['event_img']["tmp_name"]) != false)
						{
							$Image = new pjImage();
							if ($Image->getErrorCode() !== 200)
							{
								$Image->setAllowedTypes(array('image/png', 'image/gif', 'image/jpg', 'image/jpeg', 'image/pjpeg'));
								if ($Image->load($_FILES['event_img']))
								{
									$resp = $Image->isConvertPossible();
									if ($resp['status'] === true)
									{
										$hash = md5(uniqid(rand(), true));
										
										$image_path = PJ_UPLOAD_PATH . 'events/' . $id . '_' . $hash . '.' . $Image->getExtension();
										$medium_path = PJ_UPLOAD_PATH . 'events/medium/' . $id . '_' . $hash . '.' . $Image->getExtension();
										$thumb_path = PJ_UPLOAD_PATH . 'events/thumb/' . $id . '_' . $hash . '.' . $Image->getExtension();
										
										$d = array();
										$d['event_img'] = $image_path;
										$d['event_thumb'] = $thumb_path;
										$d['event_medium'] = $medium_path;
										
										$Image->loadImage($_FILES['event_img']["tmp_name"]);
										$Image->saveImage($image_path);
										
										$Image->loadImage($_FILES['event_img']["tmp_name"]);
										$Image->resizeSmart(226, 205);
										$Image->saveImage($medium_path);
										
										$Image->loadImage($_FILES['event_img']["tmp_name"]);
										$Image->resizeSmart(100, 90);
										$Image->saveImage($thumb_path);
										
										$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll($d);
									}
								}
							}
						}
					}
					
				}else{
					if($this->_post->toInt('copy') > 0 && $this->_post->toInt('copy_image') == 1)
					{
						$event_arr = $pjEventModel->reset()->find($this->_post->toInt('copy'))->getData();
						if(!empty($event_arr['event_img']))
						{
							$hash = md5(uniqid(rand(), true));
							$file_ext = substr($event_arr['event_img'], strrpos($event_arr['event_img'], '.')+1);
							$data['event_img'] = PJ_UPLOAD_PATH . 'events/' . $id . '_' .$hash . '.' . $file_ext;
							$data['event_thumb'] = PJ_UPLOAD_PATH . 'events/thumb/' . $id . '_' .$hash . '.' . $file_ext;
							$data['event_medium'] = PJ_UPLOAD_PATH . 'events/medium/' . $id . '_' .$hash . '.' . $file_ext;
							@copy($event_arr['event_img'], $data['event_img']);
							@copy($event_arr['event_thumb'], $data['event_thumb']);
							@copy($event_arr['event_medium'], $data['event_medium']);
							$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll($data);
						}
					}
				}
				
				$pjMultiLangModel = pjMultiLangModel::factory();
				$arr_i18n = array();
				$post = $this->_post->raw();
				if (isset($post['i18n']))
				{
					$arr_i18n = $post['i18n'];
					$pjMultiLangModel->saveMultiLang($post['i18n'], $id, 'pjEvent', 'data');
				}
				
				if($this->_post->toInt('copy') > 0)
				{
					$event_arr = $pjEventModel->reset()->find($this->_post->toInt('copy'))->getData();					
					$event_arr['i18n'] = $pjMultiLangModel->getMultiLang($event_arr['id'], 'pjEvent');					
					if(!empty($event_arr['ticket_img']))
					{
						$hash = md5(uniqid(rand(), true));
						$file_ext = substr($event_arr['ticket_img'], strrpos($event_arr['ticket_img'], '.')+1);
						$data['ticket_img'] = PJ_UPLOAD_PATH . 'events/' . $id . '_' .$hash . '.' . $file_ext;
						@copy($event_arr['ticket_img'], $data['ticket_img']);
						
					}
					$pjMultiLangModel->reset()->saveMultiLang(array_merge($event_arr['i18n'], $arr_i18n), $id, 'pjEvent', 'data');
					
					$pjNotificationModel = pjNotificationModel::factory();
					$notification_arr = $pjNotificationModel->reset()->where("t1.foreign_id", $this->_post->toInt('copy'))->findAll()->getData();
					
					foreach($notification_arr as $notification)
					{
					    $notification['foreign_id'] = $id;
					    $notify_id = $notification['id'];
					    unset($notification['id']);
					    
					    $nid = $pjNotificationModel->reset()->setAttributes($notification)->insert()->getInsertId();
					    if ($nid !== false && (int) $nid > 0)
					    {
					        $src_multilang_arr = $pjMultiLangModel->reset()->where("t1.model", 'pjNotification')->where("t1.foreign_id", $notify_id)->findAll()->getData();
					        foreach($src_multilang_arr as $item)
					        {
					            $item['foreign_id'] = $nid;
					            unset($item['id']);
					            $pjMultiLangModel->reset()->setAttributes($item)->insert();
					        }
					    }
					}
					
					$src_multilang_arr = $pjMultiLangModel->reset()->where("t1.model", 'pjEvent')->where('t1.field', 'term_body')->where("t1.foreign_id", $this->_post->toInt('copy'))->findAll()->getData();
					foreach($src_multilang_arr as $item)
					{
					    $item['foreign_id'] = $id;
					    unset($item['id']);
					    $pjMultiLangModel->reset()->setAttributes($item)->insert();
					}
				}else{
				    pjNotificationModel::factory()->initConfirmation($id);
				}
				
				$recurring_id = md5($id . PJ_SALT);
				$data['recurring_id'] = $recurring_id;
				
				$recurring_start_date = pjDateTime::formatDate($_start_date, $this->option_arr['o_date_format']);
				$recurring_end_date = pjDateTime::formatDate($_end_date, $this->option_arr['o_date_format']);
			
				if($this->_post->toString('repeat') == 'none')
				{
					$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll(array('recurring_id' => $recurring_id));
					
				}else if($this->_post->toString('repeat') == 'daily'){
					$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll(array('recurring_id' => $recurring_id));
					$number_of_days = 0;
					if($this->_post->toString('end_repeat_date') != '')
					{
						$end_repeat_date = pjDateTime::formatDate($this->_post->toString('end_repeat_date'), $this->option_arr['o_date_format']);
						$number_of_days = pjUtil::dateDiff('d', $recurring_start_date, $end_repeat_date);
						
					}else{
						if($this->_post->toInt('end_repeat_times') > 0)
						{
							$number_of_days = $this->_post->toInt('end_repeat_times');
						}
					}
					if($number_of_days > 0)
					{
						for($i = 0; $i < $number_of_days; $i++)
						{
							$recurring_start_date = date('Y-m-d', strtotime($recurring_start_date . " +1 day"));
							$recurring_end_date = date('Y-m-d', strtotime($recurring_end_date . " +1 day"));
							
							$data['event_start_ts'] = strtotime($recurring_start_date . ' ' . $_start_time);
							$data['event_end_ts'] = strtotime($recurring_end_date . ' ' . $_end_time);
							$data['recurring_id'] = $recurring_id;
							
							
							$event_id = $pjEventModel->reset()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
							if ($event_id !== false && (int) $event_id > 0)
							{
								pjNotificationModel::factory()->initConfirmation($event_id);
								if ($arr_i18n)
								{
									$pjMultiLangModel->reset()->saveMultiLang($arr_i18n, $event_id, 'pjEvent', 'data');
								}
								
								$this->copyImage($id, $event_id);
								$pjPriceModel->setPrice($id, $event_id, $this->_post->raw());
							}
						}
					}
				}else if($this->_post->toString('repeat') == 'weekly'){
					$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll(array('recurring_id' => $recurring_id));
					$number_of_weeks = 0;
					if($this->_post->toString('end_repeat_date') != '')
					{
						$end_repeat_date = pjDateTime::formatDate($this->_post->toString('end_repeat_date'), $this->option_arr['o_date_format']);
						$number_of_weeks = pjUtil::dateDiff('ww', $recurring_end_date, $end_repeat_date);
						
					}else{
						if($this->_post->toInt('end_repeat_times') > 0)
						{
							$number_of_weeks = $this->_post->toInt('end_repeat_times');
						}
					}
					if($number_of_weeks > 0)
					{
						for($i = 0; $i < $number_of_weeks; $i++)
						{
							$recurring_start_date = date('Y-m-d', strtotime($recurring_start_date . " +7 day"));
							$recurring_end_date = date('Y-m-d', strtotime($recurring_end_date . " +7 day"));
							
							$data['event_start_ts'] = strtotime($recurring_start_date . ' ' . $_start_time);
							$data['event_end_ts'] = strtotime($recurring_end_date . ' ' . $_end_time);
							
							$data['recurring_id'] = $recurring_id;
							$event_id = $pjEventModel->reset()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
							if ($event_id !== false && (int) $event_id > 0)
							{
								pjNotificationModel::factory()->initConfirmation($event_id);
								if ($arr_i18n)
								{
									$pjMultiLangModel->reset()->saveMultiLang($arr_i18n, $event_id, 'pjEvent', 'data');
								}
								$this->copyImage($id, $event_id);
								$pjPriceModel->setPrice($id, $event_id, $this->_post->raw());
							}
						}
					}
				}else if($this->_post->toString('repeat') == 'monthly'){
					$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll(array('recurring_id' => $recurring_id));
					
					$recurring_start_date = date('Y-m-d', strtotime($recurring_start_date . "+1 month"));
					if($this->_post->toString('repeat-monthly-date') != 0)
					{
						$recurring_start_date = date('Y-m-d', mktime(0,0,0,date('n', strtotime($recurring_start_date)), $this->_post->toString('repeat-monthly-date'), date('Y', strtotime($recurring_start_date))));
					}else{
						$recurring_start_date = date('Y-m-d', strtotime(date('Y-m', strtotime($recurring_start_date)) . '-01 ' .$this->_post->toString('repeat-monthly-each') . ' '  . $this->_post->toString('repeat-monthly-day')));
					}
					$number_of_months = 0;
					
					if($this->_post->toString('end_repeat_date') != '')
					{
						$end_repeat_date = pjDateTime::formatDate($this->_post->toString('end_repeat_date'), $this->option_arr['o_date_format']);
						$number_of_months = pjUtil::dateDiff("m", $recurring_start_date, $end_repeat_date, false);
					}else{
						if($this->_post->toInt('end_repeat_times') > 0)
						{
							$number_of_months = $this->_post->toInt('end_repeat_times');
						}
					}
					
					if($number_of_months > 0)
					{
						if($event_start_ts < $event_end_ts)
						{
							$range_days = floor(($event_end_ts - $event_start_ts) / $one_day);
						}
						$recurring_end_date = date('Y-m-d', strtotime($recurring_start_date . " +$range_days day"));
						
						for($i = 0; $i < $number_of_months; $i++)
						{
							$data['event_start_ts'] = strtotime($recurring_start_date . ' ' . $_start_time);
							$data['event_end_ts'] = strtotime($recurring_end_date . ' ' . $_end_time);
							
							$data['recurring_id'] = $recurring_id;
							$event_id = $pjEventModel->reset()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
							if ($event_id !== false && (int) $event_id > 0)
							{
								pjNotificationModel::factory()->initConfirmation($event_id);
								if ($arr_i18n)
								{
									$pjMultiLangModel->reset()->saveMultiLang($arr_i18n, $event_id, 'pjEvent', 'data');
								}
								$this->copyImage($id, $event_id);
								$pjPriceModel->setPrice($id, $event_id, $this->_post->raw());
							}
							if($this->_post->toString('repeat-monthly-date') != 0)
							{
								$recurring_start_date = date('Y-m-d', strtotime($recurring_start_date . " +1 month"));
								$recurring_end_date = date('Y-m-d', strtotime($recurring_end_date . " +1 month"));
							}else{
								$month_year = date('F Y', strtotime($recurring_start_date . " +1 month"));
								$recurring_start_date = pjUtil::ordinalDate($this->_post->toString('repeat-monthly-each'), $this->_post->toString('repeat-monthly-day'), $month_year);
								$recurring_end_date = date('Y-m-d', strtotime($recurring_start_date . " +$range_days day"));
							}
						}
					}
				}else if($this->_post->toString('repeat') == 'quarterly'){
					$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll(array('recurring_id' => $recurring_id));
					
					$number_of_quarter = 0;
					if($this->_post->toString('end_repeat_date') != '')
					{
						$end_repeat_date = pjDateTime::formatDate($this->_post->toString('end_repeat_date'), $this->option_arr['o_date_format']);
						$number_of_months = pjUtil::dateDiff("m", $recurring_start_date, $end_repeat_date, false);
						$number_of_quarter = floor($number_of_months / 3);
					}else{
						if($this->_post->toInt('end_repeat_times') > 0)
						{
							$number_of_quarter = $this->_post->toInt('end_repeat_times');
						}
					}
					if($number_of_quarter > 0)
					{
						for($i = 0; $i < $number_of_quarter; $i++)
						{
							$recurring_start_date = date('Y-m-d', strtotime($recurring_start_date . " +3 months"));
							$recurring_end_date = date('Y-m-d', strtotime($recurring_end_date . " +3 months"));
							
							$data['event_start_ts'] = strtotime($recurring_start_date . ' ' . $_start_time);
							$data['event_end_ts'] = strtotime($recurring_end_date . ' ' . $_end_time);
							
							$data['recurring_id'] = $recurring_id;
							$event_id = $pjEventModel->reset()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
							if ($event_id !== false && (int) $event_id > 0)
							{
								pjNotificationModel::factory()->initConfirmation($event_id);
								if ($arr_i18n)
								{
									$pjMultiLangModel->reset()->saveMultiLang($arr_i18n, $event_id, 'pjEvent', 'data');
								}
								$this->copyImage($id, $event_id);
								$pjPriceModel->setPrice($id, $event_id, $this->_post->raw());
							}
						}
					}
				}else if($this->_post->toString('repeat') == 'yearly'){
					$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll(array('recurring_id' => $recurring_id));
					
					$number_of_years = 0;
					if($this->_post->toString('end_repeat_date') != '')
					{
						$end_repeat_date = pjDateTime::formatDate($this->_post->toString('end_repeat_date'), $this->option_arr['o_date_format']);
						$number_of_years = pjUtil::dateDiff("yyyy", $recurring_start_date, $end_repeat_date, false);
					}else{
						if($this->_post->toInt('end_repeat_times'))
						{
							$number_of_years = $this->_post->toInt('end_repeat_times');
						}
					}
					if($number_of_years > 0)
					{
						for($i = 0; $i < $number_of_years; $i++)
						{
							$recurring_start_date = date('Y-m-d', strtotime($recurring_start_date . " +1 year"));
							$recurring_end_date = date('Y-m-d', strtotime($recurring_end_date . " +1 year"));
							
							$data['event_start_ts'] = strtotime($recurring_start_date . ' ' . $_start_time);
							$data['event_end_ts'] = strtotime($recurring_end_date . ' ' . $_end_time);
							
							$data['recurring_id'] = $recurring_id;
							$event_id = $pjEventModel->reset()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
							if ($event_id !== false && (int) $event_id > 0)
							{
								pjNotificationModel::factory()->initConfirmation($event_id);
								if ($arr_i18n)
								{
									$pjMultiLangModel->reset()->saveMultiLang($arr_i18n, $event_id, 'pjEvent', 'data');
								}
								$this->copyImage($id, $event_id);
								$pjPriceModel->setPrice($id, $event_id, $this->_post->raw());
							}
						}
					}
				}else if($this->_post->toString('repeat') == 'custom'){
					$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll(array('recurring_id' => $recurring_id));
					$steps = 0;
					$number_of_days = 0;
					if($this->_post->toInt('repeat-custom-days') > 0)
					{
						if($this->_post->toString('end_repeat_date') != '')
						{
							$end_repeat_date = pjDateTime::formatDate($this->_post->toString('end_repeat_date'), $this->option_arr['o_date_format']);
							$number_of_days = pjUtil::dateDiff('d', $recurring_start_date, $end_repeat_date);
							$steps = floor($number_of_days / $this->_post->toInt('repeat-custom-days'));
						}else{
							if($this->_post->toInt('end_repeat_times'))
							{
								$steps = $this->_post->toInt('end_repeat_times');
							}
						}
					}
					if($steps > 0)
					{
						$number_of_days = $this->_post->toInt('repeat-custom-days');
						for($i = 0; $i < $steps; $i++)
						{
							$recurring_start_date = date('Y-m-d', strtotime($recurring_start_date . " +$number_of_days day"));
							$recurring_end_date = date('Y-m-d', strtotime($recurring_end_date . " +$number_of_days day"));
							
							$data['event_start_ts'] = strtotime($recurring_start_date . ' ' . $_start_time);
							$data['event_end_ts'] = strtotime($recurring_end_date . ' ' . $_end_time);
							
							$data['recurring_id'] = $recurring_id;
							$event_id = $pjEventModel->reset()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
							if ($event_id !== false && (int) $event_id > 0)
							{
								pjNotificationModel::factory()->initConfirmation($event_id);
								if ($arr_i18n)
								{
									$pjMultiLangModel->reset()->saveMultiLang($arr_i18n, $event_id, 'pjEvent', 'data');
								}
								$this->copyImage($id, $event_id);
								$pjPriceModel->setPrice($id, $event_id, $this->_post->raw());
							}
						}
					}
				}
				
				$pjPriceModel->setPrice($id, $id, $this->_post->raw());
				
				$err = 'AE03';
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminEvents&action=pjActionUpdate&id=$id&err=$err");
			}else{
				$err = 'AE04';
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminEvents&action=pjActionIndex&err=$err");
			}
	    }
	    if (self::isGet())
	    {
	        $this->setLocalesData();
	        
	    	$category_arr = pjCategoryModel::factory()
				->select("t1.*,t2.content as name")
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjCategory' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where('t1.status', 'T')
				->orderBy("name ASC")
				->findAll()->getData();
				
			$this->set('category_arr', $category_arr);
			
			if($this->_get->check('id') && $this->_get->toInt('id') > 0)
			{
				$pjMultiLangModel = pjMultiLangModel::factory();
				$arr = pjEventModel::factory()->find($this->_get->toInt('id'))->getData();
				$arr['i18n'] = $pjMultiLangModel->getMultiLang($arr['id'], 'pjEvent');
				$price_arr = pjPriceModel::factory()->where('t1.event_id', $arr['id'])->findAll()->getData();
				foreach($price_arr as $k => $v)
				{
					$price_arr[$k]['i18n'] = $pjMultiLangModel->reset()->getMultiLang($v['id'], 'pjPrice');
				}
				$this->set('arr', $arr);
				$this->set('price_arr', $price_arr);
			}
	        
	        $this->appendJs('jquery.multilang.js', $this->getConstant('pjBase', 'PLUGIN_JS_PATH'), false, false);
	        $this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
	        $this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
	        $this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
	        $this->appendJs('jasny-bootstrap.min.js',  PJ_THIRD_PARTY_PATH . 'jasny/');
	        $this->appendJs('moment-with-locales.min.js', PJ_THIRD_PARTY_PATH . 'moment/');
	        $this->appendCss('build/css/bootstrap-datetimepicker.min.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
	        $this->appendJs('build/js/bootstrap-datetimepicker.min.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
	        $this->appendJs('pjAdminEvents.js');
	    }
	}
		
	public function pjActionDeleteEvent()
	{
	    $this->setAjax(true);
	    
	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!pjAuth::factory()->hasAccess())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
	    }
	    if (!($this->_get->toInt('id')))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $id = $this->_get->toInt('id');
	    $pjEventModel = pjEventModel::factory();
	    $arr = $pjEventModel->find($id)->getData();
	    if (!$arr)
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Event not found.'));
	    }
	    if ($pjEventModel->setAttributes(array('id' => $id))->erase()->getAffectedRows() == 1)
	    {
	        pjMultiLangModel::factory()->where('model', 'pjEvent')->where('foreign_id', $id)->eraseAll();
	        
	        if(!empty($arr['event_img']))
			{
				$cnt = $pjEventModel->reset()->where('event_img', $arr['event_img'])->findCount()->getData();
				if($cnt <= 1)
				{
					if (is_file(PJ_INSTALL_PATH . $arr['event_img']))
					{
						@unlink(PJ_INSTALL_PATH . $arr['event_img']);
					}
					if (is_file(PJ_INSTALL_PATH . $arr['event_thumb']))
					{
						@unlink(PJ_INSTALL_PATH . $arr['event_thumb']);
					}
					if (is_file(PJ_INSTALL_PATH . $arr['event_medium']))
					{
						@unlink(PJ_INSTALL_PATH . $arr['event_medium']);
					}
				}
			}
			if(!empty($arr['ticket_img']))
			{
				$cnt = $pjEventModel->reset()->where('ticket_img', $arr['ticket_img'])->findCount()->getData();
				if($cnt <= 1)
				{
					if (is_file(PJ_INSTALL_PATH . $arr['ticket_img']))
					{
						@unlink(PJ_INSTALL_PATH . $arr['ticket_img']);
					}
				}
			}
			$booking_pdf_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'bookings/event-' . $id . '.pdf';
			$ticket_pdf_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'tickets/event-' . $id . '.pdf';
			
			if(is_file($booking_pdf_path)){
				@unlink($booking_pdf_path);
			}
			if(is_file($ticket_pdf_path)){
				@unlink($ticket_pdf_path);
			}
			$price_id_arr = pjPriceModel::factory()->where('event_id', $id)->findAll()->getDataPair(null, 'id');
			if(count($price_id_arr) > 0)
			{
				pjMultiLangModel::factory()->where('model', 'pjPrice')->whereIn('foreign_id', $price_id_arr)->eraseAll();
			}
			$pjBookingModel = pjBookingModel::factory();
			
			$in_where = "booking_id IN(SELECT `TB`.`id` FROM `".$pjBookingModel->getTable()."` as `TB` WHERE `TB`.`event_id` = " .$id. ")";
			pjBookingTicketModel::factory()->where($in_where)->eraseAll();
			pjBookingDetailModel::factory()->where($in_where)->eraseAll();
			$pjBookingModel->where('event_id', $id)->eraseAll();
			pjPriceModel::factory()->reset()->where('event_id', $id)->eraseAll();

			$notification_id_arr = pjNotificationModel::factory()->where('foreign_id', $id)->findAll()->getDataPair(null, 'id');
	    	if(count($notification_id_arr) > 0)
			{
				pjMultiLangModel::factory()->reset()->where('model', 'pjNotification')->whereIn('foreign_id', $notification_id_arr)->eraseAll();
			}
			pjNotificationModel::factory()->reset()->where('foreign_id', $id)->findAll()->eraseAll();
				
	        self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Event has been deleted'));
	    }else{
	        self::jsonResponse(array('status' => 'ERR', 'code' => 105, 'text' => 'Event has not been deleted.'));
	    }
		exit;
	}
	
	public function pjActionDeleteRecurring()
	{		
	    $this->setAjax(true);
	    
	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!pjAuth::factory()->hasAccess())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
	    }
	    if (!($this->_get->toInt('id')))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $id = $this->_get->toInt('id');
	
		$pjEventModel = pjEventModel::factory();
		$pjBookingModel = pjBookingModel::factory();
		$pjBookingTicketModel = pjBookingTicketModel::factory();
		$pjBookingDetailModel = pjBookingDetailModel::factory();
		
		$arr = $pjEventModel->find($id)->getData();
		
		$event_id_arr = $pjEventModel->reset()->where('recurring_id', $arr['recurring_id'])->findAll()->getDataPair(null, 'id');
		
		if(!empty($event_id_arr))
		{
			$arr = $pjEventModel->reset()->whereIn('id', $event_id_arr)->findAll()->getData();
			if(!empty($arr))
			{
				foreach($arr as $v)
				{
					if(!empty($v['ticket_img']))
					{
						$cnt = $pjEventModel->reset()->where('ticket_img', $v['ticket_img'])->findCount()->getData();
						if($cnt <= 1)
						{
							if (is_file(PJ_INSTALL_PATH . $v['ticket_img']))
							{
								@unlink(PJ_INSTALL_PATH . $v['ticket_img']);
							}
						}
					}
					if(!empty($v['event_img']))
					{
						$cnt = $pjEventModel->reset()->where('event_img', $v['event_img'])->findCount()->getData();
						if($cnt <= 1)
						{
							if (is_file(PJ_INSTALL_PATH . $v['event_img']))
							{
								@unlink(PJ_INSTALL_PATH . $v['event_img']);
							}
							if (is_file(PJ_INSTALL_PATH . $v['event_thumb']))
							{
								@unlink(PJ_INSTALL_PATH . $v['event_thumb']);
							}
							if (is_file(PJ_INSTALL_PATH . $v['event_medium']))
							{
								@unlink(PJ_INSTALL_PATH . $v['event_medium']);
							}
						}
					}
					$booking_pdf_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'bookings/event-' . $v['id'] . '.pdf';
					$ticket_pdf_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'tickets/event-' . $v['id'] . '.pdf';
						
					if(is_file($booking_pdf_path)){
						@unlink($booking_pdf_path);
					}
					if(is_file($ticket_pdf_path)){
						@unlink($ticket_pdf_path);
					}
						
					pjMultiLangModel::factory()->where('model', 'pjEvent')->whereIn('foreign_id', $event_id_arr)->eraseAll();
					$price_id_arr = pjPriceModel::factory()->whereIn('event_id', $event_id_arr)->findAll()->getDataPair(null, 'id');
					if(count($price_id_arr) > 0)
					{
						pjMultiLangModel::factory()->where('model', 'pjPrice')->whereIn('foreign_id', $price_id_arr)->eraseAll();
					}
						
					$in_where = "booking_id IN(SELECT `TB`.`id` FROM `".$pjBookingModel->getTable()."` as `TB` WHERE `TB`.`event_id` = " .$v['id']. ")";
					$pjBookingTicketModel->reset()->where($in_where)->eraseAll();
					$pjBookingDetailModel->reset()->where($in_where)->eraseAll();
					pjPriceModel::factory()->where('event_id', $v['id'])->eraseAll();
					$pjBookingModel->reset()->where('event_id', $v['id'])->eraseAll();
				}
				$pjEventModel->reset()->whereIn('id', $event_id_arr)->eraseAll();
				
				$notification_id_arr = pjNotificationModel::factory()->whereIn('foreign_id', $event_id_arr)->findAll()->getDataPair(null, 'id');
		    	if(count($notification_id_arr) > 0)
				{
					pjMultiLangModel::factory()->reset()->where('model', 'pjNotification')->whereIn('foreign_id', $notification_id_arr)->eraseAll();
				}
				pjNotificationModel::factory()->reset()->whereIn('foreign_id', $event_id_arr)->eraseAll();
			}
		}
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Event and recurring events have been deleted'));
		exit;
	}
	
	public function pjActionDeleteEventBulk()
	{
	    $this->setAjax(true);
	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!self::isPost())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
	    }
	    if (!pjAuth::factory()->hasAccess())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
	    }
	    if (!$this->_post->has('record'))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $record = $this->_post->toArray('record');
	    if (empty($record))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $pjEventModel = pjEventModel::factory();
	    $arr = $pjEventModel->whereIn('id', $record)->findAll()->getData();
		if(!empty($arr))
		{
			$pjBookingModel = pjBookingModel::factory();
			$pjBookingTicketModel = pjBookingTicketModel::factory();
			$pjBookingDetailModel = pjBookingDetailModel::factory();
			$pjPriceModel = pjPriceModel::factory();
			
			foreach($arr as $v)
			{
				if(!empty($v['ticket_img']))
				{
					$cnt = $pjEventModel->reset()->where('ticket_img', $v['ticket_img'])->findCount()->getData();
					if($cnt <= 1)
					{
						if (is_file(PJ_INSTALL_PATH . $v['ticket_img']))
						{
							@unlink(PJ_INSTALL_PATH . $v['ticket_img']);
						}
					}
				}
				if(!empty($v['event_img']))
				{
					$cnt = $pjEventModel->reset()->where('event_img', $v['event_img'])->findCount()->getData();
					if($cnt <= 1)
					{
						if (is_file(PJ_INSTALL_PATH . $v['event_img']))
						{
							@unlink(PJ_INSTALL_PATH . $v['event_img']);
						}
						if (is_file(PJ_INSTALL_PATH . $v['event_thumb']))
						{
							@unlink(PJ_INSTALL_PATH . $v['event_thumb']);
						}
						if (is_file(PJ_INSTALL_PATH . $v['event_medium']))
						{
							@unlink(PJ_INSTALL_PATH . $v['event_medium']);
						}
					}
				}
				$booking_pdf_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'bookings/event-' . $v['id'] . '.pdf';
				$ticket_pdf_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'tickets/event-' . $v['id'] . '.pdf';
				
				if(is_file($booking_pdf_path)){
					@unlink($booking_pdf_path);
				}
				if(is_file($ticket_pdf_path)){
					@unlink($ticket_pdf_path);
				}
				
				pjMultiLangModel::factory()->where('model', 'pjEvent')->whereIn('foreign_id', $record)->eraseAll();
				$price_id_arr = pjPriceModel::factory()->whereIn('event_id', $record)->findAll()->getDataPair(null, 'id');
				if(count($price_id_arr) > 0)
				{
					pjMultiLangModel::factory()->where('model', 'pjPrice')->whereIn('foreign_id', $price_id_arr)->eraseAll();
				}
				
				$in_where = "booking_id IN(SELECT `TB`.`id` FROM `".$pjBookingModel->getTable()."` as `TB` WHERE `TB`.`event_id` = " .$v['id']. ")";
				$pjBookingTicketModel->reset()->where($in_where)->eraseAll();
				$pjBookingDetailModel->reset()->where($in_where)->eraseAll();
				pjPriceModel::factory()->where('event_id', $v['id'])->eraseAll();
				$pjBookingModel->reset()->where('event_id', $v['id'])->eraseAll();
			}
			$pjEventModel->reset()->whereIn('id', $record)->eraseAll();
			$notification_id_arr = pjNotificationModel::factory()->whereIn('foreign_id', $record)->findAll()->getDataPair(null, 'id');
	    	if(count($notification_id_arr) > 0)
			{
				pjMultiLangModel::factory()->reset()->where('model', 'pjNotification')->whereIn('foreign_id', $notification_id_arr)->eraseAll();
			}
			pjNotificationModel::factory()->reset()->whereIn('foreign_id', $record)->eraseAll();
		}
			
	    self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Event(s) has been deleted.'));
	    exit;
	}
	
	public function pjActionGetEvent()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$pjEventModel = pjEventModel::factory()
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'title'", 'left');
			
			if ($this->_get->toString('status'))
			{
			    $status = $this->_get->toString('status');
			    if(in_array($status, array('T', 'F')))
			    {
			        $pjEventModel->where('t1.status', $status);
			    }
			}
			if ($q = $this->_get->toString('q'))
			{
			    $pjEventModel->where("(t2.content LIKE '%$q%')");
			}

			$column = 'title';
			$direction = 'ASC';
			$allowed_columns = array('event_start_ts', 'title', 'total_booked', 'status');
			if ($this->_get->toString('column') && in_array($this->_get->toString('column'), $allowed_columns) && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
			{
			    $column = $this->_get->toString('column');
			    $direction = strtoupper($this->_get->toString('direction'));
			}

			$total = $pjEventModel->findCount()->getData();
			$rowCount = $this->_get->toInt('rowCount') ?: 10;
			$pages = ceil($total / $rowCount);
			$page = $this->_get->toInt('page') ?: 1;
			$offset = ((int) $page - 1) * $rowCount;
			if ($page > $pages)
			{
				$page = $pages;
			}
			
			$data = $pjEventModel
				->select("t1.*, (SELECT COUNT(*) FROM `".pjBookingModel::factory()->getTable()."` AS t2 WHERE t2.event_id = t1.id) as `cnt_bookings`,
						  (SELECT SUM(t3.available) FROM `".pjPriceModel::factory()->getTable()."` AS t3 WHERE t3.event_id=t1.id) AS `total_avail`,
						  (SELECT SUM(t4.cnt) FROM `".pjBookingDetailModel::factory()->getTable()."` AS t4 WHERE t4.booking_id IN(SELECT t5.id FROM `".pjBookingModel::factory()->getTable()."` AS t5 WHERE t5.event_id = t1.id)) AS `total_booked`,
						  t2.content as title
						")
				->orderBy("$column $direction")
				->limit($rowCount, $offset)->findAll()->getData();
			foreach($data as $k => $v)
			{
				$v['title'] = pjSanitize::clean($v['title']);
				$v['event_date'] = pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format'],$v['o_show_start_time'], $v['o_show_end_time']);
				$v['tickets'] = ((int) $v['total_booked']) . ' ' . __('lblOf', true, false) . ' ' . (int)$v['total_avail'];
				if(((int) $v['total_booked']) > 0){
					$v['linked'] = 1;
				}else{
					$v['linked'] = 0;
				}
				$data[$k] = $v;
			}	
			pjAppController::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
		}
		exit;
	}
		
	public function pjActionIndex()
	{
	    $this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
	    $this->set('has_create', pjAuth::factory('pjAdminEvents', 'pjActionCreate')->hasAccess());
	    $this->set('has_update', pjAuth::factory('pjAdminEvents', 'pjActionUpdate')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminEvents', 'pjActionDeleteEvent')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminEvents', 'pjActionDeleteEventBulk')->hasAccess());
		$this->set('has_export', pjAuth::factory('pjAdminEvents', 'pjActionExportEvent')->hasAccess());
		$this->set('has_revert_status', pjAuth::factory('pjAdminEvents', 'pjActionStatusEvent')->hasAccess());
		
	    $this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
	    $this->appendJs('pjAdminEvents.js');
	}
	
	public function pjActionSaveEvent()
	{	
		$this->setAjax(true);
		
		if (!$this->isXHR())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		
		if (!pjAuth::factory($this->_get->toString('controller'), 'pjActionUpdate')->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
		}
		$pjEventModel = pjEventModel::factory();
		$arr = $pjEventModel->find($this->_get->toInt('id'))->getData();
		if (!$arr)
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Event not found.'));
		}
		if (!in_array($this->_post->toString('column'), $pjEventModel->getI18n()))
		{
		    $pjEventModel->reset()->where('id', $this->_get->toInt('id'))->limit(1)->modifyAll(array($this->_post->toString('column') => $this->_post->toString('value')));
		} else {
		    pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($this->_post->toString('column') => $this->_post->toString('value'))), $this->_get->toInt('id'), 'pjEvent', 'data');
		}
		self::jsonResponse(array('status' => 'OK', 'code' => 201, 'text' => 'Event has been updated.'));
		exit;
	}
	
	public function pjActionStatusEvent()
	{
		$this->setAjax(true);
	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!self::isPost())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
	    }
	    if (!pjAuth::factory()->hasAccess())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
	    }
	    if (!$this->_post->has('record'))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $record = $this->_post->toArray('record');
	    if (empty($record))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	
		pjEventModel::factory()->whereIn('id', $record)->modifyAll(array(
			'status' => ":IF(`status`='F','T','F')"
		));
		
		self::jsonResponse(array('status' => 'OK', 'code' => 201, 'text' => 'Status of the events has been updated.'));
		exit;
	}
	
	public function pjActionUpdate()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
	    $post_max_size = pjUtil::getPostMaxSize();
	    if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SERVER['CONTENT_LENGTH']) && (int) $_SERVER['CONTENT_LENGTH'] > $post_max_size)
	    {
	        pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminEvents&action=pjActionIndex&err=AE13");
	    }
	    	    
	    if (self::isPost() && $this->_post->toInt('event_update'))
	    {
	        $pjEventModel = pjEventModel::factory();

	        $tab = $this->_post->toString('tab');
			$data = array();			
			$event_id = $this->_post->toInt('id');	
			$data['status'] = $this->_post->check('status') ? 'T' : 'F';
			$data['o_show_start_time'] = $this->_post->check('o_show_start_time') ? 'F' : 'T';
			$data['o_show_end_time'] = $this->_post->check('o_show_end_time') ? 'F' : 'T';
			
			if (isset($_FILES['ticket_img']))
			{
				if($_FILES['ticket_img']['error'] == 0)
				{
					if(getimagesize($_FILES['ticket_img']["tmp_name"]) != false)
					{
						$Image = new pjImage();
						if ($Image->getErrorCode() !== 200)
						{
							$Image->setAllowedTypes(array('image/png', 'image/jpg', 'image/jpeg', 'image/pjpeg'));
							if ($Image->load($_FILES['ticket_img']))
							{
								if (!in_array($Image->getExtension(), array('jpg', 'jpeg', 'pjpeg', 'png')))
								{
									pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminEvents&action=pjActionUpdate&id=".$event_id."&err=AE09&tab=" . $tab);
								}
								$size = getimagesize($_FILES['ticket_img']['tmp_name']);
							
								if ($size[0] != 510 || $size[1] != 280)
								{
									pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminEvents&action=pjActionUpdate&id=".$event_id."&err=AE10&tab=".$tab."&size=". $size[1]);
								}
								$event_arr = $pjEventModel->find($event_id)->getData();
								if (!empty($event_arr['ticket_img']) && is_file(PJ_INSTALL_PATH . $event_arr['ticket_img']))
								{
									@unlink(PJ_INSTALL_PATH . $event_arr['ticket_img']);
								}
								$image_path = PJ_UPLOAD_PATH . 'events/' . $this->_post->toString('recurring_id') . "." . $Image->getExtension();
								if ($Image->save($image_path))
								{
									$data['ticket_img'] = $image_path;
								}
							}
						}
					}else{
						pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminEvents&action=pjActionUpdate&id=".$event_id."&err=AE11&tab=".$tab);
					}
				}else if($_FILES['ticket_img']['error'] != 4){
					pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminEvents&action=pjActionUpdate&id=".$event_id."&err=AE12&tab=".$tab);
				}
			}
			
			if (isset($_FILES['event_img']) && !empty($_FILES['event_img']['tmp_name']))
			{
				$event_arr = $pjEventModel->reset()->find($event_id)->getData();
				$recurring_id = $event_arr['recurring_id'];
				
				$recurring_arr = $pjEventModel->reset()->where('recurring_id', $recurring_id)->findAll()->getData();
				
				if($_FILES['event_img']['error'] == 0)
				{
					if(getimagesize($_FILES['event_img']["tmp_name"]) != false)
					{
						$Image = new pjImage();
						if ($Image->getErrorCode() !== 200)
						{
							$Image->setAllowedTypes(array('image/png', 'image/gif', 'image/jpg', 'image/jpeg', 'image/pjpeg'));
							if ($Image->load($_FILES['event_img']))
							{
								$resp = $Image->isConvertPossible();
								if ($resp['status'] === true)
								{
									$hash = md5(uniqid(rand(), true));
									$image_extension = $Image->getExtension();	
									if($this->_post->check('apply_recurring'))
									{
										foreach($recurring_arr as $k => $v)
										{
											if (!empty($v['event_img']) && is_file(PJ_INSTALL_PATH . $v['event_img']))
											{
												@unlink(PJ_INSTALL_PATH . $v['event_img']);
											}
											if (!empty($v['event_thumb']) && is_file(PJ_INSTALL_PATH . $v['event_thumb']))
											{
												@unlink(PJ_INSTALL_PATH . $v['event_thumb']);
											}
											if (!empty($v['event_medium']) && is_file(PJ_INSTALL_PATH . $v['event_medium']))
											{
												@unlink(PJ_INSTALL_PATH . $v['event_medium']);
											}
											$recurring_data = array();
											
											$image_path = PJ_UPLOAD_PATH . 'events/' . $v['id'] . '_' . $hash . '.' . $image_extension;
											$medium_path = PJ_UPLOAD_PATH . 'events/medium/' . $v['id'] . '_' . $hash . '.' . $image_extension;
											$thumb_path = PJ_UPLOAD_PATH . 'events/thumb/' . $v['id'] . '_' . $hash . '.' . $image_extension;
												
											$recurring_data['event_img'] = $image_path;
											$recurring_data['event_thumb'] = $thumb_path;
											$recurring_data['event_medium'] = $medium_path;
												
											$Image->loadImage($_FILES['event_img']["tmp_name"]);
											$Image->saveImage($image_path);
												
											$Image->loadImage($_FILES['event_img']["tmp_name"]);
											$Image->resizeSmart(226, 205);
											$Image->saveImage($medium_path);
												
											$Image->loadImage($_FILES['event_img']["tmp_name"]);
											$Image->resizeSmart(100, 90);
											$Image->saveImage($thumb_path);
											
											$pjEventModel->reset()->where('id', $v['id'])->limit(1)->modifyAll($recurring_data);
											
										}
									}else{
										if (!empty($event_arr['event_img']) && is_file(PJ_INSTALL_PATH . $event_arr['event_img']))
										{
											@unlink(PJ_INSTALL_PATH . $event_arr['event_img']);
										}
										if (!empty($event_arr['event_thumb']) && is_file(PJ_INSTALL_PATH . $event_arr['event_thumb']))
										{
											@unlink(PJ_INSTALL_PATH . $event_arr['event_thumb']);
										}
										if (!empty($event_arr['event_medium']) && is_file(PJ_INSTALL_PATH . $event_arr['event_medium']))
										{
											@unlink(PJ_INSTALL_PATH . $event_arr['event_medium']);
										}
										
										$image_path = PJ_UPLOAD_PATH . 'events/' . $event_id . '_' . $hash . '.' . $image_extension;
										$medium_path = PJ_UPLOAD_PATH . 'events/medium/' . $event_id . '_' . $hash . '.' . $image_extension;
										$thumb_path = PJ_UPLOAD_PATH . 'events/thumb/' . $event_id . '_' . $hash . '.' . $image_extension;
											
										$data['event_img'] = $image_path;
										$data['event_thumb'] = $thumb_path;
										$data['event_medium'] = $medium_path;
											
										$Image->loadImage($_FILES['event_img']["tmp_name"]);
										$Image->saveImage($image_path);
											
										$Image->loadImage($_FILES['event_img']["tmp_name"]);
										$Image->resizeSmart(226, 205);
										$Image->saveImage($medium_path);
											
										$Image->loadImage($_FILES['event_img']["tmp_name"]);
										$Image->resizeSmart(100, 90);
										$Image->saveImage($thumb_path);
									}
								}
							}
						}
					}
				}
			}
			
			$event_start_dt =  pjUtil::convertDateTime($this->_post->toString('event_start_ts'), $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			$event_end_dt =  pjUtil::convertDateTime($this->_post->toString('event_end_ts'), $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			
			$data['event_start_ts'] = $event_start_dt['ts'];
			$data['event_end_ts'] = $event_end_dt['ts'];
							
			$pjEventModel->reset()->where('id', $event_id)->limit(1)->modifyAll(array_merge($this->_post->raw(), $data));
			
			$post = $this->_post->raw();
			$arr_i18n = array();
			if (isset($post['i18n']))
			{
				foreach ($post['i18n'] as $locale_id => $items) {
					foreach ($items as $k => $v) {
						if (in_array($k, array('title','location','description','terms_body','ticket_info'))) {
							$arr_i18n[$locale_id][$k] = $v;
						}
					}
				}
			}			
			if ($arr_i18n) {
				pjMultiLangModel::factory()->updateMultiLang($arr_i18n, $event_id, 'pjEvent', 'data');
			}
			
			$has_recurring = 0;
			if($this->_post->check('apply_recurring'))
			{
				$data = array_merge($this->_post->raw(), $data);
				unset($data['id']);
				unset($data['event_start_ts']);
				unset($data['event_end_ts']);
				
				$start_time_iso = $event_start_dt['iso_time'];
				$end_time_iso = $event_end_dt['iso_time'];
				
				if ($arr_i18n) {
				    $recurring_arr = $pjEventModel->reset()->where('t1.id <>', $event_id)->where('recurring_id', $this->_post->toString('recurring_id'))->findAll()->getData();
					foreach($recurring_arr as $k => $v)
					{
					    $data['event_start_ts'] = strtotime(date('Y-m-d', $v['event_start_ts']) . ' ' . $start_time_iso);
					    $data['event_end_ts'] = strtotime(date('Y-m-d', $v['event_end_ts']) . ' ' . $end_time_iso);
					    $pjEventModel->reset()->where('id', $v['id'])->limit(1)->modifyAll($data);
					    
						pjMultiLangModel::factory()->updateMultiLang($arr_i18n, $v['id'], 'pjEvent', 'data');
					}
				}
				$has_recurring = 1;
				
			}
			pjPriceModel::factory()->updatePrice($event_id, $this->_post->raw(), $has_recurring);
			
			pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminEvents&action=pjActionUpdate&id=".$event_id."&err=AE01&tab=" . $tab);
	    }
	    if (self::isGet() && $this->_get->toInt('id'))
	    {
	        $id = $this->_get->toInt('id');
	        $pjEventModel = pjEventModel::factory();
			$pjBookingTicketModel = pjBookingTicketModel::factory();
			$pjMultiLangModel = pjMultiLangModel::factory();
			
			$pjEventModel
				->select("t1.*,	(SELECT COUNT(*) FROM  `" . pjBookingModel::factory()->getTable(). "` AS t2 ) AS `ctn_bookings`,
								(SELECT SUM(t3.available) FROM `".pjPriceModel::factory()->getTable()."` AS t3 WHERE t3.event_id=t1.id) AS `total_avail`");
			$arr = $pjEventModel->find($id)->getData();
			if (count($arr) === 0)
			{
				pjUtil::redirect(PJ_INSTALL_URL. "index.php?controller=pjAdminEvents&action=pjActionIndex&err=AE08");
			}
			$arr['i18n'] = $pjMultiLangModel->getMultiLang($arr['id'], 'pjEvent');
							
			$category_arr = pjCategoryModel::factory()
				->select("t1.*,t2.content as name")
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjCategory' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where('t1.status', 'T')
				->orderBy("name ASC")
				->findAll()->getData();
				
			$this->set('category_arr', $category_arr);
			
			$recurring_id = $arr['recurring_id'];
			$number_of_events = $pjEventModel->reset()->where('recurring_id', $recurring_id)->findCount()->getData();
			
			$price_arr = pjPriceModel::factory()->where('t1.event_id', $id)->findAll()->getData();
			foreach($price_arr as $k => $v)
			{
				$price_arr[$k]['i18n'] = $pjMultiLangModel->reset()->getMultiLang($v['id'], 'pjPrice');
			}
			
			$booking_arr = pjBookingModel::factory()
				->where('t1.event_id', $id)
				->findAll()->getData();
			
			$details_arr = pjBookingDetailModel::factory()
				->select('t1.*, t2.content as price_title')
				->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where("t1.booking_id IN(SELECT t2.id FROM `".pjBookingModel::factory()->getTable()."` as t2 WHERE t2.event_id = '".$id."')")
				->findAll()->getData();
										
			$booking_detail_arr = array();
			$total_tickets = 0;												
			foreach($details_arr as $v)
			{
				$booking_detail_arr[$v['booking_id']][] = $v;
				$total_tickets += $v['cnt'];
			}

			$tickets_arr = $pjBookingTicketModel
										->select('t1.*, t2.unique_id, t2.customer_name, t2.customer_email')
										->join('pjBooking', "t1.booking_id = t2.id", 'left')
										->where("t1.is_used", 'T')
										->where("t1.booking_id IN(SELECT t3.id FROM `".pjBookingModel::factory()->getTable()."` as t3 WHERE t3.event_id = '".$id."' AND t3.booking_status = 'confirmed')")
										->findAll()->getData();
			
			$used_tickets = $pjBookingTicketModel
									->reset()
									->where("t1.booking_id IN(SELECT t2.id FROM `".pjBookingModel::factory()->getTable()."` as t2 WHERE t2.event_id = '".$id."' AND t2.booking_status = 'confirmed')")
									->where('t1.is_used', 'T')
									->findCount()->getData();
								
			if(count($booking_arr) > 0)
			{
				$this->set('print_file', $this->doPrintBookings($booking_arr, $booking_detail_arr, $id));				
			}
			if(count($tickets_arr) > 0)
			{
				$this->set('print_tickets_file', $this->doPrintTickets($tickets_arr, $id));				
			}
						
			$this->set('arr', $arr);
			$this->set('price_arr', $price_arr);
			$this->set('category_arr', $category_arr);
			$this->set('number_of_events', $number_of_events);
			$this->set('booking_arr', $booking_arr);
			$this->set('detail_arr', $booking_detail_arr);
			$this->set('tickets_arr', $tickets_arr);
			$this->set('total_tickets', $total_tickets);
			$this->set('used_tickets', $used_tickets);
			
			$this->setLocalesData();
			
			$this->set('has_create_booking', pjAuth::factory('pjAdminBookings', 'pjActionCreate')->hasAccess());
		    $this->set('has_update_booking', pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess());
			$this->set('has_delete_booking', pjAuth::factory('pjAdminBookings', 'pjActionDeleteBooking')->hasAccess());
			$this->set('has_delete_bulk_booking', pjAuth::factory('pjAdminBookings', 'pjActionDeleteBookingBulk')->hasAccess());
			$this->set('has_export_booking', pjAuth::factory('pjAdminBookings', 'pjActionExportBooking')->hasAccess());
	        
			$this->appendJs('jquery.multilang.js', $this->getConstant('pjBase', 'PLUGIN_JS_PATH'), false, false);
	        $this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
	        $this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
	        $this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
	        $this->appendJs('jasny-bootstrap.min.js',  PJ_THIRD_PARTY_PATH . 'jasny/');
	        $this->appendJs('moment-with-locales.min.js', PJ_THIRD_PARTY_PATH . 'moment/');
	        $this->appendCss('build/css/bootstrap-datetimepicker.min.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
	        $this->appendJs('build/js/bootstrap-datetimepicker.min.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
	        $this->appendJs('tinymce.min.js', PJ_THIRD_PARTY_PATH . 'tinymce/');
			$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
	        $this->appendJs('pjAdminEvents.js');
	    }
	}
	
	public function pjActionDeleteImage()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!self::isPost())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
		}
		if (!($this->_get->toInt('id')))
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
		}
		$id = $this->_get->toInt('id');
		$pjEventModel = pjEventModel::factory();
		$arr = $pjEventModel->find($id)->getData(); 
		if(empty($arr))
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Event not found.'));
		}
		
		$d = array();
		$d['event_img'] = ':NULL';
		$d['event_thumb'] = ':NULL';
		$d['event_medium'] = ':NULL';

		$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll($d);
		
		if (!empty($arr['event_img']) && is_file(PJ_INSTALL_PATH . $arr['event_img']))
		{
			@unlink(PJ_INSTALL_PATH . $arr['event_img']);
		}
		if (!empty($arr['event_thumb']) && is_file(PJ_INSTALL_PATH . $arr['event_thumb']))
		{
			@unlink(PJ_INSTALL_PATH . $arr['event_thumb']);
		}
		if (!empty($arr['event_medium']) && is_file(PJ_INSTALL_PATH . $arr['event_medium']))
		{
			@unlink(PJ_INSTALL_PATH . $arr['event_medium']);
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Event image has been deleted.'));
	}
	
	public function pjActionDeleteAllImages()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!self::isPost())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
		}
		if (!($this->_get->toInt('id')))
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
		}
		$id = $this->_get->toInt('id');
		$pjEventModel = pjEventModel::factory();
		$arr = $pjEventModel->find($id)->getData(); 
		if(empty($arr))
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Event not found.'));
		}
	
		$recurring_arr = $pjEventModel->reset()->where('recurring_id', $arr['recurring_id'])->findAll()->getData();
		
		foreach($recurring_arr as $k => $v)
		{
			$data = array();
			$data['event_img'] = ':NULL';
			$data['event_thumb'] = ':NULL';
			$data['event_medium'] = ':NULL';
			
			$pjEventModel->reset()->where('id', $v['id'])->limit(1)->modifyAll($data);
			
			if (!empty($v['event_img']) && is_file(PJ_INSTALL_PATH . $v['event_img']))
			{
				@unlink(PJ_INSTALL_PATH . $v['event_img']);
			}
			if (!empty($v['event_thumb']) && is_file(PJ_INSTALL_PATH . $v['event_thumb']))
			{
				@unlink(PJ_INSTALL_PATH . $v['event_thumb']);
			}
			if (!empty($v['event_medium']) && is_file(PJ_INSTALL_PATH . $v['event_medium']))
			{
				@unlink(PJ_INSTALL_PATH . $v['event_medium']);
			}
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Event images has been deleted.'));
	}
	
	public function pjActionCheckRecurring()
	{
		$this->setAjax(true);
	
		$pjEventModel = pjEventModel::factory();
	
		$arr = $pjEventModel->find($this->_get->toInt('id'))->getData();
	
		$cnt_recurring = $pjEventModel->reset()->where('recurring_id', $arr['recurring_id'])->findCount()->getData();
		
		if($cnt_recurring >= 2)
		{
			echo 'true';
		}else{
			echo 'false';
		}
		exit;
	}
	
	private function doPrintBookings($arr, $detail_arr, $event_id)
	{
		$dm = new pjDependencyManager(PJ_INSTALL_PATH, PJ_THIRD_PARTY_PATH);
		$dm->load(PJ_CONFIG_PATH . 'dependencies.php')->resolve();
		
		require_once($dm->getPath('tcpdf') . 'tcpdf.php');
		
		$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
		$pdf->setPrintHeader(false);
		$pdf->setPrintFooter(false);
		$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$pdf->SetMargins(10, 10, 10);
		$pdf->SetAutoPageBreak(true, PDF_MARGIN_BOTTOM);
		
		$pdf->AddPage();
		
		$booking_statuses = __('booking_statuses', true);
		
		$tbl = '<table style="width: 600px;" cellspacing="0">';
		$tbl .= '<tr>';
		$tbl .= 	'<td colspan="5" style="height: 30px;">' . __('lblCurrentDateTime', true) . ': '.pjDateTime::formatDate(date('Y-m-d'), 'Y-m-d', $this->option_arr['o_date_format']) . ' ' . pjDateTime::formatTime(date('H:i:s'), 'H:i:s', $this->option_arr['o_time_format']).'</td>';
		$tbl .= '</tr>';
		$tbl .= '<tr>';
		$tbl .= 	'<td style="border: 1px solid #000000; width: 100px; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblID', true) . '</td>';
		$tbl .= 	'<td style="border: 1px solid #000000; width: 140px; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblBookingName', true) . '</td>';
		$tbl .= 	'<td style="border: 1px solid #000000; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblBookingEmail', true) . '</td>';
		$tbl .= 	'<td style="border: 1px solid #000000; width: 100px; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblTickets', true) . '</td>';
		$tbl .= 	'<td style="border: 1px solid #000000; width: 80px; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblStatus', true) . '</td>';
		$tbl .= '</tr>';
		foreach($arr as $v)
		{
			$id = $v['unique_id'];
			$name = $v['customer_name'];
			$email = $v['customer_email'];
			$tickets = '';
			$price_arr = $detail_arr[$v['id']];
			if(count($price_arr) > 0)
			{
				foreach($price_arr as $d)
				{
					$tickets .= $d['cnt'] . ' x ' . $d['price_title'] . '<br/>';
				}
			}else{
				$tickets = '&nbsp;';
			}
			$status = stripslashes($booking_statuses[$v['booking_status']]);
			
			$tbl .= '<tr>';
			$tbl .= 	'<td style="border: 1px solid #000000; width: 100px;height:30px;vertical-align: middle;">' . $id . '</td>';
			$tbl .= 	'<td style="border: 1px solid #000000; width: 140px;height:30px;vertical-align: middle;">' . $name . '</td>';
			$tbl .= 	'<td style="border: 1px solid #000000;vertical-align: middle;height:30px;">' . $email . '</td>';
			$tbl .= 	'<td style="border: 1px solid #000000; width: 100px;height:30px;vertical-align: middle;">' . $tickets . '</td>';
			$tbl .= 	'<td style="border: 1px solid #000000; width: 80px;height:30px;vertical-align: middle;">' . $status . '</td>';
			$tbl .= '</tr>';
		}
		$tbl .= '</table>';
		$pdf->writeHTML($tbl, true, false, false, false, '');
		
		$pdf->Output(PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'bookings/event-'.$event_id.'.pdf', 'F');
		$filename = PJ_UPLOAD_PATH . 'bookings/event-'.$event_id.'.pdf';
		
		return $filename;
	}
	
	private function doPrintTickets($arr, $event_id)
	{
		$dm = new pjDependencyManager(PJ_INSTALL_PATH, PJ_THIRD_PARTY_PATH);
		$dm->load(PJ_CONFIG_PATH . 'dependencies.php')->resolve();
		
		require_once($dm->getPath('tcpdf') . 'tcpdf.php');
		
		$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
		$pdf->setPrintHeader(false);
		$pdf->setPrintFooter(false);
		$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$pdf->SetMargins(10, 10, 10);
		$pdf->SetAutoPageBreak(true, PDF_MARGIN_BOTTOM);
		
		$pdf->AddPage();
		
		$tbl = '<table style="width: 600px;" cellspacing="0">';
		$tbl .= '<tr>';
		$tbl .= 	'<td colspan="4" style="height: 30px;">' . __('lblCurrentDateTime', true) . ': '.pjDateTime::formatDate(date('Y-m-d'), 'Y-m-d', $this->option_arr['o_date_format']) . ' ' . pjDateTime::formatTime(date('H:i:s'), 'H:i:s', $this->option_arr['o_time_format']).'</td>';
		$tbl .= '</tr>';
		$tbl .= '<tr>';
		$tbl .= 	'<td style="border: 1px solid #000000; width: 140px; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblBookingName', true) . '</td>';
		$tbl .= 	'<td style="border: 1px solid #000000; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblBookingEmail', true) . '</td>';
		$tbl .= 	'<td style="border: 1px solid #000000; width: 120px; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblTicketType', true) . '</td>';
		$tbl .= 	'<td style="border: 1px solid #000000; width: 100px; height:30px;vertical-align: middle;background-color: #c2bebe;">' . __('lblUsedTickets', true) . '</td>';
		$tbl .= '</tr>';
		foreach($arr as $v)
		{
			$price_title = $v['price_title'];
			$name = $v['customer_name'];
			$email = $v['customer_email'];
			$ticket_id = $v['ticket_id'];
			
			$tbl .= '<tr>';
			$tbl .= 	'<td style="border: 1px solid #000000; width: 140px;height:30px;vertical-align: middle;">' . $name . '</td>';
			$tbl .= 	'<td style="border: 1px solid #000000;vertical-align: middle;height:30px;">' . $email . '</td>';
			$tbl .= 	'<td style="border: 1px solid #000000; width: 120px;height:30px;vertical-align: middle;">' . $price_title . '</td>';
			$tbl .= 	'<td style="border: 1px solid #000000; width: 100px;height:30px;vertical-align: middle;">' . $ticket_id . '</td>';
			$tbl .= '</tr>';
		}
		$tbl .= '</table>';
		$pdf->writeHTML($tbl, true, false, false, false, '');
		
		$pdf->Output(PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'tickets/event-'.$event_id.'.pdf', 'F');
		$filename = PJ_UPLOAD_PATH . 'tickets/event-'.$event_id.'.pdf';
		return $filename;
	}
	
	public function pjActionNotificationsGetMetaData()
    {
        $this->setAjax(true);
        
        if (!$this->isXHR())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
        }
        
        if (!self::isGet())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Invalid request.'));
        }
        
        if (!(isset($this->query['recipient']) && pjValidation::pjActionNotEmpty($this->query['recipient'])))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid parameters.'));
        }
        $arr = pjNotificationModel::factory()
        ->where('t1.recipient', $this->query['recipient'])
        ->where('t1.foreign_id', $this->_get->toInt('event_id'))
        ->orderBy('t1.id ASC')
        ->findAll()
        ->getData();
        $this->set('arr', $arr);
    }
    
    public function pjActionNotificationsGetContent()
    {
        $this->setAjax(true);
        
        if (!$this->isXHR())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
        }
        
        if (!self::isGet())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Invalid request.'));
        }
        
        if (!($this->_get->check('recipient') && $this->_get->check('variant') && $this->_get->check('transport'))
            && pjValidation::pjActionNotEmpty($this->_get->toString('recipient'))
            && pjValidation::pjActionNotEmpty($this->_get->toString('variant'))
            && pjValidation::pjActionNotEmpty($this->_get->toString('transport'))
            && in_array($this->_get->toString('transport'), array('email', 'sms'))
            )
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid parameters.'));
        }
        
        $arr = pjNotificationModel::factory()
        ->where('t1.recipient', $this->_get->toString('recipient'))
        ->where('t1.variant', $this->_get->toString('variant'))
        ->where('t1.transport', $this->_get->toString('transport'))
        ->where('t1.foreign_id', $this->_get->toInt('event_id'))
        ->limit(1)
        ->findAll()
        ->getDataIndex(0);
        
        if (!$arr)
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Message not found.'));
        }
        
        $arr['i18n'] = pjBaseMultiLangModel::factory()->getMultiLang($arr['id'], 'pjNotification');
        $this->set('arr', $arr);
        
        # Check SMS
        $this->set('is_sms_ready', (isset($this->option_arr['plugin_sms_api_key']) && !empty($this->option_arr['plugin_sms_api_key']) ? 1 : 0));
        
        # Get locales
        $locale_arr = pjBaseLocaleModel::factory()
        ->select('t1.*, t2.file, t2.title')
        ->join('pjBaseLocaleLanguage', 't2.iso=t1.language_iso', 'left')
        ->where('t2.file IS NOT NULL')
        ->orderBy('t1.sort ASC')
        ->findAll()
        ->getData();
        
        $lp_arr = array();
        foreach ($locale_arr as $item)
        {
            $lp_arr[$item['id']."_"] = array($item['file'], $item['title']);
        }
        $this->set('lp_arr', $locale_arr);
        $this->set('locale_str', self::jsonEncode($lp_arr));
        $this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjBaseLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
    }
    
    public function pjActionNotificationsSetContent()
    {
        $this->setAjax(true);
        
        if (!$this->isXHR())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
        }
        
        if (!self::isPost())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Invalid request.'));
        }
        
        if (!(isset($this->body['notify_id']) && pjValidation::pjActionNumeric($this->body['notify_id'])))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid parameters.'));
        }
        
        $isToggle = $this->_post->check('is_active') && in_array($this->_post->toInt('is_active'), array(1,0));
        $isFormSubmit = $this->_post->check('i18n') && !$this->_post->isEmpty('i18n');
        
        if (!($isToggle xor $isFormSubmit))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Data mismatch.'));
        }
        
        $pjNotificationModel = pjNotificationModel::factory();
        if ($isToggle)
        {
            
            $pjNotificationModel->set('id', $this->_post->toInt('notify_id'))
            	->modify(array('is_active' => $this->_post->toInt('is_active')));
        } elseif ($isFormSubmit) {            
        	if($this->_get->check('apply_recurring') && $this->_get->toInt('apply_recurring') == 1)
			{
				$notification_arr = $pjNotificationModel->reset()->find($this->_post->toInt('notify_id'))->getData();				
				$recurring_arr = pjEventModel::factory()->where('recurring_id', $this->_get->toString('recurring_id'))->findAll()->getData();
				foreach($recurring_arr as $k => $v)
				{
					$recurr_notification_arr = $pjNotificationModel->reset()
						->where('t1.foreign_id', $v['id'])
						->where('t1.recipient', $notification_arr['recipient'])
						->where('t1.transport', $notification_arr['transport'])
						->where('t1.variant', $notification_arr['variant'])
						->limit(1)
						->findAll()
						->getDataIndex(0);
					if ($recurr_notification_arr) {
						pjBaseMultiLangModel::factory()->updateMultiLang($this->_post->toArray('i18n'), $recurr_notification_arr['id'], 'pjNotification');	
					}
				}				
			} else {
				pjBaseMultiLangModel::factory()->updateMultiLang($this->_post->toArray('i18n'), $this->_post->toInt('notify_id'), 'pjNotification');
			}
        }        
        self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Notification has been updated.'));
    }
    
	public function pjActionDeleteTicketImage()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!self::isPost())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
		}
		if (!($this->_get->toInt('id')))
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
		}
		$id = $this->_get->toInt('id');
		$pjEventModel = pjEventModel::factory();
		$arr = $pjEventModel->find($id)->getData(); 
		if(empty($arr))
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Event not found.'));
		}
		
		$d = array();
		$d['ticket_img'] = ':NULL';

		$pjEventModel->reset()->where('id', $id)->limit(1)->modifyAll($d);
		
		if (!empty($arr['ticket_img']) && is_file(PJ_INSTALL_PATH . $arr['ticket_img']))
		{
			@unlink(PJ_INSTALL_PATH . $arr['ticket_img']);
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Ticket image has been deleted.'));
	}
	
	public function pjActionGetBooking()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$pjBookingModel = pjBookingModel::factory()->join('pjEvent', 't2.id=t1.event_id');
			if ($status = $this->_get->toString('booking_status'))
			{
			    if(in_array($status, array('pending','confirmed','cancelled')))
			    {
			        $pjBookingModel->where('t1.booking_status', $status);
			    }
			}
			if ($q = $this->_get->toString('q'))
			{
			    $pjBookingModel->where("(t1.unique_id LIKE '%$q%' OR t1.customer_name LIKE '%$q%' OR t1.customer_email LIKE '%$q%' OR t1.customer_phone LIKE '%$q%')");
			}
						
			if ($this->_get->check('event_id') && $this->_get->toInt('event_id') > 0)
			{
				$pjBookingModel->where('t1.event_id', $this->_get->toInt('event_id'));
			}
			
			$column = 'event_start_ts';
			$direction = 'ASC';
			$allowed_columns = array('unique_id', 'customer_name', 'event_start_ts', 'tickets', 'booking_total', 'booking_status');
			if ($this->_get->toString('column') && in_array($this->_get->toString('column'), $allowed_columns) && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
			{
			    $column = $this->_get->toString('column');
			    $direction = strtoupper($this->_get->toString('direction'));
			}

			$total = $pjBookingModel->findCount()->getData();
			$rowCount = $this->_get->toInt('rowCount') ?: 10;
			$pages = ceil($total / $rowCount);
			$page = $this->_get->toInt('page') ?: 1;
			$offset = ((int) $page - 1) * $rowCount;
			if ($page > $pages)
			{
				$page = $pages;
			}
			$booking_arr = $pjBookingModel
				->select("t1.id, t1.unique_id, t1.event_id, t1.customer_name, 
							t1.booking_status, t1.booking_total, t1.customer_people,
							t2.event_start_ts, t2.event_end_ts, t2.o_show_start_time, t2.o_show_end_time")
				->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();

			$pjBookingDetailModel = pjBookingDetailModel::factory();
			$data = array();
			foreach($booking_arr as $k => $v){
				$v['unique_id'] = pjSanitize::clean($v['unique_id']);
				$v['customer_name'] = pjSanitize::clean($v['customer_name']);
				if(!empty($v['booking_total']))
				{
					$v['booking_total'] = pjCurrency::formatPrice($v['booking_total']);
				}else{
					$v['booking_total'] = pjCurrency::formatPrice(0);
				}
				$v['event_start_ts'] = pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format'],$v['o_show_start_time'], $v['o_show_end_time']);
				
				$details_arr = $pjBookingDetailModel->reset()
					->select('t1.*, t2.content as price_title')
					->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
					->where('t1.booking_id', $v['id'])
					->where("t1.booking_id IN(SELECT t2.id FROM `".pjBookingModel::factory()->getTable()."` as t2 WHERE t2.event_id = '".$v['event_id']."')")
					->findAll()->getData();
				$temp_arr = array();
				if(count($details_arr) > 0)
				{
					foreach($details_arr as $d)
					{
						$temp_arr[] = $d['cnt'] . ' x ' . pjSanitize::clean($d['price_title']);
					}
				}	
				$v['tickets'] = implode('<br/>', $temp_arr);
				$data[$k] = $v;
			}	
			
			pjAppController::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
		}
		exit;
	}
	
	public function pjActionGetUsedTickets()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$pjBookingTicketModel = pjBookingTicketModel::factory()
				->join('pjBooking', "t1.booking_id = t2.id", 'left')
				->join('pjEvent', 't3.id=t2.event_id', 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.price_id AND t4.model = 'pjPrice' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'name'", 'left')
				->where("t1.is_used", 'T')
				->where('t2.booking_status', 'confirmed');
			if ($q = $this->_get->toString('q'))
			{
			    $pjBookingTicketModel->where("(t1.ticket_id LIKE '%$q%' OR t2.unique_id LIKE '%$q%' OR t2.customer_name LIKE '%$q%' OR t2.customer_email LIKE '%$q%' OR t2.customer_phone LIKE '%$q%' OR t4.content LIKE '%$q%')");
			}
						
			if ($this->_get->check('event_id') && $this->_get->toInt('event_id') > 0)
			{
				$pjBookingTicketModel->where('t2.event_id', $this->_get->toInt('event_id'));
			}
			
			$column = 'event_start_ts';
			$direction = 'ASC';
			$allowed_columns = array('customer_name', 'customer_email', 'price_title', 'ticket_id');
			if ($this->_get->toString('column') && in_array($this->_get->toString('column'), $allowed_columns) && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
			{
			    $column = $this->_get->toString('column');
			    $direction = strtoupper($this->_get->toString('direction'));
			}

			$total = $pjBookingTicketModel->findCount()->getData();
			$rowCount = $this->_get->toInt('rowCount') ?: 10;
			$pages = ceil($total / $rowCount);
			$page = $this->_get->toInt('page') ?: 1;
			$offset = ((int) $page - 1) * $rowCount;
			if ($page > $pages)
			{
				$page = $pages;
			}
			$booking_arr = $pjBookingTicketModel
				->select("t1.id, t1.booking_id, t1.ticket_id, t1.price_id, t1.unit_price, t1.is_used, t2.unique_id, t2.customer_name, t2.customer_email, t3.event_start_ts, t3.event_end_ts, t3.o_show_start_time, t3.o_show_end_time, t4.content AS price_title")
				->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();			
			$data = array();
			foreach($booking_arr as $k => $v){
				$v['customer_name'] = pjSanitize::clean($v['customer_name']);
				$v['customer_email'] = pjSanitize::clean($v['customer_email']);
				$v['price_title'] = pjSanitize::clean($v['price_title']);
				$v['ticket_id'] = pjSanitize::clean($v['ticket_id']);
				$data[$k] = $v;
			}	
			
			pjAppController::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
		}
		exit;
	}
	
	public function pjActionExportEvent()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
		if ($record = $this->_post->toArray('record'))
		{
			$arr = pjEventModel::factory()->select('t1.id, t2.content AS `title`, t3.content AS `location`, t1.recurring_id, t1.category_id, t1.event_start_ts, t1.event_end_ts,
				t1.event_img, t1.event_thumb, t1.event_medium, t1.o_show_start_time, t1.o_show_end_time, t1.ticket_img, t1.status')
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'title'", 'left')
				->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjEvent' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'location'", 'left')
				->whereIn('t1.id', $record)->findAll()->getData();
			$csv = new pjCSV();
			$csv
				->setHeader(true)
				->setName("Events-".time().".csv")
				->process($arr)
				->download();
		}
		exit;
	}
	
	public function pjActionCheckTime()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
		    $from_arr = pjUtil::convertDateTime($this->_post->toString('event_start_ts'), $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			$to_arr = pjUtil::convertDateTime($this->_post->toString('event_end_ts'), $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			
			$from_ts = $from_arr['ts'];
			$to_ts = $to_arr['ts'];
			if ($from_ts >= $to_ts) {
				pjAppController::jsonResponse(array('status' => 'ERR'));
			} else {
				pjAppController::jsonResponse(array('status' => 'OK'));
			}
		}
		exit;
	}
}
?>