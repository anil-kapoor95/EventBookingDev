<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjUtil extends pjToolkit
{
	static public function dateDiff($interval, $date_from, $date_to, $using_timestamps = false) {
	    
	    if (!$using_timestamps) {
	        $date_from = strtotime($date_from, 0);
	        $date_to = strtotime($date_to, 0);
	    }
	    $difference = $date_to - $date_from;
	     
	    switch($interval) {
	     
		    case 'yyyy':
		
		        $years_difference = floor($difference / 31536000);
		        if (mktime(date("H", $date_from), date("i", $date_from), date("s", $date_from), date("n", $date_from), date("j", $date_from), date("Y", $date_from)+$years_difference) > $date_to) {
		            $years_difference--;
		        }
		        if (mktime(date("H", $date_to), date("i", $date_to), date("s", $date_to), date("n", $date_to), date("j", $date_to), date("Y", $date_to)-($years_difference+1)) > $date_from) {
		            $years_difference++;
		        }
		        $date_difference = $years_difference;
		        break;
		
		    case "q":
		
		        $quarters_difference = floor($difference / 8035200);
		        while (mktime(date("H", $date_from), date("i", $date_from), date("s", $date_from), date("n", $date_from)+($quarters_difference*3), date("j", $date_to), date("Y", $date_from)) < $date_to) {
		            $quarters_difference++;
		        }
		        $quarters_difference--;
		        $date_difference = $quarters_difference;
		        break;
		
		    case "m":
		
		        $months_difference = floor($difference / 2678400);
				while (mktime(date("H", $date_from), date("i", $date_from), date("s", $date_from), date("n", $date_from)+($months_difference), date("j", $date_from), date("Y", $date_from)) < $date_to)
					$months_difference++;
				
				$date_difference = $months_difference;
				break;
		
		    case 'y':
		
		        $date_difference = date("z", $date_to) - date("z", $date_from);
		        break;
		
		    case "d":
		
		        $date_difference = floor($difference / 86400);
		        break;
		
		    case "w":
		
		        $days_difference = floor($difference / 86400);
		        $weeks_difference = floor($days_difference / 7);
		        $first_day = date("w", $date_from);
		        $days_remainder = floor($days_difference % 7);
		        $odd_days = $first_day + $days_remainder;
		        if ($odd_days > 7) { 
		            $days_remainder--;
		        }
		        if ($odd_days > 6) { 
		            $days_remainder--;
		        }
		        $date_difference = ($weeks_difference * 5) + $days_remainder;
		        break;
		
		    case "ww":
		
		        $date_difference = floor($difference / 604800);
		        break;
		
		    case "h": 
		
		        $date_difference = floor($difference / 3600);
		        break;
		
		    case "n": 
		
		        $date_difference = floor($difference / 60);
		        break;
		
		    default:
		
		        $date_difference = $difference;
		        break;
	    }    
	
	    return $date_difference;
	
	}
	
	static public function getEventDateTime($start, $end, $date_format, $time_format, $o_show_start = 'T', $o_show_end = 'T')
	{
		$start_date = pjDateTime::formatDate(date('Y-m-d', $start), 'Y-m-d', $date_format);
		$start_time = pjDateTime::formatTime(date('H:i:s', $start), 'H:i:s', $time_format);
		$end_date = pjDateTime::formatDate(date('Y-m-d', $end), 'Y-m-d', $date_format);
		$end_time = pjDateTime::formatTime(date('H:i:s', $end), 'H:i:s', $time_format);
		
		$event_date = '';
		
		if($start_date == $end_date)
		{
			if($o_show_start == 'T' && $o_show_end == 'T')
			{
				$event_date = $start_date . ' ' . __('front_label_from', true) . ' ' . $start_time . ' ' . __('front_label_till', true) . ' ' . $end_time;
			}else if($o_show_start == 'T' && $o_show_end == 'F'){
				$event_date = $start_date . ' ' . $start_time ;
			}else if($o_show_start == 'F' && $o_show_end == 'T'){
				$event_date = $start_date . ' ' . $end_time;
			}else if($o_show_start == 'F' && $o_show_end == 'F'){
				$event_date = $start_date;
			}
		}else{
			if($o_show_start == 'T' && $o_show_end == 'T')
			{
				$event_date = __('front_label_from', true) . ' ' . $start_date . ' ' . $start_time . ' ' . __('front_label_till', true) . ' ' . $end_date . ' ' . $end_time;
			}else if($o_show_start == 'T' && $o_show_end == 'F'){
				$event_date = __('front_label_from', true) . ' ' . $start_date . ' ' . $start_time . ' ' . __('front_label_till', true) . ' ' . $end_date ;
			}else if($o_show_start == 'F' && $o_show_end == 'T'){
				$event_date = __('front_label_from', true) . ' ' . $start_date . ' ' . __('front_label_till', true) . ' ' . $end_date . ' ' . $end_time;
			}else if($o_show_start == 'F' && $o_show_end == 'F'){
				$event_date = __('front_label_from', true) . ' ' . $start_date . ' ' . __('front_label_till', true) . ' ' . $end_date ;
			}
		}
		
		return $event_date;
	}
	
	static public function getEventDateTimeNOL($start, $end, $date_format, $time_format, $o_show_start = 'T', $o_show_end = 'T')
	{
		$start_date = pjDateTime::formatDate(date('Y-m-d', $start), 'Y-m-d', $date_format);
		$start_time = pjDateTime::formatTime(date('H:i:s', $start), 'H:i:s', $time_format);
		$end_date = pjDateTime::formatDate(date('Y-m-d', $end), 'Y-m-d', $date_format);
		$end_time = pjDateTime::formatTime(date('H:i:s', $end), 'H:i:s', $time_format);
		
		$event_date = '';
		
		if($start_date == $end_date)
		{
			if($o_show_start == 'T' && $o_show_end == 'T')
			{
				$event_date = $start_date . '<br/>' . __('front_label_from', true) . ' ' . $start_time . ' ' . __('front_label_till', true) . ' ' . $end_time;
			}else if($o_show_start == 'T' && $o_show_end == 'F'){
				$event_date = $start_date . ' ' . $start_time ;
			}else if($o_show_start == 'F' && $o_show_end == 'T'){
				$event_date = $start_date . ' ' . $end_time;
			}else if($o_show_start == 'F' && $o_show_end == 'F'){
				$event_date = $start_date;
			}
		}else{
			if($o_show_start == 'T' && $o_show_end == 'T')
			{
				$event_date = __('front_label_from', true) . ' ' . $start_date . ' ' . $start_time . '<br/>' . __('front_label_till', true) . ' ' . $end_date . ' ' . $end_time;
			}else if($o_show_start == 'T' && $o_show_end == 'F'){
				$event_date = __('front_label_from', true) . ' ' . $start_date . ' ' . $start_time . '<br/>' . __('front_label_till', true) . ' ' . $end_date ;
			}else if($o_show_start == 'F' && $o_show_end == 'T'){
				$event_date = __('front_label_from', true) . ' ' . $start_date . '<br/>' . __('front_label_till', true) . ' ' . $end_date . ' ' . $end_time;
			}else if($o_show_start == 'F' && $o_show_end == 'F'){
				$event_date = __('front_label_from', true) . ' ' . $start_date . '<br/>' . __('front_label_till', true) . ' ' . $end_date ;
			}
		}
		
		return $event_date;
	}
	
	static public function getUniqueID()
	{
		return chr(rand(65,90)) . chr(rand(65,90)) . time();
	}
	
	static public function ordinalDate($recurring_ordinal, $day_of_week, $month_year)    
	{
	    $first_date = date("j", strtotime($day_of_week . " " . $month_year) );
	    if ($recurring_ordinal == "first")
	    {
	    	$computed = $first_date;
	    } else if ($recurring_ordinal == "second"){
	    	$computed = $first_date + 7;
	    }elseif ($recurring_ordinal == "third"){
	    	$computed = $first_date + 14; 
	    }elseif ($recurring_ordinal == "fourth"){
	    	$computed = $first_date + 21; 
	    }elseif ($recurring_ordinal == "last"){
		    if ( ($first_date + 28) <= date("t", strtotime($month_year)) )
		    {
		        $computed = $first_date + 28; 
		    }else{
		        $computed = $first_date + 21;
		    } 
		}
	    return date("Y-m-d", strtotime($computed . " " . $month_year) );
	}
	
	static public function formatTime($time, $inputFormat, $outputFormat = "H:i:s")
	{
		$limiters = array(':');
		foreach ($limiters as $limiter)
		{
			if (strpos($inputFormat, $limiter) !== false)
			{
				$_time = explode($limiter, $time);
				if (strpos($_time[1], " ") !== false)
				{
					list($_time[1], $_time[2]) = explode(" ", $_time[1]);
				}
				$_iFormat = explode($limiter, $inputFormat);
				if (strpos($_iFormat[1], " ") !== false)
				{
					list($_iFormat[1], $_iFormat[2]) = explode(" ", $_iFormat[1]);
				}
				$_iFormat = array_flip($_iFormat);
				break;
			}
		}

		$h = $_time[isset($_iFormat['G']) ? $_iFormat['G'] : (isset($_iFormat['g']) ? $_iFormat['g'] : (isset($_iFormat['H']) ? $_iFormat['H'] : $_iFormat['h']))];
		$sec = 0;
		if (isset($_iFormat['a']))
		{
			if ($_time[$_iFormat['a']] == 'pm')
			{
				$sec = 60 * 60 * 12;
				if ((int) $h === 12)
				{
					$sec = 0;
				}
			} elseif ($_time[$_iFormat['a']] == 'am') {
				if ((int) $h === 12)
				{
					$sec = 60 * 60 * 12;
				}
			}
		} elseif (isset($_iFormat['A'])) {
			if ($_time[$_iFormat['A']] == 'PM')
			{
				$sec = 60 * 60 * 12;
				if ((int) $h === 12)
				{
					$sec = 0;
				}
			} elseif ($_time[$_iFormat['A']] == 'AM') {
				if ((int) $h === 12)
				{
					$sec = 60 * 60 * 12;
				}
			}
		}

		return date($outputFormat, mktime(
			$_time[isset($_iFormat['G']) ? $_iFormat['G'] : (isset($_iFormat['g']) ? $_iFormat['g'] : (isset($_iFormat['H']) ? $_iFormat['H'] : $_iFormat['h']))],
			$_time[$_iFormat['i']],
			$sec,
			0, 0, 0
		));
	}
	
	static public function getWherePeriod($period)
	{
		$where = '';
		
		switch ($period) {
			case 'today':
				$firstDay = mktime(0, 0, 0, (int)date('m'), (int)date('d'), (int)date('Y'));
				$lastDay = mktime(23, 59, 59, (int)date('m'), (int)date('d'), (int)date('Y'));
			break;
			case 'tomorrow':
				$firstDay = mktime(0, 0, 0, (int)date('m'), (int)date('d')+ 1, (int)date('Y'));
				$lastDay = mktime(23, 59, 59, (int)date('m'), (int)date('d')+ 1, (int)date('Y'));
			break;
			case 'weekend':
				$firstDay = mktime(0, 0, 0, (int)date("m", strtotime('next Saturday')), (int)date("d", strtotime('next Saturday')), date("Y", strtotime('next Saturday')));
				$lastDay = mktime(23, 59, 59, (int)date("m", strtotime('next Sunday')), (int)date("d", strtotime('next Sunday')), date("Y", strtotime('next Sunday')));
			break;
			case 'next7days':
				$firstDay = mktime(0, 0, 0, (int)date('m'), (int)date('d') + 1, (int)date('Y'));
				$lastDay = mktime(23, 59, 59, (int)date('m'), (int)date('d') + 8, (int)date('Y'));
			break;
			case 'next30days':
				$firstDay = mktime(0, 0, 0, (int)date('m'), (int)date('d') + 1, (int)date('Y'));
				$lastDay = mktime(23, 59, 59, (int)date('m'), (int)date('d') + 31, (int)date('Y'));
			break;
			default:
				$firstDay = '';
				$lastDay = '';
			break;
		}
		
		if($firstDay != '' && $lastDay != ''){
			$where = "(t1.event_start_ts BETWEEN $firstDay AND $lastDay OR t1.event_end_ts BETWEEN $firstDay AND $lastDay OR (t1.event_start_ts < $firstDay AND t1.event_end_ts > $lastDay))";
		}
		return $where;
	}
	
	static public function truncateDescription($string, $limit, $break=".", $pad="..."){
		if(strlen($string) <= $limit) 
			return $string;  
		if(false !== ($breakpoint = strpos($string, $break, $limit))) 
		{ 
			if($breakpoint < strlen($string) - 1) 
			{ 
				$string = substr($string, 0, $breakpoint) . $pad; 
			} 
		} 
		return $string;
	}
	
	static public function getPostMaxSize()
	{
		$post_max_size = ini_get('post_max_size');
		switch (substr($post_max_size, -1))
		{
			case 'G':
				$post_max_size = (int) $post_max_size * 1024 * 1024 * 1024;
				break;
			case 'M':
				$post_max_size = (int) $post_max_size * 1024 * 1024;
				break;
			case 'K':
				$post_max_size = (int) $post_max_size * 1024;
				break;
		}
		return $post_max_size;
	}
	static public function convertDateTime($date_time, $date_format, $time_format)
	{
		if(count(explode(" ", $date_time)) == 3)
		{
			list($_date, $_time, $_period) = explode(" ", $date_time);
			$iso_time = pjDateTime::formatTime($_time . ' ' . $_period, $time_format);
		}else{
			list($_date, $_time) = explode(" ", $date_time);
			$iso_time = pjDateTime::formatTime($_time, $time_format);
		}
		$iso_date = pjDateTime::formatDate($_date, $date_format);
		$iso_date_time = $iso_date . ' ' . $iso_time;
		$ts = strtotime($iso_date_time);
	
		return compact('iso_date', 'iso_time', 'iso_date_time', 'ts');
	}
	static public function getWeekRange($date, $week_start)
	{
		$week_arr = array(
				0=>'sunday',
				1=>'monday',
				2=>'tuesday',
				3=>'wednesday',
				4=>'thursday',
				5=>'friday',
				6=>'saturday');
			
		$ts = strtotime($date);
		$start = (date('w', $ts) == 0) ? $ts : strtotime('last ' . $week_arr[$week_start], $ts);
		$week_start = ($week_start == 0 ? 6 : $week_start -1);
		return array(date('Y-m-d', $start), date('Y-m-d', strtotime('next ' . $week_arr[$week_start], $start)));
	}
		
	static public function getMadeWhere($period, $week_start)
	{
		$where_str = '';
		switch ($period) {
			case 1:
				$where_str = "(DATE(t1.created) = CURDATE() OR DATE(t1.modified) = CURDATE())";
				break;
				;
			case 2:
				$where_str = "(DATE(t1.created) = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY)) OR DATE(t1.modified) = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY)))";
				break;
				;
			case 3:
				list($start_week, $end_week) = pjUtil::getWeekRange(date('Y-m-d'), $week_start);
				$where_str = "((DATE(t1.created) BETWEEN '$start_week' AND '$end_week') OR (DATE(t1.modified) BETWEEN '$start_week' AND '$end_week'))";
				break;
				;
			case 4:
				list($start_week, $end_week) = pjUtil::getWeekRange(date('Y-m-d', strtotime("-7 days")), $week_start);
				$where_str = "((DATE(t1.created) BETWEEN '$start_week' AND '$end_week') OR (DATE(t1.modified) BETWEEN '$start_week' AND '$end_week'))";
				break;
				;
			case 5:
				$start_month = date('Y-m-01',strtotime('this month'));
				$end_month = date('Y-m-t',strtotime('this month'));
				$where_str = "((DATE(t1.created) BETWEEN '$start_month' AND '$end_month') OR (DATE(t1.modified) BETWEEN '$start_month' AND '$end_month'))";
				break;
				;
			case 6:
				$start_month = date("Y-m-d", mktime(0, 0, 0, date("m")-1, 1, date("Y")));
				$end_month = date("Y-m-d", mktime(0, 0, 0, date("m"), 0, date("Y")));
				$where_str = "((DATE(t1.created) BETWEEN '$start_month' AND '$end_month') OR (DATE(t1.modified) BETWEEN '$start_month' AND '$end_month'))";
				break;
				;
		}
		return $where_str;
	}
	
	static public function getTimezoneName($timezone)
	{
		$offset = $timezone / 3600;
		$timezone_name = timezone_name_from_abbr(null, $offset * 3600, true);
		if($timezone_name === false)
		{
			$timezone_name = timezone_name_from_abbr(null, $offset * 3600, false);
		}
		if($offset == -12)
		{
			$timezone_name = 'Pacific/Wake';
		}
		return $timezone_name;
	}
	
	public static function getWeekdays(){
		$arr = array();
		$arr[] = 'monday';
		$arr[] = 'tuesday';
		$arr[] = 'wednesday';
		$arr[] = 'thursday';
		$arr[] = 'friday';
		$arr[] = 'saturday';
		$arr[] = 'sunday';
		return $arr;
	}
	public static function toMomemtJS($format)
	{
	    return str_replace(
	        array('Y', 'm', 'n', 'd', 'j'),
	        array('YYYY', 'MM', 'M', 'DD', 'D'),
	        $format);
	}
	public static function toBootstrapDate($format)
	{
	    return str_replace(
	        array('Y', 'm', 'n', 'd', 'j'),
	        array('yyyy', 'mm', 'm', 'dd', 'd'),
	        $format);
	}
	public static function getTitles(){
		$arr = array();
		$arr[] = 'mr';
		$arr[] = 'mrs';
		$arr[] = 'ms';
		$arr[] = 'dr';
		$arr[] = 'prof';
		$arr[] = 'rev';
		$arr[] = 'other';
		return $arr;
	}
	
	public static function sortArrayByArray(Array $array, Array $orderArray)
	{
	    $ordered = array();
	    foreach($orderArray as $key)
	    {
	        if(array_key_exists($key,$array))
	        {
	            $ordered[$key] = $array[$key];
	            unset($array[$key]);
	        }
	    }
	    return $ordered + $array;
	}
	
	static public function textToHtml($content)
	{
		return '<html><head><title></title></head><body>'.stripslashes($content).'</body></html>';
	}
}
?>