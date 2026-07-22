<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);
$bs = __('booking_statuses', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-10">
                <h2><?php __('infoBookingsListTitle')?></h2>
            </div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php __('infoBookingsListDesc')?></p>
    </div><!-- /.col-md-12 -->
</div>
<div class="row wrapper wrapper-content animated fadeInRight">
	<div class="col-lg-12">
	    <?php
		$error_code = $controller->_get->toString('err');
		if (!empty($error_code))
		{
			switch (true)
			{
				case in_array($error_code, array('AR01', 'AR03')):
					?>
					<div class="alert alert-success">
						<i class="fa fa-check m-r-xs"></i>
						<strong><?php echo @$titles[$error_code]; ?></strong>
						<?php echo @$bodies[$error_code];?>
					</div>
					<?php 
					break;
				case in_array($error_code, array('AR02', 'AR04', 'AR08', 'AR09', 'AR10')):	
					?>
					<div class="alert alert-danger">
						<i class="fa fa-exclamation-triangle m-r-xs"></i>
						<strong><?php echo @$titles[$error_code]; ?></strong>
						<?php echo @$bodies[$error_code];?>
					</div>
					<?php
					break;
			}
		} 
		?>
		<div id="datePickerOptions" style="display:none;" data-wstart="<?php echo (int) $tpl['option_arr']['o_week_start']; ?>" data-format="<?php echo pjUtil::toBootstrapDate($tpl['option_arr']['o_date_format']); ?>" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>"></div>
		<div class="ibox float-e-margins">
			<div class="ibox-content">
				<form method="get" class="frm-filter">
					<div class="row m-b-md">
						<div class="col-sm-3">
							<?php
							if(pjAuth::factory('pjAdminBookings', 'pjActionCreate')->hasAccess())
							{
								?>
								<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate" class="btn btn-primary"><i class="fa fa-plus"></i> <?php __('btnAddBooking'); ?></a>
								<?php
							}
							?>
						</div><!-- /.col-md-6 -->
			
						<div class="col-md-3 col-sm-5">
							<div class="input-group">
								<input type="text" name="q" placeholder="<?php __('plugin_base_btn_search', false, true); ?>" class="form-control">
			
								<div class="input-group-btn">
									<button class="btn btn-primary" type="submit">
										<i class="fa fa-search"></i>
									</button>
								</div>
							</div>
						</div><!-- /.col-md-3 -->
			
						<div class="col-lg-2 col-md-3 col-sm-4">
							<a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" class="btn btn-primary btn-outline btn-advance-search"><?php __('btnAdvancedSearch'); ?></a>
						</div><!-- /.col-md-2 -->
			
						<div class="col-lg-2 col-lg-offset-2 col-md-12 text-right">
							<select id="filter_status" name="booking_status" class="form-control">
								<option value="">-- <?php __('lblAll');?> --</option>
								<option value="confirmed"><?php echo $bs['confirmed'];?></option>
								<option value="pending"><?php echo $bs['pending'];?></option>
								<option value="cancelled"><?php echo $bs['cancelled'];?></option>
							</select>
						</div><!-- /.col-md-6 -->
					</div><!-- /.row -->
				</form>
				<div id="collapseOne" class="collapse" style="height: 0;" aria-expanded="false">
					<div class="m-b-lg">
						<ul class="agile-list no-padding">
							<li class="success-element b-r-sm">
							<div class="panel-body">
								<form method="get" class="frm-filter-advanced">
									<div class="row">
										<div class="col-md-6 col-sm-12">
											<div class="form-group">
												<label class="control-label"><?php __('lblBookingEvent'); ?></label>
												<select class="form-control select-item" name="event_id">
													<option value="">-- <?php __('lblChoose'); ?> --</option>
													<?php
													if (isset($tpl['event_arr']) && count($tpl['event_arr']) > 0)
													{
														foreach ($tpl['event_arr'] as $v)
														{
															$event_title = 	$v['title'] . ' | ' . pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'], $v['o_show_start_time'], $v['o_show_end_time']);
															
															?><option value="<?php echo $v['id']; ?>" <?php echo $controller->_get->check('event_id') && $controller->_get->toInt('event_id') == $v['id'] ? ' selected="selected"' : NULL; ?>><?php echo stripslashes($event_title); ?></option><?php
															
														}
													}
													?>
												</select>
											</div>
										</div>
									</div>
									<div class="hr-line-dashed"></div>
									<div class="row">
										<div class="col-md-3 col-sm-6">
											<div class="form-group">
												<label class="control-label"><?php __('lblID'); ?></label>
												<input class="form-control" type="text" name="unique_id" value="<?php echo $controller->_get->check('unique_id') ? pjSanitize::html($controller->_get->toString('unique_id')) : NULL; ?>">
											</div>
										</div>
										
										<div class="col-md-3 col-sm-6">
											<div class="form-group">
												<label class="control-label"><?php __('lblBookingName'); ?></label>
												<input class="form-control" type="text" name="customer_name" value="<?php echo $controller->_get->check('customer_name') ? pjSanitize::html($controller->_get->toString('customer_name')) : NULL; ?>">
											</div>
										</div>
				
										<div class="col-md-3 col-sm-6">
											<div class="form-group">
												<label class="control-label"><?php __('lblBookingEmail'); ?></label>
												<input class="form-control" type="text" name="customer_email" value="<?php echo $controller->_get->check('customer_email') ? pjSanitize::html($controller->_get->toString('customer_email')) : NULL; ?>">
											</div>
										</div>
				
										 <div class="col-md-3 col-sm-6">
											<div class="form-group">
												<label class="control-label"><?php __('lblBookingStatus'); ?></label>
												<select name="booking_status" class="form-control">
													<option value="">-- <?php __('lblChoose'); ?> --</option>
													<?php
													foreach ($bs as $k => $v)
													{
														?><option value="<?php echo $k; ?>"<?php echo $controller->_get->check('status') && $controller->_get->toString('status') == $k ? ' selected="selected"' : NULL; ?>><?php echo pjSanitize::html($v); ?></option><?php
													}
													?>
												</select>
											</div>
											<!-- /.form-group -->
										</div>
									</div>
									<!-- /.row -->
									<div class="hr-line-dashed"></div>
									<div class="row">
										<div class="col-lg-4 col-md-6">
											<h3 class="m-b-md"><?php __('lblNumberOfTickets'); ?></h3>
											<div class="row">
												<div class="col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('lblFrom'); ?></label>
														<input type="text" name="from_ticket" class="touchspin3" value="<?php echo $controller->_get->check('from_ticket') ? $controller->_get->toInt('from_ticket') : NULL; ?>" />
													</div>
													<!-- /.form-group -->
												</div>
												<!-- /.col-md-4 -->
												<div class="col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('lblTo'); ?></label>
														<input type="text" name="to_ticket" class="touchspin3" value="<?php echo $controller->_get->check('to_ticket') ? $controller->_get->toInt('to_ticket') : NULL; ?>" />
													</div>
													<!-- /.form-group -->
												</div>
												<!-- /.col-md-4 -->
											</div>
											<!-- /.row -->
										</div>
				
										<div class="col-lg-4 col-md-6">
											<h3 class="m-b-md"><?php __('lblTotalPrice'); ?></h3>
											<div class="row">
												<div class="col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('lblFrom'); ?></label>
														<div class="input-group">
															<input class="form-control text-right" type="text" name="from_price" value="<?php echo $controller->_get->check('from_price') ? $controller->_get->toFloat('from_price') : NULL; ?>">
															<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
														</div>
													</div>
													<!-- /.form-group -->
												</div>
												<!-- /.col-md-4 -->
												<div class="col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('lblTo'); ?></label>
														<div class="input-group">
															<input class="form-control text-right" type="text" name="to_price" value="<?php echo $controller->_get->check('to_price') ? $controller->_get->toFloat('to_price') : NULL; ?>">
															<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
														</div>
													</div>
													<!-- /.form-group -->
												</div>
												<!-- /.col-md-4 -->
											</div>
											<!-- /.row -->
										</div>
									</div>
									<div class="m-t-sm">
										<button class="btn btn-primary" type="submit"><?php __('btnSearch');?></button>
										<button class="btn btn-primary btn-outline" type="reset"><?php __('btnCancel');?></button>
									</div>
								</form>
							</div>
							<!-- /.panel-body -->
							</li>
							<!-- /.panel panel-primary -->
						</ul>
					</div>
					<!-- /.m-b-lg -->
				</div>
				
				<div id="grid" class="pj-grid"></div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var pjGrid = pjGrid || {};
pjGrid.jqDateFormat = "<?php echo pjUtil::jqDateFormat($tpl['option_arr']['o_date_format']); ?>";
pjGrid.hasUpdate = <?php echo pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess() ? 'true' : 'false'; ?>;
pjGrid.hasDeleteSingle = <?php echo pjAuth::factory('pjAdminBookings', 'pjActionDeleteBooking')->hasAccess() ? 'true' : 'false'; ?>;
pjGrid.hasDeleteMulti = <?php echo pjAuth::factory('pjAdminBookings', 'pjActionDeleteDeleteBookingBulk')->hasAccess() ? 'true' : 'false'; ?>;
pjGrid.hasExportBooking = <?php echo pjAuth::factory('pjAdminBookings', 'pjActionExportBooking')->hasAccess() ? 'true' : 'false'; ?>;
pjGrid.queryString = "";
<?php
if ($controller->_get->check('event_id') && $controller->_get->toInt('event_id') > 0)
{
	?>pjGrid.queryString += "&event_id=<?php echo $controller->_get->toInt('event_id'); ?>";<?php
}
?>
var myLabel = myLabel || {};
myLabel.choose = <?php x__encode('lblChoose'); ?>;
myLabel.name = <?php x__encode('lblBookingName'); ?>;
myLabel.eventdate = <?php x__encode('lblEventDate'); ?>;
myLabel.tickets = <?php x__encode('lblBookingTickets'); ?>;
myLabel.price = <?php x__encode('lblBookingPrice'); ?>;
myLabel.print_tickets = <?php x__encode('lblPrintTickets');?>;
myLabel.ticket_url = "<?php echo PJ_INSTALL_URL . PJ_UPLOAD_PATH . '/tickets/pdfs/p_';?>";
myLabel.status = <?php x__encode('lblStatus'); ?>;
myLabel.pending = "<?php echo $bs['pending']; ?>";
myLabel.confirmed = "<?php echo $bs['confirmed']; ?>";
myLabel.cancelled = "<?php echo $bs['cancelled']; ?>";
myLabel.exportSelected = "<?php __('lblExportSelected'); ?>";
myLabel.delete_selected = <?php x__encode('plugin_base_delete_selected'); ?>;
myLabel.delete_confirmation = <?php x__encode('plugin_base_delete_confirmation'); ?>;
</script>