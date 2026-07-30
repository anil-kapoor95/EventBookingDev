<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjFrontEnd extends pjFront
{
	public function __construct()
	{
		parent::__construct();
		
		$this->setAjax(true);
		
		$this->setLayout('pjActionEmpty');
	}

	/**
	 * Applies a discount code to the current booking session.
	 * Mirrors the Shopping Cart pjActionApplyCode: validates the code against
	 * the current date/time (purchase time), checks the code applies to the
	 * event being booked, and stores it in the session.
	 */
	public function pjActionApplyCode()
	{
		$this->setAjax(true);

		if ($this->isXHR())
		{
			if (!$this->_post->check('code') || !pjValidation::pjActionNotEmpty($this->_post->toString('code')))
			{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => __('front_voucher_missing', true)));
			}

			$event_id = $this->_post->toInt('event_id');

			$pre = array();
			list($pre['date'], $pre['hour'], $pre['minute']) = explode(",", date("Y-m-d,H,i"));

			$response = pjAppController::getDiscount(array_merge($this->_post->raw(), $pre), $this->option_arr);
			if ($response['status'] == 'OK')
			{
				$events = $response['voucher_events'];
				$applies = empty($events[0]) || in_array($event_id, (array) $events);
				if ($applies)
				{
					$_SESSION[$this->defaultDiscountCode] = array(
						'voucher_code' => $response['voucher_code'],
						'voucher_type' => $response['voucher_type'],
						'voucher_apply' => $response['voucher_apply'],
						'voucher_discount' => $response['voucher_discount'],
						'voucher_events' => empty($events[0]) ? 'all' : $events
					);
					$response['voucher'] = $_SESSION[$this->defaultDiscountCode];
				}
				else
				{
					$response = array('status' => 'ERR', 'code' => 104, 'text' => __('front_voucher_not_for_event', true));
				}
			}
			pjAppController::jsonResponse($response);
		}
		exit;
	}

	/**
	 * Removes the discount code applied to the current booking session.
	 */
	public function pjActionRemoveCode()
	{
		$this->setAjax(true);

		if ($this->isXHR())
		{
			if (isset($_SESSION[$this->defaultDiscountCode]) && !empty($_SESSION[$this->defaultDiscountCode]))
			{
				$_SESSION[$this->defaultDiscountCode] = NULL;
				unset($_SESSION[$this->defaultDiscountCode]);
			}
			pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}
		exit;
	}

	public function pjActionLoadCss()
	{
		$dm = new pjDependencyManager(PJ_INSTALL_PATH, PJ_THIRD_PARTY_PATH);
		$dm->load(PJ_CONFIG_PATH . 'dependencies.php')->resolve();
	
		$theme = $this->_get->check('theme') ? $this->_get->toString('theme') : $this->option_arr['o_theme'];
		if((int) $theme > 0)
		{
			$theme = 'theme' . $theme;
		}
		$arr = array(
				array('file' => 'font-awesome.min.css', 'path' => $dm->getPath('font_awesome') . 'css/'),
				array('file' => 'tooltipster.css', 'path' => $dm->getPath('pj_tooltipster')),
				array('file' => 'pj-calendar.css', 'path' => PJ_FRAMEWORK_LIBS_PATH . 'pj/css/'),
				array('file' => 'style.css', 'path' => PJ_CSS_PATH),
				array('file' => "$theme.css", 'path' => PJ_CSS_PATH . 'themes/')
		);
		header("Content-Type: text/css; charset=utf-8");
		foreach ($arr as $item)
		{
			ob_start();
			@readfile($item['path'] . $item['file']);
			$string = ob_get_contents();
			ob_end_clean();
	
			if ($string !== FALSE)
			{
				echo str_replace(
						array('../img/', '../fonts/glyphicons', '../fonts/fontawesome', '[URL]', "pjWrapper"),
						array(
								PJ_INSTALL_URL . PJ_IMG_PATH,
								PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/fonts/glyphicons',
								PJ_INSTALL_URL . $dm->getPath('font_awesome') . 'fonts/fontawesome',
								PJ_INSTALL_URL,
								"pjWrapperEBCalendar_" . $theme
						),
						$string
				) . "\n";
			}
		}
		exit;
	}
	
	public function pjActionLoad()
	{
	    $this->setAjax(false);
	    $this->setLayout('pjActionFront');
	    
	    ob_start();
	    header("Content-Type: text/javascript; charset=utf-8");
	}
	
	public function pjActionLocale()
	{
	    $this->setAjax(true);
	    
	    if ($this->isXHR())
	    {
	        if ($locale_id = $this->_get->toInt('locale_id'))
	        {
	            $this->pjActionSetLocale($locale_id);
	            $this->loadSetFields(true);
	            $day_names = __('day_names', true);
	            ksort($day_names, SORT_NUMERIC);
	            
	            $months = __('months', true);
	            ksort($months, SORT_NUMERIC);
	            
	            pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Locale have been changed.', 'opts' => array(
	                'day_names' => array_values($day_names),
	                'month_names' => array_values($months)
	            )));
	        }
	    }
	    exit;
	}
	
