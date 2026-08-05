(function (window, undefined){
	"use strict";
	
	pjQ.$.ajaxSetup({
		xhrFields: {
			withCredentials: true
		}
	});
	
	var document = window.document,
		routes = [],
		validate = (pjQ.$.fn.validate !== undefined);
	
	function log() {
		if (window.console && window.console.log) {
			for (var x in arguments) {
				if (arguments.hasOwnProperty(x)) {
					window.console.log(arguments[x]);
				}
			}
		}
	}
	
	function assert() {
		if (window && window.console && window.console.assert) {
			window.console.assert.apply(window.console, arguments);
		}
	}
	
	function hashBang(value) {
		if (value !== undefined && value.match(/^#!\//) !== null) {
			if (window.location.hash == value) {
				return false;
			}
			window.location.hash = value;
			return true;
		}
		
		return false;
	}
	
	function onHashChange() {
		var i, iCnt, m;
		for (i = 0, iCnt = routes.length; i < iCnt; i++) {
			m = window.location.hash.match(routes[i].pattern);
			if (m !== null) {
				pjQ.$(window).trigger(routes[i].eventName, m.slice(1));
				break;
			}
		}
		if (m === null) {
			pjQ.$(window).trigger("loadEvents");
		}
	}
	function res() {
		var _td = pjQ.$(".pjIcCalendarTable td");
		var td_width = _td.width();
		_td.height(td_width);
    }
	pjQ.$(window).on("hashchange", function (e) {
    	onHashChange.call(null);
    });
	
	function EBCalendar(opts) {
		if (!(this instanceof EBCalendar)) {
			return new EBCalendar(opts);
		}
				
		this.reset.call(this);
		this.init.call(this, opts);
		
		return this;
	}
	
	EBCalendar.inObject = function (val, obj) {
		var key;
		for (key in obj) {
			if (obj.hasOwnProperty(key)) {
				if (obj[key] == val) {
					return true;
				}
			}
		}
		return false;
	};
	
	EBCalendar.size = function(obj) {
		var key,
			size = 0;
		for (key in obj) {
			if (obj.hasOwnProperty(key)) {
				size += 1;
			}
		}
		return size;
	};
	
	EBCalendar.prototype = {
		reset: function () {
			this.$container = null;
			this.$detail_container = null;
			this.container = null;
			this.opts = {};
			
			this.month = null;
			this.year = null;
			this.view = null;
			this.category_id = null;
			this.page = null;
			this.period = null;
			this.date = null;
			this.postData = null;
			this.event_id = null;
			this.voucher = null;

			return this;
		},
		disableButtons: function () {
			var $el;
			this.$container.find(".btn").each(function (i, el) {
				$el = pjQ.$(el);
				$el.attr("disabled", "disabled");
				$el.addClass('pjEbcButtonDisabled');
			});
		},
		enableButtons: function () {
			var $el;
			this.$container.find(".pjEbcButton").each(function (i, el) {
				$el = pjQ.$(el);
				$el.removeAttr("disabled");
				$el.removeClass('pjEbcButtonDisabled');
			});
		},
		
		init: function (opts) {
			var self = this;
			this.opts = opts;
			this.container = document.getElementById("pjEbcContainer_" + this.opts.index);
			this.$container = pjQ.$(this.container);
			
			self.$detail_container = pjQ.$('#pjEbcEventDetail_' + self.opts.index);
			
			self.month = self.opts.current_month;
			self.year = self.opts.current_year;
			self.view = self.opts.default_view;
			self.category_id = self.opts.category_id;
			self.page = 1;
			
			self.loadEvents();
			
			this.$container.on("click.ebc", ".pjEbcLocale", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var locale = pjQ.$(this).data("id");
				self.opts.locale = locale;
				pjQ.$('.pjEbcLocale').removeClass('pjEbcLocaleActive');
				pjQ.$(this).addClass("pjEbcLocaleActive");
				pjQ.$.get([self.opts.folder, "index.php?controller=pjFront&action=pjActionLocale"].join(""), {
					"session_id": self.opts.session_id,
					"index": self.opts.index,
					"locale": locale,
					"hide": self.opts.hide,
					"category_id": self.category_id,
				}).done(function (data) {					
					self.loadEvents();
				}).fail(function () {
					log("Deferred is rejected");
				});
				return false;
			}).on("click.ebc", ".pjEbcCategory", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.event_id = 0;
				self.category_id = pjQ.$(this).attr('data-id');
				self.loadEvents();
				return false;
			}).on("click.ebc", ".pjEbcIcon", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.month = self.opts.current_month;
				self.year = self.opts.current_year;
				self.page = 1;
				self.view = pjQ.$(this).data('view');
				self.loadEvents();
				return false;
			}).on("click.ebc", ".pjEbcMonthlyNav", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.month = pjQ.$(this).data('month');
				self.year = pjQ.$(this).data('year');
				self.loadEvents();
				
				return false;
			}).on("click.ebc", ".pjEBcMonthName", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				if(!pjQ.$(this).hasClass('active'))
				{
					self.month = pjQ.$(this).data('month');
					self.year = pjQ.$(this).data('year');
					self.loadEvents();
				}
				return false;
			}).on("click.ebc", ".pjEbcBuyTicket", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				
				self.event_id = pjQ.$(this).data('id');
				self.loadBookingForm();
				return false;
			}).on("click.ebc", ".pjEbcCloseForm, .pjEbcCancelBooking", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.event_id = 0;
				self.closeBookingForm();
				return false;
			}).on("click.ebc", ".pjEbcPage", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.page = pjQ.$(this).data('page');
				self.loadEvents();
				return false;
			}).on("click.ebc", ".pjEbcCalendarNav", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.month = pjQ.$(this).data('month');
				self.year = pjQ.$(this).data('year');
				self.loadEvents();
				return false;
			}).on("click.ebc", ".pjEbcEventCell", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.date = pjQ.$(this).data('iso');
				self.loadEventDetail();
				return false;
			}).on("click.ebc", ".pjEbcCloseEvent", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				if(self.opts.display_events == 'replace')
				{
					pjQ.$('#pjEbcTableCalendar_' + self.opts.index).show();
					pjQ.$('.pjEbcIcons').show();
					pjQ.$('#pjEbcEventCalendar_' + self.opts.index).hide();
				}else{
					self.$detail_container.html("");
					pjQ.$('html, body').animate({
				        scrollTop: self.$container.offset().top
				    }, 500);
				}
				return false;
			}).on("click.ebc", ".pjEbcBackToCalendar", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var view = pjQ.$(this).attr('data-view');
				if(view == 'calendar')
				{
					if(self.opts.display_events == 'replace')
					{
						pjQ.$('#pjEbcTableCalendar_' + self.opts.index).show();
						pjQ.$('.pjEbcIcons').show();
						pjQ.$('#pjEbcEventCalendar_' + self.opts.index).hide();
						pjQ.$('.pjEbcBookingWrapper').hide();
					}else{
						self.$detail_container.html("");
						pjQ.$('html, body').animate({
					        scrollTop: self.$container.offset().top
					    }, 500);
					}
				}else{
					self.month = self.opts.current_month;
					self.year = self.opts.current_year;
					self.page = 1;
					self.view = view;
					self.loadEvents();
				}
				return false;
			}).on("change.ebc", ".pjEbcPriceSelector", function (e) {
				var ticket_cnt = 0;
				pjQ.$( ".pjEbcPriceSelector" ).each(function( index ) {
					var cnt = pjQ.$(this).val();
					ticket_cnt += parseInt(cnt, 10);
				});
				if(ticket_cnt == 0)
				{
					pjQ.$('#pjEbcTicketValidate_' + self.opts.index).val("");
				}else{
					var rand = Math.ceil(Math.random() * 999999);
					pjQ.$('#pjEbcTicketValidate_' + self.opts.index).val(rand).valid();
				}
				self.calPrices(1);
			}).on("click.ebc", ".pjEbcApplyCode", function (e) {
				if (e && e.preventDefault) { e.preventDefault(); }
				var idx = self.opts.index,
					code = pjQ.$.trim(pjQ.$('#pjEbcVoucherCode_' + idx).val()),
					$msg = pjQ.$('#pjEbcVoucherMsg_' + idx);
				if (code === '') { return false; }
				pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionApplyCode&session_id=" + self.opts.session_id].join(""), { code: code, event_id: self.event_id }).done(function (data) {
					var json = (typeof data === 'string') ? pjQ.$.parseJSON(data) : data;
					if (json && (json.status === 'OK' || json.code === 200) && json.voucher) {
						self.voucher = json.voucher;
						$msg.removeClass('pjEbcError').html(json.text || '').show();
						pjQ.$('.pjEbcRemoveCode').show();
					} else {
						self.voucher = null;
						$msg.addClass('pjEbcError').html((json && json.text) ? json.text : '').show();
						pjQ.$('.pjEbcRemoveCode').hide();
					}
					self.calPrices(1);
				}).fail(function () {
					log("Deferred is rejected");
				});
				return false;
			}).on("click.ebc", ".pjEbcRemoveCode", function (e) {
				if (e && e.preventDefault) { e.preventDefault(); }
				var idx = self.opts.index;
				pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionRemoveCode&session_id=" + self.opts.session_id].join(""), {}).done(function () {
					self.voucher = null;
					pjQ.$('#pjEbcVoucherCode_' + idx).val('');
					pjQ.$('#pjEbcVoucherMsg_' + idx).hide().html('');
					pjQ.$('.pjEbcRemoveCode').hide();
					self.calPrices(1);
				}).fail(function () {
					log("Deferred is rejected");
				});
				return false;
			}).on("click.ebc", ".pjEbcBackToList", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.event_id = 0;
				self.period = pjQ.$(this).data('period');
				self.page = 1;
				self.loadEvents();
				return false;
			}).on("click.ebc", ".pjEbcViewDetails", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.event_id = pjQ.$(this).data('id');
				self.$container.html(self.opts.message_9);
				self.loadView();
				return false;
			}).on("click.ebc", ".pjEbcBackToDetail", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.event_id = pjQ.$(this).data('id');
				self.$container.html(self.opts.message_9);
				self.loadView();
				return false;
			}).on("click.ebc", ".pjEbcBackToForm", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.event_id = pjQ.$(this).data('id');
				self.$container.html(self.opts.message_3);
				self.loadBookingForm();
				return false;
			}).on("change.ebc", "#pjEbcPaymentMethod_" + self.opts.index, function (e) {
				var payment_method = pjQ.$(this).val();
				switch(payment_method) {
				    case 'creditcard':
				        pjQ.$('.ebcal-ccdata').show();
				        pjQ.$('.ebcal-bankdata').hide();
				        pjQ.$('.pjEbcCCField').addClass('required');
				        break;
				    case 'bank':
				    	pjQ.$('.ebcal-ccdata').hide();
				        pjQ.$('.ebcal-bankdata').show();
				        pjQ.$('.pjEbcCCField').removeClass('required');
				        break;
				    default:
				    	pjQ.$('.ebcal-ccdata').hide();
				    	pjQ.$('.ebcal-bankdata').hide();
				    	pjQ.$('.pjEbcCCField').removeClass('required');
				} 
				return false;
			}).on("click.ebc", ".pjEbcCancelSummary", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				self.loadBookingForm();
				return false;
			}).on("click.ebc", "#pjEbcCaptchaImage_" + self.opts.index, function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $captcha = pjQ.$(this);
				$captcha.attr("src", $captcha.attr("src").replace(/(&rand=)\d+/g, '\$1' + Math.ceil(Math.random() * 99999)));
				pjQ.$("#pjEbcCaptchaField_" + self.opts.index).val("").removeData('previousValue');
				return false;
			});
			
			pjQ.$(document).on("click.ebc", 'button[data-dismiss="modal"]', function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $modal = pjQ.$(this).closest('.modal');
				if ($modal !== undefined && $modal.length > 0) {
					$modal.modal('hide');
					pjQ.$('body').removeClass('modal-open');
				}
				return false;
			});
		},
		loadView: function()
		{
			var self = this,
				index = this.opts.index,
				params =	{
								"session_id": this.opts.session_id,
								"theme": this.opts.theme,
								"locale": this.opts.locale,
								"hide": this.opts.hide,
								"index": this.opts.index,
								"show_header": this.opts.show_header,
								"show_icons": this.opts.show_icons,
								"show_categories": this.opts.show_categories,
								"category_id": self.category_id,
								"period": self.period
							};
			if(self.event_id > 0)
			{
				pjQ.$.extend(params, {"id" : self.event_id});
			}
			pjQ.$.get([this.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionView"].join(""), params).done(function (data) {
				self.$container.html(data);
				
			}).fail(function () {
				self.enableButtons.call(self);
			});
		},
		loadEvents: function()
		{
			var self = this,
				index = this.opts.index,
				params =	{
								"session_id": this.opts.session_id,			
								"theme": this.opts.theme,
								"locale": this.opts.locale,
								"hide": this.opts.hide,
								"index": this.opts.index,
								"show_header": this.opts.show_header,
								"show_icons": this.opts.show_icons,
								"show_categories": this.opts.show_categories,
								"category_id": self.category_id,
								"month": self.month,
								"year": self.year,
								"view": self.view,
								"period": self.period,
								"page": self.page
							};
			if(self.opts.event_id > 0)
			{
				pjQ.$.extend(params, {"event_id" : self.opts.event_id});
			}
			pjQ.$.get([this.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionLoadEvents"].join(""), params).done(function (data) {
				self.$container.html(data);
				if(self.view == 'calendar' && pjQ.$('#pjEbcEventDetail_' + self.opts.index).length > 0)
				{
					self.$detail_container = pjQ.$('#pjEbcEventDetail_' + self.opts.index);
					
					pjQ.$(window).resize(res).trigger("resize");
					
					pjQ.$('.pjEbcTooltipster').each(function(){
						var $tooltip = pjQ.$(this);
						var $content = $tooltip.attr('data-title');
						$tooltip.tooltipster({
			        		contentAsHTML: true,
			        		content: $content
			        	});
					});
				}
				
			}).fail(function () {
				self.enableButtons.call(self);
			});
		},
		loadEventDetail: function()
		{
			var self = this,
				index = this.opts.index,
				params =	{
								"session_id": this.opts.session_id,
								"theme": this.opts.theme,
								"locale": this.opts.locale,
								"hide": this.opts.hide,
								"index": this.opts.index,
								"show_header": this.opts.show_header,
								"show_icons": this.opts.show_icons,
								"show_categories": this.opts.show_categories,
								"view": self.view,
								"category_id": self.category_id,
								"date": self.date
							};
			pjQ.$.get([self.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionLoadEventDetail"].join(""), params).done(function (data) {
				self.$detail_container.html(data);
				if(self.opts.display_events == 'replace')
				{
					pjQ.$('#pjEbcTableCalendar_' + self.opts.index).hide();
					pjQ.$('.pjEbcIcons').hide();
				}else{
					pjQ.$('html, body').animate({
				        scrollTop: self.$detail_container.offset().top
				    }, 500);
				}
			}).fail(function () {
				self.enableButtons.call(self);
			});
		},
		loadBookingForm: function()
		{
			var self = this,
				index = this.opts.index,
				params =	{
								"session_id": this.opts.session_id,
								"theme": this.opts.theme,
								"locale": this.opts.locale,
								"hide": this.opts.hide,
								"index": this.opts.index,
								"show_header": this.opts.show_header,
								"show_icons": this.opts.show_icons,
								"show_categories": this.opts.show_categories,
								"category_id": self.category_id,
								"view": self.view
							};
			if(self.event_id > 0)
			{
				pjQ.$.extend(params, {"event_id" : self.event_id});
			}
			pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionLoadBookingForm", '&' + pjQ.$.param( params )].join(""), self.postData).done(function (data) {
				if(self.view == 'calendar')
				{
					self.$detail_container.html(data);
					pjQ.$('html, body').animate({
				        scrollTop: self.$detail_container.offset().top
				    }, 500);
				}else{
					self.$container.html(data);
					pjQ.$('html, body').animate({
				        scrollTop: self.$container.offset().top
				    }, 500);
				}
				self.bindBookingForm();
				self.calPrices(0);
			}).fail(function () {
				log("Deferred is rejected");
			});
		},
		loadBookingSummary: function()
		{
			var self = this,
				index = this.opts.index,
				params =	{
								"session_id": this.opts.session_id,
								"theme": this.opts.theme,
								"locale": this.opts.locale,
								"hide": this.opts.hide,
								"index": this.opts.index,
								"show_header": this.opts.show_header,
								"show_icons": this.opts.show_icons,
								"show_categories": this.opts.show_categories,
								"category_id": self.category_id,
								"view": self.view
							};
			if(self.event_id > 0)
			{
				pjQ.$.extend(params, {"event_id" : self.event_id});
			}
			pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionLoadBookingSummary", '&' + pjQ.$.param( params )].join(""), self.postData).done(function (data) {
				if(self.view == 'calendar')
				{
					self.$detail_container.html(data);
					pjQ.$('html, body').animate({
				        scrollTop: self.$detail_container.offset().top
				    }, 500);
				}else{
					self.$container.html(data);
					pjQ.$('html, body').animate({
				        scrollTop: self.$container.offset().top
				    }, 500);
				}
				self.bindBookingSummary();
			}).fail(function () {
				log("Deferred is rejected");
			});
		},
		loadPaymentForm: function(obj)
		{
			var self = this,
				index = this.opts.index,
				params =	{
								"session_id": this.opts.session_id,
								"theme": this.opts.theme,
								"locale": this.opts.locale,
								"hide": this.opts.hide,
								"index": this.opts.index,
								"show_header": this.opts.show_header,
								"show_icons": this.opts.show_icons,
								"show_categories": this.opts.show_categories,
								"category_id": self.category_id,
								"view": self.view,
								"id": obj.booking_id
							};
			if(self.event_id > 0)
			{
				pjQ.$.extend(params, {"event_id" : self.event_id});
			}
			
			pjQ.$.get([self.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionGetPaymentForm", '&' + pjQ.$.param( params )].join("")).done(function (data) {
				if(self.view == 'calendar')
				{
					self.$detail_container.html(data);
					var $payment_form = self.$detail_container.find("form[name='pjOnlinePaymentForm']").first(),
						$paypal_button_container = self.$detail_container.find("#paypal-button-container");
				}else{
					self.$container.html(data);
					var $payment_form = self.$container.find("form[name='pjOnlinePaymentForm']").first(),
						$paypal_button_container = self.$container.find("#paypal-button-container");
				}
				
				if ($payment_form.length > 0) {
					setTimeout(function(){
						$payment_form.trigger('submit');
				    },2000);
				} else if ($paypal_button_container.length > 0) {
					/* PAYPAL EXPRESS CHECKOUT */
				} else {
					setTimeout(function(){
						window.location.href = self.opts.thankyou_url;
				    },2000);
				}
			}).fail(function () {
				log("Deferred is rejected");
			});
		},
		closeBookingForm: function()
		{
			var self = this;
			self.postData = pjQ.$('#pjEbcBookingForm_' + self.opts.index).serialize();
			if(self.view == 'monthly' || self.view == 'list')
			{
				self.$container.html(self.opts.message_1);
				self.loadEvents();
			}else if(self.view == 'calendar'){
				self.$detail_container.html(self.opts.message_1);
				self.loadEventDetail();
			}
		},
		bindBookingForm: function()
		{
			var self = this;
			var $frmBookingForm = pjQ.$('#pjEbcBookingForm_' + self.opts.index);
			if(self.view == 'calendar')
			{
				var $reCaptcha = self.$detail_container.find('#g-recaptcha_' + self.opts.index);
			}else{
				var $reCaptcha = self.$container.find('#g-recaptcha_' + self.opts.index);
			}
			if ($reCaptcha.length > 0)
            {
                grecaptcha.render($reCaptcha.attr('id'), {
                    sitekey: $reCaptcha.data('sitekey'),
                    callback: function(response) {
                        var elem = pjQ.$("input[name='recaptcha']");
                        elem.val(response);
                        elem.valid();
                    }
                });
            }
			
			if ($frmBookingForm.length > 0 && validate) 
			{
				var ticket_cnt = 0;
				pjQ.$( ".pjEbcPriceSelector" ).each(function( index ) {
					var cnt = pjQ.$(this).val();
					ticket_cnt += parseInt(cnt, 10);
				});
				if(ticket_cnt == 0)
				{
					pjQ.$('#pjEbcTicketValidate_' + self.opts.index).val("");
				}else{
					var rand = Math.ceil(Math.random() * 999999);
					pjQ.$('#pjEbcTicketValidate_' + self.opts.index).val(rand);
				}
				$frmBookingForm.validate({
					rules: {
						"captcha": {
							remote: self.opts.folder + "index.php?controller=pjFrontEnd&action=pjActionCheckCaptcha&session_id=" + self.opts.session_id
						},
						"recaptcha": {
	                        remote: self.opts.folder + "index.php?controller=pjFrontEnd&action=pjActionCheckReCaptcha&session_id=" + self.opts.session_id,
	                    },
					},
					errorPlacement: function (error, element) {
						if(element.attr('name') == 'captcha')
						{
							error.insertAfter(element.parent().parent());
						}else if(element.attr('name') == 'accept_term')
						{
							error.insertAfter(element.parent());
						}else{
							error.insertAfter(element);
						}
					},
					onkeyup: false,
					errorClass: "pjEbcError",
					wrapper: "em",
					ignore: "",
					submitHandler: function (form) {
						self.postData = pjQ.$(form).serialize();
						
						if(self.view == 'calendar')
						{
							self.$detail_container.html(self.opts.message_3);
						}else{
							self.$container.html(self.opts.message_3);
						}
						self.loadBookingSummary();
						return false;
					}
				});
			}
		},
		bindBookingSummary: function()
		{
			var self = this;
			var $frmBookingSummary = pjQ.$('#pjEbcBookingSummary_' + self.opts.index);
		
			if ($frmBookingSummary.length > 0 && validate) {
				
				$frmBookingSummary.validate({
					errorPlacement: function (error, element) {
						error.insertAfter(element);
					},
					onkeyup: false,
					errorClass: "pjEbcError",
					wrapper: "em",
					submitHandler: function (form) {
						self.disableButtons();
						pjQ.$('#pjEbcMessageContainer_' + self.opts.index).show();
						pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionBookingSave", "&session_id=", self.opts.session_id].join(""), self.postData).done(function (data) {
							pjQ.$('#pjEbcMessageContainer_' + self.opts.index).hide();
							switch (data.code) {
								case 100:
									pjQ.$('#pjEbcErrorMessage_' + self.opts.index).html(self.opts.message_7).show();
									self.enableButtons();
									break;
								case 200:
									self.loadPaymentForm(data);
								break;
								default:
									pjQ.$('#pjEbcErrorMessage_' + self.opts.index).html(data.text).show();
									self.enableButtons();
									break;
							}
						}).fail(function () {
							log("Deferred is rejected");
							self.enableButtons();
						});
						return false;
					}
				});
			}
		},
		calPrices: function(notice)
		{
			var self = this,
				price = 0,
				tax = 0,
				deposit = 0,
				total_price = 0,
				$price_label = pjQ.$('#pjEbcPrice_' + this.opts.index),
				$tax_label = pjQ.$('#pjEbcTax_' + this.opts.index),
				$total_price_label = pjQ.$('#pjEbcTotalPrice_' + this.opts.index),
				$deposit_label = pjQ.$('#pjEbcDeposit_' + this.opts.index),
				$discount_label = pjQ.$('#pjEbcDiscount_' + this.opts.index),
				$discount_rate = pjQ.$('#pjEbcDiscountRate_' + this.opts.index),
				discount = 0,
				$frmBookingForm = pjQ.$('#pjEbcBookingForm_' + this.opts.index);

			pjQ.$( ".pjEbcPriceSelector" ).each(function( index ) {
				var unit_price = pjQ.$(this).data('price'),
					cnt = pjQ.$(this).val();
				price += parseFloat(unit_price) * parseInt(cnt, 10);
			});

			if(price <= 0)
			{
				$price_label.html("");
				$tax_label.html("");
				$total_price_label.html("");
				$deposit_label.html("");
				$discount_label.html("");
				pjQ.$('.pjEbcPriceRow').hide();
				$frmBookingForm.find("input[name='total_price']").val("");
				$frmBookingForm.find("select[name='payment_method']").removeClass('required');
			}else{
				discount = self.calDiscount(price);
				// Tax / booking fee applies to the amount actually payable (after
				// the discount), so a 100% discount => $0 payable => no fee.
				var taxable = price - discount;
				if(taxable < 0)
				{
					taxable = 0;
				}
				// Guard the rate parse: when the event has no tax/deposit
				// configured, opts.tax/opts.deposit can be empty and parseFloat
				// would return NaN, which cascades into "$NaN" on every line.
				var taxRate = parseFloat(self.opts.tax);
				if(isNaN(taxRate))
				{
					taxRate = 0;
				}
				var depositRate = parseFloat(self.opts.deposit);
				if(isNaN(depositRate))
				{
					depositRate = 0;
				}
				tax = taxRate * taxable / 100;
				total_price = taxable + tax;
				if(total_price < 0)
				{
					total_price = 0;
				}
				deposit = depositRate * total_price / 100;
				$price_label.html(self.formatCurrency(price, self.opts.currency));
				$tax_label.html(self.formatCurrency(tax, self.opts.currency));
				$total_price_label.html(self.formatCurrency(total_price, self.opts.currency));
				$deposit_label.html(self.formatCurrency(deposit, self.opts.currency));
				pjQ.$('.pjEbcPriceRow').show();
				if(discount > 0)
				{
					$discount_label.html("-" + self.formatCurrency(discount, self.opts.currency));
					if($discount_rate.length && self.voucher)
					{
						var rateTxt = "";
						if(self.voucher.voucher_type == 'percent')
						{
							rateTxt = " (" + parseFloat(self.voucher.voucher_discount).toFixed(2) + "%)";
						}
						else
						{
							rateTxt = " (" + self.formatCurrency(parseFloat(self.voucher.voucher_discount), self.opts.currency) + ")";
						}
						$discount_rate.html(rateTxt);
					}
					pjQ.$('.pjEbcDiscountRow').show();
				}
				else
				{
					$discount_label.html("");
					$discount_rate.html("");
					pjQ.$('.pjEbcDiscountRow').hide();
				}
				$frmBookingForm.find("input[name='total_price']").val(price.toFixed(2));
				$frmBookingForm.find("select[name='payment_method']").addClass('required');
				if(notice == 1)
				{
					pjQ.$('#pjEbcErrorMessage_' + self.opts.index).hide();
				}
			}
		},
		calDiscount: function(price)
		{
			var self = this, discount = 0;
			if(!self.voucher)
			{
				return 0;
			}
			var disc = parseFloat(self.voucher.voucher_discount);
			if(isNaN(disc))
			{
				return 0;
			}
			var type = self.voucher.voucher_type,
				subtotal = 0,
				lines = [];
			pjQ.$( ".pjEbcPriceSelector" ).each(function( index ) {
				var unit_price = parseFloat(pjQ.$(this).data('price')),
					cnt = parseInt(pjQ.$(this).val(), 10);
				if(cnt > 0)
				{
					subtotal += unit_price * cnt;
					lines.push({ unit: unit_price, qty: cnt, amount: unit_price * cnt });
				}
			});
			if(self.voucher.voucher_apply == 'each')
			{
				for(var i = 0; i < lines.length; i++)
				{
					if(type == 'percent')
					{
						discount += (lines[i].amount * disc) / 100;
					}
					else // amount off per ticket, capped at the ticket's unit price
					{
						discount += Math.min(disc, lines[i].unit) * lines[i].qty;
					}
				}
			}
			else // whole booking
			{
				if(type == 'percent')
				{
					discount = subtotal * disc / 100;
				}
				else // fixed amount once, capped at subtotal
				{
					discount = Math.min(disc, subtotal);
				}
			}
			if(discount > subtotal) { discount = subtotal; }
			if(discount < 0) { discount = 0; }
			return discount;
		},
		formatCurrency: function(price, currency)
		{
			var format = '---';
			switch (currency)
			{
				case 'USD':
					format = "$" + price.toFixed(2);
					break;
				case 'GBP':
					format = "&pound;" + price.toFixed(2);
					break;
				case 'EUR':
					format = "&euro;" + price.toFixed(2);
					break;
				case 'JPY':
					format = "&yen;" + price.toFixed(2);
					break;
				case 'AUD':
				case 'CAD':
				case 'NZD':
				case 'CHF':
				case 'HKD':
				case 'SGD':
				case 'SEK':
				case 'DKK':
				case 'PLN':
					format = price.toFixed(2) + currency;
					break;
				case 'NOK':
				case 'HUF':
				case 'CZK':
				case 'ILS':
				case 'MXN':
					format = currency + price.toFixed(2);
					break;
				default:
					format = price.toFixed(2) + currency;
					break;
			}
			return format;
		},
	};
	
	window.EBCalendar = EBCalendar;	
})(window);