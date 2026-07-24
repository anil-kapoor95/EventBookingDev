<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAppController extends pjBaseAppController
{

	/**
 	 * Generate (or return existing) CSRF token for the current session.
 	 */
	public static function getCsrfToken()
	{
		if (empty($_SESSION['csrf_token']))
		{
			$_SESSION['csrf_token'] = bin2hex(random_bytes(32));
		}
		return $_SESSION['csrf_token'];
	}

	/**
 	 * Validate CSRF token. pjInput nulls raw $_POST/$_GET, so read request objects first.
 	 */
	public static function validateCsrfToken()
	{
		$token = '';
		$reg = pjRegistry::getInstance();
		$post = $reg->get('_post');
		$get = $reg->get('_get');
		if (is_object($post) && $post->check('csrf_token')) {
			$token = (string) $post->toString('csrf_token');
		} elseif (is_object($get) && $get->check('csrf_token')) {
			$token = (string) $get->toString('csrf_token');
		} elseif (!empty($_POST['csrf_token'])) {
			$token = $_POST['csrf_token'];
		} elseif (!empty($_GET['csrf_token'])) {
			$token = $_GET['csrf_token'];
		} elseif (!empty($_SERVER['HTTP_X_CSRF_TOKEN'])) {
			$token = $_SERVER['HTTP_X_CSRF_TOKEN'];
		}
		if (empty($_SESSION['csrf_token']) || !hash_equals($_SESSION['csrf_token'], (string) $token))
		{
			header('HTTP/1.1 403 Forbidden');
			exit('Invalid CSRF token.');
		}
	}
	public function isEditor()
    {
    	return $this->getRoleId() == 2;
    }

    public function pjActionCheckInstall()
    {
        $this->setLayout('pjActionEmpty');

        $result = array('status' => 'OK', 'code' => 200, 'text' => 'Operation succeeded', 'info' => array());
        $folders = array(	
    			'app/web/upload', 
    			'app/web/upload/bookings', 
    			'app/web/upload/events', 
    			'app/web/upload/events/thumb', 
    			'app/web/upload/tickets', 
    			'app/web/upload/tickets/barcodes', 
    			'app/web/upload/tickets/pdfs'
    	);
        foreach ($folders as $dir)
        {
            if (!is_writable($dir))
            {
                $result['status'] = 'ERR';
                $result['code'] = 101;
                $result['text'] = 'Permission requirement';
                $result['info'][] = sprintf('Folder \'<span class="bold">%1$s</span>\' is not writable. You need to set write permissions (chmod 777) to directory located at \'<span class="bold">%1$s</span>\'', $dir);
            }
        }

        return $result;
    }

    /**
     * Sets some predefined role permissions and grants full permissions to Admin.
     */
    public function pjActionAfterInstall()
    {
        $this->setLayout('pjActionEmpty');

        $result = array('status' => 'OK', 'code' => 200, 'text' => 'Operation succeeded', 'info' => array());

        $pjAuthRolePermissionModel = pjAuthRolePermissionModel::factory();
        $pjAuthUserPermissionModel = pjAuthUserPermissionModel::factory();

        $permissions = pjAuthPermissionModel::factory()->findAll()->getDataPair('key', 'id');

        $roles = array(1 => 'admin', 2 => 'editor');
        foreach ($roles as $role_id => $role)
        {
            if (isset($GLOBALS['CONFIG'], $GLOBALS['CONFIG']["role_permissions_{$role}"])
                && is_array($GLOBALS['CONFIG']["role_permissions_{$role}"])
                && !empty($GLOBALS['CONFIG']["role_permissions_{$role}"]))
            {
                $pjAuthRolePermissionModel->reset()->where('role_id', $role_id)->eraseAll();

                foreach ($GLOBALS['CONFIG']["role_permissions_{$role}"] as $role_permission)
                {
                    if($role_permission == '*')
                    {
                        // Grant full permissions for the role
                        foreach($permissions as $key => $permission_id)
                        {
                            $pjAuthRolePermissionModel->setAttributes(compact('role_id', 'permission_id'))->insert();
                        }
                        break;
                    }
                    else
                    {
                        $hasAsterix = strpos($role_permission, '*') !== false;
                        if($hasAsterix)
                        {
                            $role_permission = str_replace('*', '', $role_permission);
                        }

                        foreach($permissions as $key => $permission_id)
                        {
                            if($role_permission == $key || ($hasAsterix && strpos($key, $role_permission) !== false))
                            {
                                $pjAuthRolePermissionModel->setAttributes(compact('role_id', 'permission_id'))->insert();
                            }
                        }
                    }
                }
            }
        }
        if (isset($GLOBALS['CONFIG'], $GLOBALS['CONFIG']["listing_actions"])
            && is_array($GLOBALS['CONFIG']["listing_actions"])
            && !empty($GLOBALS['CONFIG']["listing_actions"]))
        {
            $pjAuthPermissionModel = pjAuthPermissionModel::factory();
            foreach($GLOBALS['CONFIG']["listing_actions"] as $parent_key => $get_action)
            {
                $parent_arr = $pjAuthPermissionModel->reset()->where('`key`', $parent_key)->findAll()->getDataIndex(0);
                if(!empty($parent_arr))
                {
                    $data = array('parent_id' => ':NULL', 'key' => $get_action, 'inherit_id' => $parent_arr['id']);
                    $pjAuthPermissionModel->reset()->setAttributes($data)->insert();
                }
            }
        }

		// Grant full permissions to Admin
        $user_id = 1; // Admin ID
        $pjAuthUserPermissionModel->reset()->where('user_id', $user_id)->eraseAll();
        foreach($permissions as $key => $permission_id)
        {
            $pjAuthUserPermissionModel->setAttributes(compact('user_id', 'permission_id'))->insert();
        }

        return $result;
    }
    
    public function beforeFilter()
    {
        parent::beforeFilter();

        if(!$this->_get->isEmpty('controller') && !in_array($this->_get->toString('controller'), array('pjFront', 'pjInstaller')))
        {
            $this->appendJs('pjAdminCore.js');            
        }
        
        return true;
    }

	public function afterFilter()
	{
		parent::afterFilter();
	    if(!in_array($this->_get->toString('controller'), array('pjFront', 'pjInstaller')))
	    {
	        $this->appendCss('admin.css');
	    }
	}
	
	public static function getSubjectMessage($notification, $locale_id)
    {
    	$variant = $notification['variant'] == 'confirmation' ? 'confirm' : $notification['variant'];
        $field = $variant . '_tokens_' . $notification['recipient'];
        $pjMultiLangModel = pjMultiLangModel::factory();
        $lang_message = $pjMultiLangModel
        ->reset()
        ->select('t1.*')
        ->where('t1.foreign_id', $notification['id'])
        ->where('t1.model','pjNotification')
        ->where('t1.locale', $locale_id)
        ->where('t1.field', $field)
        ->limit(0, 1)
        ->findAll()
        ->getData();
        $field = $variant . '_subject_' . $notification['recipient'];
        $lang_subject = $pjMultiLangModel
        ->reset()
        ->select('t1.*')
        ->where('t1.foreign_id',  $notification['id'])
        ->where('t1.model','pjNotification')
        ->where('t1.locale', $locale_id)
        ->where('t1.field', $field)
        ->limit(0, 1)
        ->findAll()
        ->getData();
        return compact('lang_message', 'lang_subject');
    }
    
	public static function getSmsMessage($notification, $locale_id)
    {
    	$variant = $notification['variant'] == 'confirmation' ? 'confirm' : $notification['variant'];
        $field = $variant . '_sms_' . $notification['recipient'];
        $pjMultiLangModel = pjMultiLangModel::factory();
        $lang_message = $pjMultiLangModel
        ->reset()
        ->select('t1.*')
        ->where('t1.foreign_id', $notification['id'])
        ->where('t1.model','pjNotification')
        ->where('t1.locale', $locale_id)
        ->where('t1.field', $field)
        ->limit(0, 1)
        ->findAll()
        ->getData();
        return compact('lang_message');
    }

    public static function jsonDecode($str)
	{
		$Services_JSON = new pjServices_JSON();
		return $Services_JSON->decode($str);
	}
	
	public static function jsonEncode($arr)
	{
		$Services_JSON = new pjServices_JSON();
		return $Services_JSON->encode($arr);
	}
	
	public static function jsonResponse($arr)
	{
		header("Content-Type: application/json; charset=utf-8");
		echo pjAppController::jsonEncode($arr);
		exit;
	}
	
	public function getLocaleId()
	{
		return isset($_SESSION[$this->defaultLocale]) && (int) $_SESSION[$this->defaultLocale] > 0 ? (int) $_SESSION[$this->defaultLocale] : false;
	}
	public function setLocaleId($locale_id)
	{
		$_SESSION[$this->defaultLocale] = (int) $locale_id;
	}
	
	public function friendlyURL($str, $divider='-')
	{
		$str = mb_strtolower($str, mb_detect_encoding($str)); // change everything to lowercase
		$str = trim($str); // trim leading and trailing spaces
		$str = preg_replace('/[_|\s]+/', $divider, $str); // change all spaces and underscores to a hyphen
		$str = preg_replace('/\x{00C5}/u', 'AA', $str);
		$str = preg_replace('/\x{00C6}/u', 'AE', $str);
		$str = preg_replace('/\x{00D8}/u', 'OE', $str);
		$str = preg_replace('/\x{00E5}/u', 'aa', $str);
		$str = preg_replace('/\x{00E6}/u', 'ae', $str);
		$str = preg_replace('/\x{00F8}/u', 'oe', $str);
		$str = preg_replace('/[^a-z\x{0400}-\x{04FF}0-9-]+/u', '', $str); // remove all non-cyrillic, non-numeric characters except the hyphen
		$str = preg_replace('/[-]+/', $divider, $str); // replace multiple instances of the hyphen with a single instance
		$str = preg_replace('/^-+|-+$/', '', $str); // trim leading and trailing hyphens
		return $str;
	}
	
	protected function getTicketInfo($params, $option_arr){
		$ticket_info = '';
		$ticket_price = $params['price_name'] . " " .  __('lblTicket', true) . ", " . pjCurrency::formatPrice($params['unit_price']) . "<br/>";
		if(empty($params['ticket_detail']))
		{
			$ticket_info .= $params['customer_name'] . "<br/>";
			$ticket_info .= $params['customer_email'] . "<br/>";
			$ticket_info .= $ticket_price;
		}else{
			$search = array('{Name}', '{Email}','{Ticket}', '{EventTitle}', '{EventDateTime}');
			$replace = array($params['customer_name'], $params['customer_email'], $ticket_price, $params['event_title'], $params['event_datetime']);
			$ticket_info = str_replace($search, $replace, $params['ticket_detail']);
			$ticket_info = preg_replace('/\r\n|\n/', '<br />', $ticket_info);
		}
		
		return $ticket_info;
	}
	
	protected function calcPrice($sub_total, $option_arr, $discount = 0)
	{
		$price = $sub_total;
		$discount = (float) $discount;
		$tax = ($price * $option_arr['o_tax_payment']) / 100;
		$total = $price - $discount + $tax;
		$total = $total > 0 ? $total : 0;
		$deposit = ($total * $option_arr['o_deposit_payment']) / 100;

		return compact('price', 'discount', 'tax', 'total', 'deposit');
	}

	/**
	 * Validates a discount code and returns the voucher data if it applies.
	 * Ported (event-scoped) from the Shopping Cart voucher module so the
	 * validation rules are identical: the date/time window is checked against
	 * the moment the code is applied (purchase time).
	 */
	public static function getDiscount($data, $option_arr)
	{
		if (!isset($data['code']) || empty($data['code']))
		{
			return array('status' => 'ERR', 'code' => 100, 'text' => __('front_voucher_missing', true));
		}
		$arr = pjVoucherModel::factory()
			->select(sprintf("t1.*, (SELECT GROUP_CONCAT(`event_id`) FROM `%s` WHERE `voucher_id` = `t1`.`id` LIMIT 1) AS `events`", pjVoucherEventModel::factory()->getTable()))
			->where('t1.code', $data['code'])
			->limit(1)
			->findAll()
			->getData();

		if (empty($arr))
		{
			return array('status' => 'ERR', 'code' => 101, 'text' => __('front_voucher_not_found', true));
		}
		$arr = $arr[0];
		// Split the GROUP_CONCAT of scoped event ids into an array (empty => array(''))
		$arr['events'] = (isset($arr['events']) && $arr['events'] !== null && $arr['events'] !== '') ? explode(',', $arr['events']) : array('');

		$date = $data['date'];
		if (isset($data['hour']) && isset($data['minute']))
		{
			$time = $data['hour'] . ":" . $data['minute'] . ":00";
		}
		if (!isset($time))
		{
			$time = "00:00:00";
		}
		if (empty($date))
		{
			return array('status' => 'ERR', 'code' => 103, 'text' => __('front_voucher_missing', true));
		}
		$d = strtotime($date);
		$dt = strtotime($date . " " . $time);

		$valid = false;
		switch ($arr['valid'])
		{
			case 'fixed':
				$time_from = strtotime($arr['date_from'] . " " . $arr['time_from']);
				$time_to = strtotime($arr['date_to'] . " " . $arr['time_to']);
				if ($time_from <= $dt && $time_to >= $dt)
				{
					$valid = true;
				}
				break;
			case 'period':
				$d_from = strtotime($arr['date_from']);
				$d_to = strtotime($arr['date_to']);
				$t_from = strtotime($arr['date_from'] . " " . $arr['time_from']);
				$t_to = strtotime($arr['date_to'] . " " . $arr['time_to']);
				if ($d_from <= $d && $d_to >= $d && $t_from <= $dt && $t_to >= $dt)
				{
					$valid = true;
				}
				break;
			case 'recurring':
				$t_from = strtotime($date . " " . $arr['time_from']);
				$t_to = strtotime($date . " " . $arr['time_to']);
				if ($arr['every'] == strtolower(date("l", $dt)) && $t_from <= $dt && $t_to >= $dt)
				{
					$valid = true;
				}
				break;
		}

		if (!$valid)
		{
			return array('status' => 'ERR', 'code' => 102, 'text' => __('front_voucher_expired', true));
		}

		return array(
			'status' => 'OK',
			'code' => 200,
			'text' => __('front_voucher_applied', true),
			'voucher_code' => $arr['code'],
			'voucher_type' => $arr['type'],
			'voucher_apply' => $arr['apply'],
			'voucher_discount' => $arr['discount'],
			'voucher_events' => $arr['events']
		);
	}

	/**
	 * Re-validates a discount code held in the booking session against the
	 * CURRENT database state (event scope + purchase-time validity). A code that
	 * was applied earlier but no longer qualifies for this event — e.g. the
	 * merchant re-scoped it to other events, changed its valid window, or removed
	 * it — must not keep discounting at preview/checkout just because a stale
	 * snapshot lingers in the session. Returns a fresh voucher array when the code
	 * still applies to $event_id, or null otherwise.
	 */
	public static function getValidSessionVoucher($session_voucher, $event_id, $option_arr)
	{
		if (empty($session_voucher) || empty($session_voucher['voucher_code']))
		{
			return null;
		}
		$pre = array();
		list($pre['date'], $pre['hour'], $pre['minute']) = explode(",", date("Y-m-d,H,i"));
		$response = self::getDiscount(array_merge(array('code' => $session_voucher['voucher_code']), $pre), $option_arr);
		if (!isset($response['status']) || $response['status'] != 'OK')
		{
			return null;
		}
		$events = $response['voucher_events'];
		$applies = empty($events[0]) || in_array($event_id, (array) $events);
		if (!$applies)
		{
			return null;
		}
		return array(
			'voucher_code' => $response['voucher_code'],
			'voucher_type' => $response['voucher_type'],
			'voucher_apply' => $response['voucher_apply'],
			'voucher_discount' => $response['voucher_discount'],
			'voucher_events' => empty($events[0]) ? 'all' : $events
		);
	}

	/**
	 * Computes the discount amount for a booking (event-scoped).
	 * Percent: X% of the subtotal (apply "each" and "total" are equivalent).
	 * Amount + "each ticket": the fixed amount off PER TICKET (unit quantity),
	 *   capped at each ticket's own price so it can never exceed the ticket value.
	 * Amount + "whole booking" (total): the fixed amount once, capped at subtotal.
	 * The final discount is always capped at the subtotal (total can't go negative).
	 * $price_arr = rows from pjPriceModel (id, price); $post = raw POST (price_{id} = qty).
	 */
	public static function calcBookingDiscount($voucher, $price_arr, $post, $event_id)
	{
		$discount = 0;
		if (empty($voucher) || !isset($voucher['voucher_apply']))
		{
			return 0;
		}
		$events = isset($voucher['voucher_events']) ? $voucher['voucher_events'] : 'all';
		$in_scope = ($events === 'all' || (is_array($events) && in_array($event_id, $events)));
		if (!$in_scope)
		{
			return 0;
		}

		$type = $voucher['voucher_type'];
		$disc = (float) $voucher['voucher_discount'];

		$subtotal = 0;
		$lines = array();
		foreach ($price_arr as $v)
		{
			$qty = isset($post['price_' . $v['id']]) ? (int) $post['price_' . $v['id']] : 0;
			if ($qty <= 0)
			{
				continue;
			}
			$unit = (float) $v['price'];
			$subtotal += $unit * $qty;
			$lines[] = array('unit' => $unit, 'qty' => $qty, 'amount' => $unit * $qty);
		}

		if ($voucher['voucher_apply'] == 'each')
		{
			foreach ($lines as $ln)
			{
				if ($type == 'percent')
				{
					$discount += ($ln['amount'] * $disc) / 100;
				}
				else // amount off per ticket, capped at the ticket's unit price
				{
					$discount += min($disc, $ln['unit']) * $ln['qty'];
				}
			}
		}
		else // whole booking
		{
			if ($type == 'percent')
			{
				$discount = ($subtotal * $disc) / 100;
			}
			else // fixed amount once, capped at subtotal
			{
				$discount = min($disc, $subtotal);
			}
		}

		// Never discount more than the subtotal
		if ($discount > $subtotal)
		{
			$discount = $subtotal;
		}
		if ($discount < 0)
		{
			$discount = 0;
		}

		return $discount;
	}
	
	protected function copyImage($source_id, $dest_id)
	{
		$pjEventModel = pjEventModel::factory();
	
		$event_arr = $pjEventModel->reset()->find($source_id)->getData();
		if(!empty($event_arr['event_img']))
		{
			$hash = md5(uniqid(rand(), true));
			$recurring_data = array();
			$file_ext = substr($event_arr['event_img'], strrpos($event_arr['event_img'], '.')+1);
			$recurring_data['event_img'] = PJ_UPLOAD_PATH . 'events/' . $dest_id . '_' .$hash . '.' . $file_ext;
			$recurring_data['event_thumb'] = PJ_UPLOAD_PATH . 'events/thumb/' . $dest_id . '_' .$hash . '.' . $file_ext;
			$recurring_data['event_medium'] = PJ_UPLOAD_PATH . 'events/medium/' . $dest_id . '_' .$hash . '.' . $file_ext;
			@copy($event_arr['event_img'], $recurring_data['event_img']);
			@copy($event_arr['event_thumb'], $recurring_data['event_thumb']);
			@copy($event_arr['event_medium'], $recurring_data['event_medium']);
			$pjEventModel->reset()->where('id', $dest_id)->limit(1)->modifyAll($recurring_data);
		}
	}
	
	public static function pjGetFeedData($get, $option_arr, $locale_id)
	{
		$arr = array();
		$status = true;
		$period = '';
		if(isset($get['period']))
		{
			if(!ctype_digit($get['period']))
			{
				$status = false;
			}else{
				$period = $get['period'];
			}
		}else{
			$status = false;
		}		
		if($status == true && $period != '')
		{
			$pjBookingModel = pjBookingModel::factory()
				->select("t1.*, FROM_UNIXTIME(t2.event_start_ts) AS event_start, FROM_UNIXTIME(t2.event_end_ts) AS event_end, t3.content as event_title, t4.content as event_location,
					AES_DECRYPT(t1.cc_num, '".PJ_SALT."') AS `cc_num`,
					AES_DECRYPT(t1.cc_exp, '".PJ_SALT."') AS `cc_exp`,
					AES_DECRYPT(t1.cc_code, '".PJ_SALT."') AS `cc_code`")
				->join('pjEvent', 't2.id=t1.event_id', 'left outer')
				->join('pjMultiLang', "t3.foreign_id = t1.event_id AND t3.model = 'pjEvent' AND t3.locale = '".$locale_id."' AND t3.field = 'title'", 'left')
				->join('pjMultiLang', "t4.foreign_id = t1.event_id AND t4.model = 'pjEvent' AND t4.locale = '".$locale_id."' AND t4.field = 'location'", 'left');
	
			$column = 'created';
			$direction = 'DESC';
			$where_str = pjUtil::getMadeWhere($period, $option_arr['o_week_start']);
			if($where_str != '')
			{
				$pjBookingModel->where($where_str);
			}
			$arr= $pjBookingModel
				->orderBy("$column $direction")
				->findAll()
				->getData();
		}
		return $arr;
	}
	
	static public function getFromEmail()
	{
		$arr = pjAuthUserModel::factory()
			->findAll()
			->orderBy("t1.id ASC")
			->limit(1)
			->getData();
		return !empty($arr) ? $arr[0]['email'] : null;
	}
	
	static public function getAdminEmail()
	{
		$arr = pjAuthUserModel::factory()
				->where('t1.role_id', '1')
				->where('t1.status', 'T')
				->findAll()
				->getDataPair('id', 'email');
		return $arr;
	}
	
	static public function getAdminPhone()
	{
		$arr = pjAuthUserModel::factory()
				->where('t1.role_id', '1')
				->where('t1.status', 'T')
				->findAll()
				->getDataPair('id', 'phone');
		return $arr;
	}
}
?>