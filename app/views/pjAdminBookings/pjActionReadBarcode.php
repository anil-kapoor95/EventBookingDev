<div class="row wrapper border-bottom white-bg page-heading">
	<div class="col-sm-12">
		<div class="row">
			<div class="col-sm-10">
				<h2><?php __('infoReadBarcodeTitle');?></h2>
			</div>
		</div><!-- /.row -->

		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('infoReadBarcodeBody');?></p>
	</div><!-- /.col-md-12 -->
</div>
<div class="row wrapper wrapper-content animated fadeInRight">
	<div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
				<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionReadBarcode" method="post" id="frmReadBarcode" novalidate="novalidate">
					<input type="hidden" name="read_barcode" value="1" />
					<input type="hidden" name="csrf_token" value="<?php echo pjAppController::getCsrfToken(); ?>" />
					<div class="row">
						<div class="col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
							<div class="form-group text-center">
								<label class="control-label"><?php __('lblBarcodeDetails');?></label>
								<input type="text" name="barcode_label" id="barcode_label" value="" class="form-control barcode-field required" />
							</div>
							<div class="form-group text-center">
								<div class="clearfix">
									<button class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader" data-style="zoom-in">
										<span class="ladda-label"><?php __('btnCheck'); ?></span>
										<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>   
									</button>
								</div>
							</div>
							<?php
							if(isset($tpl['ticket_status']))
							{
								$ticket_statuses = __('ticket_statuses', true);
								if($tpl['ticket_status'] == 1)
								{
									?>
									<div class="form-group text-center">
										<label class="text-success"><?php echo $ticket_statuses[$tpl['ticket_status']]; ?></label>
									</div>
									<?php
								}else{
									?>
									<div class="form-group text-center">
										<label class="text-danger"><?php echo $ticket_statuses[$tpl['ticket_status']]; ?></label>
									</div>
									<?php
								}
							} 
							?>
							
							<div class="hr-line-dashed"></div>
							<?php
							if(isset($tpl['arr']))
							{
								$booking_statuses = __('booking_statuses', true);
								
								$event_date = pjUtil::getEventDateTime($tpl['arr']['event_start_ts'], $tpl['arr']['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'], $tpl['arr']['o_show_start_time'], $tpl['arr']['o_show_end_time']);
								
								?>
								<?php
								if($tpl['ticket_status'] == 1)
								{ 
									?>
									<div class="form-group text-center">
										<a class="btn btn-secondary btn-outline btn-lg btnMarkTicketUsed" href="javascript:void(0);" data-id="<?php echo $tpl['arr']['id'];?>"><?php __('btnMarkTicketAsUsed'); ?></a>
									</div>
									<?php
								} 
								?>
								<div class="form-group">
									<label class="control-label"><?php echo ucfirst(__('lblTicket', true)); ?>:</label>
									<span class="form-control-static"><?php echo pjSanitize::html($tpl['arr']['ticket_id']) . ' / ' . pjSanitize::html($tpl['arr']['price_name']);?></span>
								</div>
								<div class="form-group">
									<label class="control-label"><?php __('lblEvent'); ?>:</label>
									<span class="form-control-static">
										<?php if (pjAuth::factory('pjAdminEvents', 'pjActionUpdate')->hasAccess()) { ?>
											<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionUpdate&id=<?php echo $tpl['arr']['event_id'];?>"><?php echo pjSanitize::html($tpl['arr']['event_title']);?></a>
										<?php } else { ?>
											<?php echo pjSanitize::html($tpl['arr']['event_title']);?>
										<?php } ?>
									</span>
								</div>
								<div class="form-group">
									<label class="control-label"><?php __('lblDateTime'); ?>:</label>
									<span class="form-control-static"><?php echo $event_date; ?></span>
								</div>
								<div class="form-group">
									<label class="control-label"><?php __('lblStatus'); ?>:</label>
									<span class="form-control-static"><?php echo $booking_statuses[$tpl['arr']['booking_status']]; ?></span>
								</div>
								<div class="form-group">
									<label class="control-label"><?php __('lblName'); ?>:</label>
									<span class="form-control-static"><?php echo pjSanitize::html($tpl['arr']['customer_name']); ?></span>
								</div>
								<div class="form-group">
									<label class="control-label"><?php __('lblBookingEmail'); ?>:</label>
									<span class="form-control-static"><?php echo pjSanitize::html($tpl['arr']['customer_email']); ?></span>
								</div>
								<div class="form-group">
									<label class="control-label"><?php __('lblBookingPhone'); ?>:</label>
									<span class="form-control-static"><?php echo pjSanitize::html($tpl['arr']['customer_phone']); ?></span>
								</div>
								<div class="row form-group">
									<div class="col-xs-12">
										<label class="control-label pull-left"><?php __('lblBookingTickets'); ?>:</label>
										<p class="form-control-static pull-left">
											<?php
											foreach($tpl['details_arr'] as $v)
											{
												echo pjSanitize::html($v['price_name']) . ': ' . $v['cnt'] . ' x ' . pjCurrency::formatPrice($v['price']) . '<br/>';
											} 
											?>
										</p>
									</div>
								</div>
								<?php if (pjAuth::factory('pjAdminEvents', 'pjActionUpdate')->hasAccess()) { ?>
									<div class="form-group text-center">
										<a class="btn btn-primary btn-outline btn-lg" href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionUpdate&id=<?php echo $tpl['arr']['booking_id'];?>"><?php __('lblEditBooking'); ?></a>
									</div>
									<?php
								}
							}
							?>
							
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.alert_mark_ticket_used_title = <?php x__encode('alert_mark_ticket_used_title'); ?>;
myLabel.alert_mark_ticket_used_text = <?php x__encode('alert_mark_ticket_used_text'); ?>;
myLabel.btn_yes = <?php x__encode('btnYes'); ?>;
myLabel.btn_cancel = <?php x__encode('btnCancel'); ?>;
</script>