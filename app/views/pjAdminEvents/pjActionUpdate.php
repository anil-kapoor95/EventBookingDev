<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php __('infoUpdateEventTitle');?></h2>
            </div>
            <div class="col-lg-3 col-md-4 col-sm-6 btn-group-languages">
                <?php if ($tpl['is_flag_ready']) : ?>
				<div class="multilang"></div>
				<?php endif; ?>
        	</div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php __('infoUpdateEventDesc');?></p>
    </div><!-- /.col-md-12 -->
</div>
<?php
$time_format = 'HH:mm';
if((strpos($tpl['option_arr']['o_time_format'], 'a') > -1))
{
    $time_format = 'hh:mm a';
}
if((strpos($tpl['option_arr']['o_time_format'], 'A') > -1))
{
    $time_format = 'hh:mm A';
}
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);
$bs = __('booking_statuses', true);
?>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
		<div class="col-lg-12">
			<?php
	    	$error_code = $controller->_get->toString('err');
	    	if (!empty($error_code))
	    	{
	    	    $titles = __('error_titles', true);
	    	    $bodies = __('error_bodies', true);
	    	    switch (true)
	    	    {
	    	        case in_array($error_code, array('AE01', 'AE03')):
	    	            ?>
	    				<div class="alert alert-success">
	    					<i class="fa fa-check m-r-xs"></i>
	    					<strong><?php echo @$titles[$error_code]; ?></strong>
	    					<?php echo @$bodies[$error_code]?>
	    				</div>
	    				<?php
	    				break;
	                case in_array($error_code, array('AE04', 'AE05', 'AE08', 'AE09', 'AE10', 'AE11', 'AE12', 'AE13')):
	                    $bodies_text = str_replace("{SIZE}", ini_get('post_max_size'), @$bodies[$error_code]);
	    				?>
	    				<div class="alert alert-danger">
	    					<i class="fa fa-exclamation-triangle m-r-xs"></i>
	    					<strong><?php echo @$titles[$error_code]; ?></strong>
	    					<?php echo $bodies_text;?>
	    				</div>
	    				<?php
	    				break;
	    		}
	    	}
        	
        	$active_tab = $controller->_get->check('tab') ? $controller->_get->toString('tab') : 'details';
        	?>
			<div id="dateTimePickerOptions" style="display:none;" data-wstart="<?php echo (int) $tpl['option_arr']['o_week_start']; ?>" data-dateformat="<?php echo pjUtil::toMomemtJS($tpl['option_arr']['o_date_format']); ?>" data-format="<?php echo pjUtil::toMomemtJS($tpl['option_arr']['o_date_format']); ?> <?php echo $time_format;?>" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>"></div>
			<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionUpdate" method="post" id="frmUpdateEvent" class="form pj-form" enctype="multipart/form-data">
        		<input type="hidden" name="event_update" value="1" />
        		<input type="hidden" name="csrf_token" value="<?php echo pjAppController::getCsrfToken(); ?>" />
        		<input type="hidden" name="tab" value="<?php echo $active_tab;?>" />
				<input type="hidden" name="id" id="event_id" value="<?php echo $tpl['arr']['id']; ?>" />
				<input type="hidden" name="recurring_id" value="<?php echo $tpl['arr']['recurring_id']; ?>" />
				<input type="hidden" id="num_prices" name="num_prices" value="<?php echo count($tpl['price_arr']) == 0 ? 1 : count($tpl['price_arr']);?>" />
				<input type="hidden" id="index_arr" name="index_arr" value="" />
				<input type="hidden" id="remove_arr" name="remove_arr" value="" />
				<div class="tabs-container tab-update-event">
					<div class="tabs-left">
						<ul class="nav nav-tabs">
							<li class="<?php echo $active_tab == 'details' ? 'active' : NULL;?>"><a class="tab-details" data-toggle="tab" data-tab="details" href="#details" aria-expanded="true"><?php __('tabDetails');?></a></li>
							<li class="<?php echo $active_tab == 'confirmation' ? 'active' : NULL;?>"><a class="tab-confirmation" data-toggle="tab" data-tab="confirmation" href="#confirmation" aria-expanded="false"><?php __('tabConfirmation');?></a></li>
							<li class="<?php echo $active_tab == 'terms' ? 'active' : NULL;?>"><a class="tab-terms" data-toggle="tab" data-tab="terms" href="#terms" aria-expanded="false"><?php __('tabTerms');?></a></li>
							<li class="<?php echo $active_tab == 'ticket' ? 'active' : NULL;?>"><a class="tab-ticket" data-toggle="tab" data-tab="ticket" href="#ticket" aria-expanded="false"><?php __('tabTicket');?></a></li>
							<li class="<?php echo $active_tab == 'bookings' ? 'active' : NULL;?>"><a class="tab-bookings" data-toggle="tab" data-tab="bookings" href="#bookings" aria-expanded="false"><?php __('tabBookings');?></a></li>
							<li class="<?php echo $active_tab == 'used_tickets' ? 'active' : NULL;?>"><a class="tab-used_tickets" data-toggle="tab" data-tab="used_tickets" href="#used_tickets" aria-expanded="false"><?php __('tabUsedTickets');?></a></li>
							<li class="<?php echo $active_tab == 'install' ? 'active' : NULL;?>"><a class="tab-install" data-toggle="tab" data-tab="install" href="#install" aria-expanded="false"><?php __('tabInstall');?></a></li>
						</ul>
						<div class="tab-content tab-main-details">
							<?php
							include PJ_VIEWS_PATH . 'pjAdminEvents/elements/details.php';                        	
							include PJ_VIEWS_PATH . 'pjAdminEvents/elements/confirmation.php';
							include PJ_VIEWS_PATH . 'pjAdminEvents/elements/terms.php'; 
							include PJ_VIEWS_PATH . 'pjAdminEvents/elements/ticket.php';
							include PJ_VIEWS_PATH . 'pjAdminEvents/elements/bookings.php';                        	
							include PJ_VIEWS_PATH . 'pjAdminEvents/elements/used_tickets.php';                        	
							include PJ_VIEWS_PATH . 'pjAdminEvents/elements/install.php'; 
							?>
						</div><!-- /.tab-content -->
					</div><!-- /.tabs-left -->
					
					<div class="tabs-left">
						<ul class="nav nav-tabs">
							<li><a>&nbsp;</a></li>
						</ul>
						<div class="tab-content tab-actions">
							<div id="actions" class="tab-pane active">
								<div class="panel-body">
        							<div class="panel-body-inner" style="display: <?php echo in_array($active_tab, array('bookings','used_tickets','install')) ? 'none' : '';?>">
        								<?php
										if($tpl['number_of_events'] > 1)
										{ 
											$text_apply = str_replace('{numevents}', $tpl['number_of_events'], __('lblApplyRecurring', true));
											?> 
											<div class="form-group">
												<label class="control-label"><?php echo $text_apply;?></label>
											
												<div class="clearfix">
													<div class="switch onoffswitch-data pull-left">
														<div class="onoffswitch onoffswitch-apply-recurring">
															<input type="checkbox" class="onoffswitch-checkbox" value="1" id="apply_recurring" name="apply_recurring" >
															<label class="onoffswitch-label" for="apply_recurring">
																<span class="onoffswitch-inner" data-on="<?php __('_yesno_ARRAY_T', false, true);?>" data-off="<?php __('_yesno_ARRAY_F', false, true);?>"></span>
																<span class="onoffswitch-switch"></span>
															</label>
														</div>
													</div>
												</div><!-- /.clearfix -->
											</div>
											<?php
										} 
										?>
										<div class="hr-line-dashed"> </div> 
        								<div class="clearfix">
											<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in" style="margin-right: 15px;">
												<span class="ladda-label"><?php __('btnSave'); ?></span>
												<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
											</button>
											<a type="button" class="btn btn-white btn-lg pull-right" href="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminEvents&action=pjActionIndex"><?php __('btnCancel'); ?></a>
										</div>
										<!-- /.clearfix --> 
        							</div>
        						</div>
							</div>
						</div>
					</div>
				</div><!-- /.tabs-container -->	
			</form>
		</div><!-- /.col-lg-12 -->
	</div><!-- /.row -->
