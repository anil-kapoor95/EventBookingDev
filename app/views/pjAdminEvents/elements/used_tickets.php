<div id="used_tickets" class="tab-pane<?php echo $active_tab == 'used_tickets' ? ' active' : NULL;?>">
	<div class="panel-body">
		<div class="panel-body-inner">
			<div class="ibox-content ibox-heading">
				<h3><?php __('infoUsedTicketsTitle'); ?></h3>
				<small><?php __('infoUsedTicketsBody');?></small>
			</div>
			
			<p class="lead m-b-xs">
				<?php __('lblCurrentDateTime');?>: <span class="font-bold"><?php echo pjDateTime::formatDate(date('Y-m-d'), 'Y-m-d', $tpl['option_arr']['o_date_format']) . ' ' . pjDateTime::formatTime(date('H:i:s'), 'H:i:s', $tpl['option_arr']['o_time_format']);?></span>
			</p>
			<p class="lead m-b-xs">
				<?php __('lblTotalAvailable');?>: <span class="font-bold"><?php echo (int)$tpl['arr']['total_avail'];?></span>
			</p>
			<p class="lead m-b-xs">
				<?php __('lblBookedTickets');?>: <span class="font-bold"><?php echo (int)$tpl['total_tickets'];?></span>
			</p>
			<p class="lead m-b-xs">
				<?php __('lblUsedTickets');?>: <span class="font-bold"><?php echo (int)$tpl['used_tickets'];?></span>
			</p>
			<?php if(isset($tpl['print_tickets_file'])) { ?>
			<p class="lead m-b-xs">
				<a target="_blank" href="<?php echo $tpl['print_tickets_file'];?>" class="btn btn-primary" title="<?php __('btnPrint'); ?>"><i class="fa fa-print" aria-hidden="true"></i> <?php __('btnPrint'); ?></a>
			</p>
			<?php } ?>		
			<div class="hr-line-dashed"> </div>
						
			<div class="ibox float-e-margins">
            	<div class="ibox-content no-margins no-padding no-top-border">
            		<div class="row m-b-md">
						<div class="col-md-5 col-sm-8">
							<div class="input-group">
								<input type="text" name="q" id="search_event_used_tickets" placeholder="<?php __('plugin_base_btn_search', false, true); ?>" class="form-control">
					
								<div class="input-group-btn">
									<button class="btn btn-primary pjBtnFilterEventUsedTickets" type="button">
										<i class="fa fa-search"></i>
									</button>
								</div>
							</div>
						</div><!-- /.col-md-5 -->
					</div><!-- /.row -->
					<div id="grid_used_tickets"></div>
				</div>
			</div>
				
		</div>
	</div>
</div>