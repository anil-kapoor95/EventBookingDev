<?php
$first_day_of_month = $controller->_get->toString('year') . '-01-01';
$number_of_days = date('t', strtotime($controller->_get->toString('year') . '-'. $controller->_get->toString('month') .'-01'));
$month_arr = __('months', true);
$shortmonth_arr = __('short_months', true);
$days_arr = __('days', true);
$month = ltrim($controller->_get->toString('month'), '0');
$year = $controller->_get->toInt('year');

$next_month_ts = strtotime($controller->_get->toString('year') . '-'. $controller->_get->toString('month') . '-01 +1 month');
$prev_month_ts = strtotime($controller->_get->toString('year') . '-'. $controller->_get->toString('month') . '-01 -1 month');
?>
<div class="clearfix text-center pjCalHeading pjEbcMonthNav">
	<a href="#" class="btn btn-primary btn-sm pull-left pjEbcMonthlyNav" data-month="<?php echo date('m', $prev_month_ts);?>" data-year="<?php echo date('Y', $prev_month_ts);?>"><span class="glyphicon glyphicon-chevron-left"></span></a><!-- /.col-md-3 -->

	<h2 class="pjIcCalendarCurrent"><?php echo $month_arr[$month] . ', ' . $year; ?></h2><!-- /.pjIcCalendarCurrent --><!-- /.col-md-6 -->

	<a href="#" class="btn btn-primary btn-sm pull-right pjEbcMonthlyNav" data-month="<?php echo date('m', $next_month_ts);?>" data-year="<?php echo date('Y', $next_month_ts);?>"><span class="glyphicon glyphicon-chevron-right"></span></a><!-- /.col-md-3 -->
</div><!-- /.clearfix -->

<div class="table-responsive pjCalMonths">
	<table class="table table-condensed table-bordered">
		<tr>
			<?php
			for($i = 0; $i < 13; $i++)
			{
			    if(date('Y-m', strtotime($first_day_of_month)) == $year . '-' . $controller->_get->toString('month'))
				{
					?><th class="text-center"><a href="javascript:void(0);" class="pjEBcMonthName active"><?php echo $shortmonth_arr[date('n', strtotime($first_day_of_month))];?></a></th><?php
				}else{
					?><th class="text-center"><a href="#" class="pjEBcMonthName" data-year="<?php echo date('Y', strtotime($first_day_of_month));?>" data-month="<?php echo date('m', strtotime($first_day_of_month));?>"><?php echo $shortmonth_arr[date('n', strtotime($first_day_of_month))];?></a></th><?php
				}
				$first_day_of_month = date('Y-m-d', strtotime($first_day_of_month . '+1 month'));
			} 
			?>
		</tr>
	</table>
</div>

