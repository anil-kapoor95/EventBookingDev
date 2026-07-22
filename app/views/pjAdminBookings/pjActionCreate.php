<div class="row wrapper border-bottom white-bg page-heading">
	<div class="col-sm-12">
		<div class="row">
			<div class="col-sm-10">
				<h2><?php __('infoAddBookingTitle');?></h2>
			</div>
		</div><!-- /.row -->

		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('infoAddBookingDesc');?></p>
	</div><!-- /.col-md-12 -->
</div>
<div class="wrapper wrapper-content animated fadeInRight">
	<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate" method="post" id="frmCreateBooking" novalidate="novalidate">
		<input type="hidden" name="booking_create" value="1" />
		<input type="hidden" name="csrf_token" value="<?php echo pjAppController::getCsrfToken(); ?>" />
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
									<input class="form-control required" name="unique_id" id="unique_id" value="<?php echo pjUtil::getUniqueID(); ?>" maxlength="255" data-msg-required="<?php __('ebc_field_required', false, true);?>" type="text" aria-required="true">
								</div>
								<div class="form-group">
									<label><?php __('lblBookingStatus'); ?></label>
									<select name="booking_status" id="booking_status" class="form-control required" data-msg-required="<?php __('ebc_field_required', false, true);?>" aria-required="true">
										<option value="">-- <?php __('lblChoose'); ?> --</option>
										<?php
										foreach (__('booking_statuses', true) as $k => $v)
										{
											?><option value="<?php echo $k; ?>"><?php echo stripslashes($v); ?></option><?php
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
											?><option value="<?php echo $k;?>"><?php echo $v;?></option><?php
										}
										?>
										</optgroup>
										<optgroup label="<?php __('script_offline_payment', false, true); ?>">
										<?php
										foreach($offline_arr as $k => $v)
										{
											?><option value="<?php echo $k;?>"><?php echo $v;?></option><?php
										}
										?>
										</optgroup>
									</select>
								</div>
								<div class="form-group">
									<label><?php __('lblBookingEvent'); ?></label>
									<div class="row">
										<div class="col-sm-12 pjEbcEventWrap">
											<select name="event_id" id="event_id" class="form-control select-item required" data-msg-required="<?php __('ebc_field_required', false, true);?>" aria-required="true">
												<option value="">-- <?php __('lblChoose'); ?> --</option>
												<?php
												if (isset($tpl['event_arr']) && count($tpl['event_arr']) > 0)
												{
													foreach ($tpl['event_arr'] as $v)
													{
														$event_title = 	$v['title'] . ' | ' . pjUtil::getEventDateTime($v['event_start_ts'], $v['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'], $v['o_show_start_time'], $v['o_show_end_time']);
														?><option value="<?php echo $v['id']; ?>"><?php echo stripslashes($event_title); ?></option><?php
													}
												}
												?>
											</select>
										</div>		
										<?php if (pjAuth::factory('pjAdminEvents', 'pjActionUpdate')->hasAccess()) { ?>		
											<div class="col-sm-2 pjEbcEditEventWrap" style="display:none;">
												<a id="pjEbcEditEvent" class="btn btn-primary btn-outline btn-sm m-l-xs" href="#" target="blank" data-href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionUpdate&id={ID}"><i class="fa fa-pencil"></i></a>
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
										<input type="text" class="form-control number" name="booking_price" id="booking_price" data-msg-required="<?php __('ebc_field_required');?>" data-msg-number="<?php __('prices_invalid_price');?>">
										<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
									</div>
								</div>

								<input type="hidden" name="voucher_code" id="voucher_code" value="" />
								<div class="form-group">
									<label><?php __('front_label_discount_code'); ?></label>
									<div class="input-group">
										<input type="text" class="form-control" name="voucher_code_input" id="voucher_code_input" value="" autocomplete="off">
										<span class="input-group-btn">
											<button type="button" class="btn btn-primary pjAdminApplyCode"><?php __('front_button_apply'); ?></button>
										</span>
									</div>
									<label id="voucher_msg" class="m-t-xs" style="display: none;"></label>
								</div>

								<div class="form-group">
									<label><?php __('front_label_discount'); ?></label>
									<div class="input-group">
										<input type="text" class="form-control number" name="booking_discount" id="booking_discount" value="" data-msg-number="<?php __('prices_invalid_price');?>">
										<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
									</div>
								</div>

								<div class="form-group">
									<label><?php __('lblBookingTax'); ?></label>
									<div class="input-group">
										<input type="text" class="form-control number" name="booking_tax" id="booking_tax" data-msg-required="<?php __('ebc_field_required');?>" data-msg-number="<?php __('prices_invalid_price');?>">
										<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
									</div>
								</div>
								
								<div class="form-group">
									<label><?php __('lblBookingTotal'); ?></label>
									<div class="input-group">
										<input type="text" class="form-control number" name="booking_total" id="booking_total" data-msg-required="<?php __('ebc_field_required');?>" data-msg-number="<?php __('prices_invalid_price');?>">
										<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?></span>
									</div>
								</div>
								
								<div class="form-group">
									<label><?php __('lblBookingDeposit'); ?></label>
									<div class="input-group">
										<input type="text" class="form-control number" name="booking_deposit" id="booking_deposit" data-msg-required="<?php __('ebc_field_required');?>" data-msg-number="<?php __('prices_invalid_price');?>">
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
									<input type="text" name="customer_name" id="customer_name" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_name'] === 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required');?>">
								</div>
							</div>
							<div class="col-md-4 col-sm-4 ">
								<div class="form-group">
									<label><?php __('lblBookingEmail'); ?></label>
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-at"></i></span>
										<input type="text" name="customer_email" id="customer_email" class="form-control email<?php echo $tpl['option_arr']['o_bf_include_email'] == 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>" data-msg-email="<?php __('plugin_base_email_invalid', false, true);?>"/>
									</div>
								</div>
							</div>
							<div class="col-md-4 col-sm-4 ">
								<div class="form-group">
									<label><?php __('lblBookingPhone'); ?></label>
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-phone"></i></span>
										<input type="text" name="customer_phone" id="customer_phone" class="form-control<?php echo $tpl['option_arr']['o_bf_include_phone'] == 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>" />
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-4 col-sm-4 ">
								<div class="form-group">
									<label><?php __('lblBookingAddress'); ?></label>
									<input type="text" name="customer_address" id="customer_address" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_address'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
								</div>
							</div>
							<div class="col-md-4 col-sm-4 ">
								<div class="form-group">
									<label><?php __('lblBookingCity'); ?></label>
									<input type="text" name="customer_city" id="customer_city" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_city'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
								</div>
							</div>
							<div class="col-md-4 col-sm-4 ">
								<div class="form-group">
									<label><?php __('lblBookingState'); ?></label>
									<input type="text" name="customer_state" id="customer_state" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_state'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-4 col-sm-4">
								<div class="form-group ">
									<label><?php __('lblBookingZip'); ?></label>
									<input type="text" name="customer_zip" id="customer_zip" class="form-control <?php echo (int) $tpl['option_arr']['o_bf_include_zip'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
								</div>
								<div class="form-group ">
									<label><?php __('lblBookingCountry'); ?></label>
									<select name="customer_country" id="customer_country" class="form-control select-item <?php echo (int) $tpl['option_arr']['o_bf_include_country'] === 3 ? '  required' : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">
										<option value="">-- <?php __('lblChoose'); ?> --</option>
										<?php
										foreach ($tpl['country_arr'] as $country)
										{
											?><option value="<?php echo $country['id']; ?>"><?php echo stripslashes($country['name']); ?></option><?php
										}
										?>
									</select>
								</div>
							</div>
							<div class="col-md-8 col-sm-8 ">
								<div class="form-group">
									<label><?php __('lblBookingNotes'); ?></label>
									<textarea name="customer_notes" id="customer_notes" class="form-control<?php echo $tpl['option_arr']['o_bf_include_notes'] == 3 ? '  required' : NULL; ?>" rows="4" cols="30" data-msg-required="<?php __('ebc_field_required', false, true);?>"></textarea>
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
	</form>
</div>
<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.duplicatedUniqueID = "<?php __('lblDuplicatedUniqueID'); ?>";
myLabel.choose = <?php x__encode('lblChoose');?>;
myLabel.tax = <?php echo (float)$tpl['option_arr']['o_tax_payment'] ?>;
myLabel.deposit = <?php echo (float)$tpl['option_arr']['o_deposit_payment'] ?>;
myLabel.price_at_least = <?php x__encode('lblAtLeastPrice', true); ?>;
</script>