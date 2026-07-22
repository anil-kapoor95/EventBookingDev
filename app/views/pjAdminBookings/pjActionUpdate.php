<?php 
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$booking_statuses = __('booking_statuses', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
	<div class="col-sm-12">
		<div class="row">
			<div class="col-sm-10">
				<h2><?php __('infoUpdateBookingTitle');?></h2>
			</div>
		</div><!-- /.row -->

		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('infoUpdateBookingDesc');?></p>
	</div><!-- /.col-md-12 -->
</div>

<div class="wrapper wrapper-content animated fadeInRight">
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
				case in_array($error_code, array('AR04', 'AR08', 'AR11')):	
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
	<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionUpdate&amp;id=<?php echo $tpl['arr']['id']; ?>" id="frmUpdateBooking" method="post" novalidate="novalidate">
		<input type="hidden" name="booking_update" value="1" />
		<input type="hidden" name="csrf_token" value="<?php echo pjAppController::getCsrfToken(); ?>" />
		<input type="hidden" name="unique_id" value="<?php echo pjSanitize::html($tpl['arr']['unique_id']); ?>" />
		<input type="hidden" id="booking_id" name="id" value="<?php echo $tpl['arr']['id']; ?>" />
		<input type="hidden" name="voucher_code" id="voucher_code" value="<?php echo pjSanitize::html($tpl['arr']['voucher_code']); ?>" />
		<div class="row">
			<div class="col-lg-9">
				<div class="tabs-container">
					<ul class="nav nav-tabs">
						<li class="active"><a class="tab-booking-details" href="#booking-details" rev="1" aria-controls="booking-details" role="tab" data-toggle="tab" aria-expanded="true"><?php __('tabDetails');?></a></li>
						<li class=""><a class="tab-client-details" href="#client-details" rev="2" aria-controls="client-details" role="tab" data-toggle="tab" aria-expanded="false"><?php __('tabClient');?></a></li>
					</ul>
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane active" id="booking-details">
							<div class="panel-body">
								
								<div class="row">
									<div class="col-md-6 col-sm-12">
										<div class="alert alert-info m-t-sm">
											<i class="fa fa-info-circle m-r-xs"></i>
											<?php __('lblBookingDetailsDesc');?>
										</div>
										<div class="form-group">
											<label><?php __('lblBookingID'); ?></label>
											<input class="form-control required" name="unique_id" id="unique_id" value="<?php echo pjSanitize::html($tpl['arr']['unique_id']); ?>" maxlength="255" data-msg-required="<?php __('ebc_field_required', false, true);?>" type="text" aria-required="true">
										</div>
										<div class="form-group">
											<label><?php __('lblBookingStatus'); ?></label>
											<select name="booking_status" id="booking_status" class="form-control required" data-msg-required="<?php __('ebc_field_required', false, true);?>" aria-required="true">
												<option value="">-- <?php __('lblChoose'); ?> --</option>
												<?php
												foreach (__('booking_statuses', true) as $k => $v)
												{
													?><option value="<?php echo $k; ?>" <?php echo $tpl['arr']['booking_status'] == $k ? 'selected="selected"' : '';?>><?php echo stripslashes($v); ?></option><?php
												}
												?>
											</select>
										</div>
										<div class="form-group">
											<label><?php __('lblBookingPayment'); ?></label>
											<?php
											$online_arr = array();
											$offline_arr = array();
											foreach (__('payment_methods', true, false) as $k => $v)
											{
												if($k == 'creditcard') continue;
												if(in_array($k, array('cash', 'bank')))
												{
													$offline_arr[$k] = $v;
												}else{
													$online_arr[$k] = $v;
												}
											}
											?>
											<select name="payment_method" id="payment_method" class="form-control" data-msg-required="<?php __('ebc_field_required', false, true);?>">
												<option value="">-- <?php __('lblChoose'); ?>--</option>
												<optgroup label="<?php __('script_online_payment_gateway', false, true); ?>">
												<?php
												foreach($online_arr as $k => $v)
												{
													?><option value="<?php echo $k;?>"  <?php echo $tpl['arr']['payment_method'] == $k ? 'selected="selected"' : '';?>><?php echo $v;?></option><?php
												}
												?>
												</optgroup>
												<optgroup label="<?php __('script_offline_payment', false, true); ?>">
												<?php
												foreach($offline_arr as $k => $v)
												{
													?><option value="<?php echo $k;?>" <?php echo $tpl['arr']['payment_method'] == $k ? 'selected="selected"' : '';?>><?php echo $v;?></option><?php
												}
												?>
												</optgroup>
											</select>
										</div>
										<div class="form-group">
											<label><?php __('lblBookingEvent'); ?></label>
											<div class="row">
												<div class="<?php echo (int)$tpl['arr']['event_id'] > 0 ? 'col-sm-10' : 'col-sm-12';?> pjEbcEventWrap">
													<select name="event_id" id="event_id" class="form-control select-item required" data-msg-required="<?php __('ebc_field_required', false, true);?>" aria-required="true">
														<option value="">-- <?php __('lblChoose'); ?> --</option>
														<?php
														if (isset($tpl['event_arr']) && count($tpl['event_arr']) > 0)
														{
															foreach ($tpl['event_arr'] as $v)
															{
																$event_title = 	$v['title'] . ' | ' . pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'], $v['o_show_start_time'], $v['o_show_end_time']);
																?><option value="<?php echo $v['id']; ?>" <?php echo $tpl['arr']['event_id'] == $v['id'] ? 'selected="selected"' : '';?>><?php echo stripslashes($event_title); ?></option><?php
															}
														}
														?>
													</select>
												</div>		
												<?php if (pjAuth::factory('pjAdminEvents', 'pjActionUpdate')->hasAccess()) { ?>		
													<div class="col-sm-2 pjEbcEditEventWrap" style="display: <?php echo (int)$tpl['arr']['event_id'] > 0 ? '' : 'none';?>;">
														<a id="pjEbcEditEvent" class="btn btn-primary btn-outline btn-sm m-l-xs" href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionUpdate&id=<?php echo (int)$tpl['arr']['event_id'];?>" target="blank" data-href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionUpdate&id={ID}"><i class="fa fa-pencil"></i></a>
													</div>
												<?php } ?>
											</div>
										</div>
										
										<div id="price_container"></div>
										
									</div>
									<div class="col-md-6 col-sm-12">
										<div class="alert alert-info m-t-sm">
											<i class="fa fa-info-circle m-r-xs"></i>
											<?php __('lblBookingPriceDetailsDesc');?>
										</div>
										
										<div class="form-group">
											<label><?php __('lblBookingPrice'); ?></label>
											<div class="input-group">
												<input type="text" class="form-control number" name="booking_price" id="booking_price" value="<?php echo (float)$tpl['arr']['booking_total'] - (float)$tpl['arr']['booking_tax'] + (float)$tpl['arr']['booking_discount'];?>" data-msg-required="<?php __('ebc_field_required');?>" data-msg-number="<?php __('prices_invalid_price');?>">
												<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
											</div>
										</div>

										<div class="form-group">
											<label><?php __('front_label_discount_code'); ?></label>
											<div class="input-group">
												<input type="text" class="form-control" name="voucher_code_input" id="voucher_code_input" value="<?php echo pjSanitize::html($tpl['arr']['voucher_code']); ?>" autocomplete="off">
												<span class="input-group-btn">
													<button type="button" class="btn btn-primary pjAdminApplyCode"><?php __('front_button_apply'); ?></button>
												</span>
											</div>
											<label id="voucher_msg" class="m-t-xs" style="display: none;"></label>
										</div>

										<div class="form-group">
											<label><?php __('front_label_discount'); ?></label>
											<div class="input-group">
												<input type="text" class="form-control number" name="booking_discount" id="booking_discount" value="<?php echo (float)$tpl['arr']['booking_discount'];?>" data-msg-number="<?php __('prices_invalid_price');?>">
												<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
											</div>
										</div>

										<div class="form-group">
											<label><?php __('lblBookingTax'); ?></label>
											<div class="input-group">
												<input type="text" class="form-control number" name="booking_tax" id="booking_tax" value="<?php echo (float)$tpl['arr']['booking_tax'];?>" data-msg-required="<?php __('ebc_field_required');?>" data-msg-number="<?php __('prices_invalid_price');?>">
												<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
											</div>
										</div>
										
										<div class="form-group">
											<label><?php __('lblBookingTotal'); ?></label>
											<div class="input-group">
												<input type="text" class="form-control number" name="booking_total" id="booking_total" value="<?php echo (float)$tpl['arr']['booking_total'];?>" data-msg-required="<?php __('ebc_field_required');?>" data-msg-number="<?php __('prices_invalid_price');?>">
												<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
											</div>
										</div>
										
										<div class="form-group">
											<label><?php __('lblBookingDeposit'); ?></label>
											<div class="input-group">
												<input type="text" class="form-control number" name="booking_deposit" id="booking_deposit" value="<?php echo (float)$tpl['arr']['booking_deposit'];?>" data-msg-required="<?php __('ebc_field_required');?>" data-msg-number="<?php __('prices_invalid_price');?>">
												<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
											</div>
										</div>
									</div>
								</div>

								<div class="hr-line-dashed"> </div>

								<div class="clearfix">
									<button class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
										<span class="ladda-label"><?php __('btnSave'); ?></span>
										<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>   
									</button>
								
									<button class="btn btn-white btn-lg pull-right" type="button" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminBookings&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane" id="client-details">
							<div class="panel-body">
								<div class="row">
									<div class="col-md-4 col-sm-4 ">
										<div class="form-group">
											<label><?php __('lblBookingName'); ?></label>
											<input type="text" name="customer_name" id="customer_name" value="<?php echo pjSanitize::html($tpl['arr']['customer_name']);?>" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_name'] === 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required');?>">
										</div>
									</div>
									<div class="col-md-4 col-sm-4 ">
										<div class="form-group">
											<label><?php __('lblBookingEmail'); ?></label>
											<div class="input-group">
												<span class="input-group-addon"><i class="fa fa-at"></i></span>
												<input type="text" name="customer_email" id="customer_email" value="<?php echo pjSanitize::html($tpl['arr']['customer_email']);?>" class="form-control email<?php echo $tpl['option_arr']['o_bf_include_email'] == 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>" data-msg-email="<?php __('plugin_base_email_invalid', false, true);?>"/>
											</div>
										</div>
									</div>
									<div class="col-md-4 col-sm-4 ">
										<div class="form-group">
											<label><?php __('lblBookingPhone'); ?></label>
											<div class="input-group">
												<span class="input-group-addon"><i class="fa fa-phone"></i></span>
												<input type="text" name="customer_phone" id="customer_phone" value="<?php echo pjSanitize::html($tpl['arr']['customer_phone']);?>" class="form-control<?php echo $tpl['option_arr']['o_bf_include_phone'] == 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>" />
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-4 col-sm-4 ">
										<div class="form-group">
											<label><?php __('lblBookingAddress'); ?></label>
											<input type="text" name="customer_address" id="customer_address" value="<?php echo pjSanitize::html($tpl['arr']['customer_address']);?>" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_address'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
										</div>
									</div>
									<div class="col-md-4 col-sm-4 ">
										<div class="form-group">
											<label><?php __('lblBookingCity'); ?></label>
											<input type="text" name="customer_city" id="customer_city" value="<?php echo pjSanitize::html($tpl['arr']['customer_city']);?>" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_city'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
										</div>
									</div>
									<div class="col-md-4 col-sm-4 ">
										<div class="form-group">
											<label><?php __('lblBookingState'); ?></label>
											<input type="text" name="customer_state" id="customer_state" value="<?php echo pjSanitize::html($tpl['arr']['customer_state']);?>" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_state'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-4 col-sm-4">
										<div class="form-group ">
											<label><?php __('lblBookingZip'); ?></label>
											<input type="text" name="customer_zip" id="customer_zip" value="<?php echo pjSanitize::html($tpl['arr']['customer_zip']);?>" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_zip'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
										</div>
										<div class="form-group ">
											<label><?php __('lblBookingCountry'); ?></label>
											<select name="customer_country" id="customer_country" class="form-control select-item <?php echo (int) $tpl['option_arr']['o_bf_include_country'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
												<option value="">-- <?php __('lblChoose'); ?> --</option>
												<?php
												foreach ($tpl['country_arr'] as $country)
												{
													?><option value="<?php echo $country['id']; ?>" <?php echo $tpl['arr']['customer_country'] == $country['id'] ? 'selected="selected"' : '';?>><?php echo stripslashes($country['name']); ?></option><?php
												}
												?>
											</select>
										</div>
									</div>
									<div class="col-md-8 col-sm-8 ">
										<div class="form-group">
											<label><?php __('lblBookingNotes'); ?></label>
											<textarea name="customer_notes" id="customer_notes" class="form-control<?php echo $tpl['option_arr']['o_bf_include_notes'] == 3 ? '  required' : NULL; ?>" rows="4" cols="30" data-msg-required="<?php __('ebc_field_required', false, true);?>"><?php echo htmlspecialchars(stripslashes($tpl['arr']['customer_notes'])); ?></textarea>
										</div>
									</div>
									
								</div>
								<div class="hr-line-dashed"></div>
								<div class="clearfix">
									<button class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
										<span class="ladda-label"><?php __('btnSave'); ?></span>
										<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>   
									</button>
								
									<button class="btn btn-white btn-lg pull-right" type="button" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminBookings&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
								</div>
							</div>
						</div>
						
					</div>
				</div>
			</div>
			<div class="col-lg-3">
				<div class="m-b-lg">
					<div class="edit-reservation-actions">
						<a href="#" class="btn btn-primary btn-outline btn-block confirmation-email" data-id="<?php echo $tpl['arr']['id'];?>" title="<?php __('lblBookingConfirmationResend'); ?>"><i class="fa fa-envelope"></i> <?php __('lblBookingConfirmationResend'); ?></a>
						<a href="#" class="btn btn-primary btn-outline btn-block payment-email" data-id="<?php echo $tpl['arr']['id'];?>" title="<?php __('lblBookingPaymentResend'); ?>"><i class="fa fa-envelope"></i> <?php __('lblBookingPaymentResend'); ?></a>
						<a href="#" class="btn btn-primary btn-outline btn-block cancellation-email" data-id="<?php echo $tpl['arr']['id'];?>" title="<?php __('lblBookingCancelledResend'); ?>"><i class="fa fa-times"></i> <?php __('lblBookingCancelledResend'); ?></a>
						
						<a href="<?php echo PJ_INSTALL_URL . PJ_UPLOAD_PATH . '/tickets/pdfs/p_' . $tpl['arr']['unique_id'] . '.pdf'; ?>" target="_blank" class="btn btn-primary btn-outline btn-block" title="<?php __('lblPrintTickets'); ?>"><i class="fa fa-print"></i> <?php __('lblPrintTickets'); ?></a>
					</div>
					<div id="pjEbcSummaryWrapper" class="panel no-borders">
						<div id="panel-status" class="panel-heading bg-<?php echo $tpl['arr']['booking_status'];?>">
							<p class="lead m-n">
								<i class="fa fa-exclamation-triangle"></i> <?php __('lblBookingStatus'); ?>: <span class="pull-right status-text"><?php echo @$booking_statuses[$tpl['arr']['booking_status']];?></span>
							</p>
						</div>
						<div class="panel-body">
							<p class="lead m-b-xs">
								<i class="fa color-pending fa-key"></i> <?php __('lblBookingID')?>:<span class="pull-right"><?php echo pjSanitize::html($tpl['arr']['unique_id']);?></span>
							</p>
							<p class="lead m-b-md">
								<i class="fa color-pending fa-calendar"></i> <?php __('lblBookingDateTime'); ?>: <span class="pull-right"><?php echo date($tpl['option_arr']['o_date_format'], strtotime($tpl['arr']['created'])); ?>, <?php echo date($tpl['option_arr']['o_time_format'], strtotime($tpl['arr']['created'])); ?></span>
							</p>
							<p class="lead m-b-xs">
								<i class="fa color-pending fa-globe"></i> <?php __('lblIpAddress'); ?>:<span class="pull-right"><?php echo pjSanitize::html($tpl['arr']['customer_ip']);?></span>
							</p>
							<p class="lead m-b-xs">
								<i class="fa color-pending fa-gift"></i> <?php __('lblBookingEvent'); ?>:
								<?php if (pjAuth::factory('pjAdminEvents', 'pjActionUpdate')->hasAccess()) { ?>
		            				<span class="pull-right"><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionUpdate&amp;id=<?php echo $tpl['arr']['event_id']; ?>"><?php echo pjSanitize::html($tpl['arr']['event_title']);?></a></span>
		            			<?php } else { ?>
		            				<span class="pull-right"><a href="javascript:void(0);"><?php echo pjSanitize::html($tpl['arr']['event_title']);?></a></span>
		            			<?php } ?>
							</p>
						</div>
					</div>
					<div class="edit-reservation-widgets" style="margin: 0;">
						<div class="m-b-md">
							<a href="javascript:void(0);" class="widget widget-bg widget-client-info">
							<?php if (!empty($tpl['arr']['customer_name'])) { ?>
								<p class="lead m-b-xs">
									<i class="fa fa-user"></i> <?php echo pjSanitize::html($tpl['arr']['customer_name']);?>
								</p>
							<?php } ?>
							<?php if (!empty($tpl['arr']['customer_email'])) { ?>
								<p class="lead m-b-xs">
									<i class="fa fa-envelope-o"></i> <?php echo pjSanitize::html($tpl['arr']['customer_email']);?>
								</p>
							<?php } ?>
							<?php if (!empty($tpl['arr']['customer_phone'])) { ?>
								<p class="lead m-n">
									<i class="fa fa-phone"></i> <?php echo pjSanitize::html($tpl['arr']['customer_phone']);?>
								</p>
							<?php } ?>
							</a>
						</div>
						<div class="m-b-md">
							<?php
							$total = $tpl['arr']['booking_total'] > 0 ? $tpl['arr']['booking_total'] : 0;
							$payment_made = $tpl['arr']['booking_status'] == 'confirmed' ? $tpl['arr']['booking_deposit'] : 0;
							$payment_due = $total - $payment_made;
							$payment_due = $payment_due < 0 ? 0 : $payment_due;
							?>
							<a href="javascript:void(0);" class="widget widget-bg">
								<p class="lead m-b-xs">
									 <?php __('lblBookingTotalPrice');?>: <strong class="pull-right cr-total-quote"><?php echo pjCurrency::formatPrice($total, " ", NULL, $tpl['option_arr']['o_currency']);?></strong>
								</p>
								<p class="lead m-b-xs">
									 <?php __('lblBookingPaymentMade');?>: <strong class="pull-right pj_collected"><?php echo pjCurrency::formatPrice($payment_made, " ", NULL, $tpl['option_arr']['o_currency']);?></strong>
								</p>
								<p class="lead m-n">
									 <?php __('lblBookingPaymentDue');?>: <strong id="pj_due_payment" class="pull-right"><?php echo pjCurrency::formatPrice($payment_due, " ", NULL, $tpl['option_arr']['o_currency']);?></strong>
								</p>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

