<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-10">
                <h2><?php __('infoInstallTitle') ?></h2>
            </div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php __('infoInstallDesc') ?></p>
    </div><!-- /.col-md-12 -->
</div>
<?php 
$install_view = __('install_view', true);
$yesno_arr = __('_yesno', true);
$theme_arr = __('option_themes', true);
ksort($theme_arr);
$selected_theme = str_replace("theme", "", $tpl['option_arr']['o_theme']);
if($controller->_get->check('theme'))
{
	$selected_theme = 'theme' . $controller->_get->toString('theme');
}
?>
<div class="row wrapper wrapper-content animated fadeInRight">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
                <form action="" method="get" class="form-horizontal">
                	<div class="m-b-lg">
                    	<h2 class="no-margins"><?php __('lblInstallFrontEndConfig');?></h2>
                    </div>
                    <div class="row">
                    	<div class="col-lg-8">
                    		<div class="form-group">
								<label class="col-lg-3 col-md-4 control-label"><?php __('lblView');?></label>
							
								<div class="col-lg-5 col-md-8">
									<select name="install_view" id="install_view" class="form-control">
										<option value="list"><?php echo $install_view['list'];?></option>
										<option value="calendar"><?php echo $install_view['calendar'];?></option>
										<option value="monthly" selected="selected"><?php echo $install_view['monthly'];?></option>
									</select>
								</div>
							</div>
							
							<div class="form-group">
								<label class="col-lg-3 col-md-4 control-label"><?php __('lblHideSwitchIcons');?></label>
							
								<div class="col-lg-5 col-md-8">
									<div class="clearfix">
										<div class="switch onoffswitch-data pull-left">
											<div class="onoffswitch">
												<input type="checkbox" class="onoffswitch-checkbox" id="hide_icons" name="hide_icons" value="T">
												<label class="onoffswitch-label" for="hide_icons">
													<span class="onoffswitch-inner" data-on="<?php echo $yesno_arr['T'];?>" data-off="<?php echo $yesno_arr['F'];?>"></span>
													<span class="onoffswitch-switch"></span>
												</label>
											</div>
										</div>
									</div>
								</div>
							</div>
							<?php if(count($tpl['category_arr']) > 0) { ?>
								<div class="form-group">
									<label class="col-lg-3 col-md-4 control-label"><?php __('lblShowSpecificCategory');?></label>
								
									<div class="col-lg-5 col-md-8">
										<select name="install_category" id="install_category" class="form-control">
											<option value="0">-- <?php __('lblChoose');?> --</option>
											<?php
											foreach($tpl['category_arr'] as $k => $v)
											{
												?><option value="<?php echo $v['id'];?>"><?php echo pjSanitize::html($v['category_name']);?></option><?php
											} 
											?>
										</select>
									</div>
								</div>
							<?php } ?>
                    	</div>
                    </div>
                    <?php if (count($tpl['menu_locale_arr']) > 1) { ?>
                        <div class="row">
                            <div class="col-lg-8">
                                <div class="form-group">
                                    <label class="col-lg-3 col-md-4 control-label"><?php __('lblInstallConfigLocale');?></label>

                                    <div class="col-lg-5 col-md-8">
                                        <select name="install_locale" id="install_locale" class="form-control">
                                            <option value="">-- <?php __('plugin_base_choose'); ?> --</option>
                                            <?php
                                            foreach ($tpl['menu_locale_arr'] as $locale)
                                            {
                                                ?><option value="<?php echo $locale['id']; ?>"><?php echo pjSanitize::html($locale['name']); ?></option><?php
                                            }
                                            ?>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-lg-3 col-md-4 control-label"><?php __('lblInstallConfigHide');?></label>

                                    <div class="col-lg-5 col-md-8">
                                        <div class="clearfix">
                                            <div class="switch onoffswitch-data pull-left">
                                                <div class="onoffswitch">
                                                    <input type="checkbox" class="onoffswitch-checkbox" id="install_hide" name="install_hide">
                                                    <label class="onoffswitch-label" for="install_hide">
                                                        <span class="onoffswitch-inner" data-on="<?php __('plugin_base_yesno_ARRAY_T', false, true); ?>" data-off="<?php __('plugin_base_yesno_ARRAY_F', false, true); ?>"></span>
                                                        <span class="onoffswitch-switch"></span>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="hr-line-dashed"></div>
                    <?php } else { ?>
                    	<input type="hidden" id="hidden_locale" name="hidden_locale" value="<?php echo $tpl['locale_arr'][0]['id'];?>"/>
                    <?php } ?>

                    <div class="m-b-lg">
                        <h2 class="no-margins"><?php __('infoInstallCodeTitle');?></h2>
                    </div>

                    <p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php __('lblInstallJs1_body') ?></p>

                    <div class="row">
                        <div class="col-lg-12">
                            <div class="form-group">
                                <div class="col-lg-12">
                                    <textarea class="form-control textarea_install" id="install_code" rows="5"></textarea>
                                </div>
                            </div>
                        </div>

                        <div style="display:none" id="hidden_code">&lt;link href="<?php echo PJ_INSTALL_URL.PJ_FRAMEWORK_LIBS_PATH . 'pj/css/'; ?>pj.bootstrap.min.css" type="text/css" rel="stylesheet" /&gt;
&lt;link href="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&amp;action=pjActionLoadCss" type="text/css" rel="stylesheet" /&gt;
&lt;script type="text/javascript" src="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&amp;action=pjActionLoad&amp;view={VIEW}&amp;icons={ICONS}&amp;cid={CID}{LOCALE}{HIDE}"&gt;&lt;/script&gt;</div>
                    </div>
                </form>
            </div>
        </div>
    </div><!-- /.col-lg-12 -->
</div>