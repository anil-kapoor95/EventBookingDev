<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminBookings extends pjAdmin
{                  
	public function pjActionCheckUniqueId()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
		    if (!$this->_get->check('unique_id') || $this->_get->isEmpty('unique_id'))
			{
				echo 'false';
				exit;
			}
			$pjBookingModel = pjBookingModel::factory()->where('t1.unique_id', $this->_get->toString('unique_id'));
			if ($this->_get->check('id')&& $this->_get->toInt('id') > 0)
			{
			    $pjBookingModel->where('t1.id !=', $this->_get->toInt('id'));
			}
			echo $pjBookingModel->findCount()->getData() == 0 ? 'true' : 'false';
		}
		exit;
	}
	
	public function pjActionGetBooking()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$pjBookingModel = pjBookingModel::factory()->join('pjEvent', 't2.id=t1.event_id');
			
			if ($this->_get->check('q') && $this->_get->toString('q') != '')
			{
				$q = $this->_get->toString('q');
				$q = str_replace(array('%', '_'), array('\%', '\_'), trim($q));
				$pjBookingModel->where("(t1.unique_id LIKE '%$q%' OR t1.customer_name LIKE '%$q%' OR t1.customer_email LIKE '%$q%' OR t1.customer_phone LIKE '%$q%')");
			}
			if ($this->_get->check('event_id') && $this->_get->toInt('event_id') > 0)
			{
				$pjBookingModel->where('t1.event_id', $this->_get->toInt('event_id'));
			}
			if ($this->_get->check('unique_id') && $this->_get->toString('unique_id') != '')
			{
				$unique_id = $this->_get->toString('unique_id');
				$unique_id = str_replace(array('%', '_'), array('\%', '\_'), trim($unique_id));
				$pjBookingModel->where("t1.unique_id LIKE '%$unique_id%'");
			}
			if ($this->_get->check('customer_name') && $this->_get->toString('customer_name') != '')
			{
				$q = $this->_get->toString('customer_name');
				$q = str_replace(array('%', '_'), array('\%', '\_'), trim($q));
				$pjBookingModel->where("t1.customer_name LIKE '%$q%'");
			}
			if ($this->_get->check('customer_email') && $this->_get->toString('customer_email') != '')
			{
				$q = $this->_get->toString('customer_email');
				$q = str_replace(array('%', '_'), array('\%', '\_'), trim($q));
				$pjBookingModel->where("t1.customer_email LIKE '%$q%'");
			}
			if ($this->_get->check('from_ticket') && $this->_get->toInt('from_ticket') > 0)
			{
				$pjBookingModel->where('t1.customer_people >=', $this->_get->toInt('from_ticket'));
			}
			if ($this->_get->check('to_ticket') && $this->_get->toInt('to_ticket') > 0)
			{
				$pjBookingModel->where('t1.customer_people <=', $this->_get->toInt('to_ticket'));
			}
			if ($this->_get->check('from_price') && $this->_get->toFloat('from_price') > 0)
			{
				$pjBookingModel->where("t1.booking_total >=" , $this->_get->toFloat('from_price'));
			}
			if ($this->_get->check('to_price') && $this->_get->toFloat('to_price') > 0)
			{
				$pjBookingModel->where("t1.booking_total <=" , $this->_get->toFloat('to_price'));
			}
			if ($this->_get->check('booking_status') && $this->_get->toString('booking_status') != '' && in_array($this->_get->toString('booking_status'), array('pending','confirmed','cancelled')))
			{
				$pjBookingModel->where('t1.booking_status', $this->_get->toString('booking_status'));
			}
			
			$column = 'event_start_ts';
			$direction = 'ASC';
			$allowed_columns = array('customer_name', 'event_start_ts', 'customer_people', 'booking_total', 'booking_status');
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
			$data = array();
			foreach($booking_arr as $k => $v){
				$v['customer_name'] = pjSanitize::clean($v['customer_name']);
				if(!empty($v['booking_total']))
				{
					$v['booking_total'] = pjCurrency::formatPrice($v['booking_total']);
				}else{
					$v['booking_total'] = pjCurrency::formatPrice(0);
				}
				$v['event_start_ts'] = pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format'],$v['o_show_start_time'], $v['o_show_end_time']);
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
		
		$event_arr = pjEventModel::factory()
			->select('t1.*, t2.content as title')
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'title'", 'left')
			->where('t1.status', 'T')
			->orderBy("t1.event_start_ts ASC")
			->findAll()->getData();
		
		$this->set('event_arr', $event_arr);
		
		 $this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
	    $this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminBookings.js');
	}
	
	public function pjActionSaveBooking()
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
	    $pjBookingModel = pjBookingModel::factory();
	    $arr = $pjBookingModel->find($this->_get->toInt('id'))->getData();
	    if (!$arr)
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Booking not found.'));
	    }
	    if (!in_array($this->_post->toString('column'), $pjBookingModel->getI18n()))
	    {
	        $pjBookingModel->reset()->where('id', $this->_get->toInt('id'))->limit(1)->modifyAll(array($this->_post->toString('column') => $this->_post->toString('value'), 'modified' => date('Y-m-d H:i:s')));
	    } else {
	        pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($this->_post->toString('column') => $this->_post->toString('value'))), $this->_get->toInt('id'), 'pjBooking', 'data');
	    }
	    
	    self::jsonResponse(array('status' => 'OK', 'code' => 201, 'text' => 'Booking has been updated.'));
	    
	    exit;
	}
	
	public function pjActionExportBooking()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
		
		if ($record = $this->_post->toArray('record'))
		{
			$arr = pjBookingModel::factory()
				->select("t1.id, t1.unique_id, t1.event_id, t2.content as event_title, from_unixtime(t4.event_start_ts) AS event_start, from_unixtime(t4.event_end_ts) AS event_end,
						t1.booking_total, t1.booking_deposit, t1.booking_tax, t1.booking_status, t1.payment_method, t1.payment_option,
						t1.customer_name, t1.customer_email, t1.customer_phone, t3.content as country_title, t1.customer_city, 
						t1.customer_state, t1.customer_zip, t1.customer_address, t1.customer_notes, t1.customer_people, t1.customer_ip,
						t1.created")
				->join('pjMultiLang', "t2.foreign_id = t1.event_id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'title'", 'left')
				->join('pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
				->join('pjEvent', 't4.id=t1.event_id')
				->whereIn('t1.id', $record)
				->findAll()->getData();
			$csv = new pjCSV();
			$csv
				->setHeader(true)
				->setName("Bookings-".time().".csv")
				->process($arr)
				->download();
		}
		exit;
	}
	
	public function pjActionCreate()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
		
		$pjEventModel = pjEventModel::factory();
			
		if ($this->_post->check('booking_create'))
		{
			$data = array();
			
			$pjBookingModel = pjBookingModel::factory();
			$pjBookingDetailModel = pjBookingDetailModel::factory();
			$pjBookingTicketModel = pjBookingTicketModel::factory();
			
			$data['customer_ip']= $_SERVER['REMOTE_ADDR'];			
			$post = array_merge($this->_post->raw(), $data);
			if (!$pjBookingModel->validates($post))
			{
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR04");
			}
			
			$insert_id = $pjBookingModel->setAttributes($post)->insert()->getInsertId();
			if ($insert_id !== false && (int) $insert_id > 0)
			{
				$details = array();
				$tickets = array();
				$customer_people = 0;
				$ticket_number = 1;
				$price_arr = pjPriceModel::factory()->where('event_id', $this->_post->toInt('event_id'))->findAll()->getData();
				
				$details['booking_id'] = $insert_id;
				$tickets['booking_id'] = $insert_id;
				foreach($price_arr as $v)
				{
					$price_id = $v['id'];
					if(isset($post['price_' . $price_id]))
					{
						if($post['price_' . $price_id] > 0)
						{
							$customer_people += $post['price_' . $price_id];
						}
					}
					$details['price_id'] = $price_id;
					$details['price'] = $post['price_' . $price_id] * $v['price'];
					$details['unit_price'] = $v['price'];
					$details['price_title'] = ':NULL';
					$details['cnt'] = $post['price_' . $price_id];
					
					$pjBookingDetailModel->reset()->setAttributes($details)->insert();
					
					for($i = 1; $i <= $details['cnt']; $i++)
					{
						$tickets['ticket_id'] = $post['unique_id'] . '-' . $ticket_number;
						$tickets['price_id'] = $price_id;
						$tickets['unit_price'] = $v['price'];
						$tickets['price_title'] = ':NULL';
						$pjBookingTicketModel->reset()->setAttributes($tickets)->insert();
						
						$ticket_number++;
					}
				}
				$pjBookingModel->reset()->where('id', $insert_id)->limit(1)->modifyAll(array('customer_people' => $customer_people));
				
				$booking_arr = $pjBookingModel
					->reset()
					->select('t1.*, t2.event_start_ts, t2.event_end_ts, t3.content as country_title, t4.content as event_title')
					->join('pjEvent', 't1.event_id = t2.id', 'left')
					->join('pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
					->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'title'", 'left')
					->find($insert_id)->getData();
				
				$ticket_arr = $pjBookingTicketModel
					->reset()
					->select('t1.*, t2.content as price_name')
					->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
					->where('booking_id', $insert_id)
					->findAll()->getData();
				$event_arr = $pjEventModel
					->reset()
					->select('t1.*, t2.content as ticket_detail')
					->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'ticket_info'", 'left')
					->find($post['event_id'])
					->getData();
				
				$ticket_data = array();
				
				foreach($ticket_arr as $v){
					$v['event_title'] = $booking_arr['event_title'];
					$v['event_datetime'] = pjUtil::getEventDateTime($event_arr['event_start_ts'], $event_arr['event_end_ts'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format'], $event_arr['o_show_start_time'], $event_arr['o_show_end_time']);
					$v['customer_name'] = $booking_arr['customer_name'];
					$v['customer_email'] = $booking_arr['customer_email'];
					$v['ticket_detail'] = $event_arr['ticket_detail'];
					$v['ticket_img'] = $event_arr['ticket_img'];
					$v['unique_id'] = $booking_arr['unique_id'];
					$v['ticket_info'] = $this->getTicketInfo($v, $this->option_arr);
					$ticket_data[] = $v;
				}
				
				$pjTicketPdf = new pjTicketPdf();
				$pjTicketPdf->generatePdf($ticket_data);
				
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR03");
			} else {
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR04");
			}
		}
		
		$event_arr = $pjEventModel
			->reset()
			->select('t1.*, t2.content as title')
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'title'", 'left')
			->orderBy("t1.event_start_ts ASC")
			->findAll()
			->getData();
		$this->set('event_arr', $event_arr);
		
		$this->set('country_arr', pjBaseCountryModel::factory()
			->select('t1.*, t2.content AS name')
			->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.status', 'T')
			->orderBy('`name` ASC')->findAll()->getData()
		);	

		$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('pjAdminBookings.js');
	}
	
	public function pjActionUpdate()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
		
		$pjBookingModel = pjBookingModel::factory();
		$pjBookingDetailModel = pjBookingDetailModel::factory();
		$pjBookingTicketModel = pjBookingTicketModel::factory();
		$pjEventModel = pjEventModel::factory();

		$booking = $pjBookingModel
			->select(sprintf("t1.*, t3.content AS event_title,
				AES_DECRYPT(t1.cc_num, '%1\$s') AS `cc_num`,
				AES_DECRYPT(t1.cc_exp, '%1\$s') AS `cc_exp`,
				AES_DECRYPT(t1.cc_code, '%1\$s') AS `cc_code`", PJ_SALT))
			->join('pjEvent', 't2.id=t1.event_id')
			->join('pjMultiLang', "t3.foreign_id = t1.event_id AND t3.model = 'pjEvent' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'title'", 'left')
			->find($_REQUEST['id'])->getData();

		if (empty($booking) || count($booking) == 0)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR08");
		}
		
		$event = $pjEventModel->find($booking['event_id'])->getData();
		
		if (empty($event) || count($event) == 0)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR09");
		}
		
		if ($this->_post->check('booking_update'))
		{
			$data = array();			
			$data['customer_ip']= $_SERVER['REMOTE_ADDR'];
			$data['modified']= date('Y-m-d H:i:s');
			
			$post = array_merge($this->_post->raw(), $data);
			
			if (!$pjBookingModel->validates($post))
			{
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR02");
			}
			$pjBookingModel->reset()->set('id', $post['id'])->modify($post);
			
			$details = array();
			$tickets = array();
			$customer_people = 0;
			$ticket_number = 1;
			
			$price_arr = pjPriceModel::factory()->select('t1.*, t2.content AS `title`')
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where('event_id', $post['event_id'])->findAll()->getData();
			
			$details['booking_id'] = $post['id'];
			$tickets['booking_id'] = $post['id'];
			
			$this->deleteTicketInfo($post['id'], $post['unique_id']);
			
			$pjBookingDetailModel->where('booking_id', $post['id'])->eraseAll();
			$pjBookingTicketModel->where('booking_id', $post['id'])->eraseAll();
			
			foreach($price_arr as $v)
			{
				$price_id = $v['id'];
				if(isset($post['price_' . $price_id]))
				{
					if($post['price_' . $price_id] > 0)
					{
						$customer_people += $post['price_' . $price_id];
					}
				}
				$details['price_id'] = $price_id;
				$details['price'] = $post['price_' . $price_id] * $v['price'];
				$details['unit_price'] = $v['price'];
				$details['price_title'] = $v['title'];
				$details['cnt'] = $post['price_' . $price_id];
				
				$pjBookingDetailModel->reset()->setAttributes($details)->insert();
				
				for($i = 1; $i <= $details['cnt']; $i++)
				{
					$tickets['ticket_id'] = $post['unique_id'] . '-' . $ticket_number;
					$tickets['price_id'] = $price_id;
					$tickets['unit_price'] = $v['price'];
					$pjBookingTicketModel->reset()->setAttributes($tickets)->insert();
					
					$ticket_number++;
				}
			}
			$pjBookingModel->reset()->where('id', $post['id'])->limit(1)->modifyAll(array('customer_people' => $customer_people));
			
			$booking_arr = $pjBookingModel
				->reset()
				->select('t1.*, t2.event_start_ts, t2.event_end_ts, t3.content as country_title, t4.content as event_title')
				->join('pjEvent', 't1.event_id = t2.id', 'left')
				->join('pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'title'", 'left')
				->find($post['id'])->getData();
			
			$ticket_arr = $pjBookingTicketModel
				->reset()
				->select('t1.*, t2.content as price_name')
				->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where('booking_id', $post['id'])
				->findAll()->getData();
			$event_arr = $pjEventModel
				->reset()
				->select('t1.*, t2.content as ticket_detail')
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'ticket_info'", 'left')
				->find($post['event_id'])
				->getData();

			$ticket_data = array();
			
			foreach($ticket_arr as $v){
				$v['event_title'] = $booking_arr['event_title'];
				$v['event_datetime'] = pjUtil::getEventDateTime($event_arr['event_start_ts'], $event_arr['event_end_ts'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format'], $event_arr['o_show_start_time'], $event_arr['o_show_end_time']);
				$v['customer_name'] = $booking_arr['customer_name'];
				$v['customer_email'] = $booking_arr['customer_email'];
				$v['ticket_detail'] = $event_arr['ticket_detail'];
				$v['ticket_img'] = $event_arr['ticket_img'];
				$v['unique_id'] = $booking_arr['unique_id'];
				$v['ticket_info'] = $this->getTicketInfo($v, $this->option_arr);
				$ticket_data[] = $v;
			}
			
			$pjTicketPdf = new pjTicketPdf();
			$pjTicketPdf->generatePdf($ticket_data);
			
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR01");
		} else {
			$this->set('arr', $booking);
		}
		
		$event_arr = $pjEventModel
			->reset()
			->select('t1.*, t2.content as title')
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'title'", 'left')
			->orderBy("t1.event_start_ts ASC")
			->findAll()
			->getData();
		$this->set('event_arr', $event_arr);

		$this->set('country_arr', pjBaseCountryModel::factory()
			->select('t1.*, t2.content AS name')
			->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.status', 'T')
			->orderBy('`name` ASC')->findAll()->getData()
		);	
		
		$this->appendJs('tinymce.min.js', PJ_THIRD_PARTY_PATH . 'tinymce/');
		$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('pjAdminBookings.js');
	}	
	
	/**
	 * Validates a discount code for the admin booking form and returns the
	 * computed discount for the selected event + ticket quantities. Reuses the
	 * same rules as the public flow (purchase-time validity, event scope).
	 */
	public function pjActionApplyDiscount()
	{
		$this->setAjax(true);

		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!pjAuth::factory('pjAdminBookings', 'pjActionCreate')->hasAccess() && !pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
		}
		if (!$this->_post->check('code') || $this->_post->toString('code') == '')
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => __('front_voucher_missing', true)));
		}

		$event_id = $this->_post->toInt('event_id');
		if ($event_id <= 0)
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 105, 'text' => __('front_voucher_not_for_event', true)));
		}

		$pre = array();
		list($pre['date'], $pre['hour'], $pre['minute']) = explode(",", date("Y-m-d,H,i"));

		$response = pjAppController::getDiscount(array_merge($this->_post->raw(), $pre), $this->option_arr);
		if ($response['status'] == 'OK')
		{
			$events = $response['voucher_events'];
			$applies = empty($events[0]) || in_array($event_id, (array) $events);
			if ($applies)
			{
				$voucher = array(
					'voucher_code' => $response['voucher_code'],
					'voucher_type' => $response['voucher_type'],
					'voucher_apply' => $response['voucher_apply'],
					'voucher_discount' => $response['voucher_discount'],
					'voucher_events' => empty($events[0]) ? 'all' : $events
				);
				$price_arr = pjPriceModel::factory()->where('event_id', $event_id)->findAll()->getData();
				$discount = pjAppController::calcBookingDiscount($voucher, $price_arr, $this->_post->raw(), $event_id);
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => __('front_voucher_applied', true), 'discount' => round($discount, 2), 'voucher_code' => $voucher['voucher_code']));
			}
			else
			{
				self::jsonResponse(array('status' => 'ERR', 'code' => 106, 'text' => __('front_voucher_not_for_event', true)));
			}
		}
		self::jsonResponse($response);
	}

	public function pjActionGetPrices()
	{
		$this->setAjax(true);

		$event_id = $this->_get->toInt('id');
		
		$price_arr = pjPriceModel::factory()
			->select("t1.*, t2.content as name, (SELECT SUM(cnt) FROM `" .pjBookingDetailModel::factory()->getTable(). "` as t2 WHERE t2.price_id = t1.id AND t2.booking_id IN(SELECT t3.id FROM `".pjBookingModel::factory()->getTable()."` as t3 WHERE t3.booking_status='confirmed')) as cnt_booked")
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
			->where('event_id', $event_id)->findAll()->getData();
		$this->set('price_arr', $price_arr);
	}
	
	public function pjActionGetUpdatePrices()
	{
		$this->setAjax(true);
		if ($this->isXHR())
		{
			$pjBookingDetailModel = pjBookingDetailModel::factory();
			$pjBookingModel = pjBookingModel::factory();
			
			$event_id = $this->_get->toInt('id');
			$booking_id = $this->_get->toInt('booking_id');
			$booking_arr = $pjBookingModel->find($booking_id)->getData();
			$booking_detail_arr = $pjBookingDetailModel->where('booking_id', $booking_id)->findAll()->getData();
			
			$price_booking = array();
			foreach($booking_detail_arr as $v)
			{
				$price_booking[$v['price_id']] = $v['cnt'];
			}
			
			$price_arr = pjPriceModel::factory()
				->select("t1.*, t2.content as name, (SELECT SUM(cnt) FROM `" .$pjBookingDetailModel->getTable(). "` as t2 WHERE t2.price_id = t1.id AND t2.booking_id IN(SELECT t3.id FROM `".$pjBookingModel->getTable()."` as t3 WHERE t3.event_id = $event_id AND t3.booking_status='confirmed')) as cnt_booked")
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where('event_id', $event_id)
				->findAll()->getData();
			
			if($booking_arr['booking_status'] == 'confirmed')
			{
				$this->set('is_confirmed', 1);
			}else{
				$this->set('is_confirmed', 0);
			}				
			$this->set('price_arr', $price_arr);
			$this->set('price_booking', $price_booking);
		}
	}
	
	public function pjActionDeleteBooking()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isGet() && !$this->_get->check('id') && $this->_get->toInt('id') < 0)
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		$pjBookingModel = pjBookingModel::factory();
		$arr = $pjBookingModel->find($this->_get->toInt('id'))->getData();
		if (!$arr) {
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Booking not found.'));
		}
		if ($pjBookingModel->reset()->set('id', $arr['id'])->erase()->getAffectedRows() == 1)
		{
			pjBookingDetailModel::factory()->where('booking_id', $arr['id'])->eraseAll();
			$this->deleteTicketInfo($arr['id'], $arr['unique_id']);
			pjBookingTicketModel::factory()->where('booking_id', $arr['id'])->eraseAll();
			$response = array('status' => 'OK');
		} else {
			$response = array('status' => 'ERR');
		}
		self::jsonResponse($response);
	}
	
	public function pjActionDeleteBookingBulk()
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

		if (!$this->_post->has('record') || !($record = $this->_post->toArray('record')))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid data.'));
		}
		$pjBookingModel = pjBookingModel::factory();				
		$booking_arr = $pjBookingModel->whereIn('id', $record)->findAll()->getData();
		if ($pjBookingModel->reset()->whereIn('id', $record)->eraseAll()->getAffectedRows() > 0)
		{
			foreach($booking_arr as $b_arr){
				$this->deleteTicketInfo($b_arr['id'], $b_arr['unique_id']);
			}
			
			$pjBookingModel->reset()->whereIn('id', $record)->eraseAll();
			pjBookingDetailModel::factory()->whereIn('booking_id', $record)->eraseAll();
			pjBookingTicketModel::factory()->whereIn('booking_id', $record)->eraseAll();
			self::jsonResponse(array('status' => 'OK'));
		}
		
		self::jsonResponse(array('status' => 'ERR'));
	}
		
	private function deleteTicketInfo($booking_id, $unique_id)
	{
		$ticket_arr = pjBookingTicketModel::factory()->where('booking_id', $booking_id)->findAll()->getData();
		foreach($ticket_arr as $v)
		{
			$barcode_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'tickets/barcodes/b_'. $v['ticket_id'] .'.png';
			$ticket_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'tickets/t_' . $v['ticket_id'] . '.png';
			if(is_file($barcode_path)){
				@unlink($barcode_path);
			}
			if(is_file($ticket_path)){
				@unlink($ticket_path);
			}
		}
		$pdf_path = PJ_INSTALL_PATH . PJ_UPLOAD_PATH . 'tickets/pdfs/p_'. $unique_id . '.pdf';
		if(is_file($pdf_path)){
			@unlink($pdf_path);
		}
	}
	
