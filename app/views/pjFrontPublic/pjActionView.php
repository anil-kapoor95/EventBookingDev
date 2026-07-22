<?php
if (isset($tpl['status']) && $tpl['status'] == 'IP_BLOCKED') {
	?>
	<h4 class="text-danger text-center"><?php __('front_ip_address_blocked');?></h4>
	<?php 
} else {
	include_once PJ_VIEWS_PATH . 'pjFront/elements/'.$controller->_get->toString('layout').'/view.php';
}
?>