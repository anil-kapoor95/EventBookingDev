var jQuery = jQuery || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";

		var validate = ($.fn.validate !== undefined),
            $document = $(document),
			$frmUpdateOptions = $('#frmUpdateOptions');

		if($(".field-int").length > 0)
        {
            $(".field-int").TouchSpin({
                verticalbuttons: true,
                buttondown_class: 'btn btn-white',
                buttonup_class: 'btn btn-white',
                max: 4294967295
            });
        }

		if ($frmUpdateOptions.length && validate) {
			$frmUpdateOptions.validate();
		}
		
		$(window).on("popstate", function (e) {
			var state = e.originalEvent.state;
			if (state !== null) {
				//load
			} else {
				//empty
			}
		});
				
		function reDrawCode() {
			var code = $("#hidden_code").text(),
				view = $("select[name='install_view']").find("option:selected").val(),
				icons = $("input[name='hide_icons']").is(":checked") ? "T" : "F",
				cid = $('#install_category').length > 0 ? $('#install_category').val() : 0,
				locale = locale = $('#install_locale').length > 0 ? $('#install_locale').val() : ($('#hidden_locale').length > 0 ? $('#hidden_locale').val(): ''),
				hide = $("input[name='install_hide']").is(":checked") ? "&hide=1" : "";
			locale = parseInt(locale, 10) > 0 ? ("&locale=" + locale) : "";
			code = code.replace('{VIEW}', view);
			code = code.replace('{ICONS}', icons);
			code = code.replace('{CID}', cid);
			code = code.replace('{LOCALE}', locale);
			code = code.replace('{HIDE}', hide);			
			$("#install_code").val(code);
		}	
		
		if($('#install_code').length > 0)
		{
			reDrawCode();
		}
		
		$(".decimal").keyup(function(){
			var $this = $(this);
			var value = $this.val();
			if(value.indexOf(".") >= 0)
			{
				var number = ($this.val().split('.'));
			    if (number[1].length > 2)
			    {
			        var salary = parseFloat($this.val());
			        $this.val( salary.toFixed(2));
			    }
			}
		   
		});
	    
		$document.on( 'change', '.onoffswitch-checkbox', function (e) {
			var name = $(this).attr('name');
			if($(this).is(':checked'))
			{
				$('input[name="value-enum-'+name+'"]').val('Yes|No::Yes');
			}else{
				$('input[name="value-enum-'+name+'"]').val('Yes|No::No');
			}
		}).on("focus", ".textarea_install", function (e) {
			var $this = $(this);
			$this.select();
			$this.mouseup(function() {
				$this.unbind("mouseup");
				return false;
			});
		}).on("change", "select[name='install_view'], input[name='hide_icons'], select[name='install_category'], select[name='install_locale'], input[name='install_hide']", function(e) {
            reDrawCode.call(null);
		});

		var $topMenu = $("#page-wrapper").children(".row.border-bottom"),
			$iframe = $("#iframeEditor"),
			$body = $("body"),
			$window = $(window);

		function resizeIframe() {
			if (!$iframe.length) {
				return;
			}

			$iframe.height($window.height() - $topMenu.outerHeight());
		}

		if ($iframe.length) {

			$iframe.on('load', function () {
			    var body = this.contentWindow.document.body;
			    if (body.getAttribute('data-editor'))
                {
                    var script = document.createElement('script');
                    script.type = 'text/javascript';
                    script.async = true;
                    script.src = body.getAttribute('data-editor');
                    window.setTimeout(function () {
                        body.appendChild(script);
                    }, 1200);
                }

				var head = this.contentWindow.document.getElementsByTagName('head')[0],
					style = document.createElement('link');
				style.rel = 'stylesheet';
				style.href = 'third-party/font_awesome/4.7.0/css/font-awesome.min.css';
				head.appendChild(style);
			});

			$body.addClass("page-editor");
			resizeIframe.call(null);

			$window.on("resize", function () {
				resizeIframe.call(null);
			});
		}

		$(document).on('click', '.device-view', function (e) {
			e.preventDefault();

			var $this = $(this),
				device = $this.data('device'),
				orientation = $this.data('orientation'),
				$device = $('#iframeDevice'),
				$holder = $('#iframeHolder');

			$this.closest('.row').find('.device-view.active').removeClass('active').end().end().addClass('active');

			switch (device) {
			case 'desktop':
				$device.addClass('hidden');
				$iframe.insertBefore($device);
				$body.addClass('page-editor');
				$window.trigger('resize');
				break;
			case 'tablet':
			case 'phone':
				$iframe.appendTo($holder);
				$holder.removeClass().addClass(device + '-view-' + orientation);
				$device.removeClass('hidden');
				$body.removeClass('page-editor');
				$('#device_title').html($(['#', device, '_', orientation].join('')).html());
				$('#device_info').html($(['#', device, '_', orientation, '_info'].join('')).html());
				break;
			}

			return false;
		}).on('click', '[data-theme]', function (e) {
		    e.preventDefault();
		    
		    var $this = $(this);
		    
		    $.post("index.php?controller=pjAdminOptions&action=pjActionUpdateTheme", {
		    	theme: $this.data("index")
		    }).done(function (data) {
		    	if (data && data.status && data.status === "OK") {
		    		$this.closest(".dropdown-menu").find(".thumbnail").removeClass("active");
		    		$this.addClass("active");
		    	}
		    });

		    var $link = $(".open-new-window");
		    if ($link.length) {
		    	$link.attr("href", $link.attr("href").replace(/(&?theme=)theme\d+/, '$1' + $this.data("index")));
		    }
			$iframe.attr('src', $this.attr('href'));
			//$('.device-view.active').trigger('click');
		});
	});
})(jQuery);