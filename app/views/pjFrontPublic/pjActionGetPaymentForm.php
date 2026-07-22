<?php 
$index = $controller->_get->toString('index');
if (isset($tpl['status']) && $tpl['status'] == 'IP_BLOCKED') {
	?>
	<h4 class="text-danger text-center"><?php __('front_ip_address_blocked');?></h4>
	<?php 
} else {
	if($controller->_get->toString('view') != 'calendar')
	{
		include_once PJ_VIEWS_PATH . 'pjFrontPublic/elements/header.php';
	}
	?>
	<div class="pjEbcBookingWrapper pjEbcBookingForm">
		<div class="pjEbcFormContainer">
			<div class="pjEbcFormBody">
				<?php
				$front_message = __('front_message', true);
				if (isset($tpl['booking_arr']['payment_method']))
				{
					if($tpl['booking_arr']['booking_deposit'] > 0)
					{
						if(isset($tpl['params']['plugin']) && !empty($tpl['params']['plugin']))
						{
							$payment_messages = __('payment_plugin_messages');
							?>
							<div id="pjOnlinePaymentFormWrap">
								<?php echo isset($payment_messages[$tpl['booking_arr']['payment_method']]) ? $payment_messages[$tpl['booking_arr']['payment_method']]: $front_message[8]; ?><br/>
								<?php
								if (pjObject::getPlugin($tpl['params']['plugin']) !== NULL)
								{
									$controller->requestAction(array('controller' => $tpl['params']['plugin'], 'action' => 'pjActionForm', 'params' => $tpl['params']));
								}
								?>
							</div>
							<?php
						}else{
							?>
							<div>
								<?php
								switch ($tpl['booking_arr']['payment_method'])
								{
									case 'bank':
										echo $front_message[6] . '<br/>' .  nl2br(pjSanitize::html($tpl['bank_account']));
										break;
									case 'creditcard':
									case 'cash':
									default:
										echo $front_message[6];
										break;
								}
								?>
							</div>
							<?php
						}
					}else{
						?><p><?php echo $front_message[6]; ?></p><?php
					}
				}else{
					?><p><?php echo $front_message[6]; ?></p><?php
				}
				?>
			</div>
		</div>
	</div>
<?php } ?>