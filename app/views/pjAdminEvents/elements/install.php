<div id="install" class="tab-pane<?php echo $active_tab == 'install' ? ' active' : NULL;?>">
	<div class="panel-body">
		<div class="panel-body-inner">
			<div class="ibox-content ibox-heading">
				<h3><?php __('lblInstallPhp1PerEventTitle'); ?></h3>
				<small><?php __('lblInstallPhp1PerEventBody');?></small>
			</div>
					
			<div class="form-group">
				<label class="col-lg-3 col-md-4 control-label"><?php __('lblHideLanguageSelector');?></label>
			
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
			</div><br/><br/>
			<textarea id="install_step_1" class="form-control textarea_install" rows="5"></textarea>
			<textarea id="install_step_clone" class="form-control textarea_install" style="overflow: auto; height:120px; width: 729px;display: none;">&lt;link href="<?php echo PJ_INSTALL_URL.PJ_FRAMEWORK_LIBS_PATH . 'pj/css/'; ?>pj.bootstrap.min.css" type="text/css" rel="stylesheet" /&gt;
&lt;link href="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&amp;action=pjActionLoadCss" type="text/css" rel="stylesheet" /&gt;
&lt;script type="text/javascript" src="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&amp;action=pjActionLoad&amp;view=list&amp;icons=T&amp;event_id=<?php echo $tpl['arr']['id'];?>{HIDE}"&gt;&lt;/script&gt;</textarea>
		</div>
	</div>
</div>