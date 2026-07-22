<?php 
if (isset($tpl['status']) && $tpl['status'] == 'IP_BLOCKED') {
	?>
	<h4 class="text-danger text-center"><?php __('front_ip_address_blocked');?></h4>
	<?php 
} else { ?>
	<div id="pjEbcEventCalendar_<?php echo $controller->_get->toString('index');?>">
		<div id="pjEbcTableCalendar_<?php echo $controller->_get->toString('index'); ?>" class="pjIcContainer">
			<div class="pjIcCalendar">
				<header class="pjIcCalendarHead clearfix text-center">
					<?php
					if($tpl['option_arr']['o_display_events'] == 'replace')
					{ 
						?>
						<div class="pull-left">
							<a href="#" class="pjEbcBackToCalendar" data-view="<?php echo $controller->_get->toString('view');?>"><span class="glyphicon glyphicon-chevron-left"></span> <?php __('front_back_to_calendar');?></a>
						</div><!-- /.pull-left -->
						<?php
					}
					if($tpl['option_arr']['o_display_events'] == 'below')
					{ 
						?>
						<div class="pull-right">
							<a href="#" class="pull-right btn btn-primary pjEbcCloseEvent" data-view="<?php echo $controller->_get->toString('view');?>"><span class="glyphicon glyphicon-remove"></span></a>
						</div><!-- /.pull-left -->
						<?php
					} 
					?>
				</header><!-- /.pjIcCalendarHead -->
			</div>
		</div>
		<div class="pjPecEventContainer">
			<?php
			$index = $controller->_get->toString('index');
			foreach($tpl['event_arr'] as $k => $v)
			{
				$event_title = '';
				if($v['o_show_start_time'] == 'T')
				{
					$event_title = pjDateTime::formatTime(date('H:i:s', $v['event_start_ts']), 'H:i:s', $tpl['option_arr']['o_time_format']) . ', ' . $v['title'];
				}else{
					$event_title = $v['title'];
				}
				$event_date = pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'], $v['o_show_start_time'], $v['o_show_end_time']);
				$now = time() + ((int) $tpl['option_arr']['o_booking_before_hours'] * 60 * 60);
				$event_image_url = '';
				if(!empty($v['event_thumb']))
				{
					if(is_file(PJ_INSTALL_PATH . $v['event_thumb']))
					{
						$event_image_url = PJ_INSTALL_URL . $v['event_thumb'];
					}
				}
				$is_fulled = false;
				if(intval($v['total_avail']) - intval($v['total_booked']) == 0)
				{
					$is_fulled = true;
				}
				?>
				<div id="pjEbcEventBox_<?php echo $index; ?>_<?php echo $v['id']?>" class="thumbnail">
					<br/>
					<div class="container-fluid">
						<p class="pjEbcEventDate"><?php echo $event_date;?></p>
						<p class="pjEbcEventTitle"><?php echo pjSanitize::html($v['title']);?></p>
						<p class="pjEbcEventAddress"><?php echo stripslashes($v['event_location'])?></p>
						<p class="pjEbcEventCategory">
							<?php
							if($controller->_get->check('show_categories') && $controller->_get->toInt('show_categories') == 1)
							{
								echo $v['category'];
							}
							?>
						</p>
					</div><!-- /.container-fluid -->
					<br />
					<div class="container-fluid">
						<div class="pjEbcEventDesc">
							<?php
							if($event_image_url != '')
							{
								$large_url = PJ_INSTALL_URL . $v['event_img'];
								?><a target="_blank" href="<?php echo $large_url; ?>"><img src="<?php echo $event_image_url;?>" /></a><?php
							} 
							echo nl2br(stripslashes($v['event_description']));
							?>
						</div>
					</div>
					<br/>
					<div class="container-fluid">
						<?php
						if($now > $v['event_start_ts'])
						{
							?><span class="pjEbcEventPast"><?php __('front_label_past_event'); ?></span><?php
						}else{ 
							if(intval($v['total_avail']) == intval($v['total_booked']))
							{
								?><span class="pjEbcFullEvent"><?php __('front_label_full_event'); ?></span><?php
							}else if(intval($v['total_avail']) > intval($v['total_booked'])){
								?>
								<input type="button" class="btn btn-primary pjEbcBuyTicket" data-id="<?php echo $v['id']?>" value="<?php __('front_button_buy_ticket');?>">
								<?php
							}
						} 
						?>
						<?php 
						if($tpl['option_arr']['o_display_available_tickets'] == 'Yes')
						{ 
							?><span class="pjEbcAvailTickets"><?php echo __('front_label_available_tickets', true) . ': <span>' . ($v['total_avail'] - $v['total_booked']) . '</span>'; ?></span><?php
						} 
						?>
					</div>
					<?php ?>
				</div>
				<?php
			} 
			?>
		</div>
	</div>
<?php } ?>