public function pjActionCaptcha()
	{
		$this->setAjax(true);
		 
		header("Cache-Control: max-age=3600, private");
		
		$rand = $this->_get->toInt('rand') ?: rand(1, 9999);
		$patterns = 'app/web/img/button.png';
		if(!empty($this->option_arr['o_captcha_background_front']) && $this->option_arr['o_captcha_background_front'] != 'plain')
		{
			$patterns = PJ_INSTALL_PATH . $this->getConstant('pjBase', 'PLUGIN_IMG_PATH') . 'captcha_patterns/' . $this->option_arr['o_captcha_background_front'];
		}
		$Captcha = new pjCaptcha(PJ_INSTALL_PATH . $this->getConstant('pjBase', 'PLUGIN_WEB_PATH') . 'obj/arialbd.ttf', $this->defaultCaptcha, (int) $this->option_arr['o_captcha_length_front']);
		$Captcha->setImage($patterns)->setMode($this->option_arr['o_captcha_mode_front'])->init($rand);
		
		exit;
	}
	
	public function pjActionCheckCaptcha()
	{
		if ($this->isXHR())
		{
			echo isset($_SESSION[$this->defaultCaptcha]) && $this->_get->check('captcha') && $_SESSION[$this->defaultCaptcha] == strtoupper($this->_get->toString('captcha')) ? 'true' : 'false';
		}
		exit;
	}
		
	public function pjActionCheckReCaptcha()
	{
		$this->setAjax(true);
		$verifyResponse = file_get_contents('https://www.google.com/recaptcha/api/siteverify?secret='.$this->option_arr['o_captcha_secret_key_front'].'&response='.$this->_get->toString('recaptcha'));
		$responseData = json_decode($verifyResponse);
		echo $responseData->success ? 'true': 'false';
		exit;
	}
	
	public function pjActionBookingSave()
	{
		$this->setAjax(true);

		$pjEventModel = pjEventModel::factory();
		$pjBookingModel = pjBookingModel::factory();
		$pjBookingDetailModel = pjBookingDetailModel::factory();
		$pjBookingTicketModel = pjBookingTicketModel::factory();
	
		$response = $this->doubleCheckData($this->_post->raw());
        if($response['status'] == 'ERR')
        {
            pjAppController::jsonResponse($response);
        }
			
		$event_id = $this->_post->toInt('event_id');
	
		$available = true;
		$total_tickets = 0;
		$price_arr = pjPriceModel::factory()
			->select("t1.*, (SELECT SUM(cnt) FROM `" .pjBookingDetailModel::factory()->getTable(). "` as `TBD` WHERE `TBD`.price_id = t1.id AND `TBD`.booking_id IN(SELECT `TB`.id FROM `".pjBookingModel::factory()->getTable()."` as `TB` WHERE `TB`.booking_status='confirmed' OR `TB`.booking_status='pending' )) as cnt_booked")
			->where('event_id', $event_id)
			->findAll()
			->getData();
		foreach($price_arr as $k => $v)
		{
			$price_id = $v['id'];
			if($this->_post->check('price_' . $price_id))
			{
				if($this->_post->toInt('price_' . $price_id) > 0)
				{
					$total_tickets += $this->_post->toInt('price_' . $price_id);
					if((intval($v['available']) - (intval($v['cnt_booked']) + $this->_post->toInt('price_' . $price_id))) < 0 )
					{
						$available = false;
						break;
					}
				}
			}
		}
		if($available == false)
		{
			pjAppController::jsonResponse(array('code' => 101, 'text' => __('front_unavailable_ticket_msg', true)));
		}

		// Global per-booking ticket limit (0 = unlimited). Authoritative server-side check.
		$o_max_tickets = isset($this->option_arr['o_max_tickets']) ? (int) $this->option_arr['o_max_tickets'] : 0;
		if ($o_max_tickets > 0 && $total_tickets > $o_max_tickets)
		{
			pjAppController::jsonResponse(array('code' => 102, 'text' => str_replace('{X}', $o_max_tickets, __('front_ebc_max_tickets', true))));
		}
	
		// Re-validate the applied discount code server-side (current event scope +
		// purchase-time validity) so a stale/no-longer-applicable code stored in the
		// session cannot discount the saved booking. Invalid => no discount.
		$voucher = (isset($_SESSION[$this->defaultDiscountCode]) && !empty($_SESSION[$this->defaultDiscountCode])) ? $_SESSION[$this->defaultDiscountCode] : null;
		$voucher = pjAppController::getValidSessionVoucher($voucher, $event_id, $this->option_arr);
		$discount = pjAppController::calcBookingDiscount($voucher, $price_arr, $this->_post->raw(), $event_id);

		$amount_arr = $this->calcPrice($this->_post->toFloat('total_price'), $this->option_arr, $discount);

		$data = array();
		$data['unique_id'] = pjUtil::getUniqueID();
		$data['booking_status'] = $this->option_arr['o_default_status_if_not_paid'];
		$data['booking_total'] = $amount_arr['total'];
		$data['booking_tax'] = $amount_arr['tax'];
		$data['booking_discount'] = $amount_arr['discount'];
		$data['voucher_code'] = ($voucher && (float) $amount_arr['discount'] > 0) ? $voucher['voucher_code'] : ':NULL';
		$data['booking_deposit'] = $amount_arr['deposit'];
		$data['payment_option']= 'deposit';
		$data['customer_ip']= $_SERVER['REMOTE_ADDR'];
	
		if ($this->_post->check('payment_method') && $this->_post->toString('payment_method') == 'creditcard')
		{
			$data['cc_exp'] = $this->_post->toString('cc_exp_year') . '-' . $this->_post->toString('cc_exp_month');
		}
	
		$event_arr = $pjEventModel
			->reset()
			->select('t1.*, t2.content as ticket_detail')
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjEvent' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'ticket_info'", 'left')
			->find($event_id)
			->getData();
		if (count($event_arr) == 0)
		{
			$insert_id = false;
		} else {
			$insert_id = $pjBookingModel->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
		}
		if ($insert_id !== false && (int) $insert_id > 0)
		{
			$details = array();
			$tickets = array();
			$customer_people = 0;
			$ticket_number = 1;
			$details['booking_id'] = $insert_id;
			$tickets['booking_id'] = $insert_id;
				
			foreach($price_arr as $k => $v)
			{
				$price_id = $v['id'];
				if($this->_post->check('price_' . $price_id))
				{
					if($this->_post->toInt('price_' . $price_id) > 0)
					{
						$customer_people += $this->_post->toInt('price_' . $price_id);
					}
				}
				$details['price_id'] = $price_id;
				$details['price'] = $this->_post->toInt('price_' . $price_id) * $v['price'];
				$details['unit_price'] = $v['price'];
				$details['price_title'] = ':NULL';
				$details['cnt'] = $this->_post->toInt('price_' . $price_id);
	
				for($i = 1; $i <= $details['cnt']; $i++)
				{
				$tickets['ticket_id'] = $data['unique_id'] . '-' . $ticket_number;
				$tickets['price_id'] = $price_id;
				$tickets['unit_price'] = $v['price'];
					$tickets['price_title'] = ':NULL';
					$pjBookingTicketModel->reset()->setAttributes($tickets)->insert();									
					$ticket_number++;
				}
	
				$pjBookingDetailModel->reset()->setAttributes($details)->insert();
			}
			$pjBookingModel->reset()->where('id', $insert_id)->limit(1)->modifyAll(array('customer_people' => $customer_people));
				
			$booking_arr = $pjBookingModel
				->reset()
				->select('t1.*, t2.event_start_ts, t2.event_end_ts, t2.o_show_start_time, t2.o_show_end_time,
						t3.content as country_title, t4.content as event_title, t5.content as event_location')
				->join('pjEvent', 't1.event_id = t2.id', 'left')
				->join('pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'title'", 'left')
				->join('pjMultiLang', "t5.foreign_id = t1.event_id AND t5.model = 'pjEvent' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'location'", 'left')
				->find($insert_id)->getData();
	
			$ticket_arr = $pjBookingTicketModel
				->reset()
				->select('t1.*, t2.content as price_name')
				->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where('booking_id', $insert_id)
				->findAll()->getData();
	
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
				
			pjFrontEnd::pjActionConfirmSend($this->option_arr, $booking_arr, 'confirm', $this->getLocaleId());

			// Reset the applied discount code once the booking is placed
			if (isset($_SESSION[$this->defaultDiscountCode]))
			{
				$_SESSION[$this->defaultDiscountCode] = NULL;
				unset($_SESSION[$this->defaultDiscountCode]);
			}

			$json = array('code' => 200, 'text' => '', 'booking_id' => $insert_id, 'payment' => $this->_post->check('payment_method') ? $this->_post->toString('payment_method') : '');
			pjAppController::jsonResponse($json);
		}else{
			$json = array('code' => 100, 'text' => '');
			pjAppController::jsonResponse($json);
		}
	
	}
	
	public static function pjActionConfirmSend($option_arr, $booking_arr, $type, $locale_id)
	{
		if (!in_array($type, array('confirm', 'payment', 'cancel')))
		{
			return false;
		}
		$Email = self::getMailer($option_arr);
				
		$pjNotificationModel = pjNotificationModel::factory();

        $admin_email = pjAppController::getAdminEmail();
        $admin_phone = pjAppController::getAdminPhone();
        $payment_methods = pjObject::getPlugin('pjPayments') !== NULL? pjPayments::getPaymentTitles(1, $locale_id): __('payment_methods',true);
        $event_date = pjUtil::getEventDateTime($booking_arr['event_start_ts'], $booking_arr['event_end_ts'], $option_arr['o_date_format'], $option_arr['o_time_format'], $booking_arr['o_show_start_time'], $booking_arr['o_show_end_time'] );
		
		$cancelURL = PJ_INSTALL_URL . 'index.php?controller=pjFrontPublic&action=pjActionCancel&id=' . $booking_arr ['id'] . '&hash=' . md5($booking_arr ['id'].$booking_arr['created'].PJ_SALT );
		$cancelURL = '<a href="'.$cancelURL.'">'.$cancelURL.'</a>';
		
		$pdf_tickets = PJ_INSTALL_URL . PJ_UPLOAD_PATH . 'tickets/pdfs/p_' . $booking_arr['unique_id'] . '.pdf';
		
		$event = $booking_arr['event_title'] . ' | ' . $event_date;
		
		$booking_detail_arr = pjBookingDetailModel::factory()->select('t1.*, t2.content as price_name')
			->join('pjMultiLang', "t2.foreign_id = t1.price_id AND t2.model = 'pjPrice' AND t2.locale = '" . $locale_id . "' AND t2.field = 'name'", 'left')
			->where('t1.booking_id', $booking_arr['id'])->findAll()->getData();
		
		$tickets = "\n";
		foreach ($booking_detail_arr as $v) {
			$tickets .= $v['price_name'] . ': ' . $v['cnt'] . " x " . $v['unit_price'] . ' ' . $option_arr['o_currency'] . "\n";
		}
		$total = $booking_arr['booking_total'] . ' ' . $option_arr['o_currency'];
		$tax = $booking_arr['booking_tax'] . ' ' . $option_arr['o_currency'];
		$deposit = $booking_arr['booking_deposit'] . ' ' . $option_arr['o_currency'];
		$balance = ($booking_arr['booking_total'] - $booking_arr['booking_deposit']) . ' ' . $option_arr['o_currency'];
		$discount_amount = ((float) $booking_arr['booking_discount'] > 0 ? $booking_arr['booking_discount'] : '0.00') . ' ' . $option_arr['o_currency'];
		$discount_code = $booking_arr['voucher_code'];
		$search = array (
				'{Name}',
				'{Email}',
				'{Phone}',
				'{Country}',
				'{City}',
				'{State}',
				'{Zip}',
				'{Address}',
				'{Tickets}',
				'{PDF_Tickets}',
				'{Notes}',
				'{PaymentMethod}',
				'{Event}',
				'{EventTitle}',
				'{EventDateTime}',
				'{EventLocation}',
				'{DiscountCode}',
				'{Discount}',
				'{Total}',
				'{Tax}',
				'{Deposit}',
				'{Balance}',
				'{BookingID}',
				'{CancelURL}' 
		);
		$replace = array (
				$booking_arr['customer_name'],
				$booking_arr['customer_email'],
				$booking_arr['customer_phone'],
				$booking_arr['country_title'],
				$booking_arr['customer_city'],
				$booking_arr['customer_state'],
				$booking_arr['customer_zip'],
				$booking_arr['customer_address'],
				$tickets,
				$pdf_tickets,
				$booking_arr['customer_notes'],
				@$payment_methods[$booking_arr['payment_method']],
				$event,
				$booking_arr['event_title'],
				$event_date,
				$booking_arr['event_location'],
				$discount_code,
				$discount_amount,
				$total,
				$tax,
				$deposit,
				$balance,
				$booking_arr['unique_id'],
				$cancelURL 
		);		
		switch ($type)
		{
			case 'confirm':
				// Client
				$notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'email')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
		        	$resp = pjAppController::getSubjectMessage($notification, $locale_id);	                    
                    $lang_message = $resp['lang_message'];
                    $lang_subject = $resp['lang_subject'];	                    
                    if (isset($lang_subject[0]['content']) && !empty($lang_subject[0]['content']) && isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    					$subject = str_replace($search, $replace, $lang_subject[0]['content']);
    					$message = str_replace($search, $replace, $lang_message[0]['content']);
    					if (!empty($subject) && !empty($message))
    					{
    						$message = pjUtil::textToHtml($message);
    						$Email
    							->setTo($booking_arr['customer_email'])
    							->setSubject($subject)
    							->send($message);
    					}
                    }
		        }
		        // Admin
		        $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'admin')->where('transport', 'email')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$resp = pjAppController::getSubjectMessage($notification, $locale_id);	                    
                    $lang_message = $resp['lang_message'];
                    $lang_subject = $resp['lang_subject'];	                    
                    if (isset($lang_subject[0]['content']) && !empty($lang_subject[0]['content']) && isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    					$subject = str_replace($search, $replace, $lang_subject[0]['content']);
    					$message = str_replace($search, $replace, $lang_message[0]['content']);
    					if (!empty($subject) && !empty($message))
    					{
    						$message = pjUtil::textToHtml($message);
    						foreach($admin_email as $email)
    						{
    							$Email
    								->setTo($email)
    								->setSubject($subject)
    								->send($message);
    						}
    					}
                    }
		        }
				/*SMS sent to client*/
	            if(!empty($booking_arr['customer_phone']))
	            {
	                $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'sms')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
		               	$resp = pjAppController::getSmsMessage($notification, $locale_id);	                    
	                    $lang_message = $resp['lang_message'];	                    
	                    if (isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    						$message = str_replace($search, $replace, $lang_message[0]['content']);
    		                if (!empty($message))
    		                {
    		                    $params = array(
    		                        'text' => $message,
    		                        'type' => 'unicode',
    		                        'key' => md5($option_arr['private_key'] . PJ_SALT)
    		                    );
    		                    $params['number'] = $booking_arr['customer_phone'];
    		                    pjBaseSms::init($params)->pjActionSend();
    		                }
	                    }
	                }
	            }
				/*SMS sent to Admin*/
	            if($admin_phone)
	            {
	                $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'admin')->where('transport', 'sms')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
		               	$resp = pjAppController::getSmsMessage($notification, $locale_id);	                    
	                    $lang_message = $resp['lang_message'];	      
	                    if (isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    						$message = str_replace($search, $replace, $lang_message[0]['content']);
    		                if (!empty($message))
    		                {
    		                    $params = array(
    		                        'text' => $message,
    		                        'type' => 'unicode',
    		                        'key' => md5($option_arr['private_key'] . PJ_SALT)
    		                    );
    		                    foreach ($admin_phone as $phone) {
    		                    	if (!empty($phone))
    			                    $params['number'] = $phone;
    			                    pjBaseSms::init($params)->pjActionSend();
    		                    }
    		                }
	                    }
	                }
	            }
				break;
			case 'payment':
				// Client
		        $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$resp = pjAppController::getSubjectMessage($notification, $locale_id);	                    
                    $lang_message = $resp['lang_message'];
                    $lang_subject = $resp['lang_subject'];	                    
                    if (isset($lang_subject[0]['content']) && !empty($lang_subject[0]['content']) && isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    					$subject = str_replace($search, $replace, $lang_subject[0]['content']);
    					$message = str_replace($search, $replace, $lang_message[0]['content']);
    					if (!empty($subject) && !empty($message))
    					{
    						$message = pjUtil::textToHtml($message);
    						$Email
    							->setTo($booking_arr['customer_email'])
    							->setSubject($subject)
    							->send($message);
    					}
                    }
		        }
				// Admin
		        $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'admin')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
			        $resp = pjAppController::getSubjectMessage($notification, $locale_id);	                    
                    $lang_message = $resp['lang_message'];
                    $lang_subject = $resp['lang_subject'];	                    
                    if (isset($lang_subject[0]['content']) && !empty($lang_subject[0]['content']) && isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    					$subject = str_replace($search, $replace, $lang_subject[0]['content']);
    					$message = str_replace($search, $replace, $lang_message[0]['content']);
    					if (!empty($subject) && !empty($message))
    					{
    						$message = pjUtil::textToHtml($message);
    						foreach($admin_email as $email)
    						{
    							$Email
    								->setTo($email)
    								->setSubject($subject)
    								->send($message);
    						}
    					}
                    }
		        }
				/*SMS sent to client*/
	            if(!empty($booking_arr['customer_phone']))
	            {
	                $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'sms')->where('variant', $type)->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
		               	$resp = pjAppController::getSmsMessage($notification, $locale_id);	                    
	                    $lang_message = $resp['lang_message'];	                    
	                    if (isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    						$message = str_replace($search, $replace, $lang_message[0]['content']);
    		                if (!empty($message))
    		                {
    		                    $params = array(
    		                        'text' => $message,
    		                        'type' => 'unicode',
    		                        'key' => md5($option_arr['private_key'] . PJ_SALT)
    		                    );
    		                    $params['number'] = $booking_arr['customer_phone'];
    		                    pjBaseSms::init($params)->pjActionSend();
    		                }
	                    }
	                }
	            }
				/*SMS sent to Admin*/
	            if($admin_phone)
	            {
	                $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'admin')->where('transport', 'sms')->where('variant', $type)->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
		               	$resp = pjAppController::getSmsMessage($notification, $locale_id);	                    
	                    $lang_message = $resp['lang_message'];	                    
	                    if (isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    						$message = str_replace($search, $replace, $lang_message[0]['content']);
    		                if (!empty($message))
    		                {
    		                    $params = array(
    		                        'text' => $message,
    		                        'type' => 'unicode',
    		                        'key' => md5($option_arr['private_key'] . PJ_SALT)
    		                    );
    		                    foreach ($admin_phone as $phone) {
    		                    	if (!empty($phone))
    			                    $params['number'] = $phone;
    			                    pjBaseSms::init($params)->pjActionSend();
    		                    }
    		                }
	                    }
	                }
	            }
				break;
			case 'cancel':
				// Client
		        $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$resp = pjAppController::getSubjectMessage($notification, $locale_id);	                    
                    $lang_message = $resp['lang_message'];
                    $lang_subject = $resp['lang_subject'];	                    
                    if (isset($lang_subject[0]['content']) && !empty($lang_subject[0]['content']) && isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    					$subject = str_replace($search, $replace, $lang_subject[0]['content']);
    					$message = str_replace($search, $replace, $lang_message[0]['content']);
    					if (!empty($subject) && !empty($message))
    					{
    						$message = pjUtil::textToHtml($message);
    						$Email
    							->setTo($booking_arr['customer_email'])
    							->setSubject($subject)
    							->send($message);
    					}
                    }
		        }
				// Admin
		        $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'admin')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$resp = pjAppController::getSubjectMessage($notification, $locale_id);	                    
                    $lang_message = $resp['lang_message'];
                    $lang_subject = $resp['lang_subject'];	                    
                    if (isset($lang_subject[0]['content']) && !empty($lang_subject[0]['content']) && isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    					$subject = str_replace($search, $replace, $lang_subject[0]['content']);
    					$message = str_replace($search, $replace, $lang_message[0]['content']);
    					if (!empty($subject) && !empty($message))
    					{
    						$message = pjUtil::textToHtml($message);
    						foreach($admin_email as $email)
    						{
    							$Email
    								->setTo($email)
    								->setSubject($subject)
    								->send($message);
    						}
    					}
                    }
		        }
				/*SMS sent to client*/
	            if(!empty($booking_arr['customer_phone']))
	            {
	                $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'client')->where('transport', 'sms')->where('variant', $type)->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
		               	$resp = pjAppController::getSmsMessage($notification, $locale_id);	                    
	                    $lang_message = $resp['lang_message'];	                    
	                    if (isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) { 
    						$message = str_replace($search, $replace, $lang_message[0]['content']);
    		                if (!empty($message))
    		                {
    		                    $params = array(
    		                        'text' => $message,
    		                        'type' => 'unicode',
    		                        'key' => md5($option_arr['private_key'] . PJ_SALT)
    		                    );
    		                    $params['number'] = $booking_arr['customer_phone'];
    		                    pjBaseSms::init($params)->pjActionSend();
    		                }
	                    }
	                }
	            }
				/*SMS sent to Admin*/
	            if($admin_phone)
	            {
	                $notification = $pjNotificationModel->reset()->where('foreign_id', $booking_arr['event_id'])->where('recipient', 'admin')->where('transport', 'sms')->where('variant', $type)->findAll()->getDataIndex(0);
	                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	                {
		               	$resp = pjAppController::getSmsMessage($notification, $locale_id);	                    
	                    $lang_message = $resp['lang_message'];	                    
	                    if (isset($lang_message[0]['content']) && !empty($lang_message[0]['content'])) {
    						$message = str_replace($search, $replace, $lang_message[0]['content']);
    		                if (!empty($message))
    		                {
    		                    $params = array(
    		                        'text' => $message,
    		                        'type' => 'unicode',
    		                        'key' => md5($option_arr['private_key'] . PJ_SALT)
    		                    );
    		                    foreach ($admin_phone as $phone) {
    		                    	if (!empty($phone))
    			                    $params['number'] = $phone;
    			                    pjBaseSms::init($params)->pjActionSend();
    		                    }
    		                }
	                    }
	                }
	            }
				break;
		}
	}
	
	public function pjActionConfirm()
	{
	    $this->setAjax(true);
	    
	    if (pjObject::getPlugin('pjPayments') === NULL)
	    {
	        $this->log('pjPayments plugin not installed');
	        exit;
	    }
	    
	    $pjPayments = new pjPayments();
	    if($pjPlugin = $pjPayments->getPaymentPlugin($_REQUEST))
	    {
	        if($uuid = $this->requestAction(array('controller' => $pjPlugin, 'action' => 'pjActionGetCustom', 'params' => $_REQUEST), array('return')))
	        {
	            $pjBookingModel = pjBookingModel::factory();
	            $booking_arr = $pjBookingModel
					->select ( 't1.*, t2.event_start_ts, t2.event_end_ts, t2.o_show_start_time, t2.o_show_end_time,
								t3.content as country_title, t4.content as event_title, t5.content as event_location' )
					->join ( 'pjEvent', 't1.event_id = t2.id', 'left' )
					->join ( 'pjMultiLang', "t3.foreign_id = t1.customer_country AND t3.model = 'pjBaseCountry' AND t3.locale = '" . $this->getLocaleId() . "' AND t3.field = 'name'", 'left' )
					->join ( 'pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '" . $this->getLocaleId() . "' AND t4.field = 'title'", 'left' )
					->join ( 'pjMultiLang', "t5.foreign_id = t1.event_id AND t5.model = 'pjEvent' AND t5.locale = '" . $this->getLocaleId() . "' AND t5.field = 'location'", 'left' )					
					->where('t1.unique_id', $uuid)
                ->limit(1)
                ->findAll()
                ->getDataIndex(0);
				if (!empty($booking_arr))
				{
				    $booking_id = $booking_arr['id'];
				    $locale_id = $this->getLocaleId();
				    $option_arr = $this->option_arr;
				    $params = array(
				        'request'		=> $_REQUEST,
				        'payment_method' => $_REQUEST['payment_method'],
				        'foreign_id'	 => $this->getForeignId(),
				        'amount'		 => $booking_arr['booking_deposit'],
				        'txn_id'		 => $booking_arr['txn_id'],
				        'order_id'	   => $booking_arr['id'],
				        'cancel_hash'	=> sha1($booking_arr['unique_id'].strtotime($booking_arr['created']).PJ_SALT),
				        'key'			=> md5($option_arr['private_key'] . PJ_SALT)
				    );
				    $response = $this->requestAction(array('controller' => $pjPlugin, 'action' => 'pjActionConfirm', 'params' => $params), array('return'));
				    
				    if($response['status'] == 'OK')
				    {
				        $this->log("Payments | {$pjPlugin} plugin<br>Booking was confirmed. UUID: {$uuid}");
				        if($booking_arr['booking_status'] != $option_arr['o_default_status_if_paid'])
				        {
    				        $pjBookingModel
	    				        ->reset()
	    				        ->set('id', $booking_arr['id'])
	    				        ->modify(array('txn_id' => @$response['txn_id'], 'booking_status' => $option_arr['o_default_status_if_paid'], 'processed_on' => ':NOW()'));
    				        
    				        pjFrontEnd::pjActionConfirmSend($option_arr, $booking_arr, 'payment', $locale_id);
				        }
            			echo $option_arr['o_thankyou_page'];
            			exit;
				    }elseif($response['status'] == 'CANCEL'){
				        $this->log("Payments | {$pjPlugin} plugin<br>Payment was cancelled. UUID: {$uuid}");
				        $pjBookingModel
					        ->reset()
					        ->set('id', $booking_arr['id'])
					        ->modify(array('booking_status' => 'cancelled', 'processed_on' => ':NOW()'));
				        
				        pjFrontEnd::pjActionConfirmSend($option_arr, $booking_arr, 'cancel', $locale_id);
				        
				        echo $option_arr['o_cancel_booking_page'];
				        exit;
				    }else{
				        $this->log("Payments | {$pjPlugin} plugin<br>Booking confirmation was failed. UUID: {$uuid}");
				    }
				    
				    if(isset($response['redirect']) && $response['redirect'] == true)
				    {
				        echo $option_arr['o_thankyou_page'];
				        exit;
				    }
				}else{
				    $this->log("Payments | {$pjPlugin} plugin<br>Booking with UUID {$uuid} not found.");
				}
				echo $this->option_arr['o_thankyou_page'];
				exit;
	        }
	    }
	    
	    echo $this->option_arr['o_thank_you_page'];
	    exit;
	}
	
	public static function pjActionGetSubjectMessage($notification_id, $locale_id)
	{
	    $pjMultiLangModel = pjMultiLangModel::factory();
	    $lang_message = $pjMultiLangModel
	    ->reset()
	    ->select('t1.*')
	    ->where('t1.foreign_id', $notification_id)
	    ->where('t1.model','pjNotification')
	    ->where('t1.locale', $locale_id)
	    ->where('t1.field', 'message')
	    ->limit(0, 1)
	    ->findAll()
	    ->getData();
	    $lang_subject = $pjMultiLangModel
	    ->reset()
	    ->select('t1.*')
	    ->where('t1.foreign_id',  $notification_id)
	    ->where('t1.model','pjNotification')
	    ->where('t1.locale', $locale_id)
	    ->where('t1.field', 'subject')
	    ->limit(0, 1)
	    ->findAll()
	    ->getData();
	    return compact('lang_message', 'lang_subject');
	}
		
	private function doubleCheckData($data)
	{
	    $double_check_error = __('double_check_error', true);
	    if($this->option_arr['o_captcha_type_front'] == 'system')
	    {
	        if((int) $this->option_arr['o_bf_include_captcha'] === 3 && !isset($data['captcha']))
	        {
	            return array('status' => 'ERR', 'code' => 101, 'text' => $double_check_error[101]);
	        }
	        if((int) $this->option_arr['o_bf_include_captcha'] === 3 && !pjValidation::pjActionNotEmpty($data['captcha']))
	        {
	            return array('status' => 'ERR', 'code' => 102, 'text' => $double_check_error[102]);
	        }
	        if((int) $this->option_arr['o_bf_include_captcha'] === 3 && !pjCaptcha::validate($data['captcha'], $this->session->getData($this->defaultCaptcha)))
	        {
	            return array('status' => 'ERR', 'code' => 103, 'text' => $double_check_error[103]);
	        }
	    }else{
	        if((int) $this->option_arr['o_bf_include_captcha'] === 3 && !isset($data['recaptcha']))
	        {
	            return array('status' => 'ERR', 'code' => 101, 'text' => $double_check_error[101]);
	        }
	        if((int) $this->option_arr['o_bf_include_captcha'] === 3 && !pjValidation::pjActionNotEmpty($data['recaptcha']))
	        {
	            return array('status' => 'ERR', 'code' => 102, 'text' => $double_check_error[102]);
	        }
	    }
	    
	    if((int) $this->option_arr['o_bf_include_name'] === 3 && !isset($data['customer_name']))
	    {
	        return array('status' => 'ERR', 'code' => 137, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_name'] === 3 && !pjValidation::pjActionNotEmpty($data['customer_name']))
	    {
	        return array('status' => 'ERR', 'code' => 138, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_email'] === 3 && !isset($data['customer_email']))
	    {
	        return array('status' => 'ERR', 'code' => 139, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_email'] === 3 && !pjValidation::pjActionNotEmpty($data['customer_email']))
	    {
	        return array('status' => 'ERR', 'code' => 140, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_email'] === 3 && !pjValidation::pjActionEmail($data['customer_email']))
	    {
	        return array('status' => 'ERR', 'code' => 141, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_phone'] === 3 && !isset($data['customer_phone']))
	    {
	        return array('status' => 'ERR', 'code' => 142, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_phone'] === 3 && !pjValidation::pjActionNotEmpty($data['customer_phone']))
	    {
	        return array('status' => 'ERR', 'code' => 143, 'text' => $double_check_error[104]);
	    }	    
		if((int) $this->option_arr['o_bf_include_address'] === 3 && !isset($data['customer_address']))
	    {
	        return array('status' => 'ERR', 'code' => 122, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_address'] === 3 && !pjValidation::pjActionNotEmpty($data['customer_address']))
	    {
	        return array('status' => 'ERR', 'code' => 123, 'text' => $double_check_error[104]);
	    }	    
		if((int) $this->option_arr['o_bf_include_city'] === 3 && !isset($data['customer_city']))
	    {
	        return array('status' => 'ERR', 'code' => 122, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_city'] === 3 && !pjValidation::pjActionNotEmpty($data['customer_city']))
	    {
	        return array('status' => 'ERR', 'code' => 123, 'text' => $double_check_error[104]);
	    }	    
		if((int) $this->option_arr['o_bf_include_state'] === 3 && !isset($data['customer_state']))
	    {
	        return array('status' => 'ERR', 'code' => 128, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_state'] === 3 && !pjValidation::pjActionNotEmpty($data['customer_state']))
	    {
	        return array('status' => 'ERR', 'code' => 129, 'text' => $double_check_error[104]);
	    }
		if((int) $this->option_arr['o_bf_include_zip'] === 3 && !isset($data['customer_zip']))
	    {
	        return array('status' => 'ERR', 'code' => 130, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_zip'] === 3 && !pjValidation::pjActionNotEmpty($data['customer_zip']))
	    {
	        return array('status' => 'ERR', 'code' => 131, 'text' => $double_check_error[104]);
	    }
		if((int) $this->option_arr['o_bf_include_country'] === 3 && !isset($data['customer_country']))
	    {
	        return array('status' => 'ERR', 'code' => 132, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_country'] === 3 && (int) $data['customer_country'] <= 0)
	    {
	        return array('status' => 'ERR', 'code' => 133, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_notes'] === 3 && !isset($data['customer_notes']))
	    {
	        return array('status' => 'ERR', 'code' => 146, 'text' => $double_check_error[104]);
	    }
	    if((int) $this->option_arr['o_bf_include_notes'] === 3 && !pjValidation::pjActionNotEmpty($data['customer_notes']))
	    {
	        return array('status' => 'ERR', 'code' => 147, 'text' => $double_check_error[104]);
	    }
	    // Only require a payment method when there is actually something to pay.
	    // A free booking (subtotal 0) hides the payment selector on the form, so
	    // demanding one here would reject every $0.00 booking with "Invalid Data!".
	    if($this->option_arr['o_payment_disable'] == 'No' && (float) (isset($data['total_price']) ? $data['total_price'] : 0) > 0)
	    {
	        if(!isset($data['payment_method']))
	        {
	            return array('status' => 'ERR', 'code' => 148, 'text' => $double_check_error[104]);
	        }
	        if(!pjValidation::pjActionNotEmpty($data['payment_method']))
	        {
	            return array('status' => 'ERR', 'code' => 149, 'text' => $double_check_error[104]);
	        }
	    }
	    return array('status' => 'OK', 'code' => 200, 'text' => "");
	}
}
?>