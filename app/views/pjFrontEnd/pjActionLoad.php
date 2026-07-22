<?php
mt_srand();
$index = mt_rand(1, 9999);

$default_view = 'monthly';
$show_header = 1;
$show_icons = 1;
$show_categoies = 1;
if($tpl['option_arr']['o_enable_monthly_view'] == 'No' && $tpl['option_arr']['o_enable_list_view'] == 'No')
{
	$show_header = 0;
	$default_view = 'calendar';
}
if($controller->_get->check('view'))
{
	$default_view = $controller->_get->toString('view');
}
if($controller->_get->check('icons'))
{
	if($controller->_get->toString('icons') == 'T')
	{
		$show_icons = 0;
	}else{
		$show_icons = 1;
	}
}
if($show_icons == 0 && $show_categoies == 0)
{
	$show_header = 0;
}

$front_messages = __('front_message', true);
$front_errors  = __('front_error', true);

$theme = $controller->_get->check('theme') ? $controller->_get->toString('theme') : $tpl['option_arr']['o_theme'];
if((int) $theme > 0)
{
	$theme = 'theme' . $theme;
}
?>
<div id="pjWrapperEBCalendar_<?php echo $theme;?>">
	<div class="container-fluid">
		<div id="pjEbcContainer_<?php echo $index; ?>" class="pjEbcContainer"></div>	
	</div><!-- /.container -->
</div><!-- /#pjWrapper -->

<script type="text/javascript">
var pjQ = pjQ || {},
	EBCalendar_<?php echo $index; ?>;
