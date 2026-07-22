<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdmin extends pjAppController
{
	public $defaultUser = 'admin_user';
	
	public $requireLogin = true;
	
	public function __construct($requireLogin=null)
	{
		$this->setLayout('pjActionAdmin');
		
		if (!is_null($requireLogin) && is_bool($requireLogin))
		{
		    $this->requireLogin = $requireLogin;
		}
		
		if ($this->requireLogin)
		{
			$_get = pjRegistry::getInstance()->get('_get');
		    if (!$this->isLoged() && !in_array(@$_get->toString('action'), array('pjActionLogin', 'pjActionForgot', 'pjActionReset', 'pjActionValidate', 'pjActionExportFeed')))
		    {
		        if (!$this->isXHR())
		        {
		            pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjBase&action=pjActionLogin");
		        } else {
		            header('HTTP/1.1 401 Unauthorized');
		            exit;
		        }
		    }
		}
		
		$ref_inherits_arr = array();
		if ($this->isXHR() && isset($_SERVER['HTTP_REFERER'])) {
		    $http_refer_arr = parse_url($_SERVER['HTTP_REFERER']);
		    parse_str($http_refer_arr['query'], $arr);
		    if (isset($arr['controller']) && isset($arr['action'])) {
		        parse_str($_SERVER['QUERY_STRING'], $query_string_arr);
		        $key = $query_string_arr['controller'].'_'.$query_string_arr['action'];
		        $cnt = pjAuthPermissionModel::factory()->where('`key`', $key)->findCount()->getData();
		        if ($cnt <= 0) {
		            $ref_inherits_arr[$query_string_arr['controller'].'::'.$query_string_arr['action']] = $arr['controller'].'::'.$arr['action'];
		        }
		    }
		}
		
		$inherits_arr = array(
		    'pjBasePermissions::pjActionResetPermission' => 'pjBasePermissions::pjActionUserPermission',
		    
		    'pjAdminOptions::pjActionNotificationsGetMetaData' => 'pjAdminOptions::pjActionNotifications',
		    'pjAdminOptions::pjActionNotificationsGetContent' => 'pjAdminOptions::pjActionNotifications',
		    'pjAdminOptions::pjActionNotificationsSetContent' => 'pjAdminOptions::pjActionNotifications',
		
			'pjAdminCategories::pjActionCreate' => 'pjAdminCategories::pjActionCreateForm',
			'pjAdminCategories::pjActionUpdate' => 'pjAdminCategories::pjActionUpdateForm',
			'pjAdminCategories::pjActionGetCategory' => 'pjAdminCategories::pjActionIndex',
			'pjAdminCategories::pjActionSaveCategory' => 'pjAdminCategories::pjActionUpdateForm',
		
			'pjAdminEvents::pjActionGetEvent' => 'pjAdminEvents::pjActionIndex',
			'pjAdminEvents::pjActionCheckPrices' => 'pjAdminEvents::pjActionCreate',
			'pjAdminEvents::pjActionCheckPrices' => 'pjAdminEvents::pjActionUpdate',
			'pjAdminEvents::pjActionCheckTime' => 'pjAdminEvents::pjActionCreate',
			'pjAdminEvents::pjActionCheckTime' => 'pjAdminEvents::pjActionUpdate',
			'pjAdminEvents::pjActionDeleteRecurring' => 'pjAdminEvents::pjActionDeleteEvent',
			'pjAdminEvents::pjActionSaveEvent' => 'pjAdminEvents::pjActionUpdate',
			'pjAdminEvents::pjActionDeleteImage' => 'pjAdminEvents::pjActionUpdate',
			'pjAdminEvents::pjActionDeleteAllImages' => 'pjAdminEvents::pjActionUpdate',
			'pjAdminEvents::pjActionCheckRecurring' => 'pjAdminEvents::pjActionDeleteEvent',
			'pjAdminEvents::pjActionDeleteTicketImage' => 'pjAdminEvents::pjActionUpdate',
			'pjAdminEvents::pjActionGetBooking' => 'pjAdminEvents::pjActionUpdate',
			'pjAdminEvents::pjActionGetUsedTickets' => 'pjAdminEvents::pjActionUpdate',
		
			'pjAdminBookings::pjActionGetBooking' => 'pjAdminBookings::pjActionIndex',
			'pjAdminBookings::pjActionSaveBooking' => 'pjAdminBookings::pjActionUpdate',		
			'pjAdminBookings::pjActionGetPrices' => 'pjAdminBookings::pjActionCreate',
			'pjAdminBookings::pjActionCheckUniqueId' => 'pjAdminBookings::pjActionCreate',
			'pjAdminBookings::pjActionCheckUniqueId' => 'pjAdminBookings::pjActionUpdate',		
			'pjAdminBookings::pjActionUpdate' => 'pjAdminBookings::pjActionUpdate',		
			'pjAdminBookings::pjActionEmailConfirmation' => 'pjAdminBookings::pjActionUpdate',
			'pjAdminBookings::pjActionEmailPayment' => 'pjAdminBookings::pjActionUpdate',
			'pjAdminBookings::pjActionEmailCancellation' => 'pjAdminBookings::pjActionUpdate',		
			'pjAdminBookings::pjActionSetUseTicket' => 'pjAdminBookings::pjActionReadBarcode'
		);
		if ($_REQUEST['controller'] == 'pjAdminOptions' && isset($_REQUEST['next_action'])) {
		    $inherits_arr['pjAdminOptions::pjActionUpdate'] = 'pjAdminOptions::'.$_REQUEST['next_action'];
		}
		$inherits_arr = array_merge($ref_inherits_arr, $inherits_arr);
		pjRegistry::getInstance()->set('inherits', $inherits_arr);
	}
	
	public function beforeFilter()
	{
	    parent::beforeFilter();
	    
	    if (!pjAuth::factory()->hasAccess())
	    {
	        if (!$this->isXHR())
	        {
	            $this->sendForbidden();
	            return false;
	        } else {
	            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Access denied.'));
	        }
	    }
	    
	    if (self::isPost())
	    {
	    	pjAppController::validateCsrfToken();
	    }
	
	    return true;
	}
	
	public function afterFilter()
	{
	    parent::afterFilter();
	    $this->appendJs('index.php?controller=pjBase&action=pjActionMessages', PJ_INSTALL_URL, true);
	}
	
	public function beforeRender()
	{
		
	}

	public function setLocalesData()
    {
        $locale_arr = pjLocaleModel::factory()
            ->select('t1.*, t2.file')
            ->join('pjBaseLocaleLanguage', 't2.iso=t1.language_iso', 'left')
            ->where('t2.file IS NOT NULL')
            ->orderBy('t1.sort ASC')->findAll()->getData();

        $lp_arr = array();
        foreach ($locale_arr as $item)
        {
            $lp_arr[$item['id']."_"] = $item['file'];
        }
        $this->set('lp_arr', $locale_arr);
        $this->set('locale_str', pjAppController::jsonEncode($lp_arr));
        $this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjBaseLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
    }

    public function pjActionVerifyAPIKey()
    {
        $this->setAjax(true);

        if ($this->isXHR())
        {
            if (!self::isPost())
            {
                self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => __('plugin_base_api_key_text_ARRAY_100', true)));
            }

            $option_key = $this->_post->toString('key');
            if (!array_key_exists($option_key, $this->option_arr))
            {
                self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => __('plugin_base_api_key_text_ARRAY_101', true)));
            }

            $option_value = $this->_post->toString('value');
            if(empty($option_value))
            {
                self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => __('plugin_base_api_key_text_ARRAY_102', true)));
            }

            $html = '';
            $isValid = false;
            switch ($option_key)
            {
                case 'o_google_maps_api_key':
                    $address = preg_replace('/\s+/', '+', $this->option_arr['o_timezone']);
                    $api_key_str = $option_value;
                    $gfile = "https://maps.googleapis.com/maps/api/geocode/json?key=".$api_key_str."&address=".$address;
                    $Http = new pjHttp();
                    $response = $Http->request($gfile)->getResponse();
                    $geoObj = pjAppController::jsonDecode($response);
                    $geoArr = (array) $geoObj;
                    if ($geoArr['status'] == 'OK')
                    {
                        $isValid = true;
                    }
                    break;
                default:
                    // API key for an unknown service. We can't verify it so we assume it's correct.
                    $isValid = true;
            }

            if ($isValid)
            {
                self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => __('plugin_base_api_key_text_ARRAY_200', true), 'html' => $html));
            }
            else
            {
                self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => __('plugin_base_api_key_text_ARRAY_103', true), 'html' => $html));
            }
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
	
		$pjBookingModel = pjBookingModel::factory();
		$pjAuthUserModel = pjAuthUserModel::factory();
		$pjEventModel = pjEventModel::factory();
		
		$first_date_of_month = date('Y-m-01');
	    $last_date_of_month = date('Y-m-t');
	    $cnt_bookings_today = $total_amount_today = $cnt_bookings_this_month = $total_amount_this_month = 0;
	    
		$pjBookingModel
			->join('pjMultiLang', "t2.model='pjEvent' AND t2.foreign_id=t1.event_id AND t2.field='title' AND t2.locale='".$this->getLocaleId()."'", 'left')
			->where('DATE(t1.created) BETWEEN "'.$first_date_of_month.'" AND "'.$last_date_of_month.'"')
			->whereIn('t1.booking_status', array('pending','confirmed'));
		$bookings_today = $pjBookingModel->select('t1.*, t2.content AS `event_title`')->orderBy('t1.created DESC')->findAll()->getData();	
		foreach ($bookings_today as $val) {
			$total = $val['booking_total'];
			if (date('Y-m-d', strtotime($val['created'])) == date('Y-m-d')) {
				$cnt_bookings_today += 1;
				$total_amount_today += $total;
			}
			$cnt_bookings_this_month += 1;
			$total_amount_this_month += $total;
		}	
		$this->set('cnt_bookings_today', $cnt_bookings_today)
			->set('total_amount_today', $total_amount_today)
			->set('cnt_bookings_this_month', $cnt_bookings_this_month)
			->set('total_amount_this_month', $total_amount_this_month)
			->set('total_bookings', $pjBookingModel->reset()->findCount()->getData())
			->set('cnt_users', $pjAuthUserModel->findCount()->getData())
			->set('cnt_events', $pjEventModel->findCount()->getData());
			
		$pjBookingModel->reset()
			->select("t1.id, t1.unique_id, t1.customer_name, t1.customer_email, t1.booking_status, t1.booking_total, t1.customer_people, t1.created, t1.event_id, t2.event_start_ts, t2.event_end_ts, t2.o_show_start_time, t2.o_show_end_time, t3.content AS `event_title`")
			->join('pjEvent', 't2.id=t1.event_id', 'left')
			->join('pjMultiLang', "t3.model='pjEvent' AND t3.foreign_id=t1.event_id AND t3.field='title' AND t3.locale='".$this->getLocaleId()."'", 'left')
			->limit(5)
			->orderBy('t1.created DESC');
		$latest_bookings = $pjBookingModel->findAll()->getData();		
		$this->set('latest_bookings', $latest_bookings);
		
		list($y, $n, $j) = explode("-", date("Y-n-j"));
		$midnight = mktime(0, 0, 0, $n, $j, $y);
		$upcoming_events = $pjEventModel
			->reset()
			->select('t1.*, t2.content as title, t3.content as location')
			->join('pjMultiLang', "t2.model='pjEvent' AND t2.foreign_id=t1.id AND t2.field='title' AND t2.locale='".$this->getLocaleId()."'", 'left')
			->join('pjMultiLang', "t3.model='pjEvent' AND t3.foreign_id=t1.id AND t3.field='location' AND t3.locale='".$this->getLocaleId()."'", 'left')
			->where("t1.event_start_ts >=", $midnight)
			->orWhere("(t1.event_start_ts <= $midnight AND t1.event_end_ts >= $midnight)")
			->orderBy('t1.event_start_ts ASC')
			->limit(5)
			->findAll()->getData();
		$this->set('upcoming_events', $upcoming_events);
					
		$this->appendJs('pjAdmin.js');
    }
}
?>