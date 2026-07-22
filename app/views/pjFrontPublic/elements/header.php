<?php
if (isset($tpl['locale_arr']) && is_array($tpl['locale_arr']) && !empty($tpl['locale_arr']) && count($tpl['locale_arr']) > 1)
{
	$selected_title = null;
	$selected_src = NULL;
	foreach ($tpl['locale_arr'] as $locale)
	{
		if($controller->getLocaleId() == $locale['id'])
		{
			$selected_title = $locale['language_iso'];
			$lang_iso = explode("-", $selected_title);
			if(isset($lang_iso[1]))
			{
				$selected_title = $lang_iso[1];
			}
			if (!empty($locale['flag']) && is_file(PJ_INSTALL_PATH . $locale['flag']))
			{
				$selected_src = PJ_INSTALL_URL . $locale['flag'];
			} elseif (!empty($locale['file']) && is_file(PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'])) {
				$selected_src = PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'];
			}
			break;
		}
	}
	?>
	<div class="clearfix">
		<div class="dropdown pull-left">
			<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenuLang" data-pj-toggle="dropdown" aria-expanded="true">
				<img src="<?php echo $selected_src; ?>" alt="">
				<span class="pjIcDropdownInner"><?php echo $selected_title;?></span>
				<span class="caret"></span>
			</button>
			<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenuLang">
				<?php
				foreach ($tpl['locale_arr'] as $locale)
				{
					$selected_src = NULL;
					if (!empty($locale['flag']) && is_file(PJ_INSTALL_PATH . $locale['flag']))
					{
						$selected_src = PJ_INSTALL_URL . $locale['flag'];
					} elseif (!empty($locale['file']) && is_file(PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'])) {
						$selected_src = PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'];
					}
					?>
					<li role="presentation">
						<a href="#" class="pjEbcLocale<?php echo $controller->getLocaleId() == $locale['id'] ? ' pjEbcLocaleActive' : NULL; ?>" rel="<?php echo $locale['id']; ?>" data-id="<?php echo $locale['id']; ?>" title="<?php echo htmlspecialchars($locale['title']); ?>">
							<img src="<?php echo $selected_src; ?>" alt="">
							<?php echo pjSanitize::html($locale['name']); ?>
						</a>
					</li>
					<?php
				} 
				?>
			</ul>
		</div>
	</div>
	<br/>
	<?php
} 
?>
<?php
$show_header = 1;
if(in_array($controller->_get->toString('view'), array('monthly', 'list')) && in_array($controller->_get->toString('action'), array('pjActionLoadBookingForm', 'pjActionLoadBookingSummary', 'pjActionGetPaymentForm')))
{
	$show_header = 0;
}
if($controller->_get->check('show_header') && $controller->_get->toInt('show_header') == 1 && $show_header == 1 )
{ 
	?>
	<div class="clearfix">
		<?php
		
		if($controller->_get->check('show_categories') && $controller->_get->toInt('show_categories') == 1 && isset($tpl['category_arr']) && count($tpl['category_arr']) > 0 && ($controller->_get->toString('action') == 'pjActionLoadEvents' && !$controller->_get->check('event_id')))
		{ 
			$select_label = '--  ' . __('front_label_choose', true) . ' --';
			foreach($tpl['category_arr'] as $v)
			{
				if($controller->_get->check('category_id'))
				{
					if($controller->_get->toInt('category_id') > 0 && $v['id'] == $controller->_get->toInt('category_id'))
					{
						$select_label = $v['category_name'];
					}
				}
			}
			?>
			<div class="dropdown pull-left pjEbcIcons">
				<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-pj-toggle="dropdown" aria-expanded="true">
					<span id="pjPecDropDown_<?php echo $controller->_get->toString('index');?>" class="pjIcDropdownInner"><?php echo $select_label;?></span>
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
					<li role="presentation"><a class="pjEbcCategory" role="menuitem" tabindex="-1" href="#" data-id="0">-- <?php __('front_label_choose');?> --</a></li>
					<?php
					foreach($tpl['category_arr'] as $v)
					{	
						?><li role="presentation"><a class="pjEbcCategory" role="menuitem" tabindex="-1" href="#" data-id="<?php echo $v['id']?>"><?php echo pjSanitize::html($v['category_name'])?></a></li><?php
					} 
					?>
				</ul>
			</div>
			<?php
		} 
		if($controller->_get->check('show_icons') && $controller->_get->toInt('show_icons') == 1)
		{
			?>
			<div class="btn-group pull-right pjEbcIcons" role="group" aria-label="...">
				<?php
				if($tpl['option_arr']['o_enable_monthly_view'] == 'Yes')
				{ 
					?><a href="#" class="btn btn-default pjEbcIcon<?php echo $controller->_get->toString('view') == 'monthly' ? ' active' : null;?>" data-view="monthly" title="<?php __('front_label_monthly_view');?>"><span class="glyphicon glyphicon-th-list"></span></a><?php
				} 
				?>
				<a href="#" data-view="calendar" class="btn btn-default pjEbcIcon<?php echo $controller->_get->toString('view') == 'calendar' ? ' active' : null;?>" title="<?php __('front_label_calendar_view');?>"><span class="glyphicon glyphicon-calendar"></span></a>
				<?php
				if($tpl['option_arr']['o_enable_list_view'] == 'Yes')
				{ 
					?><a href="#" data-view="list" class="btn btn-default pjEbcIcon<?php echo $controller->_get->toString('view') == 'list' ? ' active' : null;?>" title="<?php __('front_label_list_view');?>"><span class="glyphicon glyphicon-list"></span></a><?php
				} 
				?>
			</div>
			<?php
		} 
		?>
	</div>
	<?php
} 
?>