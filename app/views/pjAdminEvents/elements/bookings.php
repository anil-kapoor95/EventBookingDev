<div id="bookings" class="tab-pane<?php echo $active_tab == 'bookings' ? ' active' : NULL;?>">
    <div class="panel-body">
		<div class="panel-body-inner">
			<div class="ibox-content ibox-heading">
				<h3><?php __('infoBookingsTitle'); ?></h3>
				<small><?php __('infoBookingsBody');?></small>
			</div>
						
			<p class="lead m-b-xs">
				<?php __('lblCurrentDateTime');?>: <span class="font-bold"><?php echo pjDateTime::formatDate(date('Y-m-d'), 'Y-m-d', $tpl['option_arr']['o_date_format']) . ' ' . pjDateTime::formatTime(date('H:i:s'), 'H:i:s', $tpl['option_arr']['o_time_format']);?></span>
			</p>
			<p class="lead m-b-xs">
				<?php __('lblTotalBookings');?>: <span class="font-bold"><?php echo count($tpl['booking_arr']);?></span>
			</p>
			<p class="lead m-b-xs">
				<?php __('lblTotalTickets');?>: <span class="font-bold"><?php echo $tpl['total_tickets'];?></span>
			</p>
			<?php if(isset($tpl['print_file'])) { ?>
			<p class="lead m-b-xs">
				<a target="_blank" href="<?php echo $tpl['print_file'];?>" class="btn btn-primary" title="<?php __('btnPrint'); ?>"><i class="fa fa-print" aria-hidden="true"></i> <?php __('btnPrint'); ?></a>
			</p>
			<?php } ?>
			<div class="hr-line-dashed"> </div> 
			
			<div class="ibox float-e-margins">
            	<div class="ibox-content no-margins no-padding no-top-border">
            		<div class="row m-b-md">
						<div class="col-sm-3">
							<?php
							if($tpl['has_create_booking'])
							{
								?>
								<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate&amp;event_id=<?php echo $tpl['arr']['id']; ?>" class="btn btn-primary"><i class="fa fa-plus"></i> <?php __('btnAddBooking'); ?></a>
								<?php
							}
							?>
						</div><!-- /.col-md-6 -->
					
						<div class="col-md-5 col-sm-8">
							<div class="input-group">
								<input type="text" name="q" id="search_event_bookings" placeholder="<?php __('plugin_base_btn_search', false, true); ?>" class="form-control">
					
								<div class="input-group-btn">
									<button class="btn btn-primary pjBtnFilterEventBookings" type="button">
										<i class="fa fa-search"></i>
									</button>
								</div>
							</div>
						</div><!-- /.col-md-3 -->
					
						<div class="col-lg-2 col-lg-offset-2 col-md-12 text-right">
							<select id="filter_status" name="filter_status" class="form-control">
								<option value="">-- <?php __('lblAll');?> --</option>
								<option value="confirmed"><?php echo $bs['confirmed'];?></option>
								<option value="pending"><?php echo $bs['pending'];?></option>
								<option value="cancelled"><?php echo $bs['cancelled'];?></option>
							</select>
						</div><!-- /.col-md-6 -->
					</div><!-- /.row -->
					<div id="grid_bookings"></div>
				</div>
			</div>
			
		</div>
	</div>
</div>