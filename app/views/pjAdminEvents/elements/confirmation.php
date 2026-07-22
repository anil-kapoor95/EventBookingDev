<div id="confirmation" class="tab-pane<?php echo $active_tab == 'confirmation' ? ' active' : NULL;?>">
    <div class="panel-body">
        <div class="panel-body-inner">
        	<div id="boxNotificationsWrapper">
            	<div class="ibox float-e-margins settings-box">
                    <div class="ibox-content ibox-heading">
            			<h3><?php __('notifications_main_title'); ?></h3>
            			<small><?php __('notifications_main_subtitle'); ?></small>
            		</div>
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-lg-3 col-sm-5">
                                <div class="m-b-sm">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <h3><?php __('notifications_recipient'); ?></h3>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
            						<div class="radio radio-primary">
            							<input class="i-checks" type="radio" id="recipient_client" name="recipient" value="client"<?php echo !isset($tpl['query']['recipient']) || $tpl['query']['recipient'] == 'client' ? ' checked' : NULL; ?>>
            							<label for="recipient_client"><?php __('recipients_ARRAY_client'); ?></label>
            						</div>
            					</div>
                                <div class="form-group">
            						<div class="radio radio-primary">
            							<input class="i-checks" type="radio" id="recipient_admin" name="recipient" value="admin"<?php echo isset($tpl['query']['recipient']) && $tpl['query']['recipient'] == 'admin' ? ' checked' : NULL; ?>>
            							<label for="recipient_admin"><?php __('recipients_ARRAY_admin'); ?></label>
            						</div>
            					</div>
            
                            </div>
                            <div class="col-lg-9 col-sm-7 ibox-content-notification" id="boxNotificationsMetaData">
                                
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-lg-9 ibox-content-notification" id="boxNotificationsContent">
                        
                    </div>
                    <div class="col-lg-3">
                        <div class="ibox float-e-margins settings-box">
                            <div class="ibox-content ibox-heading">
            					<h3><?php __('notifications_tokens'); ?></h3>
            	
            					<small><?php __('notifications_tokens_note'); ?></small>
            				</div>
                            <div class="ibox-content">
            					<div class="notifyTokens reservationTokens">
            						<?php __('notifications_tokens_list');?>
            					</div>
            				</div>
                        </div>
                    </div>
                </div><!-- /.row -->
            </div>
		</div>
    </div>
    
</div>