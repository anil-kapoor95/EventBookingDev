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
				<?php
				?><span><?php echo stripslashes($tpl['arr']['title']) . ' | ';?></span> <?php
				echo $event_date = pjUtil::getEventDateTime($tpl['arr']['event_start_ts'], $tpl['arr']['event_end_ts'], $tpl['option_arr']['o_date_format'], $tpl['option_arr']['o_time_format'], $tpl['arr']['o_show_start_time'], $tpl['arr']['o_show_end_time']);
				?>
			</div>
		</div>
		<div class="pjEbcFormContainer">
			<form id="pjEbcBookingSummary_<?php echo $index;?>" action="" method="post" class="pjEbcForm" style="width: auto">
				<div class="pjEbcFormBody">
					<?php
					$cc_types = __('cc_types', true);
					$months = __('months', true); ksort($months);
					$payment_methods = __('payment_methods', true);
					$front_messages = __('front_message', true);
					
					if(count($tpl['price_arr']) > 0)
					{
						foreach($tpl['price_arr'] as $k => $v)
						{
							if ($controller->_post->check('price_' . $v['id']) && $controller->_post->toInt('price_' . $v['id']) > 0)
							{
								?>
								<dl class="dl-horizontal">
									<dt class="title"><?php echo stripslashes($v['price_name']);?> (<?php echo $controller->_post->toInt('price_' . $v['id']); ?> x  <?php echo pjCurrency::formatPrice($v['price']);?>)</dt>
									<dd class="content"><?php echo pjCurrency::formatPrice($controller->_post->toInt('price_' . $v['id']) * $v['price']); ?></dd>
								</dl>
								<?php
							}
						}
					}
					?>
					<dl class="dl-horizontal">
						<dt class="title"><?php __('front_label_price'); ?></dt>
						<dd class="content"><?php echo pjCurrency::formatPrice($tpl['amount']['price']); ?></dd>
					</dl>
					<?php
					if (isset($tpl['amount']['discount']) && (float) $tpl['amount']['discount'] > 0)
					{
						?>
						<dl class="dl-horizontal">
							<dt class="title"><?php __('front_label_discount'); ?><?php echo !empty($tpl['voucher']['voucher_code']) ? ' (' . pjSanitize::html($tpl['voucher']['voucher_code']) . ')' : ''; ?></dt>
							<dd class="content">-<?php echo pjCurrency::formatPrice($tpl['amount']['discount']); ?></dd>
						</dl>
						<?php
					}
					?>
					<dl class="dl-horizontal">
						<dt class="title"><?php __('front_label_tax'); ?></dt>
						<dd class="content"><?php echo pjCurrency::formatPrice($tpl['amount']['tax']); ?></dd>
					</dl>
					<dl class="dl-horizontal">
						<dt class="title"><?php __('front_label_total_price'); ?></dt>
						<dd class="content"><?php echo pjCurrency::formatPrice($tpl['amount']['total']); ?></dd>
					</dl>
					<dl class="dl-horizontal">
						<dt class="title"><?php __('front_label_deposit'); ?></dt>
						<dd class="content"><?php echo pjCurrency::formatPrice($tpl['amount']['deposit']); ?></dd>
					</dl>
					<?php
					if (in_array($tpl['option_arr']['o_bf_include_name'], array(2, 3)) && $controller->_post->check('customer_name'))
					{
						if($controller->_post->toString('customer_name') != '')
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_name'); ?></dt>
								<dd class="content"><?php echo pjSanitize::html($controller->_post->toString('customer_name')); ?></dd>
							</dl>
							<?php
						}
					}
					if (in_array($tpl['option_arr']['o_bf_include_email'], array(2, 3)) && $controller->_post->check('customer_email'))
					{
						if($controller->_post->toString('customer_email') != '')
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_email'); ?></dt>
								<dd class="content"><?php echo pjSanitize::html($controller->_post->toString('customer_email')); ?></dd>
							</dl>
							<?php
						}
					}
					if (in_array($tpl['option_arr']['o_bf_include_phone'], array(2, 3)) && $controller->_post->check('customer_phone'))
					{
						if($controller->_post->toString('customer_phone') != '')
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_phone'); ?></dt>
								<dd class="content"><?php echo pjSanitize::html($controller->_post->toString('customer_phone')); ?></dd>
							</dl>
							<?php
						}
					}
					if (in_array($tpl['option_arr']['o_bf_include_country'], array(2, 3)) && $controller->_post->check('customer_country'))
					{
						if($controller->_post->toInt('customer_country') > 0)
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_country'); ?></dt>
								<dd class="content">
								<?php
								if (isset($tpl['country_arr']) && is_array($tpl['country_arr']))
								{
									foreach ($tpl['country_arr'] as $v)
									{
										if ($controller->_post->toInt('customer_country') == $v['id'])
										{
											echo htmlspecialchars($v['country_title']);
											break;
										}
									}
								}
								?>
								</dd>
							</dl>
							<?php
						}
					}
					if (in_array($tpl['option_arr']['o_bf_include_city'], array(2, 3)) && $controller->_post->check('customer_city'))
					{
						if($controller->_post->toString('customer_city') != '')
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_city'); ?></dt>
								<dd class="content"><?php echo pjSanitize::html($controller->_post->toString('customer_city')); ?></dd>
							</dl>
							<?php
						}
					}
					if (in_array($tpl['option_arr']['o_bf_include_state'], array(2, 3)) && $controller->_post->check('customer_state'))
					{
						if($controller->_post->toString('customer_state') != '')
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_state'); ?></dt>
								<dd class="content"><?php echo pjSanitize::html($controller->_post->toString('customer_state')); ?></dd>
							</dl>
							<?php
						}
					}
					if (in_array($tpl['option_arr']['o_bf_include_zip'], array(2, 3)) && $controller->_post->check('customer_zip'))
					{
						if($controller->_post->toString('customer_zip') != '')
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_zip'); ?></dt>
								<dd class="content"><?php echo pjSanitize::html($controller->_post->toString('customer_zip')); ?></dd>
							</dl>
							<?php
						}
					}
					if (in_array($tpl['option_arr']['o_bf_include_address'], array(2, 3)) && $controller->_post->check('customer_address'))
					{
						if($controller->_post->toString('customer_address') != '')
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_address'); ?></dt>
								<dd class="content"><?php echo pjSanitize::html($controller->_post->toString('customer_address')); ?></dd>
							</dl>
							<?php
						}
					}
					if (in_array($tpl['option_arr']['o_bf_include_notes'], array(2, 3)) && $controller->_post->check('customer_notes'))
					{
						if($controller->_post->toString('customer_notes') != '')
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_notes'); ?></dt>
								<dd class="content"><?php echo nl2br(htmlspecialchars($controller->_post->toString('customer_notes'))); ?></dd>
							</dl>
							<?php
						}
					}
					if ($tpl['option_arr']['o_payment_disable'] == 'No')
					{
						if (isset($tpl['amount']['price']) && (float) $tpl['amount']['price'] > 0)
						{
							?>
							<dl class="dl-horizontal">
								<dt class="title"><?php __('front_label_payment_method'); ?></dt>
								<dd class="content"><?php echo $controller->_post->check('payment_method') ? $payment_methods[$controller->_post->toString('payment_method')] : NULL; ?></dd>
							</dl>
							<?php
							if ($controller->_post->toString('payment_method') == 'bank')
							{
								?>
								<dl class="dl-horizontal">
									<dt class="title">&nbsp;</dt>
									<dd class="content ebc-overflow"><?php echo nl2br($tpl['bank_account']);?></dd>
								</dl>
								<?php
							}
						}
					}
					?>
					<p id="pjEbcErrorMessage_<?php echo $index;?>" class="pjEbcError pjEbcErrorMessage" style="display: none"></dl>
					<p id="pjEbcMessageContainer_<?php echo $index; ?>" style="display:none;"><?php echo $front_messages[5]; ?></dl>
					<div>
						<label class="title pjEbcActions">&nbsp;</label>
						<input type="submit" value="<?php __('front_button_submit'); ?>" class="pjEbcButton btn btn-primary"/>
						<input type="button" value="<?php __('front_button_cancel'); ?>" class="pjEbcButton btn btn-primary pjEbcCancelSummary"/>
					</div>
				</div>
			</form>
		</div>
	</div>
<?php } ?>