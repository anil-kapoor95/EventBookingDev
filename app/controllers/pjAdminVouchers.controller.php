<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminVouchers extends pjAdmin
{
	public function pjActionCheckCode()
	{
		$this->setAjax(true);

		if ($this->isXHR())
		{
			if (!$this->_get->check('code') || $this->_get->toString('code') == '')
			{
				echo 'false';
				exit;
			}
			$pjVoucherModel = pjVoucherModel::factory()->where('t1.code', $this->_get->toString('code'));
			if ($this->_get->check('id') && $this->_get->toInt('id') > 0)
			{
				$pjVoucherModel->where('t1.id !=', $this->_get->toInt('id'));
			}
			echo $pjVoucherModel->findCount()->getData() == 0 ? 'true' : 'false';
		}
		exit;
	}

	public function pjActionCheckDate()
	{
		$this->setAjax(true);

		if ($this->isXHR())
		{
			if(strpos($this->option_arr['o_time_format'], 'a') > -1 || strpos($this->option_arr['o_time_format'], 'A') > -1)
			{
				$dt_from = strtotime(pjDateTime::formatDate($this->_post->toString('p_date_from'), $this->option_arr['o_date_format']) . ' ' .$this->_post->toString('p_hour_from') . ':' . $this->_post->toString('p_minute_from') . ' ' . strtoupper($this->_post->toString('p_ampm_from')));
				$dt_to = strtotime(pjDateTime::formatDate($this->_post->toString('p_date_to'), $this->option_arr['o_date_format']) . ' ' .$this->_post->toString('p_hour_to') . ':' . $this->_post->toString('p_minute_to') . ' ' . strtoupper($this->_post->toString('p_ampm_to')));
			}else{
				$dt_from = sprintf("%s %s:%s:00", pjDateTime::formatDate($this->_post->toString('p_date_from'), $this->option_arr['o_date_format']), $this->_post->toString('p_hour_from'), $this->_post->toString('p_minute_from'));
				$dt_to = sprintf("%s %s:%s:00", pjDateTime::formatDate($this->_post->toString('p_date_to'), $this->option_arr['o_date_format']), $this->_post->toString('p_hour_to'), $this->_post->toString('p_minute_to'));
				$dt_from = strtotime($dt_from);
				$dt_to = strtotime($dt_to);
			}
			echo $dt_to > $dt_from ? 'true' : 'false';
		}
		exit;
	}

	public function pjActionCreate()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }

		if ($this->_post->check('voucher_create'))
		{
			$data = array();
			$data['code'] = $this->_post->toString('code');
			$data['discount'] = $this->_post->toString('discount');
			$data['type'] = $this->_post->toString('type');
			$data['valid'] = $this->_post->toString('valid');
			$data['apply'] = $this->_post->check('apply') ? 'each' : 'total';
			switch ($this->_post->toString('valid'))
			{
				case 'fixed':
					$data['date_from'] = pjDateTime::formatDate($this->_post->toString('f_date'), $this->option_arr['o_date_format']);
					$data['date_to'] = $data['date_from'];
					$data['time_from'] = $this->_post->toString('f_hour_from') . ":" . $this->_post->toString('f_minute_from') . ":00";
					$data['time_to'] = $this->_post->toString('f_hour_to') . ":" . $this->_post->toString('f_minute_to') . ":00";
					break;
				case 'period':
					$data['date_from'] = pjDateTime::formatDate($this->_post->toString('p_date_from'), $this->option_arr['o_date_format']);
					$data['date_to'] = pjDateTime::formatDate($this->_post->toString('p_date_to'), $this->option_arr['o_date_format']);
					$data['time_from'] = $this->_post->toString('p_hour_from') . ":" . $this->_post->toString('p_minute_from') . ":00";
					$data['time_to'] = $this->_post->toString('p_hour_to') . ":" . $this->_post->toString('p_minute_to') . ":00";
					break;
				case 'recurring':
					$data['every'] = $this->_post->toString('r_every');
					$data['time_from'] = $this->_post->toString('r_hour_from') . ":" . $this->_post->toString('r_minute_from') . ":00";
					$data['time_to'] = $this->_post->toString('r_hour_to') . ":" . $this->_post->toString('r_minute_to') . ":00";
					break;
			}

			$id = pjVoucherModel::factory()->setAttributes($data)->insert()->getInsertId();
			if ($id !== false && (int) $id > 0)
			{
				if ($event_id_arr = $this->_post->toArray('event_id'))
				{
					$pjVoucherEventModel = pjVoucherEventModel::factory();
					$pjVoucherEventModel->begin();
					foreach ($event_id_arr as $event_id)
					{
						$pjVoucherEventModel->reset()->setAttributes(array(
							'voucher_id' => $id,
							'event_id' => $event_id
						))->insert();
					}
					$pjVoucherEventModel->commit();
				}
				$err = 'AV01';
			} else {
				$err = 'AV02';
			}

			pjUtil::redirect(sprintf("%s?controller=pjAdminVouchers&action=pjActionIndex&err=%s", $_SERVER['PHP_SELF'], $err));
		} else {
			$this->set('event_arr', $this->getEventList());

			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('moment-with-locales.min.js', PJ_THIRD_PARTY_PATH . 'moment/');
			$this->appendCss('datepicker.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('pjAdminVouchers.js');
		}
	}

	public function pjActionDeleteVoucher()
	{
		$this->setAjax(true);

	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!pjAuth::factory()->hasAccess())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
	    }
	    if (!($this->_get->toInt('id')))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $id = $this->_get->toInt('id');
	    $pjVoucherModel = pjVoucherModel::factory();
	    $arr = $pjVoucherModel->find($id)->getData();
	    if (!$arr)
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => __('system_133', true)));
	    }
	    if ($pjVoucherModel->reset()->set('id', $id)->erase()->getAffectedRows() == 1)
	    {
	    	pjVoucherEventModel::factory()->where('voucher_id', $id)->eraseAll();
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => __('system_205', true)));
	    }else{
	        self::jsonResponse(array('status' => 'ERR', 'code' => 105, 'text' => __('error_titles_ARRAY_AV06', true)));
	    }
		exit;
	}

	public function pjActionDeleteVoucherBulk()
	{
		$this->setAjax(true);

		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Access denied.'));
		}

		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}

		if (!$this->_post->has('record') || !($record = $this->_post->toArray('record')))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid data.'));
		}

		pjVoucherModel::factory()->whereIn('id', $record)->eraseAll();
		pjVoucherEventModel::factory()->whereIn('voucher_id', $record)->eraseAll();

		self::jsonResponse(array('status' => 'OK'));
	}

	public function pjActionGetVoucher()
	{
		$this->setAjax(true);

		if ($this->isXHR())
		{
			$pjVoucherModel = pjVoucherModel::factory();

			if ($q = $this->_get->toString('q'))
			{
				$q = str_replace(array('%', '_'), array('\%', '\_'), trim($q));
				$pjVoucherModel->where('t1.code LIKE', "%$q%");
			}
			if ($this->_get->check('valid') && $this->_get->toString('valid') != '')
			{
				$pjVoucherModel->where('t1.valid', $this->_get->toString('valid'));
			}

			$column = 'code';
			$direction = 'DESC';
			$allowed_columns = array('id', 'code', 'type', 'discount', 'valid_from', 'valid_to', 'is_active', 'created');
			if ($this->_get->check('direction') && $this->_get->check('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')) && in_array($this->_get->toString('column'), $allowed_columns))
			{
				$column = $this->_get->toString('column');
				$direction = strtoupper($this->_get->toString('direction'));
			}

			$total = $pjVoucherModel->findCount()->getData();
			$rowCount = $this->_get->check('rowCount') && $this->_get->toInt('rowCount') > 0 ? $this->_get->toInt('rowCount') : 10;
			$pages = ceil($total / $rowCount);
			$page = $this->_get->check('page') && $this->_get->toInt('page') > 0 ? $this->_get->toInt('page') : 1;
			$offset = ((int) $page - 1) * $rowCount;
			if ($page > $pages)
			{
				$page = $pages;
			}

			$data = $pjVoucherModel
				->select('t1.*,
				(
					SELECT GROUP_CONCAT(TL.content SEPARATOR "<br/>")
					FROM `'.pjEventModel::factory()->getTable().'` AS TP
						LEFT OUTER JOIN `'.pjMultiLangModel::factory()->getTable().'` AS TL ON TL.model="pjEvent" AND TL.foreign_id=TP.id AND TL.locale="'.$this->getLocaleId().'" AND TL.field="title"
						WHERE TP.id IN (
			                         	SELECT TVE.event_id
										FROM `'.pjVoucherEventModel::factory()->getTable().'` AS TVE
										WHERE TVE.voucher_id = t1.id
									)
				) AS events')
				->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();

			$daynames = __('daynames', true);
			foreach ($data as $k => $v)
			{
				$data[$k]['discount_f'] = $v['type'] == 'amount' ? pjCurrency::formatPrice($v['discount']) : $v['discount'] . '%';
				$data[$k]['events'] = !empty($v['events']) ? $v['events'] : __('lblAll', true);
				switch ($v['valid'])
				{
					case 'fixed':
						$data[$k]['valid_f'] = sprintf('%s, %s - %s', pjDateTime::formatDate($v['date_from'], 'Y-m-d', $this->option_arr['o_date_format']), substr($v['time_from'], 0, 5), substr($v['time_to'], 0, 5));
						break;
					case 'period':
						$data[$k]['valid_f'] = sprintf('%s, %s &divide; %s, %s', pjDateTime::formatDate($v['date_from'], 'Y-m-d', $this->option_arr['o_date_format']), substr($v['time_from'], 0, 5), pjDateTime::formatDate($v['date_to'], 'Y-m-d', $this->option_arr['o_date_format']), substr($v['time_to'], 0, 5));
						break;
					case 'recurring':
						$data[$k]['valid_f'] = sprintf('%s, %s - %s', @$daynames[$v['every']], substr($v['time_from'], 0, 5), substr($v['time_to'], 0, 5));
						break;
				}
			}

			pjAppController::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
		}
		exit;
	}

	public function pjActionIndex()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }

		$this->set('has_create', pjAuth::factory('pjAdminVouchers', 'pjActionCreate')->hasAccess());
		$this->set('has_update', pjAuth::factory('pjAdminVouchers', 'pjActionUpdate')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminVouchers', 'pjActionDeleteVoucher')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminVouchers', 'pjActionDeleteVoucherBulk')->hasAccess());

		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminVouchers.js');
	}

	public function pjActionSaveVoucher()
	{
		$this->setAjax(true);

		if (!$this->isXHR())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}

		if (!self::isPost())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}

		if (!pjAuth::factory($this->_get->toString('controller'), 'pjActionUpdate')->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
		}
		$pjVoucherModel = pjVoucherModel::factory();
		$arr = $pjVoucherModel->find($this->_get->toInt('id'))->getData();
		if (!$arr)
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => __('system_133', true)));
		}
		if (!in_array($this->_post->toString('column'), $pjVoucherModel->getI18n()))
		{
		    $pjVoucherModel->reset()->where('id', $this->_get->toInt('id'))->limit(1)->modifyAll(array($this->_post->toString('column') => $this->_post->toString('value')));
		} else {
		    pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($this->_post->toString('column') => $this->_post->toString('value'))), $this->_get->toInt('id'), 'pjVoucher', 'data');
		}
		self::jsonResponse(array('status' => 'OK', 'code' => 201, 'text' => __('error_titles_ARRAY_AV05', true)));
		exit;
	}

	public function pjActionUpdate()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }

		if ($this->_post->check('voucher_update'))
		{
			$data = array();
			$data['id'] = $this->_post->toInt('id');
			$data['code'] = $this->_post->toString('code');
			$data['discount'] = $this->_post->toString('discount');
			$data['type'] = $this->_post->toString('type');
			$data['valid'] = $this->_post->toString('valid');
			$data['apply'] = $this->_post->check('apply') ? 'each' : 'total';
			switch ($this->_post->toString('valid'))
			{
				case 'fixed':
					$data['date_from'] = pjDateTime::formatDate($this->_post->toString('f_date'), $this->option_arr['o_date_format']);
					$data['date_to'] = $data['date_from'];
					$data['time_from'] = $this->_post->toString('f_hour_from') . ":" . $this->_post->toString('f_minute_from') . ":00";
					$data['time_to'] = $this->_post->toString('f_hour_to') . ":" . $this->_post->toString('f_minute_to') . ":00";
					$data['every'] = array('NULL');
					break;
				case 'period':
					$data['date_from'] = pjDateTime::formatDate($this->_post->toString('p_date_from'), $this->option_arr['o_date_format']);
					$data['date_to'] = pjDateTime::formatDate($this->_post->toString('p_date_to'), $this->option_arr['o_date_format']);
					$data['time_from'] = $this->_post->toString('p_hour_from') . ":" . $this->_post->toString('p_minute_from') . ":00";
					$data['time_to'] = $this->_post->toString('p_hour_to') . ":" . $this->_post->toString('p_minute_to') . ":00";
					$data['every'] = array('NULL');
					break;
				case 'recurring':
					$data['date_from'] = array('NULL');
					$data['date_to'] = array('NULL');
					$data['every'] = $this->_post->toString('r_every');
					$data['time_from'] = $this->_post->toString('r_hour_from') . ":" . $this->_post->toString('r_minute_from') . ":00";
					$data['time_to'] = $this->_post->toString('r_hour_to') . ":" . $this->_post->toString('r_minute_to') . ":00";
					break;
			}
			$pjVoucherEventModel = pjVoucherEventModel::factory();
			$pjVoucherEventModel->where('voucher_id', $this->_post->toInt('id'))->eraseAll();

			if ($event_id_arr = $this->_post->toArray('event_id'))
			{
				$pjVoucherEventModel->begin();
				foreach ($event_id_arr as $event_id)
				{
					$pjVoucherEventModel->reset()->setAttributes(array(
						'voucher_id' => $this->_post->toInt('id'),
						'event_id' => $event_id
					))->insert();
				}
				$pjVoucherEventModel->commit();
			}

			if (pjVoucherModel::factory()->set('id', $data['id'])->modify($data)->getAffectedRows() == 1)
			{
				$err = 'AV05';
			} else {
				$err = 'AV06';
			}
			pjUtil::redirect(sprintf("%s?controller=pjAdminVouchers&action=pjActionIndex&err=%s", $_SERVER['PHP_SELF'], $err));
		} else {
			$arr = pjVoucherModel::factory()->find($this->_get->toInt('id'))->getData();
			if (count($arr) === 0)
			{
				pjUtil::redirect(sprintf("%s?controller=pjAdminVouchers&action=pjActionIndex&err=%s", $_SERVER['PHP_SELF'], 'AV08'));
			}
			$this->set('arr', $arr);

			$this->set('ve_arr', pjVoucherEventModel::factory()->where('t1.voucher_id', $arr['id'])->findAll()->getDataPair('event_id', 'event_id'));

			$this->set('event_arr', $this->getEventList());

			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('moment-with-locales.min.js', PJ_THIRD_PARTY_PATH . 'moment/');
			$this->appendCss('datepicker.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('pjAdminVouchers.js');
		}
	}

	/**
	 * Returns the list of events (id + localized title + start timestamp)
	 * used to scope a voucher to specific events. Mirrors the product list
	 * used by the shopping cart voucher module.
	 */
	private function getEventList()
	{
		return pjEventModel::factory()
			->select('t1.id, t1.event_start_ts, t2.content AS name')
			->join('pjMultiLang', "t2.model='pjEvent' AND t2.foreign_id=t1.id AND t2.field='title' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.status', 'T')
			->orderBy('t1.event_start_ts ASC')
			->findAll()
			->getData();
	}
}
?>