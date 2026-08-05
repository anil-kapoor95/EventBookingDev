<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php __('infoAddEventTitle');?></h2>
            </div>
            <div class="col-lg-3 col-md-4 col-sm-6 btn-group-languages">
                <?php if ($tpl['is_flag_ready']) : ?>
				<div class="multilang"></div>
				<?php endif; ?>
        	</div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('infoAddEventDesc');?></p>
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
?>
<div id="dateTimePickerOptions" style="display:none;" data-wstart="<?php echo (int) $tpl['option_arr']['o_week_start']; ?>" data-dateformat="<?php echo pjUtil::toMomemtJS($tpl['option_arr']['o_date_format']); ?>" data-format="<?php echo pjUtil::toMomemtJS($tpl['option_arr']['o_date_format']); ?> <?php echo $time_format;?>" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>"></div>
<div class="row wrapper wrapper-content animated fadeInRight">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
                <form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionCreate" method="post" id="frmCreateEvent" autocomplete="off" enctype="multipart/form-data">
            		<input type="hidden" name="event_create" value="1" />
            		<input type="hidden" name="csrf_token" value="<?php echo pjAppController::getCsrfToken(); ?>" />
            		<input type="hidden" name="event_create" value="1" />
					<input type="hidden" id="time_flag" name="time_flag" value="0" />
					<input type="hidden" id="num_prices" name="num_prices" value="1" />
					<input type="hidden" id="copy" name="copy" value="<?php echo $controller->_get->check('id') ? $controller->_get->toInt('id') : 0;?>" />
					<input type="hidden" id="copy_image" name="copy_image" value="1" />
					<input type="hidden" id="index_arr" name="index_arr" value="" />
					<input type="hidden" id="remove_arr" name="remove_arr" value="" />
                    
                    <div class="row">
                    	<div class="col-md-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('lblStatus'); ?></label>
							
								<div class="clearfix">
									<div class="switch onoffswitch-data pull-left">
										<div class="onoffswitch onoffswitch-order">
											<input type="checkbox" class="onoffswitch-checkbox" id="status" name="status" checked>
											<label class="onoffswitch-label" for="status">
												<span class="onoffswitch-inner" data-on="<?php __('filter_ARRAY_active', false, true);?>" data-off="<?php __('filter_ARRAY_inactive', false, true);?>"></span>
												<span class="onoffswitch-switch"></span>
											</label>
										</div>
									</div>
								</div><!-- /.clearfix -->
							</div>
							
							<div class="row">
								<div class="col-lg-6">
									<div class="form-group">
										<label class="control-label"><?php __('lblStartDateTime'); ?></label>
										<div class="input-group">
											<input type="text" name="event_start_ts" id="event_start_ts" data-wt="open" readonly="readonly" class="form-control datetimepick required" data-msg-required="<?php __('ebc_field_required');?>"/>
											
											<span class="input-group-addon">
												<i class="fa fa-calendar"></i>
											</span>
										</div><!-- /.input-group date -->										
									</div>
								</div>
								
								<div class="col-lg-6">
									<div class="form-group">
										<label class="control-label"><?php __('lblOnlyShowDateForEvent'); ?></label>
									
										<div class="clearfix">
											<div class="switch onoffswitch-data pull-left">
												<div class="onoffswitch onoffswitch-order">
													<input type="checkbox" class="onoffswitch-checkbox" id="o_show_start_time" name="o_show_start_time">
													<label class="onoffswitch-label" for="o_show_start_time">
														<span class="onoffswitch-inner" data-on="<?php __('_yesno_ARRAY_T', false, true);?>" data-off="<?php __('_yesno_ARRAY_F', false, true);?>"></span>
														<span class="onoffswitch-switch"></span>
													</label>
												</div>
											</div>
										</div><!-- /.clearfix -->
									</div>
								</div>								
							</div>

							<div class="row">
								<div class="col-lg-6">
									<div class="form-group">
										<label class="control-label"><?php __('lblEndDateTime'); ?></label>
										<div class="input-group">
											<input type="text" name="event_end_ts" id="event_end_ts" data-wt="open" readonly="readonly" class="form-control datetimepick required" data-msg-required="<?php __('ebc_field_required');?>"/>
											
											<span class="input-group-addon">
												<i class="fa fa-calendar"></i>
											</span>
										</div><!-- /.input-group date -->
									</div>
								</div>
								
								<div class="col-lg-6">
									<div class="form-group">
										<label class="control-label"><?php __('lblOnlyShowDateForEvent'); ?></label>
									
										<div class="clearfix">
											<div class="switch onoffswitch-data pull-left">
												<div class="onoffswitch onoffswitch-order">
													<input type="checkbox" class="onoffswitch-checkbox" id="o_show_end_time" name="o_show_end_time">
													<label class="onoffswitch-label" for="o_show_end_time">
														<span class="onoffswitch-inner" data-on="<?php __('_yesno_ARRAY_T', false, true);?>" data-off="<?php __('_yesno_ARRAY_F', false, true);?>"></span>
														<span class="onoffswitch-switch"></span>
													</label>
												</div>
											</div>
										</div><!-- /.clearfix -->
									</div>
								</div>								
							</div>
							
							<div class="form-group">
                                <label class="control-label"><?php __('lblEventTitle');?></label>
								<?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][title]" value="<?php echo isset($tpl['arr']) ? htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['title'])) : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">	
										<?php if ($tpl['is_flag_ready']) : ?>
										<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
										<?php endif; ?>
									</div>
									<?php 
								}
								?>
                            </div>
                            
							<div class="form-group">
                                <label class="control-label"><?php __('lblLocation');?></label>
								<?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][location]" value="<?php echo isset($tpl['arr']) ? htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['location'])) : NULL; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">	
										<?php if ($tpl['is_flag_ready']) : ?>
										<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
										<?php endif; ?>
									</div>
									<?php 
								}
								?>
                            </div>
                            
                    	</div>
                    	<div class="col-md-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('lblCategory'); ?></label>
								<select name="category_id" id="category_id" class="form-control select-item required" data-msg-required="<?php __('ebc_field_required');?>" data-placeholder="-- <?php __('lblChoose'); ?> --">
									<option value="">-- <?php __('lblChoose'); ?> --</option>
									<?php
									foreach ($tpl['category_arr'] as $v)
									{
										?><option value="<?php echo $v['id']; ?>"<?php echo isset($tpl['arr']) ? ($tpl['arr']['category_id'] == $v['id'] ? ' selected="selected"' : null) : null?>><?php echo pjSanitize::html($v['name']); ?></option><?php
									}
									?>
								</select>
							</div>
							
                    		<div class="form-group">
                                <label class="control-label"><?php __('lblDescription');?></label>
								<?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<textarea id="i18n_description_<?php echo $v['id'];?>" name="i18n[<?php echo $v['id']; ?>][description]"  class="form-control" rows="7"><?php echo isset($tpl['arr']) ? htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['description'])) : NULL; ?></textarea>
										<?php if ($tpl['is_flag_ready']) : ?>
										<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
										<?php endif; ?>
									</div>
									<?php 
								}
								?>
                            </div>
                            
                            <div class="form-group">
                                <label class="control-label"><?php __('lblImage', false, true); ?></label>

                                <div>
                                    <div class="fileinput fileinput-new" data-provides="fileinput">
                                        <span class="btn btn-primary btn-outline btn-file"><span class="fileinput-new"><i class="fa fa-upload"></i> <?php __('lblSelectImage');?></span>
                                        <span class="fileinput-exists"><?php __('lblChangeImage');?></span><input name="event_img" type="file"></span>
                                        <span class="fileinput-filename"></span>

                                        <a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">×</a>
                                    </div>
                                </div>
                            </div><!-- /.form-group -->
                            
                            <?php 
							if (isset($tpl['arr']) && !empty($tpl['arr']['event_medium']) && is_file(PJ_INSTALL_PATH . $tpl['arr']['event_medium']))
							{
								?>
								<div id="boxEventImage" class="form-group">
									<a target="_blank" href="<?php echo PJ_INSTALL_URL . $tpl['arr']['event_img'];?>"><img src="<?php echo PJ_INSTALL_URL . $tpl['arr']['event_medium']; ?>?r=<?php echo rand(1,9999); ?>" alt="" class="align_middle" style="max-width: 180px; margin-right: 10px;"></a>
									<a href="javascript:void(0);" class="btn btn-xs btn-danger btn-outline btnDeleteImage"><i class="fa fa-trash"></i> <?php __('plugin_app_management_btn_delete'); ?></a>
								</div>
								<?php
							} 
							?>
							
                    	</div>
                    </div>
                    
                    <div class="alert alert-success">
    					<div><strong><?php __('infoEventPriceTitle'); ?></strong></div>
    					<?php __('infoEventPriceDesc');?>
    				</div>
    				
    				<div class="row">
                        <div class="col-md-8 col-sm-9">
                            <div class="">
                                <div class="table-responsive table-responsive-secondary">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                            	<th><?php __('lblType');?></th>
                                                <th><?php __('lblPrice');?></th>
                                                <th><?php __('lblAvailable');?></th>
                                                <th><?php __('lblMaxPurchase');?></th>
                                                <th></th>
                                            </tr>
                                        </thead>

                                        <tbody id="ebc_price_list">
                                        	<?php
											if(isset($tpl['price_arr']) && count($tpl['price_arr']) > 0)
											{
												foreach($tpl['price_arr'] as $k => $price)
												{
													$index = 'ebc_' . rand(1, 999999);
													?>
													<tr class="ebc-price-row" data-index="<?php echo $index;?>">
														<td>
															<?php
															foreach ($tpl['lp_arr'] as $v)
															{
																?>
																<div class="form-group pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
																	<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group' : '';?>" data-index="<?php echo $v['id']; ?>">
																		<input type="text" name="i18n[<?php echo $v['id']; ?>][name][<?php echo $index;?>]" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" value="<?php echo htmlspecialchars(stripslashes(@$price['i18n'][$v['id']]['name']));?>" lang="<?php echo $v['id']; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>"/>	
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
																	<input type="text" name="price[<?php echo $index;?>]" value="<?php echo $price['price']; ?>" class="form-control number" data-msg-number="<?php __('prices_invalid_price', false, true);?>"/>
							
																	<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']); ?></span> 
																</div>
															</div>
														</td>
							
														<td>
															<div class="form-group">
																<input class="touchspin3 required" type="text" name="available[<?php echo $index;?>]" id="available_<?php echo $index;?>" value="<?php echo $price['available']; ?>" data-msg-required="<?php __('ebc_field_required');?>" />
															</div>
														</td>

														<td>
															<div class="form-group">
																<input class="touchspin3" type="text" name="max_purchase[<?php echo $index;?>]" id="max_purchase_<?php echo $index;?>" value="<?php echo isset($price['max_purchase']) ? (int) $price['max_purchase'] : 0; ?>" />
															</div>
														</td>

														<td>
															<?php if($k > 0) { ?>
																<div class="m-t-xs text-right">
																	<a href="#" class="btn btn-danger btn-outline btn-sm btn-delete pj-remove-price"><i class="fa fa-trash"></i></a>
																</div>
															<?php } else { ?>
															&nbsp;
															<?php } ?>
														</td>
													</tr>
                                        			<?php 
												}
											} else{
												$index = 'ebc_' . rand(1, 999999);
												?>
	                                            <tr class="ebc-price-row" data-index="<?php echo $index;?>">
	                                                <td>
	                                                    <?php
	                                                	foreach ($tpl['lp_arr'] as $v)
	                                                	{
	                                                    	?>
	                                                        <div class="form-group pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
	                                                            <div class="<?php echo $tpl['is_flag_ready'] ? 'input-group' : '';?>" data-index="<?php echo $v['id']; ?>">
	                        										<input type="text" name="i18n[<?php echo $v['id']; ?>][name][<?php echo $index;?>]" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" value="<?php __('lblRegular');?>" lang="<?php echo $v['id']; ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>"/>	
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
	                                                            <input type="text" name="price[<?php echo $index;?>]" class="form-control number" data-msg-number="<?php __('prices_invalid_price', false, true);?>"/>
	    
	                                                            <span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']); ?></span> 
	                                                        </div>
	                                                    </div>
	                                                </td>
	
													<td>
														<div class="form-group">
															<input class="touchspin3 required" value="5" type="text" name="available[<?php echo $index;?>]" id="available_<?php echo $index;?>" data-msg-required="<?php __('ebc_field_required');?>" />
														</div>
													</td>

													<td>
														<div class="form-group">
															<input class="touchspin3" value="0" type="text" name="max_purchase[<?php echo $index;?>]" id="max_purchase_<?php echo $index;?>" />
														</div>
													</td>

	                                                <td>
	                                                    &nbsp;
	                                                </td>
	                                            </tr>
												<?php } 
											?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div><!-- /.col-sm-7 -->

                        <div class="col-md-4 col-sm-3">
                            <div class="m-t-lg">
                                <a href="#" class="btn btn-primary btn-outline m-t-xs pj-add-price"><i class="fa fa-plus"></i> <?php __('btnAdd'); ?></a>
                            </div>
                        </div><!-- /.col-sm-5 -->
                    </div>
						
					<div class="row">
						<div class="col-md-3 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="control-label"><?php __('lblRepeat'); ?></label>
								<?php $repeat_arr = __('repeatarr', true); ?>
								<select name="repeat" id="repeat" class="form-control">
									<option value="none">-- <?php echo $repeat_arr['none'];?> --</option>
									<option value="daily"><?php echo $repeat_arr['daily'];?></option>
									<option value="weekly"><?php echo $repeat_arr['weekly'];?></option>
									<option value="monthly"><?php echo $repeat_arr['monthly'];?></option>
									<option value="quarterly"><?php echo $repeat_arr['quarterly'];?></option>
									<option value="yearly"><?php echo $repeat_arr['yearly'];?></option>
									<option value="custom"><?php echo $repeat_arr['custom'];?></option>
								</select>
								<small id="repeat_daily" style="display:none;"><?php __('lblRepeatEveryDay');?></small>
								<small id="repeat_weekly" style="display:none;"><?php __('lblRepeatEveryWeek');?></small>
								<small id="repeat_quarterly" style="display:none;"><?php __('lblRepeatEveryQuarter');?></small>
								<small id="repeat_yearly" style="display:none;"><?php __('lblRepeatEveryYear');?></small>
							</div>
						</div>
					</div>
					
					<div class="row repeat_box" style="display:none;">
						<div class="row" id="repeat_monthly" style="display:none;">
							<div class="col-sm-6 col-xs-12">
								<div class="col-sm-6 col-xs-6">
									<div class="form-group">
										<label class="control-label"><?php __('lblOn'); ?></label>
										<select id="repeat-monthly-date" name="repeat-monthly-date" class="form-control">
											<?php
											$monthly_date = __('monthly_date', true); 
											ksort($monthly_date);
											foreach($monthly_date as $k => $v){
												?><option value="<?php echo $k;?>"><?php echo $v;?></option><?php
											}
											?>
										</select>
									</div>
								</div>
								<div class="col-sm-6 col-xs-6">
									<div class="form-group">
										<label class="control-label">&nbsp;</label>
										<p class="m-t-xs"><?php __('lblOfTheMonth');?></p>
									</div>
								</div>
							</div>
							<div class="col-sm-6 col-xs-12">
								<div class="col-xs-4">
									<div class="form-group">
										<label class="control-label"><?php __('lblOrEach'); ?></label>
										<select id="repeat-monthly-each" name="repeat-monthly-each" class="form-control">
											<?php
											$monthly_each = __('monthly_each', true); 
											?>
											<option value="first"><?php echo $monthly_each['first'];?></option>
											<option value="second"><?php echo $monthly_each['second'];?></option>
											<option value="third"><?php echo $monthly_each['third'];?></option>
											<option value="fourth"><?php echo $monthly_each['fourth'];?></option>
										</select>
									</div>
								</div>
								<div class="col-xs-4">
									<div class="form-group">
										<label class="control-label">&nbsp;</label>
										<select id="repeat-monthly-day" name="repeat-monthly-day" class="form-control">
											<?php
											$day_names = __('days', true); 
											ksort($day_names);
											foreach($day_names as $k => $v){
												?><option value="<?php echo $v;?>"><?php echo substr($v, 0, 3);?></option><?php
											}
											?>
										</select>
									</div>
								</div>
								<div class="col-xs-4">
									<div class="form-group">
										<label class="control-label">&nbsp;</label>
										<p class="m-t-xs"><?php __('lblOfTheMonth');?></p>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col-md-3 col-sm-6 col-xs-12" id="repeat_custom" style="display:none;">
							<div class="row">
								<div class="col-md-8 col-sm-7 col-xs-12">
									<div class="form-group">
										<label class="control-label"><?php __('lblEach');?></label>
										<input class="touchspin3" type="text" name="repeat-custom-days" id="repeat-custom-days" data-msg-required="<?php __('ebc_field_required');?>" />							
									</div>
								</div>
								<div class="col-md-4 col-sm-5">
									<div class="form-group">
										<label class="control-label">&nbsp;</label>
										<p class="m-t-xs"><?php __('lblDays');?></p>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col-md-3 col-sm-6">
							<div class="form-group">
								<label class="control-label"><?php __('lblEndRecurringOn');?></label>
								<div class="input-group"> 
									<input type="text" name="end_repeat_date" id="end_repeat_date" class="form-control datepick" readonly="readonly" data-msg-required="<?php __('ebc_field_required');?>" /> 
									<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
								</div>
							</div>
						</div>
						<div class="col-md-3 col-sm-6">
							<div class="form-group">
								<label class="control-label"><?php __('lblOrRepeat');?></label>
								<input class="touchspin3" type="text" name="end_repeat_times" id="end_repeat_times" data-msg-required="<?php __('ebc_field_required');?>" />
								<input type="hidden" name="hidden_recurring_on" id="hidden_recurring_on" class="" data-msg-required="<?php __('lblAtLeastTheseTwo');?>"/>
							</div>
						</div>
						
						<div class="col-md-3 col-sm-6">
							<div class="form-group">
								<label class="control-label">&nbsp;</label>
								<p class="m-t-xs"><?php __('lblTimes');?></p>
							</div>
						</div>
						
					</div>
						
                    <div class="hr-line-dashed"></div>

                    <div class="clearfix">
                        <button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in" style="margin-right: 15px;">
                            <span class="ladda-label"><?php __('btnSave'); ?></span>
                            <?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
                        </button>
                        <a class="btn btn-white btn-lg pull-right" href="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminEvents&action=pjActionIndex"><?php __('btnCancel'); ?></a>
                    </div><!-- /.clearfix -->
                </form>
            </div>
        </div>
    </div><!-- /.col-lg-12 -->
</div>

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
var myLabel = myLabel || {};
myLabel.localeId = "<?php echo $controller->getLocaleId(); ?>";
myLabel.invalid_from_dt = <?php x__encode('event_invalid_datetime_from');?>;
myLabel.invalid_to_dt = <?php x__encode('event_invalid_datetime_to');?>;
</script>