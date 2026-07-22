<?php
if(count($tpl['price_arr']) > 0)
{
	foreach($tpl['price_arr'] as $v)
	{
		?>
		<div class="form-group">
			<label><?php echo pjSanitize::html($v['name']); ?></label>
			<div class="input-group">
				<select name="price_<?php echo $v['id']; ?>" lang="<?php echo (float)$v['price'];?>" class="form-control pj-price" data-msg-required="<?php __('ebc_field_required', false, true);?>" aria-required="true">
					<?php
					$max = intval($v['available']) - intval($v['cnt_booked']);
					$max = (int) $max < 1 ? 0 : $max;
					foreach (range(0, $max) as $i)
					{
						?><option value="<?php echo $i; ?>"><?php echo $i; ?></option><?php
					}
					?>
				</select>
				<span class="input-group-addon">&nbsp;x&nbsp;<?php echo pjCurrency::formatPrice($v['price']);?></span>
			</div>
		</div>
		<?php
	}
}
?>
<input type="hidden" id="customer_people" name="customer_people" class="required" value="" />