</div><!-- /.wrapper wrapper-content animated fadeInRight -->

<table style="display:none;">
    <tbody id="ebc_price_clone">
        <tr class="ebc-price-row" data-index="{INDEX}">            
            <td>
                <?php
            	foreach ($tpl['lp_arr'] as $v)
            	{
                	?>
                    <div class="form-group pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
                        <div class="<?php echo $tpl['is_flag_ready'] ? 'input-group' : '';?>" data-index="<?php echo $v['id']; ?>">
							<input type="text" name="i18n[<?php echo $v['id']; ?>][name][{INDEX}]" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' ebcRequired required'; ?>" lang="<?php echo $v['id']; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>"/>	
							<?php if ($tpl['is_flag_ready']) : ?>
							<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
							<?php endif; ?>
						</div>
                    </div>
                    <?php
                }
                ?>
            </td>

            <td>
            	<div class="form-group">
                    <div class="input-group pjFdEventPrice">
                        <input type="text" name="price[{INDEX}]" class="form-control number" data-msg-number="<?php __('prices_invalid_price', false, true);?>"/>
    
                        <span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']); ?></span> 
                    </div>
                </div>
            </td>
            
            <td>
				<div class="form-group">
					<input class="required" value="5" type="text" name="available[{INDEX}]" id="available_{INDEX}" data-msg-required="<?php __('ebc_field_required');?>" />
				</div>
			</td>

			<td>
				<div class="form-group">
					<input value="0" type="text" name="max_purchase[{INDEX}]" id="max_purchase_{INDEX}" />
				</div>
			</td>

            <td>
                <div class="m-t-xs text-right">
                    <a href="#" class="btn btn-danger btn-outline btn-sm btn-delete pj-remove-price"><i class="fa fa-trash"></i></a>
                </div>
            </td>
        </tr>

    </tbody>