public function pjActionEmailConfirmation()
	{
	    $this->checkLogin();
	    
	    $this->setAjax(true);
	    
	    if ($this->isXHR())
	    {
	        if (self::isPost())
	        {
	            if($this->_post->toInt('send_email') && $this->_post->toString('to') && $this->_post->toString('subject') && $this->_post->toString('message') && $this->_post->toInt('id'))
	            {
	                $Email = self::getMailer($this->option_arr);
	                $message = pjUtil::textToHtml($this->_post->toString('message'));
	                $r = $Email
	                ->setTo($this->_post->toString('to'))
	                ->setSubject($this->_post->toString('subject'))
	                ->send($message);
	                if (isset($r) && $r)
	                {
	                    pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
	                }
	                pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	            }
	        }
	        if (self::isGet())
	        {
	            if($booking_id = $this->_get->toInt('booking_id'))
	            {
	                $booking_arr = pjBookingModel::factory()
						->select('t1.*, t4.content as event_title, t5.content as event_location, t2.event_start_ts, t2.event_end_ts, t2.o_show_start_time, t2.o_show_end_time, t3.content as country_title')
						->join('pjEvent', 't1.event_id = t2.id', 'left')
						->join('pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
						->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'title'", 'left')
						->join('pjMultiLang', "t5.foreign_id = t1.event_id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
						->find($booking_id)->getData();
	                
	                $notification = pjNotificationModel::factory()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'email')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
	                	$event_date = pjUtil::getEventDateTime($booking_arr['event_start_ts'], $booking_arr['event_end_ts'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format'], $booking_arr['o_show_start_time'], $booking_arr['o_show_end_time']);
			
						$cancelURL = PJ_INSTALL_URL . 'index.php?controller=pjFrontPublic&action=pjActionCancel&id='.$booking_arr['id'].'&hash='.md5($booking_arr['id'].$booking_arr['created'].PJ_SALT);
						$cancelURL = '<a href="'.$cancelURL.'">'.$cancelURL.'</a>';
						
						$pdf_tickets = PJ_INSTALL_URL . PJ_UPLOAD_PATH . 'tickets/pdfs/p_' . $booking_arr['unique_id'] . '.pdf';
						
						$event = $booking_arr['event_title'] . ' | ' . $event_date;
			
						$booking_detail_arr = pjBookingDetailModel::factory()
							->select('t1.*, t2.content as price_name')
							->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
							->where('t1.booking_id', $booking_arr['id'])
							->findAll()->getData();
				
						$tickets = "\n";
						foreach($booking_detail_arr as $v)
						{
							$tickets .= $v['price_name'] . ': ' . $v['cnt'] . " x " . $v['unit_price']  . ' ' . $this->option_arr['o_currency'] . "\n";
						}
						$total = $booking_arr['booking_total'] . ' ' . $this->option_arr['o_currency'];
						$tax = $booking_arr['booking_tax'] . ' ' . $this->option_arr['o_currency'];
						$deposit = $booking_arr['booking_deposit'] . ' ' . $this->option_arr['o_currency'];
						$balance = ($booking_arr['booking_total'] - $booking_arr['booking_deposit']) . ' ' . $this->option_arr['o_currency'];
						$discount_amount = ((float) $booking_arr['booking_discount'] > 0 ? $booking_arr['booking_discount'] : '0.00') . ' ' . $this->option_arr['o_currency'];
						$discount_code = $booking_arr['voucher_code'];
						
	                    $search = array('{Name}', '{Email}', '{Phone}', '{Country}', '{City}', '{State}', '{Zip}', '{Address}', '{Tickets}', '{PDF_Tickets}', '{Notes}', '{CCType}', '{CCNum}', '{CCExp}', '{CCSec}', '{PaymentMethod}', '{Event}', '{EventTitle}', '{EventDateTime}', '{EventLocation}', '{DiscountCode}', '{Discount}', '{Total}', '{Tax}', '{Deposit}', '{Balance}', '{BookingID}', '{CancelURL}');
						$replace = array($booking_arr['customer_name'], $booking_arr['customer_email'], $booking_arr['customer_phone'], $booking_arr['country_title'], $booking_arr['customer_city'], $booking_arr['customer_state'], $booking_arr['customer_zip'], $booking_arr['customer_address'], $tickets, $pdf_tickets, $booking_arr['customer_notes'], $booking_arr['cc_type'], $booking_arr['cc_num'], ($booking_arr['payment_method'] == 'creditcard' ? $booking_arr['cc_exp'] : NULL), $booking_arr['cc_code'], $booking_arr['payment_method'], $event, $booking_arr['event_title'], $event_date, $booking_arr['event_location'], $discount_code, $discount_amount, $total, $tax, $deposit, $balance, $booking_arr['unique_id'], $cancelURL);
			
						$resp = pjAppController::getSubjectMessage($notification, $this->getLocaleId());	                    
	                    $lang_message = $resp['lang_message'];
	                    $lang_subject = $resp['lang_subject'];
	                    
	                    $subject_client = str_replace($search, $replace, @$lang_subject[0]['content']);
	                    $message_client = str_replace($search, $replace, @$lang_message[0]['content']);
	                    
	                    $this->set('arr', array(
	                        'id' => $booking_id,
	                        'to' => $booking_arr['customer_email'],
	                        'message' => $message_client,
	                        'subject' => $subject_client
	                    ));
	                }
	            }
	        }
	    }
	}
	
	public function pjActionEmailPayment()
	{
	    $this->checkLogin();
	    
	    $this->setAjax(true);
	    
	    if ($this->isXHR())
	    {
	        if (self::isPost())
	        {
	            if($this->_post->toInt('send_email') && $this->_post->toString('to') && $this->_post->toString('subject') && $this->_post->toString('message') && $this->_post->toInt('id'))
	            {
	                $Email = self::getMailer($this->option_arr);
	                $message = pjUtil::textToHtml($this->_post->toString('message'));
	                $r = $Email
	                ->setTo($this->_post->toString('to'))
	                ->setSubject($this->_post->toString('subject'))
	                ->send($message);
	                if (isset($r) && $r)
	                {
	                    pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
	                }
	                pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	            }
	        }
	        if (self::isGet())
	        {
	            if($booking_id = $this->_get->toInt('booking_id'))
	            {
	                $booking_arr = pjBookingModel::factory()
						->select('t1.*, t4.content as event_title, t5.content as event_location, t2.event_start_ts, t2.event_end_ts, t2.o_show_start_time, t2.o_show_end_time, t3.content as country_title')
						->join('pjEvent', 't1.event_id = t2.id', 'left')
						->join('pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
						->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'title'", 'left')
						->join('pjMultiLang', "t5.foreign_id = t1.event_id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
						->find($booking_id)->getData();
	                
	                $notification = pjNotificationModel::factory()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'email')->where('variant', 'payment')->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
	                	$event_date = pjUtil::getEventDateTime($booking_arr['event_start_ts'], $booking_arr['event_end_ts'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format'], $booking_arr['o_show_start_time'], $booking_arr['o_show_end_time']);
			
						$cancelURL = PJ_INSTALL_URL . 'index.php?controller=pjFrontPublic&action=pjActionCancel&id='.$booking_arr['id'].'&hash='.md5($booking_arr['id'].$booking_arr['created'].PJ_SALT);
						$cancelURL = '<a href="'.$cancelURL.'">'.$cancelURL.'</a>';
						
						$pdf_tickets = PJ_INSTALL_URL . PJ_UPLOAD_PATH . 'tickets/pdfs/p_' . $booking_arr['unique_id'] . '.pdf';
						
						$event = $booking_arr['event_title'] . ' | ' . $event_date;
			
						$booking_detail_arr = pjBookingDetailModel::factory()
							->select('t1.*, t2.content as price_name')
							->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
							->where('t1.booking_id', $booking_arr['id'])
							->findAll()->getData();
				
						$tickets = "\n";
						foreach($booking_detail_arr as $v)
						{
							$tickets .= $v['price_name'] . ': ' . $v['cnt'] . " x " . $v['unit_price']  . ' ' . $this->option_arr['o_currency'] . "\n";
						}
						$total = $booking_arr['booking_total'] . ' ' . $this->option_arr['o_currency'];
						$tax = $booking_arr['booking_tax'] . ' ' . $this->option_arr['o_currency'];
						$deposit = $booking_arr['booking_deposit'] . ' ' . $this->option_arr['o_currency'];
						$balance = ($booking_arr['booking_total'] - $booking_arr['booking_deposit']) . ' ' . $this->option_arr['o_currency'];
						$discount_amount = ((float) $booking_arr['booking_discount'] > 0 ? $booking_arr['booking_discount'] : '0.00') . ' ' . $this->option_arr['o_currency'];
						$discount_code = $booking_arr['voucher_code'];
						
	                    $search = array('{Name}', '{Email}', '{Phone}', '{Country}', '{City}', '{State}', '{Zip}', '{Address}', '{Tickets}', '{PDF_Tickets}', '{Notes}', '{CCType}', '{CCNum}', '{CCExp}', '{CCSec}', '{PaymentMethod}', '{Event}', '{EventTitle}', '{EventDateTime}', '{EventLocation}', '{DiscountCode}', '{Discount}', '{Total}', '{Tax}', '{Deposit}', '{Balance}', '{BookingID}', '{CancelURL}');
						$replace = array($booking_arr['customer_name'], $booking_arr['customer_email'], $booking_arr['customer_phone'], $booking_arr['country_title'], $booking_arr['customer_city'], $booking_arr['customer_state'], $booking_arr['customer_zip'], $booking_arr['customer_address'], $tickets, $pdf_tickets, $booking_arr['customer_notes'], $booking_arr['cc_type'], $booking_arr['cc_num'], ($booking_arr['payment_method'] == 'creditcard' ? $booking_arr['cc_exp'] : NULL), $booking_arr['cc_code'], $booking_arr['payment_method'], $event, $booking_arr['event_title'], $event_date, $booking_arr['event_location'], $discount_code, $discount_amount, $total, $tax, $deposit, $balance, $booking_arr['unique_id'], $cancelURL);
			
						$resp = pjAppController::getSubjectMessage($notification, $this->getLocaleId());	                    
	                    $lang_message = $resp['lang_message'];
	                    $lang_subject = $resp['lang_subject'];
	                    
	                    $subject_client = str_replace($search, $replace, @$lang_subject[0]['content']);
	                    $message_client = str_replace($search, $replace, @$lang_message[0]['content']);
	                    
	                    $this->set('arr', array(
	                        'id' => $booking_id,
	                        'to' => $booking_arr['customer_email'],
	                        'message' => $message_client,
	                        'subject' => $subject_client
	                    ));
	                }
	            }
	        }
	    }
	}
	
	public function pjActionEmailCancellation()
	{
	$this->checkLogin();
	    
	    $this->setAjax(true);
	    
	    if ($this->isXHR())
	    {
	        if (self::isPost())
	        {
	            if($this->_post->toInt('send_email') && $this->_post->toString('to') && $this->_post->toString('subject') && $this->_post->toString('message') && $this->_post->toInt('id'))
	            {
	                $Email = self::getMailer($this->option_arr);
	                $message = pjUtil::textToHtml($this->_post->toString('message'));
	                $r = $Email
	                ->setTo($this->_post->toString('to'))
	                ->setSubject($this->_post->toString('subject'))
	                ->send($message);
	                if (isset($r) && $r)
	                {
	                    pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
	                }
	                pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	            }
	        }
	        if (self::isGet())
	        {
	            if($booking_id = $this->_get->toInt('booking_id'))
	            {
	                $booking_arr = pjBookingModel::factory()
						->select('t1.*, t4.content as event_title, t5.content as event_location, t2.event_start_ts, t2.event_end_ts, t2.o_show_start_time, t2.o_show_end_time, t3.content as country_title')
						->join('pjEvent', 't1.event_id = t2.id', 'left')
						->join('pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
						->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'title'", 'left')
						->join('pjMultiLang', "t5.foreign_id = t1.event_id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
						->find($booking_id)->getData();
	                
	                $notification = pjNotificationModel::factory()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'email')->where('variant', 'cancel')->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
	                	$event_date = pjUtil::getEventDateTime($booking_arr['event_start_ts'], $booking_arr['event_end_ts'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format'], $booking_arr['o_show_start_time'], $booking_arr['o_show_end_time']);
			
						$cancelURL = PJ_INSTALL_URL . 'index.php?controller=pjFrontPublic&action=pjActionCancel&id='.$booking_arr['id'].'&hash='.md5($booking_arr['id'].$booking_arr['created'].PJ_SALT);
						$cancelURL = '<a href="'.$cancelURL.'">'.$cancelURL.'</a>';
						
						$pdf_tickets = PJ_INSTALL_URL . PJ_UPLOAD_PATH . 'tickets/pdfs/p_' . $booking_arr['unique_id'] . '.pdf';
						
						$event = $booking_arr['event_title'] . ' | ' . $event_date;
			
						$booking_detail_arr = pjBookingDetailModel::factory()
							->select('t1.*, t2.content as price_name')
							->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
							->where('t1.booking_id', $booking_arr['id'])
							->findAll()->getData();
				
						$tickets = "\n";
						foreach($booking_detail_arr as $v)
						{
							$tickets .= $v['price_name'] . ': ' . $v['cnt'] . " x " . $v['unit_price']  . ' ' . $this->option_arr['o_currency'] . "\n";
						}
						$total = $booking_arr['booking_total'] . ' ' . $this->option_arr['o_currency'];
						$tax = $booking_arr['booking_tax'] . ' ' . $this->option_arr['o_currency'];
						$deposit = $booking_arr['booking_deposit'] . ' ' . $this->option_arr['o_currency'];
						$balance = ($booking_arr['booking_total'] - $booking_arr['booking_deposit']) . ' ' . $this->option_arr['o_currency'];
						$discount_amount = ((float) $booking_arr['booking_discount'] > 0 ? $booking_arr['booking_discount'] : '0.00') . ' ' . $this->option_arr['o_currency'];
						$discount_code = $booking_arr['voucher_code'];
						
	                    $search = array('{Name}', '{Email}', '{Phone}', '{Country}', '{City}', '{State}', '{Zip}', '{Address}', '{Tickets}', '{PDF_Tickets}', '{Notes}', '{CCType}', '{CCNum}', '{CCExp}', '{CCSec}', '{PaymentMethod}', '{Event}', '{EventTitle}', '{EventDateTime}', '{EventLocation}', '{DiscountCode}', '{Discount}', '{Total}', '{Tax}', '{Deposit}', '{Balance}', '{BookingID}', '{CancelURL}');
						$replace = array($booking_arr['customer_name'], $booking_arr['customer_email'], $booking_arr['customer_phone'], $booking_arr['country_title'], $booking_arr['customer_city'], $booking_arr['customer_state'], $booking_arr['customer_zip'], $booking_arr['customer_address'], $tickets, $pdf_tickets, $booking_arr['customer_notes'], $booking_arr['cc_type'], $booking_arr['cc_num'], ($booking_arr['payment_method'] == 'creditcard' ? $booking_arr['cc_exp'] : NULL), $booking_arr['cc_code'], $booking_arr['payment_method'], $event, $booking_arr['event_title'], $event_date, $booking_arr['event_location'], $discount_code, $discount_amount, $total, $tax, $deposit, $balance, $booking_arr['unique_id'], $cancelURL);
			
						$resp = pjAppController::getSubjectMessage($notification, $this->getLocaleId());	                    
	                    $lang_message = $resp['lang_message'];
	                    $lang_subject = $resp['lang_subject'];
	                    
	                    $subject_client = str_replace($search, $replace, @$lang_subject[0]['content']);
	                    $message_client = str_replace($search, $replace, @$lang_message[0]['content']);
	                    
	                    $this->set('arr', array(
	                        'id' => $booking_id,
	                        'to' => $booking_arr['customer_email'],
	                        'message' => $message_client,
	                        'subject' => $subject_client
	                    ));
	                }
	            }
	        }
	    }
	}
	
	public function pjActionReadBarcode()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
		if($this->_post->check('read_barcode'))
		{
			$ticket_arr = array();
			if ($this->_post->toString('barcode_label') != '') {
				$ticket_arr = pjBookingTicketModel::factory()
					->select('t1.*, t4.content as event_title, , t5.content as price_name, t3.event_start_ts, t3.event_end_ts, t3.o_show_start_time, t3.o_show_end_time, t2.event_id, t2.booking_status, t2.customer_name, t2.customer_email, t2.customer_phone')
					->join('pjBooking', 't1.booking_id=t2.id', 'left')
					->join('pjEvent', 't2.event_id = t3.id', 'left')
					->join('pjMultiLang', "t4.foreign_id = t2.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'title'", 'left')
					->join('pjMultiLang', "t5.foreign_id = t1.price_id AND t5.model = 'pjPrice' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'name'", 'left')
					->where('ticket_id', $this->_post->toString('barcode_label'))->findAll()->getData();
			}					
			if(count($ticket_arr) > 0)
			{
				$status = 1;
				$arr = $ticket_arr[0];
				
				if($arr['booking_status'] != 'confirmed')
				{
					$status = 2;
				}else if($arr['is_used'] == 'T'){
					$status = 3;
				}
				$details_arr = pjBookingDetailModel::factory()
					->select('t1.*, t2.content as price_name')
					->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
					->where('booking_id', $arr['booking_id'])
					->findAll()
					->getData();
				$this->set('arr', $arr);
				$this->set('details_arr', $details_arr);
			}else{
				$status = 4;
			}
			$this->set('ticket_status', $status);
		}
		
		$this->appendJs('pjAdminBookings.js');
	}
	
	public function pjActionSetUseTicket()
	{
		$this->setAjax(true);
		if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
		$ticket_statuses = __('ticket_statuses', true);
		if ($this->_post->check('id') && $this->_post->toInt('id') > 0) {
			pjBookingTicketModel::factory()->where('id', $this->_post->toInt('id'))->limit(1)->modifyAll(array('is_used' => 'T'));
		}
		self::jsonResponse(array('status' => 'OK', 'text' => $ticket_statuses[3]));		
	}
	
	public function pjActionExport()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	
		if($this->_post->check('bookings_export'))
		{
			$pjBookingModel = pjBookingModel::factory()
				->select("t1.*, FROM_UNIXTIME(t2.event_start_ts) AS event_start, FROM_UNIXTIME(t2.event_end_ts) AS event_end, t3.content as event_title, t4.content as event_location,
					AES_DECRYPT(t1.cc_num, '".PJ_SALT."') AS `cc_num`,
					AES_DECRYPT(t1.cc_exp, '".PJ_SALT."') AS `cc_exp`,
					AES_DECRYPT(t1.cc_code, '".PJ_SALT."') AS `cc_code`")
				->join('pjEvent', 't2.id=t1.event_id', 'left outer')
				->join('pjMultiLang', "t3.foreign_id = t1.event_id AND t3.model = 'pjEvent' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'title'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'location'", 'left');

			$column = 'created';
			$direction = 'ASC';
			$where_str = pjUtil::getMadeWhere($this->_post->toString('made_period'), $this->option_arr['o_week_start']);
			if($where_str != '')
			{
				$pjBookingModel->where($where_str);
			}

			$arr= $pjBookingModel
				->orderBy("$column $direction")
				->findAll()
				->getData();
			if($this->_post->toString('type') == 'file')
			{
				$this->setLayout('pjActionEmpty');

				if($this->_post->toString('format') == 'csv')
				{
					$csv = new pjCSV();
					$csv
						->setHeader(true)
						->setName("Export-".time().".csv")
						->process($arr)
						->download();
				}
				if($this->_post->toString('format') == 'xml')
				{
					$xml = new pjXML();
					$xml
						->setEncoding('UTF-8')
						->setName("Export-".time().".xml")
						->process($arr)
						->download();
				}
				if($this->_post->toString('format') == 'ical')
				{
					foreach($arr as $k => $v)
					{
						$v['uuid'] = $v['unique_id'] . '-' . $k;
						$v['date_from'] = $v['event_start'];
						$v['date_to'] = $v['event_end'];
						$_arr = array();
						$_arr[] = $v['customer_name'];
						if(!empty($v['customer_email']))
						{
							$_arr[] = __('lblBookingEmail', true).': ' . pjSanitize::html($v['customer_email']);
						}
						if(!empty($v['customer_phone']))
						{
							$_arr[] = __('lblBookingPhone', true).': ' . pjSanitize::html($v['customer_phone']);
						}
						if(!empty($v['booking_total']))
						{
							$_arr[] = __('lblBookingTotalPrice', true).': ' . pjSanitize::html($v['booking_total']);
						}
						if(!empty($v['customer_notes']))
						{
							$_arr[] = __('lblBookingNotes', true).': ' . preg_replace('/\n|\r|\r\n/', ' ', $v['customer_notes']);
						}
						$_arr[] = __('lblBookingStatus', true).': ' . pjSanitize::html($v['booking_status']);
							
						$v['desc'] = join("\; ", $_arr);
						$v['location'] = $v['event_location'];
						$v['summary'] = $v['event_title'];
						$arr[$k] = $v;
					}

					$ical = new pjICal();
					$ical
					->setName("Export-".time().".ics")
					->setProdID('Event Booking Calendar')
					->setSummary('summary')
					->setCName('desc')
					->setLocation('location')
					->setTimezone(pjUtil::getTimezoneName($this->option_arr['o_timezone']))
					->process($arr)
					->download();
				}
				exit;
			}else{
				$pjPasswordModel = pjPasswordModel::factory();
				$password = md5($this->_post->toString('password').PJ_SALT);
				$arr = $pjPasswordModel
					->where("t1.password", $password)
					->limit(1)
					->findAll()
					->getData();
				if (count($arr) != 1)
				{
					$pjPasswordModel->setAttributes(array('password' => $password))->insert();
				}
				$this->set('password', $password);
			}
		}
		$this->appendCss('awesome-bootstrap-checkbox.css', PJ_THIRD_PARTY_PATH . 'awesome_bootstrap_checkbox/');
		$this->appendJs('pjAdminBookings.js');
	}	
}
?>