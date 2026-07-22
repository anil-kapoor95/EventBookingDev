<?php 
$booking_statuses = __('booking_statuses', true);
$map_statuses = array(
	'confirmed' => 'badge-success',
	'pending' => 'bg-pending',
	'cancelled' => 'bg-cancelled'
);
?>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
		<div class="col-lg-4 col-sm-6">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<span class="label label-primary pull-right"><?php __('dash_today');?></span>
					<h5><?php __('dash_new_bookings');?></h5>
				</div>
				<div class="ibox-content ibox-content-stats">
					<div class="row">
						<div class="col-lg-3 col-xs-5">
							<p class="h1 no-margins">
								<a href="#"><?php echo (int) @$tpl['cnt_bookings_today'];?></a>
							</p>
						</div>
						<div class="col-lg-9 col-xs-7 text-right">
							<p class="h1 no-margins">
								<?php echo pjCurrency::formatPrice($tpl['total_amount_today']);?>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-lg-4 col-sm-6">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<span class="label label-primary pull-right"><?php __('dash_this_month');?></span>
					<h5><?php __('dash_total_bookings');?></h5>
				</div>
				<div class="ibox-content ibox-content-stats">
					<div class="row">
						<div class="col-lg-3 col-xs-5">
							<p class="h1 no-margins">
								<a href="#"><?php echo $tpl['cnt_bookings_this_month'];?></a>
							</p>
						</div>
						<div class="col-lg-9 col-xs-7 text-right">
							<p class="h1 no-margins">
								<?php echo pjCurrency::formatPrice($tpl['total_amount_this_month']);?>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-lg-2 col-xs-6">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5><?php __('lblDashUsers');?></h5>
				</div>
				<div class="ibox-content ibox-content-stats">
					<p class="h1 no-margins">
						<a href="#"><?php echo (int)$tpl['cnt_users'];?></a>
					</p>
				</div>
			</div>
		</div>

		<div class="col-lg-2 col-xs-6">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5><?php __('lblDashEvents');?></h5>
				</div>
				<div class="ibox-content ibox-content-stats">
					<p class="h1 no-margins">
						<a href="#"><?php echo (int)$tpl['cnt_events'];?></a>
					</p>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-8 col-sm-12">
			<div class="ibox float-e-margins">
				<div class="ibox-content ibox-heading clearfix">
					<div class="pull-left">
						<h3><?php __('dash_latest_bookings');?></h3>
						<small><?php __('dash_total');?> <strong><?php echo $tpl['total_bookings'];?></strong> <?php $tpl['total_bookings'] != 1 ? __('dash_bookings_made') : __('dash_booking_made');?></small>
					</div>
					<?php if (pjAuth::factory('pjAdminBookings', 'pjActionIndex')->hasAccess()) { ?>
					<div class="pull-right m-t-md">
						<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex" class="btn btn-primary btn-sm btn-outline m-n"><?php __('dash_view_all_bookings');?></a>
					</div>
					<?php } ?>
				</div>

				<div class="ibox-content">
					<div class="table-responsive table-responsive-secondary">
						<table id="lastest_bookings" class="table table-striped table-hover no-margins">
							<thead>
								<tr>
									<th><?php __('dash_event_date');?></th>
									<th><?php __('dash_client');?></th>
									<th><?php __('dash_tickets');?></th>
									<th><?php __('dash_status');?></th>
									<th><?php __('dash_price');?></th>
								</tr>
							</thead>

							<tbody>
								<?php
                            	if(!empty($tpl['latest_bookings']))
                            	{
                                	foreach($tpl['latest_bookings'] as $v)
                                	{
                                	    $icon_status = '';
                                	    $badge_status = '';
                                	    switch ($v['booking_status']) {
                                	        case 'confirmed':
                                	            $badge_status = ' bg-confirmed';
                                	            $icon_status = ' fa-check';
                                	            break;
                                	            
                                	        case 'pending':
                                	            $badge_status = ' bg-pending';
                                	            $icon_status = ' fa-exclamation-triangle';
                                	            break;
                                	        case 'cancelled':
                                	            $badge_status = ' bg-canceled';
                                	            $icon_status = ' fa-times';
                                	            break;
                                	    }
                                	    $url_update_booking = 'javascript:void(0);';
                                	    if (pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess()) {
                                	    	$url_update_booking = $_SERVER['PHP_SELF'].'?controller=pjAdminBookings&action=pjActionUpdate&id='.$v['id'];
                                	    }
                                    	?>
                                        <tr>
                                            <td><a href="<?php echo $url_update_booking; ?>"><?php echo pjSanitize::html($v['event_title']).'<br/>'.pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'],$v['o_show_start_time'], $v['o_show_end_time']);?></a></td>
                                            <td><?php echo pjSanitize::html($v['customer_name']);?><br/><?php echo pjSanitize::html($v['customer_email']);?></td>
                                            <td><?php echo (int)$v['customer_people'];?></td>
                                            <td><div class="btn<?php echo $badge_status;?> btn-xs no-margin"><i class="fa<?php echo $icon_status;?>"></i> <?php echo $booking_statuses[$v['booking_status']];?></div></td>
                                            <td><?php echo pjCurrency::formatPrice($v['booking_total']);?></td>
                                        </tr>
                                        <?php
                                	}
                            	}else{
                            	    ?>
                            	    <tr>
                            	    	<td colspan="5"><?php __('dash_no_bookings_found');?></td>
                            	    </tr>
                            	    <?php
                            	}
                                ?>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="col-md-4 col-sm-12">
			<div class="ibox float-e-margins">
				<div class="ibox-content ibox-heading clearfix">
					<div class="pull-left">
						<h3><?php __('lblUpcomingEvents');?></h3>
					</div>
				</div>

				<div class="ibox-content">
					<div>
						<?php if ($tpl['upcoming_events']) { ?>
							<?php foreach ($tpl['upcoming_events'] as $k => $v) { 
								$url_update_event = 'javascript:void(0);';
                                if (pjAuth::factory('pjAdminEvents', 'pjActionUpdate')->hasAccess()) {
                                	$url_update_event = $_SERVER['PHP_SELF'].'?controller=pjAdminEvents&action=pjActionUpdate&id='.$v['id'];
                                }
								?>
								<a href="<?php echo $url_update_event;?>">
									<strong class="block"><?php echo pjSanitize::html($v['title']);?></strong>
									<small class="block"><?php echo pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'],$v['o_show_start_time'], $v['o_show_end_time']);?></small>
									<?php if (!empty($v['location'])) { ?>
										<small class="block"><?php echo pjSanitize::html($v['location']);?></small>
									<?php } ?>
								</a>
								<?php if ($k < count($tpl['upcoming_events']) - 1) { ?>
									<hr/>
								<?php } ?>
							<?php } ?>
						<?php } else { ?>
							<?php __('dash_no_events_found');?>
						<?php } ?>
					</div>
				</div>
			</div>
		</div>
	</div>
</div><!-- /.wrapper wrapper-content -->