</table>
	
<style>
    table .form-group{
        margin-bottom: 0px !important;
    }
</style>

<?php if ($tpl['is_flag_ready']) : ?>
<script type="text/javascript">
var pjCmsLocale = pjCmsLocale || {};
pjCmsLocale.langs = <?php echo $tpl['locale_str']; ?>;
pjCmsLocale.flagPath = "<?php echo PJ_FRAMEWORK_LIBS_PATH; ?>pj/img/flags/";
</script>
<?php endif; ?>
<script type="text/javascript">
var pjGrid = pjGrid || {};
pjGrid.queryString = "";
pjGrid.queryString += "&event_id=<?php echo $tpl['arr']['id']; ?>";

var myLabel = myLabel || {};
myLabel.localeId = "<?php echo $controller->getLocaleId(); ?>";
myLabel.invalid_from_dt = <?php x__encode('event_invalid_datetime_from');?>;
myLabel.invalid_to_dt = <?php x__encode('event_invalid_datetime_to');?>;
myLabel.alert_delete_event_image_title = <?php x__encode('lblDeleteImageTitle'); ?>;
myLabel.alert_delete_event_image_text = <?php x__encode('lblDeleteImageBody'); ?>;
myLabel.alert_delete_event_images_text = <?php x__encode('lblDeleteAllImagesBody'); ?>;
myLabel.alert_delete_ticket_image_title = <?php x__encode('lblDeleteTicketImageTitle'); ?>;
myLabel.alert_delete_ticket_image_text = <?php x__encode('lblDeleteTicketImageBody'); ?>;
myLabel.btn_delete = <?php x__encode('btnDelete'); ?>;
myLabel.btn_cancel = <?php x__encode('btnCancel'); ?>;

myLabel.booking_id = "<?php __('lblID'); ?>";
myLabel.name = "<?php __('lblBookingName'); ?>";
myLabel.email = "<?php __('lblBookingEmail'); ?>";
myLabel.eventdate = "<?php __('lblEventDate'); ?>";
myLabel.tickets = "<?php __('lblBookingTickets'); ?>";
myLabel.price = "<?php __('lblBookingPrice'); ?>";
myLabel.ticket_type = "<?php __('lblTicketType'); ?>";
myLabel.used_tickets = "<?php __('lblUsedTickets'); ?>";
myLabel.delete_selected = <?php x__encode('plugin_base_delete_selected'); ?>;
myLabel.delete_confirmation = <?php x__encode('plugin_base_delete_confirmation'); ?>;
myLabel.status = "<?php __('lblStatus'); ?>";
myLabel.resend = "<?php __('lblResendConfirmation'); ?>";
myLabel.print_tickets = "<?php __('lblPrintTickets');?>";
myLabel.ticket_url = "<?php echo PJ_INSTALL_URL . PJ_UPLOAD_PATH . '/tickets/pdfs/p_';?>";
myLabel.pending = "<?php echo $bs['pending']; ?>";
myLabel.confirmed = "<?php echo $bs['confirmed']; ?>";
myLabel.cancelled = "<?php echo $bs['cancelled']; ?>";
myLabel.exportSelected = "<?php __('lblExportSelected'); ?>";
myLabel.has_create_booking = <?php echo (int) $tpl['has_create_booking']; ?>;
myLabel.has_update_booking = <?php echo (int) $tpl['has_update_booking']; ?>;
myLabel.has_delete_booking = <?php echo (int) $tpl['has_delete_booking']; ?>;
myLabel.has_delete_bulk_booking = <?php echo (int) $tpl['has_delete_bulk_booking']; ?>;
myLabel.has_export_booking = <?php echo (int) $tpl['has_export_booking']; ?>;
</script>