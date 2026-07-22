<div id="terms" class="tab-pane<?php echo $active_tab == 'terms' ? ' active' : NULL;?>">
    <div class="panel-body">
		<div class="panel-body-inner">
			<div class="ibox-content ibox-heading">
				<h3><?php __('infoTermsTitle'); ?></h3>
				<small><?php __('infoTermsBody');?></small>
			</div>
			<div class="form-group">
				<?php
				foreach ($tpl['lp_arr'] as $v)
				{
					?>
					<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
						<textarea name="i18n[<?php echo $v['id']; ?>][terms_body]" rows="10" class="form-control mceEditor"><?php echo isset($tpl['arr']['i18n'][$v['id']]['terms_body']) && !empty($tpl['arr']['i18n'][$v['id']]['terms_body']) ? stripslashes($tpl['arr']['i18n'][$v['id']]['terms_body']) : ''; ?></textarea>	
						<?php if ($tpl['is_flag_ready']) : ?>
						<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
						<?php endif; ?>
					</div>
					<?php 
				}
				?>
			</div>
		</div>
	</div>
		
</div>