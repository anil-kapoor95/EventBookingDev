<?php
if (!defined("ROOT_PATH"))
{
    header("HTTP/1.1 403 Forbidden");
    exit;
}
class pjFront extends pjAppController
{
    public $defaultCaptcha = 'pjEBCalendar_Captcha';
    
    public $defaultLocale = 'pjEBCalendar_LocaleId';
    
    public function __construct()
    {
    	if($_REQUEST['action'] != 'pjActionCancel')
		{
			$this->setLayout('pjActionFront');
		}else{
			$this->setLayout('pjActionCancel');
		}
        
        self::allowCORS();
    }
        
    public function afterFilter()
    {
    	if (!$this->_get->check('hide') || ($this->_get->check('hide') && $this->_get->toInt('hide') !== 1) &&
				in_array($this->_get->toString('action'), array('pjActionBookingSave', 'pjActionLoadEvents', 'pjActionLoadEventDetail', 'pjActionLoadBookingForm', 'pjActionLoadBookingSummary', 'pjActionGetPaymentForm')))
		{
			$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file, t2.title')
            ->join('pjBaseLocaleLanguage', 't2.iso=t1.language_iso', 'left')
            ->where('t2.file IS NOT NULL')
            ->orderBy('t1.sort ASC')->findAll()->getData();
            
            $this->set('locale_arr', $locale_arr);
            
            if (!in_array($this->_get->toString('action'), array('pjActionLoadCss')))
			{
				if ($this->_get->check('locale') && $this->_get->toInt('locale') > 0)
				{
					$locale_id = $this->_get->toInt('locale');
					if($locale_id != $this->pjActionGetLocale())
					{
						$this->setLocaleId($locale_id);
						$this->loadSetFields(true);
					}else{
						$this->loadSetFields();
					}
				}else{
					$locale_arr = pjLocaleModel::factory()->where('is_default', 1)->limit(1)->findAll()->getData();
					if (count($locale_arr) === 1)
					{
						$this->setLocaleId($locale_arr[0]['id']);
					}
					$this->loadSetFields(true);
				}
			}
			
			$category_arr = pjCategoryModel::factory()
				->select('t1.*, t2.content as category_name')
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjCategory' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->where("t1.status", 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData();
			$this->set('category_arr', $category_arr);
		}
    }
    
    public function beforeFilter()
    {
        return parent::beforeFilter();
    }
    
    public function beforeRender()
    {
        if ($this->_get->check('iframe'))
        {
            $this->setLayout('pjActionIframe');
        }
    }
    
	public function pjActionLocale()
	{
		$this->setAjax(true);
		$this->pjActionSetLocale($this->_get->toInt('locale'));
		$this->loadSetFields(true);
		$category_arr = pjCategoryModel::factory()
			->select('t1.*, t2.content as category_name')
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjCategory' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
			->where("t1.status", 'T')
			->orderBy('t2.content ASC')
			->findAll()
			->getData();
		$this->set('category_arr', $category_arr);
	}
	
 	protected function pjActionSetLocale($locale)
    {
        if ((int) $locale > 0)
        {
            $_SESSION[$this->defaultLocale] = (int) $locale;
        }
        return $this;
    }
    
    public function pjActionGetLocale()
    {
        return isset($_SESSION[$this->defaultLocale]) && (int) $_SESSION[$this->defaultLocale] > 0 ? (int) $_SESSION[$this->defaultLocale] : FALSE;
    }
    
    public function isXHR()
    {
        return parent::isXHR() || isset($_SERVER['HTTP_ORIGIN']);
    }
    
    protected static function allowCORS()
    {
    	$install_url = parse_url(PJ_INSTALL_URL);
	    if($install_url['scheme'] == 'https'){
	        header('Set-Cookie: '.session_name().'='.session_id().'; SameSite=None; Secure');
	    }
	    
	    if (!isset($_SERVER['HTTP_ORIGIN']))
	    {
	        return;
	    }
	    
	    header("Access-Control-Allow-Origin: " . $_SERVER['HTTP_ORIGIN']);
	    header("Access-Control-Allow-Credentials: true");
	    header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
	    header("Access-Control-Allow-Headers: Origin, X-Requested-With");
	    header('P3P: CP="ALL DSP COR CUR ADM TAI OUR IND COM NAV INT"');
	    
	    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS')
	    {
	        exit;
	    }
    }
    
	public function pjActionExportFeed()
	{
	    $this->setLayout('pjActionEmpty');
	    $access = true;
	    if($this->_get->check('p'))
	    {
	        $pjPasswordModel = pjPasswordModel::factory();
	        $arr = $pjPasswordModel
	        ->where('t1.password', $this->_get->toString('p'))
	        ->limit(1)
	        ->findAll()
	        ->getData();
	        if (count($arr) != 1)
	        {
	            $access = false;
	        }
	    }
	    if($access == true)
	    {
	        $get = $this->_get->raw();
	        $arr = pjAppController::pjGetFeedData($get, $this->option_arr, $this->getLocaleId());
	    	if(!empty($arr))
			{
				if($get['format'] == 'csv')
				{
					$csv = new pjCSV();
					echo $csv
						->setHeader(true)
						->process($arr)
						->getData();
						
				}
				if($get['format'] == 'xml')
				{
					$xml = new pjXML();
					echo $xml
						->setEncoding('UTF-8')
						->process($arr)
						->getData();
	
				}
				if($get['format'] == 'ical')
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
					echo $ical
					->setName("Export-".time().".ics")
					->setProdID('Event Booking Calendar')
					->setSummary('summary')
					->setCName('desc')
					->setLocation('location')
					->setTimezone(pjUtil::getTimezoneName($this->option_arr['o_timezone']))
					->process($arr)
					->getData();
	
				}
			}
	    }else{
	        __('lblNoAccessToFeed');
	    }
	    exit;
	}
}
?>