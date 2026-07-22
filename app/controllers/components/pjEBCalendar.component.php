<?php
class pjEBCalendar extends pjBaseCalendar
{
    private $calendarId = NULL;   
    private $weekNumbers = NULL;
    private $options = array();
	private $dayoff = array();	
	private $dateoff = array();	
	private $monthStatus = array();
	private $dates = array();
	private $cart = array();
	private $titles = array();
	private $classHasEvent = NULL;
	private $classDayoff = NULL;
	
	public function __construct()
	{
		parent::__construct();
		
		$this->classMonthPrev = "pjEbcCalendarNav";
		$this->classMonthNext = "pjEbcCalendarNav";
		$this->classCalendar = "pjEbcCalendarDate";
		
		$this->classHasEvent = "pjEbcEventCell pjEbcTooltipster";
		
		$this->classPast = "pj-calendar-day-past";
		$this->classToday = "pj-calendar-day-today pjEbcTooltipster";
		$this->classReserved = "pj-calendar-day-inactive";
		$this->classDayoff = "pj-calendar-day-inactive ";
		$this->classSelected = "pj-calendar-day-selected";
		$this->classEmpty = "pj-calendar-day-disabled";
	}
	
	public function getMonthView($month, $year)
    {
        return $this->getMonthHTML($month, $year, 1);
    }
    
	public function get($key)
	{
		if (isset($this->$key))
		{
			return $this->$key;
		}
		return FALSE;
	}
	
	public function set($key, $value)
	{
		if (in_array($key, array('calendarId', 'weekNumbers', 'options', 'dayoff', 'dateoff', 'monthStatus', 'dates', 'cart', 'titles')))
		{
			$this->$key = $value;
		}

		return $this;
	}
	
	private function getClass($status)
	{
		$class = $this->classCalendar;
	
		switch ($status)
		{
			case 'partly':
				$class = $this->classCalendar ." ". $this->classPartly;
				break;
			case 'fully':
				$class = $this->classFully;
				break;
			case 'available':
			default:
				$class = $this->classCalendar;
				break;
		}
	
		return $class;
	}
	public function onShowTooltip($timestamp)
	{
		$tooltip = '';
		
		$iso_date = date('Y-m-d', $timestamp);
		if(isset($this->dates[$iso_date]))
		{
			$events = $this->dates[$iso_date];
			$number_of_events = count($events);
			$event_title_arr = array();
			for($j = 0; $j < $number_of_events; $j++)
			{
				$start_time = pjDateTime::formatTime(date('H:i:s', $events[$j]['event_start_ts']), 'H:i:s',  $this->options['o_time_format']);
				$available_tickets = '<br/>' . $this->titles['avail_tickets'] . ': ' . (intval($events[$j]['total_avail']) - intval($events[$j]['total_booked']));
				if(intval($events[$j]['total_avail']) - intval($events[$j]['total_booked']) > 0)
				{
					$is_full = false;
				}
				if($events[$j]['o_show_start_time'] == 'T')
				{
					if($this->options['o_display_available_tickets'] == 'Yes')
					{
						$event_title_arr[] = $start_time . ' - ' . $events[$j]['event_title'] . $available_tickets;
					}else{
						$event_title_arr[] = $start_time . ' - ' . $events[$j]['event_title'];
					}
				}else{
					if($this->options['o_display_available_tickets'] == 'Yes')
					{
						$event_title_arr[] = $events[$j]['event_title'] . $available_tickets;
					}else{
						$event_title_arr[] = $events[$j]['event_title'];
					}
				}
			}
			$tooltip .= '<div class="pj-calendar-tooltip"><label>' . join("<br/>", $event_title_arr) . '</label></div>';
		}else{
			$today_timestamp = mktime(0, 0, 0, date('n'), date('j'), date('Y'));
			if($timestamp == $today_timestamp)
			{
				$tooltip .= '<div class="pj-calendar-tooltip today"><label>' . $this->titles['today'] . '</label></div>';
			}
		}
		
		return $tooltip;
	}
	public function onBeforeShow($timestamp, $iso, $today, $current, $year, $month, $d)
	{
		$class = $this->classCalendar;
		if ($timestamp < strtotime(date('Y-m-d 00:00:00', $today[0])))
		{
			$class = $this->classPast;
		}
		if(isset($this->dates[$iso]))
		{
			$class = $this->classHasEvent;
		}else{
			if ($year == $today["year"] && $month == $today["mon"] && $d == $today["mday"])
			{
				$class .= " " . $this->classToday;
			}
		}
		
		return $class;
	}
}
?>