<div class="modal fade" id="confirmEmailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
		      <div class="modal-header">
		        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        	<h4 class="modal-title"><?php __('ebc_email_confirmation'); ?></h4>
		      </div>
		      <div id="confirmEmailContentWrapper" class="modal-body"></div>
		      <div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel');?></button>
		        	<button id="btnSendEmailConfirm" type="button" class="btn btn-primary"><?php __('btnSend');?></button>
		      </div>
	    </div><!-- /.modal-content -->
  	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="paymentEmailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
		      <div class="modal-header">
		        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        	<h4 class="modal-title"><?php __('ebc_email_payment'); ?></h4>
		      </div>
		      <div id="paymentEmailContentWrapper" class="modal-body"></div>
		      <div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel');?></button>
		        	<button id="btnSendEmailPayment" type="button" class="btn btn-primary"><?php __('btnSend');?></button>
		      </div>
	    </div><!-- /.modal-content -->
  	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="cancellationEmailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
		      <div class="modal-header">
		        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        	<h4 class="modal-title"><?php __('ebc_email_cancellation'); ?></h4>
		      </div>
		      <div id="cancellationEmailContentWrapper" class="modal-body"></div>
		      <div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel');?></button>
		        	<button id="btnSendEmailCancellation" type="button" class="btn btn-primary"><?php __('btnSend');?></button>
		      </div>
	    </div><!-- /.modal-content -->
  	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script type="text/javascript">
	var myLabel = myLabel || {};
	myLabel.duplicatedUniqueID = "<?php __('lblDuplicatedUniqueID'); ?>";
	myLabel.choose = <?php x__encode('lblChoose');?>;
	myLabel.tax = <?php echo (float)$tpl['option_arr']['o_tax_payment'] ?>;
	myLabel.deposit = <?php echo (float)$tpl['option_arr']['o_deposit_payment'] ?>;
	myLabel.price_at_least = <?php x__encode('lblAtLeastPrice', true); ?>;
	</script>