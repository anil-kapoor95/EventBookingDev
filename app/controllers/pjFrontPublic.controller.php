<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjFrontPublic extends pjFront
{
	public function __construct()
	{
		parent::__construct();
		
		$this->setAjax(true);
		
		$this->setLayout('pjActionEmpty');
	}
	
	public function pjActionLoadEvents()
	{
		$this->setAjax(true);
	
		$is_ip_blocked = pjBase::isBlockedIp(pjUtil::getClientIp(), $this->option_arr);
		if($is_ip_blocked == true)
		{
			$this->set('status', 'IP_BLOCKED');
		} else {
			$pjEventModel = pjEventModel::factory();
		
			$pjEventModel->where("t1.status", 'T');
		
			if($this->_get->check('category_id') && $this->_get->toInt('category_id') > 0)
			{
				$pjEventModel->where('t1.category_id', $this->_get->toInt('category_id'));
			}
		
			$pjEventModel->where("(t1.category_id IN(SELECT t5.id FROM `".pjCategoryModel::factory()->getTable()."` AS t5 WHERE t5.status = 'T') OR t1.category_id IS NULL)");
			if($this->_get->check('view') && $this->_get->toString('view') == 'list')
			{
				if(!$this->_get->check('event_id'))
				{
					list($y, $n, $j) = explode("-", date("Y-n-j"));
					$midnight = mktime(0, 0, 0, $n, $j, $y);
		
					$pjEventModel->where("t1.event_start_ts >=", $midnight);
		
					if($this->_get->check('period') && $this->_get->toString('period') != '' && $this->_get->toString('period') != 'all')
					{
						$where = pjUtil::getWherePeriod($this->_get->toString('period'));
						if($where != '')
						{
							$pjEventModel->where($where);
						}
					}
		
					$total = $pjEventModel->findCount()->getData();
					$rowCount = $this->option_arr['o_events_per_page'];
					$pages = ceil($total / $rowCount);
					$page = $this->_get->toInt('page') ?: 1;
					$offset = ((int) $page - 1) * $rowCount;
					if ($page > $pages)
					{
						$page = $pages;
					}
					$pjEventModel->limit($rowCount, $offset);
					$this->set('pages', $pages);
					$this->set('page', $page);
					$this->set('paginator', array('pages' => $pages, 'total' => $total));
				}else{
					$pjEventModel->where('t1.id', $this->_get->toInt('event_id'));
				}
			}else{
				$month = $this->_get->toInt('month');
				$year = $this->_get->toInt('year');
					
				$firstDayOfMonth = mktime(0, 0, 0, $month, 1, $year);
				$lastDayOfMonth = mktime(23, 59, 59, $month + 1, 0, $year);
					
				$pjEventModel->where("((t1.event_start_ts BETWEEN $firstDayOfMonth AND $lastDayOfMonth) OR (t1.event_end_ts BETWEEN $firstDayOfMonth AND $lastDayOfMonth) OR (t1.event_start_ts < $firstDayOfMonth AND t1.event_end_ts > $lastDayOfMonth))");
			}
		
			$event_arr = $pjEventModel
				->select("t1.*, t6.content as category, t3.content as title, t4.content as event_description, t5.content as event_location,
						(SELECT SUM(`TP`.available) FROM `".pjPriceModel::factory()->getTable()."` AS `TP` WHERE `TP`.event_id=t1.id) AS `total_avail`,
						(SELECT SUM(`TBD`.cnt) FROM `".pjBookingDetailModel::factory()->getTable()."` AS `TBD` WHERE `TBD`.booking_id IN (SELECT `TB`.id FROM `".pjBookingModel::factory()->getTable()."` as `TB` WHERE `TB`.event_id = t1.id AND (`TB`.booking_status ='confirmed' OR `TB`.booking_status ='pending') )) AS `total_booked`")
				->join('pjCategory', 't2.id=t1.category_id', 'left outer')
				->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjEvent' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'title'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'description'", 'left')
				->join('pjMultiLang', "t5.foreign_id = t1.id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
				->join('pjMultiLang', "t6.foreign_id = t1.category_id AND t6.model = 'pjCategory' AND t6.locale = '".$this->getLocaleId()."' AND t6.field = 'name'", 'left')
				->orderBy('t1.event_start_ts ASC')
				->findAll()
				->getData();
		
			$event_date_arr = array();
			foreach ($event_arr as $v)
			{
				$start_date = date('Y-m-d', $v['event_start_ts']);
				$end_date = date('Y-m-d', $v['event_end_ts']);
					
				$event_field_arr = array();
					
				$event_field_arr['id'] = $v['id'];
				$event_field_arr['event_title'] = $v['title'];
				$event_field_arr['location'] = $v['event_location'];
				$event_field_arr['category'] = $v['category'];
				$event_field_arr['event_start_ts'] = $v['event_start_ts'];
				$event_field_arr['event_end_ts'] = $v['event_end_ts'];
				$event_field_arr['event_img'] = $v['event_img'];
				$event_field_arr['event_thumb'] = $v['event_thumb'];
				$event_field_arr['o_show_start_time'] = $v['o_show_start_time'];
				$event_field_arr['o_show_end_time'] = $v['o_show_end_time'];
				$event_field_arr['total_booked'] = $v['total_booked'];
				$event_field_arr['total_avail'] = $v['total_avail'];
				$event_field_arr['description'] = $v['event_description'];
					
				if($start_date == $end_date)
				{
					$event_date_arr[$start_date][] = $event_field_arr;
				}else{
					while($start_date <= $end_date)
					{
						$event_date_arr[$start_date][] = $event_field_arr;
						$start_date = date('Y-m-d', strtotime($start_date . '+1 day'));
					}
				}
			}
		
			if($this->_get->check('view') && $this->_get->toString('view') == 'calendar')
			{
				$pjEBCalendar = new pjEBCalendar();
				
				$title_arr = array();
				$title_arr['avail_tickets'] = __('front_label_available_tickets', true);
				$title_arr['today'] = __('front_today', true);
				$pjEBCalendar
					->setPrevLink("&nbsp;")
					->setNextLink("&nbsp;")
					->setStartDay($this->option_arr['o_week_start'])
					->setWeekNumbers('left')
					->setDayNames(__('days_short', true))
					->setMonthNames(__('months', true))
					->setShowTooltip($this->option_arr['o_event_title_position'] == 'tooltip' ? true : false)
					->set('options', $this->option_arr)
					->set('dates', $event_date_arr)
					->set('titles', $title_arr);
				
				$this->set('calendar', $pjEBCalendar);
				
			}
			
			$this->set('event_arr', $event_arr);
			$this->set('event_date_arr', $event_date_arr);
		}
	}
	
	public function pjActionLoadEventDetail()
	{
		$this->setAjax(true);
	
		$is_ip_blocked = pjBase::isBlockedIp(pjUtil::getClientIp(), $this->option_arr);
		if($is_ip_blocked == true)
		{
			$this->set('status', 'IP_BLOCKED');
		} else {
			$date = $this->_get->toString('date');
			$start_ts = strtotime($date . ' 00:00:00');
			$end_ts = strtotime($date . ' 23:59:59');
			$pjEventModel = pjEventModel::factory();
			$pjEventModel->where('t1.status', 'T');
			$pjEventModel->where("((t1.event_start_ts BETWEEN $start_ts AND $end_ts) OR (t1.event_end_ts BETWEEN $start_ts AND $end_ts) OR (t1.event_start_ts <= $start_ts AND t1.event_end_ts >= $end_ts))");
		
			if($this->_get->check('category_id') && $this->_get->toInt('category_id') > 0)
			{
				$pjEventModel->where('t1.category_id', $this->_get->toInt('category_id'));
			}
		
			$event_arr = $pjEventModel
				->select("t1.*, t2.content as category, t3.content as title, t4.content as event_description, t5.content as event_location,
							(SELECT SUM(`TP`.available) FROM `".pjPriceModel::factory()->getTable()."` AS `TP` WHERE `TP`.event_id=t1.id) AS `total_avail`,
							(SELECT SUM(`TBD`.cnt) FROM `".pjBookingDetailModel::factory()->getTable()."` AS `TBD` WHERE `TBD`.booking_id IN (SELECT `TB`.id FROM `".pjBookingModel::factory()->getTable()."` as `TB` WHERE `TB`.event_id = t1.id AND (`TB`.booking_status ='confirmed' OR `TB`.booking_status ='pending' ))) AS `total_booked`")
				->join('pjMultiLang', "t2.foreign_id = t1.category_id AND t2.model = 'pjCategory' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjEvent' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'title'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'description'", 'left')
				->join('pjMultiLang', "t5.foreign_id = t1.id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
				->orderBy('t1.event_start_ts ASC')
				->findAll()
				->getData();
			$this->set('event_arr', $event_arr);
		}
	}
	
	public function pjActionView()
	{
		$this->setAjax(true);
		$is_ip_blocked = pjBase::isBlockedIp(pjUtil::getClientIp(), $this->option_arr);
		if($is_ip_blocked == true)
		{
			$this->set('status', 'IP_BLOCKED');
		} else {	
			$pjEventModel = pjEventModel::factory();
		
			$arr = $pjEventModel
				->select("t1.*, t6.content as category, t3.content as title, t4.content as event_description, t5.content as event_location,
						(SELECT SUM(`TP`.available) FROM `".pjPriceModel::factory()->getTable()."` AS `TP` WHERE `TP`.event_id=t1.id) AS `total_avail`,
						(SELECT SUM(`TBD`.cnt) FROM `".pjBookingDetailModel::factory()->getTable()."` AS `TBD` WHERE `TBD`.booking_id IN (SELECT `TB`.id FROM `".pjBookingModel::factory()->getTable()."` as `TB` WHERE `TB`.event_id = t1.id AND `TB`.booking_status ='confirmed')) AS `total_booked`")
				->join('pjCategory', 't2.id=t1.category_id', 'left outer')
				->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjEvent' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'title'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'description'", 'left')
				->join('pjMultiLang', "t5.foreign_id = t1.id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
				->join('pjMultiLang', "t6.foreign_id = t1.category_id AND t6.model = 'pjCategory' AND t6.locale = '".$this->getLocaleId()."' AND t6.field = 'name'", 'left')
				->find($this->_get->toInt('id'))
				->getData();
		
			$price_arr = pjPriceModel::factory()
			->select("t1.*, t2.content as price_name, (SELECT SUM(cnt) FROM `" .pjBookingDetailModel::factory()->getTable(). "` as `TBD` WHERE `TBD`.price_id = t1.id AND `TBD`.booking_id IN(SELECT `TB`.id FROM `".pjBookingModel::factory()->getTable()."` as `TB` WHERE `TB`.booking_status='confirmed')) as cnt_booked")
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
			->where('event_id', $this->_get->toInt('id'))
			->findAll()
			->getData();
				
			$this->set('arr', $arr);
			$this->set('price_arr', $price_arr);
		}
	}
	
	public function pjActionLoadBookingForm()
	{
		$this->setAjax(true);
		$is_ip_blocked = pjBase::isBlockedIp(pjUtil::getClientIp(), $this->option_arr);
		if($is_ip_blocked == true)
		{
			$this->set('status', 'IP_BLOCKED');
		} else {
			$event_id = $this->_get->toInt('event_id');
		
			$arr = pjEventModel::factory()
				->select("t1.*, t2.content as category, t3.content as title, t4.content as event_description, t5.content as event_location, t6.content as booking_terms")
				->join('pjMultiLang', "t2.foreign_id = t1.category_id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjEvent' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'title'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'description'", 'left')
				->join('pjMultiLang', "t5.foreign_id = t1.id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
				->join('pjMultiLang', "t6.foreign_id = t1.id AND t6.model = 'pjEvent' AND t6.locale = '".$this->getLocaleId()."' AND t6.field = 'terms_body'", 'left')
				->find($event_id)
				->getData();
		
			$price_arr = pjPriceModel::factory()
				->select("t1.*, t2.content as price_name,
						(SELECT SUM(cnt) FROM `" .pjBookingDetailModel::factory()->getTable(). "` as `TBD` WHERE `TBD`.price_id = t1.id AND `TBD`.booking_id IN(SELECT `TB`.id FROM `".pjBookingModel::factory()->getTable()."` as `TB` WHERE `TB`.booking_status='confirmed' OR `TB`.booking_status='pending')) as cnt_booked")
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where('event_id', $event_id)
				->findAll()
				->getData();
		
			$this->set('country_arr', pjBaseCountryModel::factory()
				->select('t1.*, t2.content AS country_title')
				->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.status', 'T')
				->orderBy('`country_title` ASC')
				->findAll()
				->getData()
			);
		
			$this->set('arr', $arr);
			$this->set('price_arr', $price_arr);
			
			$bank_account = pjMultiLangModel::factory()->select('t1.content')
				->where('t1.model','pjOption')
				->where('t1.locale', $this->getLocaleId())
				->where('t1.field', 'o_bank_account')
				->limit(1)
				->findAll()->getDataIndex(0);
				$this->set('bank_account', $bank_account ? $bank_account['content'] : '');
			
			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
				$this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
				$this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}
			else
			{
				$this->set('payment_titles', __('payment_methods', true));
			}
		}
	}
	
	public function pjActionLoadBookingSummary()
	{
		$this->setAjax(true);
		$is_ip_blocked = pjBase::isBlockedIp(pjUtil::getClientIp(), $this->option_arr);
		if($is_ip_blocked == true)
		{
			$this->set('status', 'IP_BLOCKED');
		} else {
			$event_id = $this->_get->toInt('event_id');
		
			$amount_arr = $this->calcPrice($this->_post->toFloat('total_price'), $this->option_arr);
		
			$arr = pjEventModel::factory()
				->select("t1.*, t2.content as category, t3.content as title, t4.content as event_description, t5.content as event_location")
				->join('pjMultiLang', "t2.foreign_id = t1.category_id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjEvent' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'title'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'description'", 'left')
				->join('pjMultiLang', "t5.foreign_id = t1.id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
				->find($event_id)
				->getData();
			
			$price_arr = pjPriceModel::factory()
				->select("t1.*, t2.content as price_name,
						(SELECT SUM(cnt) FROM `" .pjBookingDetailModel::factory()->getTable(). "` as `TBD` WHERE `TBD`.price_id = t1.id AND `TBD`.booking_id IN(SELECT `TB`.id FROM `".pjBookingModel::factory()->getTable()."` as `TB` WHERE `TB`.booking_status='confirmed' OR `TB`.booking_status='pending')) as cnt_booked")
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where('event_id', $event_id)
				->findAll()
				->getData();
		
			$this->set('arr', $arr);
			$this->set('price_arr', $price_arr);
			$this->set('amount', $amount_arr);
			
			$this->set('country_arr', pjBaseCountryModel::factory()
				->select('t1.*, t2.content AS country_title')
				->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.status', 'T')
				->orderBy('`country_title` ASC')
				->findAll()
				->getData()
			);
			
			$bank_account = pjMultiLangModel::factory()->select('t1.content')
				->where('t1.model','pjOption')
				->where('t1.locale', $this->getLocaleId())
				->where('t1.field', 'o_bank_account')
				->limit(1)
				->findAll()->getDataIndex(0);
				$this->set('bank_account', $bank_account ? $bank_account['content'] : '');
			
			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
				$this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
				$this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}
			else
			{
				$this->set('payment_titles', __('payment_methods', true));
			}
		}
	}
	
	public function pjActionGetPaymentForm()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			$is_ip_blocked = pjBase::isBlockedIp(pjUtil::getClientIp(), $this->option_arr);
			if($is_ip_blocked == true)
			{
				$this->set('status', 'IP_BLOCKED');
			} else {
				$pjBookingModel = pjBookingModel::factory();
				
				$booking_arr = $pjBookingModel
					->reset()
					->select('t1.*, t2.content as event_title')
					->join('pjMultiLang', "t2.foreign_id = t1.event_id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'title'", 'left')
					->find($this->_get->toInt('id'))->getData();
					
				if(pjObject::getPlugin('pjPayments') !== NULL)
			    {
			        $pjPlugin = pjPayments::getPluginName($booking_arr['payment_method']);
			        if(pjObject::getPlugin($pjPlugin) !== NULL)
			        {
			            $this->set('params', $pjPlugin::getFormParams(array('payment_method' => $booking_arr['payment_method']), array(
			                'locale_id'	 => $this->getLocaleId(),
			                'return_url'	=> $this->option_arr['o_thankyou_page'],
			                'id'			=> $booking_arr['id'],
			                'foreign_id'	=> $this->getForeignId(),
			                'uuid'		  => $booking_arr['unique_id'],
			                'name'		  => $booking_arr['customer_name'],
			                'email'		 => $booking_arr['customer_email'],
			                'phone'		 => $booking_arr['customer_phone'],
			                'amount'		=> $booking_arr['booking_deposit'],
			                'cancel_hash'   => sha1($booking_arr['unique_id'].strtotime($booking_arr['created']).PJ_SALT),
			                'currency_code' => $this->option_arr['o_currency'],
			            )));
			        }
			        if ($booking_arr['payment_method'] == 'bank')
			        {
			            $bank_account = pjMultiLangModel::factory()
			            ->select('t1.content')
			            ->where('t1.model','pjOption')
			            ->where('t1.locale', $this->getLocaleId())
			            ->where('t1.field', 'o_bank_account')
			            ->limit(1)
			            ->findAll()
			            ->getDataIndex(0);
			            $this->set('bank_account', $bank_account ? $bank_account['content'] : '');
			        }
			    }
				
				$this->set('booking_arr', $booking_arr);
				$this->set('get', $this->_get->raw());
			}
		}
	}
	
	public function pjActionCancel() {
		$is_ip_blocked = pjBase::isBlockedIp(pjUtil::getClientIp(), $this->option_arr);
		if($is_ip_blocked == true)
		{
			$this->set('status', 'IP_BLOCKED');
		} else {
			if ($this->_post->check('booking_cancel')) {
				$pjBookingModel = pjBookingModel::factory();
				
				$pjBookingModel->set('id', $this->_post->toInt('id'))->modify(array('booking_status' => 'cancelled'));
				$booking_arr = $pjBookingModel
					->select( 't1.*, t2.event_start_ts, t2.event_end_ts, t2.o_show_start_time, t2.o_show_end_time, t3.content as country_title, t4.content as event_title, t5.content as event_location' )
					->join( 'pjEvent', 't1.event_id = t2.id', 'left' )
					->join( 'pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '" . $this->getLocaleId() . "' AND t3.field = 'name'", 'left' )
					->join( 'pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '" . $this->getLocaleId() . "' AND t4.field = 'title'", 'left' )
					->join( 'pjMultiLang', "t5.foreign_id = t1.event_id AND t5.model = 'pjEvent' AND t5.locale = '" . $this->getLocaleId() . "' AND t5.field = 'location'", 'left' )
					->find($this->_post->toInt('id'))->getData();
				pjFrontEnd::pjActionConfirmSend($this->option_arr, $booking_arr, 'cancel', $this->getLocaleId());
				pjUtil::redirect($this->option_arr ['o_cancel_booking_page'] );
			} else {
				if ($this->_get->check('hash') && $this->_get->check('id')) {
					$id = $this->_get->toInt('id');
					$hash = $this->_get->toString('hash');
					
					$arr = pjBookingModel::factory()->select('t1.*, t3.content as country_title, t4.content as event_title, t5.content as description, t2.event_start_ts, t2.event_end_ts, , t2.o_show_start_time, t2.o_show_end_time')
						->join('pjEvent', 't1.event_id = t2.id', 'left')
						->join('pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '" . $this->getLocaleId() . "' AND t3.field = 'name'", 'left')
						->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '" . $this->getLocaleId() . "' AND t4.field = 'title'", 'left' )
						->join('pjMultiLang', "t5.foreign_id = t1.event_id AND t5.model = 'pjEvent' AND t5.locale = '" . $this->getLocaleId() . "' AND t5.field = 'description'", 'left' )
						->find($id)->getData();
					if ($arr) {
						if ($arr ['booking_status'] == 'cancelled') {
							$this->set ( 'status', 4 );
						} else {
							if ($hash == md5($arr['id']. $arr['created'].PJ_SALT)) {
								$this->set('arr', $arr);
							} else {
								$this->set('status', 3);
							}
						}
					} else {
						$this->set('status', 2);
					}
				} elseif (!$this->_get->check('err')) {
					$this->set ('status', 1);
				}
			}
		}
		$this->appendCss('front_cancel.css');
	}
}
?>