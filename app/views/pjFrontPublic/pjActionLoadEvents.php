<br/>
<?php
if (isset($tpl['status']) && $tpl['status'] == 'IP_BLOCKED') {
	?>
	<h4 class="text-danger text-center"><?php __('front_ip_address_blocked');?></h4>
	<?php 
} else {
	include_once PJ_VIEWS_PATH . 'pjFrontPublic/elements/header.php';
	if($controller->_get->toString('view') == 'monthly'){
		include_once PJ_VIEWS_PATH . 'pjFrontPublic/elements/monthly.php';
	}else if($controller->_get->toString('view') == 'calendar'){
		$month = $controller->_get->toString('month');
		$year = $controller->_get->toString('year');
		?>
		<div id="pjEbcTableCalendar_<?php echo $controller->_get->toString('index'); ?>" class="pjIcContainer">
			<div class="pjIcCalendar">
				<?php 
				echo $tpl['calendar']->getMonthHTML((int) $month, $year);
				?>
			</div>
		</div>
		<div id="pjEbcEventDetail_<?php echo $controller->_get->toString('index');?>"></div>
		<?php
		//include_once PJ_VIEWS_PATH . 'pjFrontPublic/elements/calendar.php';
	}else if($controller->_get->toString('view') == 'list'){
		include_once PJ_VIEWS_PATH . 'pjFrontPublic/elements/list.php';
	}
}
?>