<table class="table table-condensed table-bordered pjCalTable">
	<?php
	$day_in_month = $controller->_get->toString('year') . '-' . $controller->_get->toString('month') . '-01';
	$event_date_arr = $tpl['event_date_arr'];
	for($i = 1; $i <= $number_of_days; $i++)
	{
		if(!empty($event_date_arr[$day_in_month]))
		{
			$now = time() + ((int) $tpl['option_arr']['o_booking_before_hours'] * 60 * 60);
			$events = $event_date_arr[$day_in_month];
			$num_events = count($events);
			for($j = 0; $j < $num_events; $j++)
			{
				$event_time = '';
				if($events[$j]['o_show_start_time'] == 'T')
				{
					$event_time .= pjDateTime::formatTime(date('H:i:s', $events[$j]['event_start_ts']), 'H:i:s', $tpl['option_arr']['o_time_format']);
				}
				if($events[$j]['o_show_end_time'] == 'T')
				{
					if($event_time == '')
					{
						$event_time .= pjDateTime::formatTime(date('H:i:s', $events[$j]['event_end_ts']), 'H:i:s', $tpl['option_arr']['o_time_format']);
					}else{
						$event_time .= '<br/>' . pjDateTime::formatTime(date('H:i:s', $events[$j]['event_end_ts']), 'H:i:s', $tpl['option_arr']['o_time_format']);
					}
				}
				
				$event_title = $events[$j]['event_title'];
				
				$event_image_url = '';
				if(!empty($events[$j]['event_thumb']))
				{
					if(is_file(PJ_INSTALL_PATH . $events[$j]['event_thumb']))
					{
						$event_image_url = PJ_INSTALL_URL . $events[$j]['event_thumb'];
					}
				}
				$is_fulled = false;
				if(intval($events[$j]['total_avail']) - intval($events[$j]['total_booked']) == 0)
				{
					$is_fulled = true;
				}
				 
				if($j == 0)
				{
					?>
					<tr class="pjEbcHasEvent<?php echo $is_fulled == true ? ' pjEbcFullyBooked' : null;?>">
						<td class="day-num" rowspan="<?php echo $num_events;?>"><?php echo $i;?></td>
						<td class="day-week" rowspan="<?php echo $num_events;?>"><?php echo $days_arr[date('w', strtotime($day_in_month))];?></td>
						<td class="start-time"><?php echo $event_time; ?></td>
						<td>
							<p class="pjEbcEventTitle"><?php echo $event_title; ?></p>
							<p class="pjEbcEventAddress"><?php echo stripslashes($events[$j]['location'])?></p>
							<p class="pjEbcEventCategory">
								<?php
								if($controller->_get->check('show_categories') && $controller->_get->toInt('show_categories') == 1)
								{
									if(!empty($events[$j]['category']))
									{
										?><span><?php echo $events[$j]['category'];?></span><?php
									}
								} 
								?>
							</p>

							<div class="pjEbcEventDesc">
								<?php
								if($event_image_url != '')
								{ 
									$large_url = PJ_INSTALL_URL . $events[$j]['event_img'];
									?><a target="_blank" href="<?php echo $large_url; ?>"><img class="pjEbcEventImage" src="<?php echo $event_image_url;?>" /></a><?php
								} 
								echo nl2br(stripslashes($events[$j]['description'])); 
								?>
							</div>
							<?php
							if($now > $events[$j]['event_start_ts'])
							{
								?><span class="pjEbcEventPast"><?php __('front_label_past_event'); ?></span><?php
							}else{ 
								if(intval($events[$j]['total_avail']) == intval($events[$j]['total_booked']))
								{
									?><span class="pjEbcFullEvent"><?php __('front_label_full_event'); ?></span><?php
								}else if(intval($events[$j]['total_avail']) > intval($events[$j]['total_booked'])){
									?>
									<input type="button" class="btn btn-primary pjEbcBuyTicket" data-id="<?php echo $events[$j]['id']?>" value="<?php __('front_button_buy_ticket');?>">
									<?php
								}
							} 
							?>
							<?php 
							if($tpl['option_arr']['o_display_available_tickets'] == 'Yes')
							{ 
								?><span class="pjEbcAvailTickets"><?php echo __('front_label_available_tickets', true) . ': <span>' . ($events[$j]['total_avail'] - $events[$j]['total_booked']) . '</span>'; ?></span><?php
							} 
							?>
						</td>
					</tr>
					<?php
				}else{
					?>
					<tr class="pjEbcHasEvent<?php echo $is_fulled == true ? ' pjEbcFullyBooked' : null;?>">
						<td class="start-time"><?php echo $event_time; ?></td>
						<td>
							<p class="pjEbcEventTitle"><?php echo $event_title; ?></p>
							<p class="pjEbcEventAddress"><?php echo stripslashes($events[$j]['location'])?></p>
							<p class="pjEbcEventCategory">
								<?php
								if($controller->_get->check('show_categories') && $controller->_get->toInt('show_categories') == 1)
								{
									if(!empty($events[$j]['category']))
									{
										?><span><?php echo $events[$j]['category'];?></span><?php
									}
								} 
								?>
							</p>

							<div class="pjEbcEventDesc">
								<?php
								if($event_image_url != '')
								{ 
									$large_url = PJ_INSTALL_URL . $events[$j]['event_img'];
									?><a target="_blank" href="<?php echo $large_url; ?>"><img class="pjEbcEventImage" src="<?php echo $event_image_url;?>" /></a><?php
								} 
								echo nl2br(stripslashes($events[$j]['description'])); 
								?>
							</div>
							<?php
							if($now > $events[$j]['event_start_ts'])
							{
								?><span class="pjEbcEventPast"><?php __('front_label_past_event'); ?></span><?php
							}else{ 
								if(intval($events[$j]['total_avail']) == intval($events[$j]['total_booked']))
								{
									?><span class="pjEbcFullEvent"><?php __('front_label_full_event'); ?></span><?php
								}else if(intval($events[$j]['total_avail']) > intval($events[$j]['total_booked'])){
									?>
									<input type="button" class="btn btn-primary pjEbcBuyTicket" data-id="<?php echo $events[$j]['id']?>" value="<?php __('front_button_buy_ticket');?>">
									<?php
								}
							} 
							?>
							<?php 
							if($tpl['option_arr']['o_display_available_tickets'] == 'Yes')
							{ 
								?><span class="pjEbcAvailTickets"><?php echo __('front_label_available_tickets', true) . ': <span>' . ($events[$j]['total_avail'] - $events[$j]['total_booked']) . '</span>'; ?></span><?php
							} 
							?>
						</td>
					</tr>
					<?php
				}
			}
		}else{
			?>
			<tr <?php echo $day_in_month == date('Y-m-d') ? 'class="pjPecToday"' : null; ?>>
				<td class="day-num"><?php echo $i;?></td>
				<td class="day-week"><?php echo $days_arr[date('w', strtotime($day_in_month))];?></td>
				<td class="start-time">&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<?php
		}
		$day_in_month = date('Y-m-d', strtotime($day_in_month . '+1 day'));
	} 
	?>
</table>