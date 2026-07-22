<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-10">
                <h2><?php __('infoEventsTitle', false, true);?></h2>
            </div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php __('infoEventsDesc', false, true);?></p>
    </div><!-- /.col-md-12 -->
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
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
    	?>
        <div class="ibox float-e-margins">
            <div class="ibox-content">
                <div class="row m-b-md">
                	<?php if ($tpl['has_create']) { ?>
	                    <div class="col-md-4">
	                    	<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionCreate" class="btn btn-primary"><i class="fa fa-plus"></i> <?php __('btnAddEvent') ?></a>
	                    </div><!-- /.col-md-6 -->
					<?php } ?>
                    <div class="col-md-4 col-sm-8">
                        <form action="" method="get" class="form-horizontal frm-filter">
                            <div class="input-group">
                                <input type="text" name="q" placeholder="<?php __('plugin_base_btn_search', false, true); ?>" class="form-control">
                                <div class="input-group-btn">
                                    <button class="btn btn-primary" type="submit">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div><!-- /.col-md-4 -->
                    <?php
                	$filter = __('filter', true);
                	?>
                    <div class="col-md-4 text-right">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-primary btn-all active"><?php __('lblAll'); ?></button>
                            <button type="button" class="btn btn-default btn-filter" data-column="status" data-value="T"><i class="fa fa-check m-r-xs"></i><?php echo $filter['active']; ?></button>
                            <button type="button" class="btn btn-default btn-filter" data-column="status" data-value="F"><i class="fa fa-times m-r-xs"></i><?php echo $filter['inactive']; ?></button>
                        </div>
                    </div>
                </div><!-- /.row -->
				
				<div id="grid"></div>
            </div>
        </div>
    </div><!-- /.col-lg-12 -->
</div>

<script type="text/javascript">
var pjGrid = pjGrid || {};
var myLabel = myLabel || {};
myLabel.image = <?php x__encode('lblImage'); ?>;
myLabel.eventdate = "<?php __('lblEventDate'); ?>";
myLabel.eventtime = "<?php __('lblEventTime'); ?>";
myLabel.eventtitle = "<?php __('lblEventTitle'); ?>";
myLabel.bookings = "<?php __('lblEventBookings'); ?>";
myLabel.tickets = "<?php __('lblEventTickets'); ?>";
myLabel.copy = "<?php __('lblCopyEvent'); ?>";
myLabel.revert_status = "<?php __('revert_status'); ?>";
myLabel.exported = "<?php __('lblExport'); ?>";
myLabel.status = <?php x__encode('lblStatus'); ?>;
myLabel.active = <?php x__encode('filter_ARRAY_active'); ?>;
myLabel.inactive = <?php x__encode('filter_ARRAY_inactive'); ?>;
myLabel.delete_selected = <?php x__encode('plugin_base_delete_selected'); ?>;
myLabel.delete_confirmation = <?php x__encode('plugin_base_delete_confirmation'); ?>;

myLabel.has_create = <?php echo (int) $tpl['has_create']; ?>;
myLabel.has_update = <?php echo (int) $tpl['has_update']; ?>;
myLabel.has_delete = <?php echo (int) $tpl['has_delete']; ?>;
myLabel.has_delete_bulk = <?php echo (int) $tpl['has_delete_bulk']; ?>;
myLabel.has_export = <?php echo (int) $tpl['has_export']; ?>;
myLabel.has_revert_status = <?php echo (int) $tpl['has_revert_status']; ?>;

myLabel.alert_delete_event_title = <?php x__encode('lblDeleteEventTitle'); ?>;
myLabel.alert_delete_event_text = <?php x__encode('lblDeleteEventBody'); ?>;
myLabel.alert_delete_recurring_event_title = <?php x__encode('lblDeleteRecurringEventTitle'); ?>;
myLabel.alert_delete_recurring_event_text = <?php x__encode('lblDeleteRecurringEventBody'); ?> + '<br/><br/><div class="row form-group"><label class="control-label col-xs-6 text-right"><?php __('lblDeleteAll');?>:</label><div class="col-xs-6 text-left"><div class="switch onoffswitch-data pull-left"><div class="onoffswitch onoffswitch-delete-all-receurring"><input type="checkbox" class="onoffswitch-checkbox" value="1" id="delete_all_recurring" name="delete_all_recurring"><label class="onoffswitch-label" for="delete_all_recurring"><span class="onoffswitch-inner" data-on="<?php __('_yesno_ARRAY_T', false, true);?>" data-off="<?php __('_yesno_ARRAY_F', false, true);?>"></span><span class="onoffswitch-switch"></span></label></div></div></div></div>';
myLabel.btn_delete = <?php x__encode('btnDelete'); ?>;
myLabel.btn_cancel = <?php x__encode('btnCancel'); ?>;
</script>