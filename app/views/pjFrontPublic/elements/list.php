<?php
if(!empty($tpl['event_arr']))
{
	?>
	<div class="pjPecEventContainer">
		<?php
		foreach($tpl['event_arr'] as $v)
		{
			$event_date = pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'], $v['o_show_start_time'], $v['o_show_end_time']);
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
			<div class="thumbnail pjEbcEventBox">
				<br>
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
				</div>
				<br/>
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
					$now = time() + ((int) $tpl['option_arr']['o_booking_before_hours'] * 60 * 60);
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
			</div>
			<?php
		} 
		if(!$controller->_get->check('event_id'))
		{
			$page = $controller->_get->check('page') ? $controller->_get->toInt('page') : 1 ;
			$pages = $tpl['pages'];
			if($pages > 1)
			{
				?>
				<br/>
				<div class="clearfix text-center pjPecPagination">
					<?php
					if($page < $pages)
					{
						?><a href="#" class="btn btn-primary btn-sm pull-right pjEbcPage" data-page="<?php echo $page + 1;?>"><span class="glyphicon glyphicon-chevron-right"></span></a><!-- /.col-md-3 --><?php
					}
					if($page > 1)
					{
						?><a href="#" class="btn btn-primary btn-sm pull-left pjEbcPage" data-page="<?php echo $page - 1;?>"><span class="glyphicon glyphicon-chevron-left"></span></a><!-- /.col-md-3 -->
					<?php
					}
					?>			
				</div><!-- /.clearfix -->
				<?php
			}
		}
		?>
	</div>
	<?php
}else{
	?><div class="pjPecEventContainer"><?php __('front_no_event');?></div><?php
}
?>