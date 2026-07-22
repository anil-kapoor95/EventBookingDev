<?php 
$index = $controller->_get->toString('index');
if (isset($tpl['status']) && $tpl['status'] == 'IP_BLOCKED') {
	?>
	<h4 class="text-danger text-center"><?php __('front_ip_address_blocked');?></h4>
	<?php 
} else {
	if($controller->_get->toString('view') != 'calendar')
	{
		?>
		<br />
		<?php
		include_once PJ_VIEWS_PATH . 'pjFrontPublic/elements/header.php';
	}
	?>
	<div id="pjEbcTableCalendar_<?php echo $index; ?>" class="pjIcContainer pjEbcBookingWrapper">
		<div class="pjIcCalendar">
			<header class="pjIcCalendarHead clearfix text-center">
				<?php
				if($controller->_get->toString('view') != 'calendar')
				{ 
					?>
					<div class="pull-left">
						<a href="#" class="<?php echo $controller->_get->toString('view') == 'list' ? 'pjEbcBackToList' : 'pjEbcBackToCalendar'; ?>" data-view="<?php echo $controller->_get->toString('view');?>"><span class="glyphicon glyphicon-chevron-left"></span> <?php $controller->_get->toString('view') == 'list' ? __('front_back_to_list') : __('front_back_to_calendar');?></a>
					</div><!-- /.pull-left -->
					<?php
				}else{
					?>
					<div class="pull-right">
						<a href="#" class="pull-right btn btn-primary pjEbcBackToCalendar" data-view="<?php echo $controller->_get->toString('view');?>"><span class="glyphicon glyphicon-remove"></span></a>
					</div><!-- /.pull-left -->
					<?php
				} 
				?>
			</header><!-- /.pjIcCalendarHead -->
		</div>
	</div>
	<div class="pjEbcBookingWrapper pjEbcBookingForm">
		<div class="pjEbcFormHeader">
			<div class="datetime">
				<?php __('front_label_event_details');?>
			</div>
		</div>
		<div class="pjEbcEventContent">
			<label><?php echo stripslashes($tpl['arr']['title']) ;?></label>
			<span><?php echo $event_date = pjUtil::getEventDateTime($tpl['arr']['event_start_ts'], $tpl['arr']['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'], $tpl['arr']['o_show_start_time'], $tpl['arr']['o_show_end_time']) ;?></span>
		</div>
		<div class="pjEbcFormContainer">
			<form id="pjEbcBookingForm_<?php echo $index;?>" action="" method="post" class="pjEbcForm">
				<input type="hidden" name="total_price" value="0" />
				<input type="hidden" name="event_id" value="<?php echo $tpl['arr']['id'];?>" />
				<div class="pjEbcFormHeader">
					<div class="datetime">
						<?php __('front_label_select_tickets');?>
					</div>
				</div>
				<div class="pjEbcFormBody">
					<?php
					$front_error = __('front_error', true);
					$front_required = __('front_required', true);
					$cc_types = __('cc_types', true);
					$months = __('months', true);
					ksort($months);
					
					if(count($tpl['price_arr']) > 0)
					{
						foreach($tpl['price_arr'] as $k => $v)
						{
							?>
							<div class="form-group">
								<label class="title"><?php echo stripslashes($v['price_name']);?></label>
	
								<div class="row">
									<div class="col-lg6 col-md-6 col-sm-6 col-xs-12">
										<div class="input-group">
											<select name="price_<?php echo $v['id']; ?>" data-price="<?php echo $v['price'];?>" class="pjEbcField form-control ebc-w50 pjEbcPriceSelector">
												<?php
												$max = intval($v['available']) - intval($v['cnt_booked']);
												$max = (int) $max < 1 ? 0 : $max;
												foreach (range(0, $max) as $i)
												{
													if ($controller->_post->check('price_' . $v['id']) && $controller->_post->toInt('price_' . $v['id']) == $i)
													{
														?><option value="<?php echo $i; ?>" selected="selected"><?php echo $i; ?></option><?php
													} else {
														?><option value="<?php echo $i; ?>"><?php echo $i; ?></option><?php
													}
												}
												?>
											</select>
										
											<span class="input-group-addon">x <?php echo pjCurrency::formatPrice($v['price']);?></span>
										</div><!-- /.input-group -->
									</div><!-- /.col-lg6 col-md-6 col-sm-6 col-xs-12 -->
								</div><!-- /.row -->
								<?php
								if($k + 1 == count($tpl['price_arr'])) 
								{
									?>
									<input type="hidden" id="pjEbcTicketValidate_<?php echo $index;?>" name="validate_ticket" class="required" value="" data-msg-required="<?php echo pjSanitize::html($front_error['min']);?>" />
									<?php
								} 
								?>
							</div>
							<?php
						}
					} 
					?>
					<div class="form-group pjEbcPriceRow pjEbcVoucherRow" style="display: none">
						<label class="title"><?php __('front_label_discount_code'); ?></label>
						<div class="row">
							<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<input type="text" name="voucher_code" id="pjEbcVoucherCode_<?php echo $index; ?>" class="pjEbcField form-control" autocomplete="off" value="<?php echo $controller->_post->check('voucher_code') ? pjSanitize::html($controller->_post->toString('voucher_code')) : NULL; ?>" />
									<span class="input-group-btn">
										<button type="button" class="pjEbcButton btn btn-primary pjEbcApplyCode" data-index="<?php echo $index; ?>" data-event="<?php echo $tpl['arr']['id']; ?>"><?php __('front_button_apply'); ?></button>
										<button type="button" class="pjEbcButton btn btn-default pjEbcRemoveCode" data-index="<?php echo $index; ?>" style="display: none"><?php __('front_button_remove'); ?></button>
									</span>
								</div><!-- /.input-group -->
								<label id="pjEbcVoucherMsg_<?php echo $index; ?>" class="pjEbcVoucherMsg content" style="display: none; margin-top: 6px;"></label>
							</div>
						</div><!-- /.row -->
					</div>
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
						<p class="pjEbcPriceRow" style="display: none">
							<label class="title"><?php __('front_label_price'); ?></label>
							<label id="pjEbcPrice_<?php echo $index; ?>" class="content">---</label>
						</p>
						<p class="pjEbcPriceRow pjEbcDiscountRow" style="display: none">
							<label class="title"><?php __('front_label_discount'); ?></label>
							<label id="pjEbcDiscount_<?php echo $index; ?>" class="content">---</label>
						</p>
						<p class="pjEbcPriceRow" style="display: none">
							<label class="title"><?php __('front_label_tax'); ?></label>
							<label id="pjEbcTax_<?php echo $index; ?>" class="content">---</label>
						</p>
						<p class="pjEbcPriceRow" style="display: none">
							<label class="title"><?php __('front_label_total_price'); ?></label>
							<label id="pjEbcTotalPrice_<?php echo $index; ?>" class="content">---</label>
						</p>
						<p class="pjEbcPriceRow" style="display: none">
							<label class="title"><?php __('front_label_deposit'); ?></label>
							<label id="pjEbcDeposit_<?php echo $index; ?>" class="content">---</label>
						</p>
					</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
				</div>
				<div class="pjEbcFormHeader">
					<div class="datetime">
						<?php __('front_label_fill_in');?>
					</div>
				</div>
				<div class="row pjEbcFormBody">
					<?php
					if (in_array($tpl['option_arr']['o_bf_include_email'], array(2, 3)))
					{
						?>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_email');?></label>
								<input type="text" name="customer_email" class="pjEbcField form-control ebc-w300 email<?php echo $tpl['option_arr']['o_bf_include_email'] == 3 ? ' required' : NULL; ?>" value="<?php echo $controller->_post->check('customer_email') ? pjSanitize::html($controller->_post->toString('customer_email')) : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['email']); ?>" data-msg-email="<?php __('front_error_ARRAY_email'); ?>"/>
							</div>
						</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_name'], array(2, 3)))
					{
						?>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_name');?></label>
								<input type="text" name="customer_name" class="pjEbcField form-control ebc-w300<?php echo $tpl['option_arr']['o_bf_include_name'] == 3 ? ' required' : NULL; ?>" value="<?php echo $controller->_post->check('customer_name') ? pjSanitize::html($controller->_post->toString('customer_name')) : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['name']); ?>" />
							</div>
						</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_phone'], array(2, 3)))
					{
						?>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_phone');?></label>
								<input type="text" name="customer_phone" class="pjEbcField form-control ebc-w300<?php echo $tpl['option_arr']['o_bf_include_phone'] == 3 ? ' required' : NULL; ?>" value="<?php echo $controller->_post->check('customer_phone') ? pjSanitize::html($controller->_post->toString('customer_phone')) : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['phone']); ?>" />
							</div>
						</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_country'], array(2, 3)))
					{
						?>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_country');?></label>
								<select name="customer_country" class="pjEbcField form-control ebc-w300<?php echo $tpl['option_arr']['o_bf_include_country'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['country']); ?>">
									<option value="">---</option>
									<?php
									if (isset($tpl['country_arr']) && is_array($tpl['country_arr']))
									{
										foreach ($tpl['country_arr'] as $v)
										{
											?><option value="<?php echo $v['id']; ?>"<?php echo $controller->_post->check('customer_country') && $controller->_post->toInt('customer_country') == $v['id'] ? ' selected="selected"' : NULL; ?>><?php echo stripslashes($v['country_title']); ?></option><?php
										}
									}
									?>
								</select>
							</div>
						</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_city'], array(2, 3)))
					{
						?>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_city');?></label>
								<input type="text" name="customer_city" class="pjEbcField form-control ebc-w300<?php echo $tpl['option_arr']['o_bf_include_city'] == 3 ? ' required' : NULL; ?>" value="<?php echo $controller->_post->check('customer_city') ? pjSanitize::html($controller->_post->toString('customer_city')) : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['city']); ?>" />
							</div>
						</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_state'], array(2, 3)))
					{
						?>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_state');?></label>
								<input type="text" name="customer_state" class="pjEbcField form-control ebc-w300<?php echo $tpl['option_arr']['o_bf_include_state'] == 3 ? ' required' : NULL; ?>" value="<?php echo $controller->_post->check('customer_state') ? pjSanitize::html($controller->_post->toString('customer_state')) : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['state']); ?>" />
							</div>
						</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_zip'], array(2, 3)))
					{
						?>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_zip');?></label>
								<input type="text" name="customer_zip" class="pjEbcField form-control ebc-w300<?php echo $tpl['option_arr']['o_bf_include_zip'] == 3 ? ' required' : NULL; ?>" value="<?php echo $controller->_post->check('customer_zip') ? pjSanitize::html($controller->_post->toString('customer_zip')) : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['zip']); ?>" maxlength="8" />
							</div>
						</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_address'], array(2, 3)))
					{
						?>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_address');?></label>
								<input type="text" name="customer_address" class="pjEbcField form-control ebc-w300<?php echo $tpl['option_arr']['o_bf_include_address'] == 3 ? ' required' : NULL; ?>" value="<?php echo $controller->_post->check('customer_address') ? pjSanitize::html($controller->_post->toString('customer_address')) : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['address']); ?>" />
							</div>
						</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_notes'], array(2, 3)))
					{
						?>
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label class="title"><?php __('front_label_notes');?></label>
								<textarea name="customer_notes" class="pjEbcField form-control ebc-w300 ebc-h100<?php echo $tpl['option_arr']['o_bf_include_notes'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars($front_required['notes']); ?>"><?php echo $controller->_post->check('customer_notes') ? htmlspecialchars($controller->_post->toString('customer_notes')) : NULL; ?></textarea>
							</div>
						</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
						<?php
					}
					if ($tpl['option_arr']['o_payment_disable'] == 'No')
					{
						?>
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pjEbcPriceRow" style="display: none;">
								<label class="title"><?php __('front_label_payment_method'); ?></label>
								<?php
								$plugins_payment_methods = pjObject::getPlugin('pjPayments') !== NULL? pjPayments::getPaymentMethods(): array();
								$haveOnline = $haveOffline = false;
								foreach ($tpl['payment_titles'] as $k => $v)
								{
									if($k == 'creditcard') continue;
									if (array_key_exists($k, $plugins_payment_methods))
									{
										if(!isset($tpl['payment_option_arr'][$k]['is_active']) || (isset($tpl['payment_option_arr']) && $tpl['payment_option_arr'][$k]['is_active'] == 0) )
										{
											continue;
										}
									}else if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '0') || $k == 'cash' || $k == 'bank' ){
										continue;
									}
									$haveOnline = true;
									break;
								}
								foreach ($tpl['payment_titles'] as $k => $v)
								{
									if($k == 'creditcard') continue;
									if( $k == 'cash' || $k == 'bank' )
									{
										if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '1'))
										{
											$haveOffline = true;
											break;
										}
									}
								}
								?>
								<select id="pjEbcPaymentMethod_<?php echo $index;?>" name="payment_method" class="pjEbcField form-control ebc-w300 required" data-msg-required="<?php echo $front_error['payment']; ?>">
									<option value="">-- <?php __('front_select_payment'); ?> --</option>
									<?php 
									if ($haveOnline && $haveOffline)
									{
										?><optgroup label="<?php __('script_online_payment_gateway', false, true); ?>"><?php 
									}
									?>
									 <?php
									 foreach ($tpl['payment_titles'] as $k => $v)
									 {
										 if($k == 'creditcard') continue;
										 if (array_key_exists($k, $plugins_payment_methods))
										 {
											 if(!isset($tpl['payment_option_arr'][$k]['is_active']) || (isset($tpl['payment_option_arr']) && $tpl['payment_option_arr'][$k]['is_active'] == 0) )
											 {
												 continue;
											 }
										 }else if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '0') || $k == 'cash' || $k == 'bank' ){
											 continue;
										 }
										 ?><option value="<?php echo $k; ?>"<?php echo $controller->_post->check('payment_method') && $controller->_post->toString('payment_method') == $k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
									 }
									 ?>
									 <?php
									 if ($haveOnline && $haveOffline)
									 {
										?>
										</optgroup>
										<optgroup label="<?php __('script_offline_payment', false, true); ?>">
										<?php 
									 }
									 ?>
									 <?php
									 foreach ($tpl['payment_titles'] as $k => $v)
									 {
										 if($k == 'creditcard') continue;
										 if( $k == 'cash' || $k == 'bank' )
										 {
											 if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '1'))
											 {
												 ?><option value="<?php echo $k; ?>"<?php echo $controller->_post->check('payment_method') && $controller->_post->toString('payment_method') == $k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
											 }
										 }
									  }
									?>
									<?php
									if ($haveOnline && $haveOffline)
									{
										?></optgroup><?php 
									}
									?>
								</select>
							</div>
						</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
						
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 ebcal-bankdata" style="display: <?php echo $controller->_post->check('payment_method') && $controller->_post->toString('payment_method') == 'bank' ? 'block' : 'none'; ?>">
							<div class="form-group">
								<label class="title">&nbsp;</label>
								<label class="content ebc-overflow"><?php echo nl2br($tpl['bank_account']);?></label>
							</div>
						</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
						<?php 
					}
					if (in_array($tpl['option_arr']['o_bf_include_captcha'], array(2, 3)))
					{
						?>
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pjEbcCaptchaWrap <?php echo $tpl['option_arr']['o_captcha_type_front'] != 'system' ? 'pjEbcReCaptchaWrap' : '';?>">
								<label class="title"><?php echo __('front_label_captcha'); ?></label>
								<div class="row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
										<?php
										if($tpl['option_arr']['o_captcha_type_front'] == 'system')
										{
		    								?>
											<div class="row">
												<div class="col-lg-6 col-md-6 col-sm-6 col-sx-12">
													<input type="text" id="pjEbcCaptchaField_<?php echo $index;?>" name="captcha" class="form-control<?php echo (int) $tpl['option_arr']['o_bf_include_captcha'] === 3 ? ' required' : NULL; ?>" maxlength="<?php echo $tpl['option_arr']['o_captcha_mode_front'] == 'string'? (int) $tpl['option_arr']['o_captcha_length_front']: 10 ?>" autocomplete="off" data-msg-required="<?php echo htmlspecialchars($front_required['captcha']); ?>" data-msg-remote="<?php __('co_v_captcha_remote', false, true); ?>" />
												</div>
												<div class="col-lg-6 col-md-6 col-sm-6 col-sx-12">
													<img id="pjEbcCaptchaImage_<?php echo $index;?>" alt="<?php echo __('front_label_captcha'); ?>" src="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&action=pjActionCaptcha&rand=<?php echo rand(1000, 999999); ?>&session_id=<?php echo $controller->_get->check('session_id') ? pjObject::escapeString($controller->_get->toString('session_id')) : NULL;?>" style="vertical-align: middle; cursor: pointer;" />
												</div>
											</div>
											<?php 
										} else {
											?>
										    <div id="g-recaptcha_<?php echo $index; ?>" class="g-recaptcha" data-sitekey="<?php echo $tpl['option_arr']['o_captcha_site_key_front'] ?>"></div>
											<input type="hidden" id="recaptcha" name="recaptcha" class="recaptcha<?php echo ($tpl['option_arr']['o_bf_include_captcha'] == 3) ? ' required' : NULL; ?>" autocomplete="off" data-msg-required="<?php echo htmlspecialchars($front_required['captcha']); ?>" data-msg-remote="<?php __('co_v_captcha_remote');?>"/>
											<?php 
										}
										?>
									</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
								</div>
							</div><!-- /.form-group -->
						</div><br/>
						<?php
					}
					if(!empty($tpl['arr']['booking_terms']))
					{
						?>
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pjEbcTermContent">
								<div class="pjEbcTermWrapper">
									<?php echo nl2br(stripslashes($tpl['arr']['booking_terms']));?>
								</div>
								<br/>
								<div class="">
									<input type="checkbox" id="ebc_accept_term_<?php echo $index;?>" name="accept_term" class="pjEbcField required" style="display: block; float: left; margin-right: 5px;" <?php echo $controller->_post->check('accept_term') ? 'checked="checked"' : NULL; ?> data-msg-required="<?php echo htmlspecialchars($front_required['accept_terms']); ?>" />
									<label for="ebc_accept_term_<?php echo $index;?>"><?php __('front_label_accept_terms');?></label>
								</div>
							</div>
						</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
						<?php
					}
					?>
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
						<label class="title">&nbsp;</label>
						<input type="submit" value="<?php __('front_button_submit'); ?>" class="pjEbcButton btn btn-primary" />
						<input type="button" value="<?php __('front_button_cancel'); ?>" class="pjEbcButton btn btn-primary pjEbcCancelBooking" data-id="<?php echo $tpl['arr']['id'];?>"/>
					</div>
				</div>
			</form>
		</div>
	</div>
<?php } ?>