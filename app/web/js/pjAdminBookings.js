var jQuery = jQuery || $.noConflict();
(function ($, undefined) {
	$(function () {
		var $frmCreateBooking = $("#frmCreateBooking"),
			$frmUpdateBooking = $("#frmUpdateBooking"),
			$frmExportBookings = $("#frmExportBookings"),
			validate = ($.fn.validate !== undefined),
			select2 = ($.fn.select2 !== undefined),
			dialog = ($.fn.dialog !== undefined),
			datagrid = ($.fn.datagrid !== undefined);
			
		if ($(".select-item").length && select2) {
            $(".select-item").select2({
                placeholder: '-- ' + myLabel.choose + ' --',
                allowClear: true
            });
        }
		
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
		
		var calculatePrice = function(){
			var total_price = 0,
				tax = 0,
				deposit = 0,
				total = 0,
				customer_people = 0;
			$(".pj-price").each(function(){
				total_price += parseFloat($(this).val(), 10) * parseFloat($(this).attr('lang'));
				customer_people += parseFloat($(this).val(), 10);
			});
			var discount = parseFloat($('#booking_discount').val());
			if (isNaN(discount)) { discount = 0; }
			tax = (total_price * parseFloat(myLabel.tax, 10) ) / 100;
			total = total_price - discount + tax;
			if (total < 0) { total = 0; }
			deposit = (total * parseFloat(myLabel.deposit, 10) ) / 100;
			$('#booking_price').val(total_price.toFixed(2));
			$('#booking_total').val(total.toFixed(2));
			$('#booking_tax').val(tax.toFixed(2));
			$('#booking_deposit').val(deposit.toFixed(2));
			if(customer_people > 0)
			{
				$('#customer_people').val(customer_people);
			}else{
				$('#customer_people').val("");
			}
		};
		
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
				
		if ($frmCreateBooking.length > 0 && validate) {
			$frmCreateBooking.validate({
				rules: {
					"unique_id": {
						required: true,
						remote: "index.php?controller=pjAdminBookings&action=pjActionCheckUniqueId"
					}
				},
				messages: {
					"unique_id":{
						remote: myLabel.duplicatedUniqueID
					},
					"customer_people": {
						required: myLabel.price_at_least
					}
				},
				onkeyup: false,
				ignore: ".ignore",
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
				    form.submit();
					return false;
				}
			});
			
		}
		if ($frmUpdateBooking.length > 0 && validate) {
			$frmUpdateBooking.validate({
				rules: {
					"unique_id": {
						required: true,
						remote: "index.php?controller=pjAdminBookings&action=pjActionCheckUniqueId&id=" + $frmUpdateBooking.find("input[name='id']").val()
					}
				},
				messages: {
					"unique_id":{
						remote: myLabel.duplicatedUniqueID
					},
					"customer_people": {
						required: myLabel.price_at_least
					}
				},
				onkeyup: false,
				ignore: ".ignore",
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
				    form.submit();
					return false;
				}
			});
			
			var event_id = $('#event_id').val(),
				booking_id = $('#booking_id').val();
			$.ajax({
				type: "GET",
				dataType: "html",
				url: "index.php?controller=pjAdminBookings&action=pjActionGetUpdatePrices&id=" + event_id + "&booking_id="+booking_id,
				success: function (res) {
					$('#price_container').html(res);
					calculatePrice();
				}
			});
		}
		
		if ($("#price_container").length > 0)
		{
			$("#price_container").on("change", ".pj-price", function (e) {
				calculatePrice();
			});
		}

		$(document).on("click", ".pjAdminApplyCode", function (e) {
			if (e && e.preventDefault) { e.preventDefault(); }
			var code = $.trim($('#voucher_code_input').val()),
				event_id = $('#event_id').val(),
				$msg = $('#voucher_msg');
			if (code === '') { return false; }
			if (!event_id) {
				$msg.css('color', '#a94442').html(myLabel.choose).show();
				return false;
			}
			var data = { code: code, event_id: event_id };
			$('.pj-price').each(function () {
				data[$(this).attr('name')] = $(this).val();
			});
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "index.php?controller=pjAdminBookings&action=pjActionApplyDiscount",
				data: data,
				success: function (res) {
					if (res && res.status === 'OK') {
						$('#booking_discount').val(parseFloat(res.discount).toFixed(2));
						$('#voucher_code').val(res.voucher_code);
						$msg.css('color', '#1ab394').html(res.text).show();
						calculatePrice();
					} else {
						$('#booking_discount').val('0.00');
						$('#voucher_code').val('');
						$msg.css('color', '#a94442').html(res && res.text ? res.text : '').show();
						calculatePrice();
					}
				}
			});
			return false;
		});

		if ($("#grid").length > 0 && datagrid) {
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
			var menuItems = [];
			
			if (pjGrid.hasResendConfirmation) {
				menuItems.push({text: myLabel.copy, url: "index.php?controller=pjAdminBookings&action=pjActionResend&id={:id}", ajax: false, render: true, target: "_blank"});
			}
			buttonsOpts.push({type: "print", url: myLabel.ticket_url + "{:unique_id}.pdf", target: "_blank"});
			if(pjGrid.hasUpdate)
			{
				buttonsOpts.push({type: "edit", url: "index.php?controller=pjAdminBookings&action=pjActionUpdate&id={:id}"});
			}
			if(pjGrid.hasDeleteSingle)
			{
				buttonsOpts.push({type: "delete", url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBooking&id={:id}"});
			}
			if (menuItems.length > 0) {
				buttonsOpts.push({type: "menu", url: "#", text: myLabel.more, items: menuItems});
			}
			if(pjGrid.hasDeleteMulti)
			{
				actionsOpts.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBookingBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			if (pjGrid.hasExportBooking) {
				actionsOpts.push({text: myLabel.exportSelected, url: "index.php?controller=pjAdminBookings&action=pjActionExportBooking", ajax: false});
			}
			var $grid = $("#grid").datagrid({
				buttons: buttonsOpts,
				columns: [
				          {text: myLabel.name, type: "text", sortable: true, editable: false},
				          {text: myLabel.eventdate, type: "text", sortable: true},
				          {text: myLabel.tickets, type: "text", sortable: true},
				          {text: myLabel.price, type: "text", sortable: true, editable: false},
				          {text: myLabel.status, type: "text", sortable: true, editable: false, renderer: formatStatus}],
				dataUrl: "index.php?controller=pjAdminBookings&action=pjActionGetBooking" + pjGrid.queryString,
				dataType: "json",
				fields: ['customer_name', 'event_start_ts', 'customer_people', 'booking_total', 'booking_status'],
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
			
			$(document).on("submit", ".frm-filter", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = $(this),
					content = $grid.datagrid("option", "content"),
					cache = $grid.datagrid("option", "cache");
				$.extend(cache, {
					q: $this.find("input[name='q']").val(),
					booking_status: $this.find("option:selected", "select[name='booking_status']").val(),
					unique_id: "",
					customer_name: "",
					customer_email: "",
					event_id: "",
					from_ticket: "",
					to_ticket: "",
					from_price: "",
					to_price: ""
				});
				$grid.datagrid("option", "cache", cache);
				$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking", content.column, content.direction, content.page, content.rowCount);
				return false;
			}).on("change", "#filter_status", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				$('.frm-filter').trigger('submit');
				return false;
			}).on("submit", ".frm-filter-advanced", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var obj = {},
					$this = $(this),
					arr = $this.serializeArray(),
					content = $grid.datagrid("option", "content"),
					cache = $grid.datagrid("option", "cache");
				for (var i = 0, iCnt = arr.length; i < iCnt; i++) {
					obj[arr[i].name] = arr[i].value;
				}
				$.extend(cache, obj);
				$grid.datagrid("option", "cache", cache);
				$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking", content.column, content.direction, content.page, content.rowCount);
				return false;
			}).on("reset", ".frm-filter-advanced", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $frm = $('.frm-filter-advanced');
				$frm.find("input[name='unique_id']").val('');
				$frm.find("input[name='customer_name']").val('');
				$frm.find("input[name='customer_email']").val('');
				$frm.find("select[name='event_id']").val('');
				$frm.find("select[name='booking_status']").val('');				
				$frm.find("input[name='from_ticket']").val('');
				$frm.find("input[name='to_ticket']").val('');
				$frm.find("input[name='from_price']").val('');
				$frm.find("input[name='to_price']").val('');				
				$(".btn-advance-search").trigger("click");
				$('.frm-filter-advanced').submit();
				return false;
			});
		}
		
		$(document).on("change", "#event_id", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var event_id = $(this).val(),
				ajax_url = "index.php?controller=pjAdminBookings&action=pjActionGetPrices&id=" + event_id;			
			if(event_id != '') {
				$('.pjEbcEventWrap').removeClass('col-sm-12').addClass('col-sm-10');
				var href = $('#pjEbcEditEvent').attr('data-href');
				href = href.replace("{ID}", event_id);
				$('#pjEbcEditEvent').attr('href', href);
				$('.pjEbcEditEventWrap').css('display', 'inline-block');
			} else {
				$('.pjEbcEventWrap').removeClass('col-sm-10').addClass('col-sm-12');
				$('.pjEbcEditEventWrap').css('display', 'none');
			}
			if($frmUpdateBooking.length > 0){
				booking_id = $('#booking_id').val();
				ajax_url = "index.php?controller=pjAdminBookings&action=pjActionGetUpdatePrices&id=" + event_id + "&booking_id="+booking_id;
			}
			$.ajax({
				type: "GET",
				dataType: "html",
				url: ajax_url,
				success: function (res) {
					$('#price_container').html(res);
					$('#booking_price').val('');
					$('#booking_total').val('');
					$('#booking_tax').val('');
					$('#booking_deposit').val('');
					if($frmUpdateBooking.length > 0){
						calculatePrice();
					}
				}
			});
		}).on("focus", "#bookings_feed", function (e) {
			$(this).select();
		}).on("change", "#booking_status", function (e) {
			var $pjEbcSummaryWrapper = $('#pjEbcSummaryWrapper');
			var value = $("#booking_status option:selected").val();
			var text = $("#booking_status option:selected").text();
			var bg_class = 'bg-' + value;
			$pjEbcSummaryWrapper.find('.panel-heading').removeClass("bg-pending").removeClass("bg-cancelled").removeClass("bg-confirmed").addClass(bg_class);
			$pjEbcSummaryWrapper.find('.status-text').html(text);
		}).on("click", ".widget-client-info", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$('.tab-client-details').trigger('click');
			return false;
		}).on("click", ".confirmation-email", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var booking_id = $(this).attr('data-id');
			var document_id = 0;
			var $confirmEmailContentWrapper = $('#confirmEmailContentWrapper');
			
			$('#btnSendEmailConfirm').attr('data-booking_id', booking_id);
			
			$confirmEmailContentWrapper.html("");
			$.get("index.php?controller=pjAdminBookings&action=pjActionEmailConfirmation", {
				"booking_id": booking_id
			}).done(function (data) {
				$confirmEmailContentWrapper.html(data);
				if(data.indexOf("pjResendAlert") == -1)
				{
					if ($('#mceEditor').length > 0) {
						myTinyMceDestroy.call(null);
						myTinyMceInit.call(null, 'textarea#mceEditor');
			        }
					
					validator = $confirmEmailContentWrapper.find("form").validate({});
					$('#btnSendEmailConfirm').show();
				}else{
					$('#btnSendEmailConfirm').hide();
				}	
				$('#confirmEmailModal').modal('show');
			});
			return false;
		}).on("click", "#btnSendEmailConfirm", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this);
			var $confirmEmailContentWrapper = $('#confirmEmailContentWrapper');
			if (validator.form()) {
				$('#mceEditor').html( tinymce.get('mceEditor').getContent() );
				$(this).attr("disabled", true);
				var l = Ladda.create(this);
			 	l.start();
				$.post("index.php?controller=pjAdminBookings&action=pjActionEmailConfirmation", $confirmEmailContentWrapper.find("form").serialize()).done(function (data) {
					if (data.status == "OK") {
						$('#confirmEmailModal').modal('hide');
					} else {
						$('#confirmEmailModal').modal('hide');
					}
					$this.attr("disabled", false);
					l.stop();
				});
			}
			return false;
		}).on("click", ".cancellation-email", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var booking_id = $(this).attr('data-id');
			var document_id = 0;
			var $cancellationEmailContentWrapper = $('#cancellationEmailContentWrapper');
			
			$('#btnSendEmailCancellation').attr('data-booking_id', booking_id);
			
			$cancellationEmailContentWrapper.html("");
			$.get("index.php?controller=pjAdminBookings&action=pjActionEmailCancellation", {
				"booking_id": booking_id
			}).done(function (data) {
				$cancellationEmailContentWrapper.html(data);
				if(data.indexOf("pjResendAlert") == -1)
				{
					if ($('#mceEditor').length > 0) {
						myTinyMceDestroy.call(null);
						myTinyMceInit.call(null, 'textarea#mceEditor');
			        }
					validator = $cancellationEmailContentWrapper.find("form").validate({});
					$('#btnSendEmailCancellation').show();
				}else{
					$('#btnSendEmailCancellation').hide();
				}	
				$('#cancellationEmailModal').modal('show');
			});
			return false;
		}).on("click", "#btnSendEmailCancellation", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this);
			var $cancellationEmailContentWrapper = $('#cancellationEmailContentWrapper');
			if (validator.form()) {
				$('#mceEditor').html( tinymce.get('mceEditor').getContent() );
				$(this).attr("disabled", true);
				var l = Ladda.create(this);
			 	l.start();
				$.post("index.php?controller=pjAdminBookings&action=pjActionEmailCancellation", $cancellationEmailContentWrapper.find("form").serialize()).done(function (data) {
					if (data.status == "OK") {
						$('#cancellationEmailModal').modal('hide');
					} else {
						$('#cancellationEmailModal').modal('hide');
					}
					$this.attr("disabled", false);
					l.stop();
				});
			}
			return false;
		}).on("click", ".payment-email", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var booking_id = $(this).attr('data-id');
			var document_id = 0;
			var $paymentEmailContentWrapper = $('#paymentEmailContentWrapper');
			
			$('#btnSendEmailPayment').attr('data-booking_id', booking_id);
			
			$paymentEmailContentWrapper.html("");
			$.get("index.php?controller=pjAdminBookings&action=pjActionEmailPayment", {
				"booking_id": booking_id
			}).done(function (data) {
				$paymentEmailContentWrapper.html(data);
				if(data.indexOf("pjResendAlert") == -1)
				{
					if ($('#mceEditor').length > 0) {
						myTinyMceDestroy.call(null);
						myTinyMceInit.call(null, 'textarea#mceEditor');
			        }
					validator = $paymentEmailContentWrapper.find("form").validate({});
					$('#btnSendEmailPayment').show();
				}else{
					$('#btnSendEmailPayment').hide();
				}	
				$('#paymentEmailModal').modal('show');
			});
			return false;
		}).on("click", "#btnSendEmailPayment", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this);
			var $paymentEmailContentWrapper = $('#paymentEmailContentWrapper');
			if (validator.form()) {
				$('#mceEditor').html( tinymce.get('mceEditor').getContent() );
				$(this).attr("disabled", true);
				var l = Ladda.create(this);
			 	l.start();
				$.post("index.php?controller=pjAdminBookings&action=pjActionEmailPayment", $paymentEmailContentWrapper.find("form").serialize()).done(function (data) {
					if (data.status == "OK") {
						$('#paymentEmailModal').modal('hide');
					} else {
						$('#paymentEmailModal').modal('hide');
					}
					$this.attr("disabled", false);
					l.stop();
				});
			}
			return false;
		}).on("click", ".btnMarkTicketUsed", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				$id = $this.attr('data-id');
			swal({
				title: myLabel.alert_mark_ticket_used_title,
				text: myLabel.alert_mark_ticket_used_text,
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: myLabel.btn_yes,
				cancelButtonText: myLabel.btn_cancel,
				closeOnConfirm: false,
				showLoaderOnConfirm: true
			}, function () {
				$.post("index.php?controller=pjAdminBookings&action=pjActionSetUseTicket", {id: $id}).done(function (data) {
					if (!(data && data.status)) {
						
					}
					switch (data.status) {
					case "OK":
						swal.close();
						$this.closest(".form-group").addClass('text-danger').html(data.text);
						break;
					}
				});
			});
		}).on("click", "#file", function (e) {
			$('#tsSubmitButton').html(myLabel.btn_export);
			$('.tsFeedContainer').hide();
			$('.tsPassowrdContainer').hide();
		}).on("click", "#feed", function (e) {
			$('.tsPassowrdContainer').show();
			$('#tsSubmitButton').html(myLabel.btn_get_url);
		}).on("focus", "#bookings_feed", function (e) {
			$(this).select();
		});		
	});
})(jQuery);