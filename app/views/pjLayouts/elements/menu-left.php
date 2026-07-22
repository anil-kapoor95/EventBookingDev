<?php
$controller_name = $controller->_get->toString('controller');
$action_name = $controller->_get->toString('action');

// Dashboard
$isScriptDashboard = in_array($controller_name, array('pjAdmin')) && in_array($action_name, array('pjActionIndex'));

// Bookings
$isScriptBookingsController = in_array($controller_name, array('pjAdminBookings'));
$isScriptBookingsIndex = $isScriptBookingsController && in_array($action_name, array('pjActionIndex', 'pjActionCreate', 'pjActionUpdate'));
$isScriptBookingsReadBarcode = $isScriptBookingsController && in_array($action_name, array('pjActionReadBarcode'));
$isScriptBookingsExport = $isScriptBookingsController && in_array($action_name, array('pjActionExport'));

$isScriptEventsController       = in_array($controller_name, array('pjAdminEvents'));
$isScriptEventsIndex      = $isScriptEventsController && in_array($action_name, array('pjActionIndex', 'pjActionCreate', 'pjActionUpdate'));

$isScriptCategoriesController     = in_array($controller_name, array('pjAdminCategories'));
$isScriptCategoriesIndex      = $isScriptCategoriesController && in_array($action_name, array('pjActionIndex', 'pjActionCreate', 'pjActionUpdate'));

// Settings
$isScriptOptionsController = in_array($controller_name, array('pjAdminOptions')) && !in_array($action_name, array('pjActionPreview', 'pjActionInstall'));

$isScriptOptionsBooking         = $isScriptOptionsController && in_array($action_name, array('pjActionBooking'));
$isScriptOptionsBookingForm     = $isScriptOptionsController && in_array($action_name, array('pjActionBookingForm'));

// Payments
$isScriptPaymentsController = in_array($controller_name, array('pjPayments'));

// Permissions - Dashboard
$hasAccessScriptDashboard = pjAuth::factory('pjAdmin', 'pjActionIndex')->hasAccess();

// Permissions - Bookings
$hasAccessScriptBookings            = pjAuth::factory('pjAdminBookings')->hasAccess();
$hasAccessScriptBookingsIndex       = pjAuth::factory('pjAdminBookings', 'pjActionIndex')->hasAccess();
$hasAccessScriptBookingsReadBarcode       = pjAuth::factory('pjAdminBookings', 'pjActionReadBarcode')->hasAccess();
$hasAccessScriptBookingsExport     = pjAuth::factory('pjAdminBookings', 'pjActionExport')->hasAccess();

// Permissions - Events
$hasAccessScriptEvents            = pjAuth::factory('pjAdminEvents')->hasAccess();
$hasAccessScriptEventsIndex       = pjAuth::factory('pjAdminEvents', 'pjActionIndex')->hasAccess();

// Permissions - Categories
$hasAccessScriptCategories  = pjAuth::factory('pjAdminCategories')->hasAccess();
$hasAccessScriptCategoriesIndex  = pjAuth::factory('pjAdminCategories', 'pjActionIndex')->hasAccess();


// Permissions - Payments
$hasAccessScriptPayments = pjAuth::factory('pjPayments', 'pjActionIndex')->hasAccess();

// Permissions - Settings
$hasAccessScriptOptions                 = pjAuth::factory('pjAdminOptions')->hasAccess();
$hasAccessScriptOptionsBooking          = pjAuth::factory('pjAdminOptions', 'pjActionBooking')->hasAccess();
$hasAccessScriptOptionsBookingForm      = pjAuth::factory('pjAdminOptions', 'pjActionBookingForm')->hasAccess();
?>

<?php if ($hasAccessScriptDashboard): ?>
    <li<?php echo $isScriptDashboard ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdmin&amp;action=pjActionIndex"><i class="fa fa-th-large"></i> <span class="nav-label"><?php __('plugin_base_menu_dashboard');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptBookingsIndex): ?>
	<li<?php echo $isScriptBookingsController ? ' class="active"' : NULL; ?>>
        <a href="#"><i class="fa fa-list"></i> <span class="nav-label"><?php __('menuBookings');?></span><span class="fa arrow"></span></a>
        <ul class="nav nav-second-level collapse">
            <?php if ($hasAccessScriptBookingsIndex): ?>
                <li<?php echo $isScriptBookingsIndex ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex"><?php __('menuBookingsList');?></a></li>
            <?php endif; ?>
            <?php if ($hasAccessScriptBookingsReadBarcode): ?>
                <li<?php echo $isScriptBookingsReadBarcode ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionReadBarcode"><?php __('menuReadBarcode');?></a></li>
            <?php endif; ?>
             <?php if ($hasAccessScriptBookingsExport): ?>
                <li<?php echo $isScriptBookingsExport ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionExport"><?php __('menuExport');?></a></li>
            <?php endif; ?>
        </ul>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptEvents): ?>
    <li<?php echo $isScriptEventsIndex ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEvents&amp;action=pjActionIndex"><i class="fa fa-calendar"></i> <span class="nav-label"><?php __('menuEvents');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptCategories): ?>
    <li<?php echo $isScriptCategoriesIndex ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminCategories&amp;action=pjActionIndex"><i class="fa fa-list-alt"></i> <span class="nav-label"><?php __('menuCategories');?></span></a>
    </li>
<?php endif; ?>


<?php if ($hasAccessScriptOptions || $hasAccessScriptPayments): ?>
    <li<?php echo $isScriptOptionsController || $isScriptPaymentsController ? ' class="active"' : NULL; ?>>
        <a href="#"><i class="fa fa-cogs"></i> <span class="nav-label"><?php __('script_menu_settings');?></span><span class="fa arrow"></span></a>
        <ul class="nav nav-second-level collapse">
            <?php if ($hasAccessScriptOptionsBooking): ?>
                <li<?php echo $isScriptOptionsBooking ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionBooking"><?php __('menuOptions');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptPayments): ?>
                <li<?php echo $isScriptPaymentsController ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjPayments&amp;action=pjActionIndex"><?php __('menuPayments');?></a></li>
            <?php endif; ?>
            
            <?php if ($hasAccessScriptOptionsBookingForm): ?>
                <li<?php echo $isScriptOptionsBookingForm ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionBookingForm"><?php __('menuBookingForm');?></a></li>
            <?php endif; ?>
        </ul>
    </li>
<?php endif; ?>