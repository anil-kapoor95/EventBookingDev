<div id="details" class="tab-pane<?php echo $active_tab == 'details' ? ' active' : NULL;?>">
    <div class="panel-body">
        <div class="panel-body-inner">
        	<div class="ibox-content ibox-heading">
				<h3><?php __('infoEventTimeTitle'); ?></h3>
				<small><?php __('infoEventTimeDesc');?></small>
			</div>
        	
			<?php 
			$start_date_time = pjDateTime::formatDate(date('Y-m-d', $tpl['arr']['event_start_ts']), 'Y-m-d', $tpl['option_arr']['o_date_format']) . ' ' . pjDateTime::formatTime(date('H:i:s', $tpl['arr']['event_start_ts']), 'H:i:s', $tpl['option_arr']['o_time_format']);
			$end_date_time = pjDateTime::formatDate(date('Y-m-d', $tpl['arr']['event_end_ts']), 'Y-m-d', $tpl['option_arr']['o_date_format']) . ' ' . pjDateTime::formatTime(date('H:i:s', $tpl['arr']['event_end_ts']), 'H:i:s', $tpl['option_arr']['o_time_format']);
			?>
			<div class="row">
				<div class="col-md-6 col-xs-12">
					<div class="form-group">
						<label class="control-label"><?php __('lblStatus'); ?></label>
					
						<div class="clearfix">
							<div class="switch onoffswitch-data pull-left">
								<div class="onoffswitch onoffswitch-order">
									<input type="checkbox" class="onoffswitch-checkbox" id="status" name="status" <?php echo $tpl['arr']['status'] == 'T' ? 'checked="checked"' : '';?>>
									<label class="onoffswitch-label" for="status">
										<span class="onoffswitch-inner" data-on="<?php __('filter_ARRAY_active', false, true);?>" data-off="<?php __('filter_ARRAY_inactive', false, true);?>"></span>
										<span class="onoffswitch-switch"></span>
									</label>
								</div>
							</div>
						</div><!-- /.clearfix -->
					</div>
					
					<div class="row">
						<div class="col-lg-5">
							<div class="form-group">
								<label class="control-label"><?php __('lblStartDateTime'); ?></label>
								<div class="input-group">
									<input type="text" name="event_start_ts" id="event_start_ts" value="<?php echo $start_date_time;?>" data-wt="open" readonly="readonly" class="form-control datetimepick required" data-msg-required="<?php __('ebc_field_required');?>"/>
									
									<span class="input-group-addon">
										<i class="fa fa-calendar"></i>
									</span>
								</div><!-- /.input-group date -->										
							</div>
						</div>
						
						<div class="col-lg-7">
							<div class="form-group">
								<label class="control-label"><?php __('lblOnlyShowDateForEvent'); ?></label>
							
								<div class="clearfix">
									<div class="switch onoffswitch-data pull-left">
										<div class="onoffswitch onoffswitch-order">
											<input type="checkbox" class="onoffswitch-checkbox" id="o_show_start_time" name="o_show_start_time" <?php echo $tpl['arr']['o_show_start_time'] == 'F' ? 'checked="checked"' : '';?>>
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
						<div class="col-lg-5">
							<div class="form-group">
								<label class="control-label"><?php __('lblEndDateTime'); ?></label>
								<div class="input-group">
									<input type="text" name="event_end_ts" id="event_end_ts" value="<?php echo $end_date_time;?>" data-wt="open" readonly="readonly" class="form-control datetimepick required" data-msg-required="<?php __('ebc_field_required');?>"/>
									
									<span class="input-group-addon">
										<i class="fa fa-calendar"></i>
									</span>
								</div><!-- /.input-group date -->
							</div>
						</div>
						
						<div class="col-lg-7">
							<div class="form-group">
								<label class="control-label"><?php __('lblOnlyShowDateForEvent'); ?></label>
							
								<div class="clearfix">
									<div class="switch onoffswitch-data pull-left">
										<div class="onoffswitch onoffswitch-order">
											<input type="checkbox" class="onoffswitch-checkbox" id="o_show_end_time" name="o_show_end_time" <?php echo $tpl['arr']['o_show_end_time'] == 'F' ? 'checked="checked"' : '';?>>
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
								<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][title]" value="<?php echo htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['title'])); ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">	
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
								<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][location]" value="<?php echo htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['location'])); ?>" data-msg-required="<?php __('ebc_field_required', false, true);?>">	
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
								?><option value="<?php echo $v['id']; ?>"<?php echo $tpl['arr']['category_id'] == $v['id'] ? ' selected="selected"' : null;?>><?php echo pjSanitize::html($v['name']); ?></option><?php
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
								<textarea id="i18n_description_<?php echo $v['id'];?>" name="i18n[<?php echo $v['id']; ?>][description]"  class="form-control" rows="7"><?php echo htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['description'])); ?></textarea>
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
					if (!empty($tpl['arr']['event_medium']) && is_file(PJ_INSTALL_PATH . $tpl['arr']['event_medium']))
					{
						$action_delete_image = 'pjActionDeleteImage';
						if ($tpl['number_of_events'] > 1) {
							$action_delete_image = 'pjActionDeleteAllImages';	
						}
						?>
						<div id="boxEventImage" class="form-group">
							<a target="_blank" href="<?php echo PJ_INSTALL_URL . $tpl['arr']['event_img'];?>"><img src="<?php echo PJ_INSTALL_URL . $tpl['arr']['event_medium']; ?>?r=<?php echo rand(1,9999); ?>" alt="" class="align_middle" style="max-width: 180px; margin-right: 10px;"></a>
							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=<?php echo $action_delete_image;?>&amp;id=<?php echo pjSanitize::html($tpl['arr']['id']);?>" class="btn btn-xs btn-danger btn-outline btnDeleteImage" data-id="<?php echo pjSanitize::html($tpl['arr']['id']);?>" data-recurring="<?php echo $tpl['number_of_events'] > 1 ? 'yes' : 'no';?>"><i class="fa fa-trash"></i> <?php __('plugin_app_management_btn_delete'); ?></a>
						</div>
						<?php
					} 
					?>
				</div>
			</div>
			
			<div class="ibox-content ibox-heading">
				<h3><?php __('infoEventPriceTitle'); ?></h3>
				<small><?php __('infoEventPriceDesc');?></small>
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
									if(count($tpl['price_arr']) > 0)
									{
										$has_bookings = 0;
										if(count($tpl['booking_arr']) > 0)
										{
											$has_bookings = 1;
										}
										foreach($tpl['price_arr'] as $k => $price)
										{
											$index = $price['id']; 
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
													<?php if($has_bookings == 0 && $k > 0) { ?>
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
									}else{
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
									<?php } ?>
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
			            
        </div><!-- /.panel-body-inner -->
    </div><!-- /.panel-body -->
</div>