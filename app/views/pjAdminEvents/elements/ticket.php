<div id="ticket" class="tab-pane<?php echo $active_tab == 'ticket' ? ' active' : NULL;?>">
	<div class="panel-body">
        <div class="panel-body-inner">
        	<?php
        	$info_body = __('infoTicketsImageBody', true);
			$info_body = str_replace("[STARTTAG]", "<a href='".PJ_INSTALL_URL."sample-ticket.jpg' target='_blank'>", $info_body);
			$info_body = str_replace("[ENDTAG]", "</a>", $info_body); 
        	?>
        	<div class="ibox-content ibox-heading">
				<h3><?php __('infoTicketsImageTitle'); ?></h3>
				<small><?php echo $info_body;?></small>
			</div>
			
			<div class="row">
				<div class="col-lg-9">
					<div class="form-group">
						<label class="control-label"><?php __('lblTicketDetails'); ?></label>
						<?php
						foreach ($tpl['lp_arr'] as $v)
						{
							?>
							<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 0 ? 'none' : NULL; ?>">
								<textarea name="i18n[<?php echo $v['id']; ?>][ticket_info]" class="form-control" rows="10"><?php echo isset($tpl['arr']['i18n'][$v['id']]['ticket_info']) && !empty($tpl['arr']['i18n'][$v['id']]['ticket_info']) ? htmlspecialchars(stripslashes($tpl['arr']['i18n'][$v['id']]['ticket_info'])) : ''; ?></textarea>
								<?php if ($tpl['is_flag_ready']) : ?>
								<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
								<?php endif; ?>
							</div>
							<?php
						}
						?>
					</div>
					
					<div class="form-group">
						<label class="control-label"><?php __('lblTicketImage', false, true); ?></label>
			
						<div>
							<div class="fileinput fileinput-new" data-provides="fileinput">
								<span class="btn btn-primary btn-outline btn-file"><span class="fileinput-new"><i class="fa fa-upload"></i> <?php __('lblSelectImage');?></span>
								<span class="fileinput-exists"><?php __('lblChangeImage');?></span><input name="ticket_img" id="ticket_img" type="file"></span>
								<span class="fileinput-filename"></span>
			
								<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">×</a>
							</div>
						</div>
					</div><!-- /.form-group -->
					<?php 
					if (!empty($tpl['arr']['ticket_img']) && is_file(PJ_INSTALL_PATH . $tpl['arr']['ticket_img']))
					{
						?>
						<div id="boxTicketImage" class="form-group">
							<a href="<?php echo PJ_INSTALL_URL . $tpl['arr']['ticket_img']; ?>?r=<?php echo rand(1,9999); ?>" target="_blank"><img src="<?php echo PJ_INSTALL_URL . $tpl['arr']['ticket_img']; ?>?r=<?php echo rand(1,9999); ?>" alt="" class="align_middle" style="max-width: 180px; margin-right: 10px;"></a>
							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionDeleteTicketImage&amp;id=<?php echo pjSanitize::html($tpl['arr']['id']);?>" class="btn btn-xs btn-danger btn-outline btnDeleteTicketImage" data-id="<?php echo pjSanitize::html($tpl['arr']['id']);?>"><i class="fa fa-trash"></i> <?php __('plugin_app_management_btn_delete'); ?></a>
						</div>
						<?php
					} 
					?>
					
				</div>
				<div class="col-lg-3">
					<div class="ibox float-e-margins settings-box">
						<div class="ibox-content ibox-heading">
							<h3><?php __('notifications_tokens'); ?></h3>
			
						</div>
						<div class="ibox-content">
							<div class="notifyTokens">
								<?php __('lblImageTokens');?>
							</div>
						</div>
					</div>
				</div>
			</div><!-- /.row -->
						
		</div>
	</div>
</div>