(function () {
	"use strict";
	var isSafari = /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor),

	loadCssHack = function(url, callback){
		var link = document.createElement('link');
		link.type = 'text/css';
		link.rel = 'stylesheet';
		link.href = url;

		document.getElementsByTagName('head')[0].appendChild(link);

		var img = document.createElement('img');
		img.onerror = function(){
			if (callback && typeof callback === "function") {
				callback();
			}
		};
		img.src = url;
	},
	loadRemote = function(url, type, callback) {
		if (type === "css" && isSafari) {
			loadCssHack.call(null, url, callback);
			return;
		}
		var _element, _type, _attr, scr, s, element;
		
		switch (type) {
		case 'css':
			_element = "link";
			_type = "text/css";
			_attr = "href";
			break;
		case 'js':
			_element = "script";
			_type = "text/javascript";
			_attr = "src";
			break;
		}
		
		scr = document.getElementsByTagName(_element);
		s = scr[scr.length - 1];
		element = document.createElement(_element);
		element.type = _type;
		if (type == "css") {
			element.rel = "stylesheet";
		}
		if (element.readyState) {
			element.onreadystatechange = function () {
				if (element.readyState == "loaded" || element.readyState == "complete") {
					element.onreadystatechange = null;
					if (callback && typeof callback === "function") {
						callback();
					}
				}
			};
		} else {
			element.onload = function () {
				if (callback && typeof callback === "function") {
					callback();
				}
			};
		}
		element[_attr] = url;
		s.parentNode.insertBefore(element, s.nextSibling);
	},
	loadScript = function (url, callback) {
		loadRemote.call(null, url, "js", callback);
	},
	loadCss = function (url, callback) {
		loadRemote.call(null, url, "css", callback);
	},
	isMSIE = function() {
		var ua = window.navigator.userAgent,
        	msie = ua.indexOf("MSIE ");

        if (msie !== -1) {
            return true;
        }

		return false;
	},
	getSessionId = function () {
		return sessionStorage.getItem("session_id") == null ? "" : sessionStorage.getItem("session_id");
	},
	createSessionId = function () {
		if(getSessionId()=="") {
			sessionStorage.setItem("session_id", "<?php echo session_id(); ?>");
		}
	},
	options = {
		server: "<?php echo PJ_INSTALL_URL; ?>",
		folder: "<?php echo PJ_INSTALL_URL; ?>",
		index: <?php echo $index; ?>,
		hide: <?php echo $controller->_get->toInt('hide') === 1 ? 1 : 0; ?>,
		locale: <?php echo $controller->_get->toInt('locale') ? $controller->_get->toInt('locale') : $controller->pjActionGetLocale(); ?>,
		theme: "<?php echo $theme; ?>",
		default_view: "<?php echo $default_view; ?>",
		show_header: <?php echo $show_header;?>,
		show_icons: <?php echo $show_icons;?>,
		show_categories: <?php echo $show_categoies;?>,
		display_events: "<?php echo $tpl['option_arr']['o_display_events'];?>",
		event_title_position: "<?php echo $tpl['option_arr']['o_event_title_position'];?>",
		currency: "<?php echo $tpl['option_arr']['o_currency'];?>",
		tax: "<?php echo $tpl['option_arr']['o_tax_payment'];?>",
		deposit: "<?php echo $tpl['option_arr']['o_deposit_payment'];?>",
		category_id: <?php echo $controller->_get->toInt('cid') ? $controller->_get->toInt('cid') : 0; ?>,
		event_id: <?php echo $controller->_get->toInt('event_id') ? $controller->_get->toInt('event_id') : 0; ?>,
		current_month: "<?php echo date('m');?>",
		current_year: "<?php echo date('Y');?>",
		thankyou_url: "<?php echo $tpl['option_arr']['o_thankyou_page']; ?>",

		message_1: "<?php echo pjSanitize::html($front_messages[1]); ?>",
		message_2: "<?php echo pjSanitize::html($front_messages[2]); ?>",
		message_3: "<?php echo pjSanitize::html($front_messages[3]); ?>",
		message_4: "<?php echo pjSanitize::html($front_messages[4]); ?>",
		message_5: "<?php echo pjSanitize::html($front_messages[5]); ?>",
		message_6: "<?php echo pjSanitize::html($front_messages[6]); ?>",
		message_7: "<?php echo pjSanitize::html($front_messages[7]); ?>",
		message_9: "<?php echo pjSanitize::html($front_messages[9]); ?>",

		validation: {
			error_title: "<?php echo pjSanitize::html($front_errors['title']); ?>",
			error_email: "<?php echo pjSanitize::html($front_errors['email']); ?>",
			error_captcha: "<?php echo pjSanitize::html($front_errors['captcha']); ?>",
			error_payment: "<?php echo pjSanitize::html($front_errors['payment']); ?>",
			error_max: "<?php echo pjSanitize::html($front_errors['max']); ?>",
			error_min: "<?php echo pjSanitize::html($front_errors['min']); ?>"
		}
	};
	<?php
	$dm = new pjDependencyManager(PJ_INSTALL_PATH, PJ_THIRD_PARTY_PATH);
	$dm->load(PJ_CONFIG_PATH . 'dependencies.php')->resolve();
	?>
	loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('storage_polyfill'); ?>storagePolyfill.min.js", function () {
		if (isSafari) {
			createSessionId();
			options.session_id = getSessionId();
		}else{
			options.session_id = "";
		}
		loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_jquery'); ?>pjQuery.min.js", function () {
			window.pjQ.$.browser = {
				msie: isMSIE()
			};
			loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_validate'); ?>pjQuery.validate.min.js", function () {
				loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_jquery_ui'); ?>js/pjQuery-ui.custom.min.js", function () {
					loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_bootstrap'); ?>pjQuery.bootstrap.min.js", function () {
						loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_tooltipster'); ?>pjQuery.tooltipster.js", function () {
							loadScript("<?php echo PJ_INSTALL_URL . PJ_JS_PATH; ?>pjEBCalendar.js", function () {
								<?php if($tpl['option_arr']['o_captcha_type_front'] == 'google'): ?>
							    loadScript('https://www.google.com/recaptcha/api.js', function () {
	                            <?php endif; ?>
	                            EBCalendar_<?php echo $index; ?> = new EBCalendar(options);
								<?php if($tpl['option_arr']['o_captcha_type_front'] == 'google'): ?>
	                            });
							    <?php endif; ?>
							});
						});
					});
				});
			});
		});
	});
})();
</script>