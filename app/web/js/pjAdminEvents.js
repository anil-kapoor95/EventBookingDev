var jQuery = jQuery || $.noConflict();
(function ($, undefined) {
	$(function () {
		var $frmCreateEvent = $("#frmCreateEvent"),
			$frmUpdateEvent = $("#frmUpdateEvent"),
			select2 = ($.fn.select2 !== undefined),
			dialog = ($.fn.dialog !== undefined),
			validate = ($.fn.validate !== undefined),
			datagrid = ($.fn.datagrid !== undefined),
			multilang = ($.fn.multilang !== undefined),
			remove_arr = new Array(),
			datetimeOptions = null,
			$active_tab = null;
		
		if ($('#dateTimePickerOptions').length) {
        	var $optionsEle = $('#dateTimePickerOptions');
        	
	        moment.updateLocale('en', {
				week: { dow: parseInt($optionsEle.data('wstart'), 10) },
				months : $optionsEle.data('months').split("_"),
		        weekdaysMin : $optionsEle.data('days').split("_")
			});
	        datetimeOptions = {
				format: $optionsEle.data('format'),
				locale: moment.locale('en'),
				allowInputToggle: true,
				ignoreReadonly: true,
				useCurrent: false
			};
	        $('.datetimepick').datetimepicker(datetimeOptions);
	        
	        var $dt_start = $('#event_start_ts'),
				$dt_end = $('#event_end_ts');
			$dt_start.datetimepicker(datetimeOptions).on('dp.change', function (e) {
				var $from_ts = e.date.valueOf();
				if ($dt_end.val() != '') {
					var $to_ts = $dt_end.data("DateTimePicker").date().valueOf();
					if ($to_ts < $from_ts) {
						$dt_end.val($dt_start.val());
					}
				}
				$dt_end.data("DateTimePicker").minDate(e.date);
			});
			$dt_end.datetimepicker(datetimeOptions).on('dp.change', function (e) {
				var $to_ts = e.date.valueOf();
				if ($dt_start.val() != '') {
					var $from_ts = $dt_start.data("DateTimePicker").date().valueOf();
					if ($to_ts < $from_ts) {
						$dt_start.val($dt_end.val());
					}
				}
			});
			
			$('.datepick').datetimepicker({
				format: $optionsEle.data('dateformat'),
				locale: moment.locale('en'),
				allowInputToggle: true,
				ignoreReadonly: true,
				useCurrent: false
			}).on('dp.change', function (selected) {
	        	if($(this).attr('name') == 'end_repeat_date')
	        	{
	        		if($('#end_repeat_date').val() != '' || $('#end_repeat_times').val() != '')
					{
						$('#hidden_recurring_on').removeClass('required').valid();
					}
	        	}
			});
        }
		
		if (multilang && 'pjCmsLocale' in window) {
			$(".multilang").multilang({
				langs: pjCmsLocale.langs,
				flagPath: pjCmsLocale.flagPath,
				tooltip: "",
				select: function (event, ui) {
					locale_id = ui.index;
				}
			});
		}
		
		if ($(".select-item").length && select2) {
            $(".select-item").select2({
                allowClear: true
            });
        };
        
        if($(".touchspin3").length > 0)
		{
			$(".touchspin3").TouchSpin({
				min: 0,
				max: 4294967295,
				step: 1,
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white'
	        });
		}
		
        function myTinyMceDestroy() {
			if (window.tinymce === undefined) {
				return;
			}
			
			var iCnt = tinymce.editors.length;
			
			if (!iCnt) {
				return;
			}
			
			for (var i = 0; i < iCnt; i++) {
				tinymce.remove(tinymce.editors[i]);
			}
		}
		
		function myTinyMceInit(pSelector) {			
			if (window.tinymce === undefined) {
				return;
			}
			
			tinymce.init({
				relative_urls : false,
				remove_script_host : false,
				convert_urls : true,
				browser_spellcheck : true,
			    contextmenu: false,
			    selector: pSelector,
			    theme: "modern",
			    height: 480,
			    plugins: [
			         "advlist autolink link image lists charmap print preview hr anchor pagebreak",
			         "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
			         "save table contextmenu directionality emoticons template paste textcolor"
			    ],
			    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons",
			    image_advtab: true,
			    menubar: "file edit insert view table tools",
			    setup: function (editor) {
			    	editor.on('change', function (e) {
			    		editor.editorManager.triggerSave();
			    	});
			    }
			});
		}

		if ($('.mceEditor').length > 0) {
			myTinyMceDestroy.call(null);
			myTinyMceInit.call(null, 'textarea.mceEditor');
        }
		
        function setPrices()
		{
			var index_arr = new Array();
				
			$('#ebc_price_list').find(".ebc-price-row").each(function (index, row) {
				index_arr.push($(row).attr('data-index'));
			});
			
			$('#index_arr').val(index_arr.join("|"));
		}
		
        if ($frmCreateEvent.length > 0 || $frmUpdateEvent.length > 0) {
	        $.validator.addMethod('startTime',
			    function (value, element) {
					if($(element).attr('data-wt') == 'open')
					{
						return true;
					}else{
						return false;
					}
			    }
			);
			$.validator.addMethod('endTime',
			    function (value, element) {
					if($(element).attr('data-wt') == 'open')
					{
						return true;
					}else{
						return false;
					}
			    }
			);
        }
        
        if ($frmUpdateEvent.length > 0) {
        	$active_tab = $frmUpdateEvent.find('input[name="tab"]').val();
        }
		
		if ($frmCreateEvent.length > 0 && validate) {
			$frmCreateEvent.validate({
				rules: {
					"from":{
						startTime: true
					},
					"to":{
						endTime: true
					}
				},
				messages: {
					"from":{
						startTime: myLabel.invalid_from_dt
					},
					"to":{
						endTime: myLabel.invalid_to_dt
					}
				},
				onkeyup: false,
				ignore: "",
				submitHandler: function(form){
					var ladda_buttons = $(form).find('.ladda-button');
				    if(ladda_buttons.length > 0)
                    {
                        var l = ladda_buttons.ladda();
                        l.ladda('start');
                    }
				    setPrices();
				    $.post("index.php?controller=pjAdminEvents&action=pjActionCheckTime", $(form).serialize()).done(function (data) {
				    	if(data.status == 'OK')
						{
				    		$.ajax({
								type: 'POST',
								async: true, 
								url: "index.php?controller=pjAdminEvents&action=pjActionCheckPrices",
								data: $(form).serialize(),
								success: function(data){
									if(data.status == 'OK')
									{
										form.submit();
									}else{
										l.ladda('stop');
										swal({
							    			title: "",
											text: data.text,
											type: "warning",
											confirmButtonColor: "#DD6B55",
											confirmButtonText: "OK",
											closeOnConfirm: false,
											showLoaderOnConfirm: false
										}, function () {
											swal.close();
										});
									}
								}
							});
						} else {
							l.ladda('stop');
							swal({
				    			title: "",
								text: myLabel.invalid_to_dt,
								type: "warning",
								confirmButtonColor: "#DD6B55",
								confirmButtonText: "OK",
								closeOnConfirm: false,
								showLoaderOnConfirm: false
							}, function () {
								swal.close();
							});
						}
					});
					return false;
				}
			});
		}
		
		function setInstall()
		{
			var step_1 = $('#install_step_clone').text();
			var hide = $("input[name='install_hide']").is(":checked") ? "&hide=1" : "";
			step_1 = step_1.replace('{HIDE}', hide);
			$('#install_step_1').val(step_1);
		}
		
		if ($frmUpdateEvent.length > 0 && validate) {
			$frmUpdateEvent.validate({
				rules: {
					"from":{
						startTime: true
					},
					"to":{
						endTime: true
					}
				},
				messages: {
					"from":{
						startTime: myLabel.invalid_from_dt
					},
					"to":{
						endTime: myLabel.invalid_to_dt
					}
				},
				onkeyup: false,
				ignore: "",
				invalidHandler: function (event, validator) {
				    if (validator.numberOfInvalids()) {
				    	var $_id = $(validator.errorList[0].element, this).closest("div.tab-pane").attr("id");
				    	$('.tab-'+$_id).trigger("click");
				    };
				},
				submitHandler: function(form){
					var ladda_buttons = $(form).find('.ladda-button');
				    if(ladda_buttons.length > 0)
                    {
                        var l = ladda_buttons.ladda();
                        l.ladda('start');
                    }
				    
				    if ($active_tab == 'confirmation') {
				    	notificationsSetContent.call(null, false);
				    	l.ladda('stop');
				    } else {
					    setPrices();
					    $.post("index.php?controller=pjAdminEvents&action=pjActionCheckTime", $(form).serialize()).done(function (data) {
					    	if(data.status == 'OK')
							{
					    		$.ajax({
									type: 'POST',
									async: true, 
									url: "index.php?controller=pjAdminEvents&action=pjActionCheckPrices",
									data: $(form).serialize(),
									success: function(data){
										if(data.status == 'OK')
										{
											form.submit();
										}else{
											l.ladda('stop');
											swal({
								    			title: "",
												text: data.text,
												type: "warning",
												confirmButtonColor: "#DD6B55",
												confirmButtonText: "OK",
												closeOnConfirm: false,
												showLoaderOnConfirm: false
											}, function () {
												swal.close();
											});
										}
									}
								});
							} else {
								l.ladda('stop');
								swal({
					    			title: "",
									text: myLabel.invalid_to_dt,
									type: "warning",
									confirmButtonColor: "#DD6B55",
									confirmButtonText: "OK",
									closeOnConfirm: false,
									showLoaderOnConfirm: false
								}, function () {
									swal.close();
								});
							}
						});
				    }
					return false;
				}
			});
			
			setInstall();
			
			$frmUpdateEvent.on("change", "input[name='install_hide']", function (e) {
				setInstall();
			});
		}
		
		$('#repeat-monthly-date').on('change', function(e){
			if($(this).val() == 0)
			{
				$('#repeat-monthly-each').removeAttr('disabled');
				$('#repeat-monthly-day').removeAttr('disabled');
			}else{
				$('#repeat-monthly-each').attr('disabled', 'disabled');
				$('#repeat-monthly-day').attr('disabled', 'disabled');
			}
		});
		
		$('#repeat').on('change', function(e){
			$('small[id^="repeat_"]').css('display','none');
			$('div[id^="repeat_"]').css('display','none');
			$('#repeat_' + $(this).val()).css('display','block');
			if($(this).val() == 'none')
			{
				$('.repeat_box').css('display','none');
				$('#hidden_recurring_on').removeClass('required');
			}else{
				$('.repeat_box').css('display','block');
				if($('#end_repeat_date').val() == '' && $('#end_repeat_times').val() == '')
				{
					$('#hidden_recurring_on').addClass('required');
				}
			}
			if($(this).val() == 'custom')
			{
				$('#repeat-custom-days').addClass('required');
			}else{
				$('#repeat-custom-days').removeClass('required');
			}
		});
			
		
		if ($("#grid").length > 0 && datagrid) {
			function showBookings (str, obj) {
				if(obj.linked == '1')
				{
					return '<a href="index.php?controller=pjAdminBookings&action=pjActionIndex&event_id='+obj.id+'">'+obj.tickets+'</a>';
				}else{
					return obj.tickets;
				}
			}	
			function formatEventDate (str, obj) {
				return obj.event_date;
			}
			var buttonsOpts = [];
			var actionsOpts = [];
			var menuItems = [];
			if (myLabel.has_create) {
				menuItems.push({text: myLabel.copy, url: "index.php?controller=pjAdminEvents&action=pjActionCreate&id={:id}", ajax: false, render: true});
			}
			if (myLabel.has_update)
			{
				buttonsOpts.push({type: "edit", url: "index.php?controller=pjAdminEvents&action=pjActionUpdate&id={:id}"});
				menuItems.push({text: myLabel.tickets, url: "index.php?controller=pjAdminEvents&action=pjActionUpdate&id={:id}&tab=used_tickets", ajax: false, render: true});
			}
			
			if (myLabel.has_delete)
			{
				buttonsOpts.push({type: "custom-delete", url: "index.php?controller=pjAdminEvents&action=pjActionDeleteEvent&id={:id}", render: true});
			}
			if (menuItems.length > 0) {
				buttonsOpts.push({type: "menu", url: "#", text: myLabel.more, items: menuItems});
			}
			if (myLabel.has_delete_bulk) 
			{
				actionsOpts.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminEvents&action=pjActionDeleteEventBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			if (myLabel.has_revert_status) 
			{
				actionsOpts.push({text: myLabel.revert_status, url: "index.php?controller=pjAdminEvents&action=pjActionStatusEvent", render: true});
			}
			if (myLabel.has_export) 
			{
				actionsOpts.push({text: myLabel.exported, url: "index.php?controller=pjAdminEvents&action=pjActionExportEvent", ajax: false});
			}
			
			var $grid = $("#grid").datagrid({
				buttons: buttonsOpts,
				columns: [{text: myLabel.eventdate, type: "text", sortable: true, editable: false, renderer: formatEventDate},
				          {text: myLabel.eventtitle, type: "text", sortable: true, editable: myLabel.has_update},
				          {text: myLabel.tickets, type: "text", sortable: true, editable: false, align: 'center', renderer: showBookings},
				          {text: myLabel.status, type: "toggle", sortable: true, editable: myLabel.has_update, positiveLabel: myLabel.active, positiveValue: "T", negativeLabel: myLabel.inactive, negativeValue: "F"}
				          ],
				dataUrl: "index.php?controller=pjAdminEvents&action=pjActionGetEvent",
				dataType: "json",
				fields: ['event_start_ts', 'title', 'total_booked', 'status'],
				paginator: {
					actions: actionsOpts,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminEvents&action=pjActionSaveEvent&id={:id}",
				select: {
					field: "id",
					name: "record[]",
					cellClass: 'cell-width-2'					
				}
			});
			
			$grid.on("click", ".pj-table-icon-custom-delete", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $tr = $(this).closest('tr'),
					$id = ($tr.data('id')).replace("id_", ""),
					$url = $(this).attr('href');
				
				$.get("index.php?controller=pjAdminEvents&action=pjActionCheckRecurring", {
					"id": $id
				}).done(function (data) {
					var $title = myLabel.alert_delete_event_title,
						$text = myLabel.alert_delete_event_text;
					if(data == 'true')
					{
						$title = myLabel.alert_delete_recurring_event_title;
						$text = myLabel.alert_delete_recurring_event_text;
					}
					swal({
						html: true,
						title: $title,
						text: $text,
						type: "warning",
						showCancelButton: true,
						confirmButtonColor: "#DD6B55",
						confirmButtonText: myLabel.btn_delete,
						cancelButtonText: myLabel.btn_cancel,
						denyButtonText: "Don't save",
						closeOnConfirm: true,
						showLoaderOnConfirm: true
					}, function () {
						if ($('#delete_all_recurring').is(":checked")) {
							$.get("index.php?controller=pjAdminEvents&action=pjActionDeleteRecurring", {
								"id": $id
							}).done(function (data) {
								var content = $grid.datagrid("option", "content"),
									cache = $grid.datagrid("option", "cache");
								$grid.datagrid("option", "cache", cache);
								$grid.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetEvent", content.column, content.direction, content.page, content.rowCount);
							});
						} else {
							$.get("index.php?controller=pjAdminEvents&action=pjActionDeleteEvent", {
								"id": $id
							}).done(function (data) {
								var content = $grid.datagrid("option", "content"),
									cache = $grid.datagrid("option", "cache");
								$grid.datagrid("option", "cache", cache);
								$grid.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetEvent", content.column, content.direction, content.page, content.rowCount);
							});
						}
					});
				});
				return false;
			});
		}
		
		if ($("#grid_bookings").length > 0 && datagrid) {
			function formatStatus(val, obj) {
				if(val == 'confirmed')
				{
					return '<div class="btn bg-confirmed btn-xs no-margin"><i class="fa fa-check"></i> ' + myLabel.confirmed + '</div>';
				}else if(val == 'cancelled'){
					return '<div class="btn bg-cancelled btn-xs no-margin"><i class="fa fa-times"></i> ' + myLabel.cancelled + '</div>';
				}else if(val == 'pending'){
					return '<div class="btn bg-pending btn-xs no-margin"><i class="fa fa-exclamation-triangle"></i> ' + myLabel.pending + '</div>';
				}
			}
			var buttonsOpts = [];
			var actionsOpts = [];
			if (myLabel.has_update_booking)
			{
				buttonsOpts.push({type: "edit", url: "index.php?controller=pjAdminBookings&action=pjActionUpdate&id={:id}"});
			}			
			if (myLabel.has_delete_booking)
			{
				buttonsOpts.push({type: "delete", url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBooking&id={:id}"});
			}
			if (myLabel.has_delete_bulk_booking) 
			{
				actionsOpts.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBookingBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			if (myLabel.has_export_booking) 
			{
				actionsOpts.push({text: myLabel.exportSelected, url: "index.php?controller=pjAdminBookings&action=pjActionExportBooking", ajax: false});
			}
			
			var $grid_bookings = $("#grid_bookings").datagrid({
				buttons: buttonsOpts,
				columns: [{text: myLabel.booking_id, type: "text", sortable: true, editable: false},
				          {text: myLabel.name, type: "text", sortable: true, editable: false},
				          {text: myLabel.eventdate, type: "text", sortable: true, editable: false},
				          {text: myLabel.tickets, type: "text", sortable: false, editable: false},
				          {text: myLabel.price, type: "text", sortable: true, editable: false},
				          {text: myLabel.status, type: "text", sortable: true, editable: false, renderer: formatStatus}
				          ],
				dataUrl: "index.php?controller=pjAdminEvents&action=pjActionGetBooking" + pjGrid.queryString,
				dataType: "json",
				fields: ['unique_id', 'customer_name', 'event_start_ts', 'tickets', 'booking_total', 'booking_status'],
				paginator: {
					actions: actionsOpts,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminBookings&action=pjActionSaveBooking&id={:id}",
				select: {
					field: "id",
					name: "record[]",
					cellClass: 'cell-width-2'
					
				}
			});
			
			$('#bookings').on("change", "#filter_status", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var content = $grid_bookings.datagrid("option", "content"),
					cache = $grid_bookings.datagrid("option", "cache");
				$.extend(cache, {
					q: $('#bookings').find("input[name='q']").val(),
					booking_status: $('#bookings').find("select[name='filter_status']").val()
				});
				$grid_bookings.datagrid("option", "cache", cache);
				$grid_bookings.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetBooking" + pjGrid.queryString, "event_start_ts", "ASC", content.page, content.rowCount);
				return false;
			}).on("click", ".pjBtnFilterEventBookings", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var content = $grid_bookings.datagrid("option", "content"),
					cache = $grid_bookings.datagrid("option", "cache");
				$.extend(cache, {
					q: $('#bookings').find("input[name='q']").val(),
					booking_status: $('#bookings').find("select[name='filter_status']").val()
				});
				$grid_bookings.datagrid("option", "cache", cache);
				$grid_bookings.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetBooking" + pjGrid.queryString, "event_start_ts", "ASC", content.page, content.rowCount);
				return false;
			}).on("keyup, keydown", "#search_event_bookings", function (e) {
		         if(e.which === 13){
		        	 if (e && e.preventDefault) {
						e.preventDefault();
					}
					var content = $grid_bookings.datagrid("option", "content"),
						cache = $grid_bookings.datagrid("option", "cache");
					$.extend(cache, {
						q: $('#bookings').find("input[name='q']").val(),
						booking_status: $('#bookings').find("select[name='filter_status']").val()
					});
					$grid_bookings.datagrid("option", "cache", cache);
					$grid_bookings.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetBooking" + pjGrid.queryString, "event_start_ts", "ASC", content.page, content.rowCount);
					return false;
		         }
		    });
		}
		
		if ($("#grid_used_tickets").length > 0 && datagrid) {
			var buttonsOpts = [];
			var actionsOpts = [];			
			var $grid_used_tickets = $("#grid_used_tickets").datagrid({
				buttons: buttonsOpts,
				columns: [{text: myLabel.name, type: "text", sortable: true, editable: false},
				          {text: myLabel.email, type: "text", sortable: true, editable: false},
				          {text: myLabel.ticket_type, type: "text", sortable: true, editable: false},
				          {text: myLabel.used_tickets, type: "text", sortable: true, editable: false}
				          ],
				dataUrl: "index.php?controller=pjAdminEvents&action=pjActionGetUsedTickets" + pjGrid.queryString,
				dataType: "json",
				fields: ['customer_name', 'customer_email', 'price_title', 'ticket_id'],
				paginator: {
					actions: actionsOpts,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminBookings&action=pjActionSaveBooking&id={:id}",
				select: false
			});
			
			$('#used_tickets').on("click", ".pjBtnFilterEventUsedTickets", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var content = $grid_used_tickets.datagrid("option", "content"),
					cache = $grid_used_tickets.datagrid("option", "cache");
				$.extend(cache, {
					q: $('#used_tickets').find("input[name='q']").val()
				});
				$grid_used_tickets.datagrid("option", "cache", cache);
				$grid_used_tickets.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetUsedTickets" + pjGrid.queryString, "event_start_ts", "ASC", content.page, content.rowCount);
				return false;
			}).on("keyup, keydown", "#search_event_used_tickets", function (e) {
		         if(e.which === 13){
		        	 if (e && e.preventDefault) {
						e.preventDefault();
					}
					var content = $grid_used_tickets.datagrid("option", "content"),
						cache = $grid_used_tickets.datagrid("option", "cache");
					$.extend(cache, {
						q: $('#used_tickets').find("input[name='q']").val()
					});
					$grid_used_tickets.datagrid("option", "cache", cache);
					$grid_used_tickets.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetUsedTickets" + pjGrid.queryString, "event_start_ts", "ASC", content.page, content.rowCount);
					return false;
		         }
		    });
		}
			
		$(document).on("focusin", ".textarea_install", function (e) {
			$(this).select();
		}).on("click", ".btn-all", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$(this).addClass("pj-button-active").siblings(".pj-button").removeClass("pj-button-active");
			var content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				status: "",
				q: ""
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetEvent", "title", "ASC", content.page, content.rowCount);
			return false;
		}).on("click", ".btn-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache"),
				obj = {};
			$this.addClass("btn-primary active").removeClass("btn-default")
			.siblings(".btn").removeClass("btn-primary active").addClass("btn-default");
			obj.status = "";
			obj[$this.data("column")] = $this.data("value");
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetEvent", "title", "ASC", content.page, content.rowCount);
			return false;
		}).on("submit", ".frm-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				q: $this.find("input[name='q']").val()
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminEvents&action=pjActionGetEvent", "title", "ASC", content.page, content.rowCount);
			return false;
		}).on("click", '.pj-add-price', function(e){
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var clone_text = $('#ebc_price_clone').html(),
				index = Math.ceil(Math.random() * 999999),
				number_of_sizes = $('#ebc_price_list').find(".ebc-price-row").length;
			clone_text = clone_text.replace(/\{INDEX\}/g, 'ebc_' + index);
			$('#ebc_price_list').append(clone_text);
			if($("#available_ebc_" + index).length > 0)
			{
				$("#available_ebc_" + index).TouchSpin({
					verticalbuttons: true,
		            buttondown_class: 'btn btn-white',
		            buttonup_class: 'btn btn-white',
		            max: 4294967295
		        });
			}
			if($("#max_purchase_ebc_" + index).length > 0)
			{
				$("#max_purchase_ebc_" + index).TouchSpin({
					verticalbuttons: true,
		            buttondown_class: 'btn btn-white',
		            buttonup_class: 'btn btn-white',
		            max: 4294967295
		        });
			}
		}).on("click", '.pj-remove-price', function(e){
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $price = $(this).parent().parent().parent(),
				id = $price.attr('data-index');
			if(id.indexOf("fd") == -1)
			{
				remove_arr.push(id);
			}
			$('#remove_arr').val(remove_arr.join("|"));
			$price.remove();
		}).on("keyup", '.pj-positive-number', function(e){
			if($(this).val() == '')
			{
				$(this).removeClass('pj-error-field');
			}else{
				if(Number($(this).val()) < 0 || $.isNumeric($(this).val()) == false)
			    {
			    	$(this).addClass('pj-error-field');
			    }else{
			    	$(this).removeClass('pj-error-field');
			    }
			}
			
		}).on("keyup", '.ebcRequired', function(e){
			if($(this).val() == '')
			{
				$(this).addClass('pj-error-field');
			}else{
				$(this).removeClass('pj-error-field');
			}
		}).on("keydown", "#end_repeat_times", function (e) {
			if (e.shiftKey == true) {
                e.preventDefault();
            }
			if ((e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 96 && e.keyCode <= 105) || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 46) {
				console.log('number');
            } else {
            	e.preventDefault();
            } 
		}).on("keyup", "#end_repeat_times", function (e) {
			if (e.shiftKey == true) {
                e.preventDefault();
            }
			if ((e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 96 && e.keyCode <= 105) || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 46) {
				if($('#end_repeat_date').val() != '' || $('#end_repeat_times').val() != '')
				{
					$('#hidden_recurring_on').removeClass('required').valid();
				}
            } else {
            	e.preventDefault();
            } 
			return false;
		}).on("click", ".btnDeleteImage", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			if($frmCreateEvent.length > 0)
			{
				$("#boxEventImage").remove();
				$("#copy_image").val(0);
			} else {
				var $this = $(this),
					id = $this.attr('data-id'),
					is_recurring = $this.attr('data-recurring'),
					alert_text = myLabel.alert_delete_event_image_text;
				if (is_recurring == 'yes') {
					alert_text = myLabel.alert_delete_event_images_text;
				}
				swal({
					title: myLabel.alert_delete_event_image_title,
					text: alert_text,
					type: "warning",
					showCancelButton: true,
					confirmButtonColor: "#DD6B55",
					confirmButtonText: myLabel.btn_delete,
					cancelButtonText: myLabel.btn_cancel,
					closeOnConfirm: false,
					showLoaderOnConfirm: true
				}, function () {
					$.post($this.attr("href"), {id: id}).done(function (data) {
						if (!(data && data.status)) {
							
						}
						switch (data.status) {
						case "OK":
							swal.close();
							$('#boxEventImage').remove();
							break;
						}
					});
				});
			}
		}).on("click", 'a[data-toggle="tab"]', function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var tab = $(this).attr('data-tab');
			if(tab == 'confirmation'){
				$('input[name="recipient"]:checked').trigger("change");
			}
			$('input[name="tab"]').val(tab);
			$active_tab = tab;
			if ($active_tab == 'bookings' || $active_tab == 'used_tickets' || $active_tab == 'install') {
				$('.tab-actions').find('.panel-body-inner').hide();
			} else {
				$('.tab-actions').find('.panel-body-inner').show();
			}
			return false;
		}).on("change", ".number", function (e) {
			var v = parseFloat(this.value);
		    if (isNaN(v)) {
		        this.value = '';
		    } else {
		        this.value = v.toFixed(2);
		    }
		    if (parseFloat(this.value) >= 99999999999999.99) {
		    	this.value = '99999999999999.99';
		    }
		}).on("click", ".btnDeleteTicketImage", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				id = $this.attr('data-id');
			swal({
				title: myLabel.alert_delete_ticket_image_title,
				text: myLabel.alert_delete_ticket_image_text,
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: myLabel.btn_delete,
				cancelButtonText: myLabel.btn_cancel,
				closeOnConfirm: false,
				showLoaderOnConfirm: true
			}, function () {
				$.post($this.attr("href"), {id: id}).done(function (data) {
					if (!(data && data.status)) {
						
					}
					switch (data.status) {
					case "OK":
						swal.close();
						$('#boxTicketImage').remove();
						break;
					}
				});
			});
		});
		
		function notificationsGetMetaData() {
			var $box = $("#boxNotificationsMetaData");
			if (!$box.length) {
				return;
			}
			
			// show preloader
			$box.empty().addClass("ibox-content-notification");
			
			$('<div class="ibox-content-overlay"></div> \
				<div class="sk-spinner sk-spinner-double-bounce"> \
					<div class="sk-double-bounce1"></div> \
					<div class="sk-double-bounce2"></div> \
				</div>').appendTo($box);
			
			$box.find(".ibox-content-overlay, .sk-spinner").show();

			var search = window.location.search,
				variant = search.match(/&?variant=(\w+)/),
				transport = search.match(/&?transport=(\w+)/),
				params = {
					recipient: $('input[name="recipient"]:checked').val()
				};
			
			if (variant !== null && transport !== null) {
				params.variant = variant[1];
				params.transport = transport[1];
			}
			params.event_id = $('#event_id').val();
			
			$.get("index.php?controller=pjAdminEvents&action=pjActionNotificationsGetMetaData", params).done(function (data) {
				$box.html(data);				
				if (variant !== null && transport !== null) {
					$box.find(['#variant', transport[1], variant[1]].join("_")).trigger("change");
				} else {
					$box.find('input[name="variant"]:first').trigger("change");
				}
			});
		}
		
		function notificationsGetContent() {
			var $box = $("#boxNotificationsContent");
			if (!$box.length) {
				return;
			}
			
			// show preloader
			$box.empty().addClass("ibox-content-notification");
			
			$('<div class="ibox-content-overlay"></div> \
				<div class="sk-spinner sk-spinner-double-bounce"> \
					<div class="sk-double-bounce1"></div> \
					<div class="sk-double-bounce2"></div> \
				</div>').appendTo($box);
			
			$box.find(".ibox-content-overlay, .sk-spinner").show();
			
			var $checked = $('input[name="variant"]:checked');
			
			$.get("index.php?controller=pjAdminEvents&action=pjActionNotificationsGetContent", {
				recipient: $('input[name="recipient"]:checked').val(),
				variant: $checked.val(),
				transport: $checked.data("transport"),
				event_id: $('#event_id').val()
			}).done(function (data) {
				
				$box.html(data);
				
				myTinyMceDestroy.call(null);
				myTinyMceInit.call(null, 'textarea.mceEditor');
				
				var index = $(".pj-form-langbar-item.btn-primary").data("index");
				if (index !== undefined) {
					$box.find('.pj-multilang-wrap[data-index!="' + index + '"]').hide();
					$box.find('.pj-multilang-wrap[data-index="' + index + '"]').show();
				}
			});
		}
		
		function notificationsSetContent(toggle) {
			
			var $box = $("#boxNotificationsContent");
			if (!$box.length) {
				return;
			}
			
			// show preloader
			$box.addClass("notification-box");
			
			$('<div class="ibox-content-overlay"></div> \
				<div class="sk-spinner sk-spinner-double-bounce"> \
					<div class="sk-double-bounce1"></div> \
					<div class="sk-double-bounce2"></div> \
				</div>').appendTo($box);
			
			$box.find(".ibox-content-overlay, .sk-spinner").show();
			
			var postData,
				$form = $('#pjNotificationContent');
			
			if (toggle) {
				postData = $.param({
					is_active: ($form.find("#is_active").is(":checked") ? 1 : 0),
					notify_id: $form.find('input[name="notify_id"]').val()
				});
			} else {
				postData = $form.find('input, textarea').serialize();
				postData = postData.replace(/&?is_active=(\w+)?/, "");
			}
			var $apply_recurring = $("input[name='apply_recurring']").is(":checked") ? 1 : 0,
				$recurring_id = $frmUpdateEvent.find("input[name='recurring_id']").val();
			$.post("index.php?controller=pjAdminEvents&action=pjActionNotificationsSetContent&apply_recurring=" + $apply_recurring + "&recurring_id=" + $recurring_id, postData).done(function (data) {
				
				if (data && data.status && data.status === "OK") {
					
					notificationsGetMetaData.call(null);
					
				}
				
			});
		}
		
		$("#boxNotificationsWrapper").on("change", 'input[name="recipient"]', function () {
			var event_id = $('#event_id').val();
			var search = window.location.search,
				recipient = search.match(/&?recipient=(\w+)/),
				variant = search.match(/&?variant=(\w+)/),
				transport = search.match(/&?transport=(\w+)/);
			var arr = [];
			arr.push("index.php?controller=pjAdminEvents&action=pjActionUpdate&id="+event_id+"&tab=confirmation&recipient=");
			arr.push(this.value);
			
			if (recipient !== null && recipient[1] === this.value) {
				if (variant !== null && transport !== null) {
					arr.push("&transport=");
					arr.push(transport[1]);
					arr.push("&variant=");
					arr.push(variant[1]);
				}
			}
			var url = arr.join("");
			history.pushState({
				url: url,
				title: null
			}, null, url);
			
			notificationsGetMetaData.call(null);			
		}).on("change", 'input[name="variant"]', function () {			
			var $this = $(this);
			var event_id = $('#event_id').val();
			var url = ["index.php?controller=pjAdminEvents&action=pjActionUpdate","&id=", event_id, "&tab=confirmation", "&recipient=" , $('input[name="recipient"]:checked').val(), "&transport=", $this.data("transport"), "&variant=", $this.val()].join("");
			history.pushState({
				url: url,
				title: null
			}, null, url);
			
			notificationsGetContent.call(null);
			
		}).on("change", '#is_active', function () {			
			notificationsSetContent.call(null, true);			
			var $this = $(this),
				$hidden = $this.closest("form").find(".notification-area");
			
			if ($this.is(":checked")) {
				$hidden.removeClass("hidden");
			} else {
				$hidden.addClass("hidden");
			}			
		}).on("click", ".pjRpbBtnSaveNotify", function (e) {
			e.preventDefault();			
			notificationsSetContent.call(null, false);			
			return false;
		});
		
		$(document).ready(function() {
			var $tab = $('.tabs-container .nav-tabs').find('li.active a').attr('data-tab');
			if ($tab == 'confirmation') {
				$('input[name="recipient"]:checked').trigger("change");
			}
		});
	});
})(jQuery);