<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminOptions extends pjAdmin
{
    public function pjActionBooking()
	{
	 	$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
        $arr = pjOptionModel::factory()
            ->where('t1.foreign_id', $this->getForeignId())
            ->where('t1.tab_id', 1)
            ->orderBy('t1.order ASC')
            ->findAll()
            ->getData();

        $this->set('arr', $arr);
        $this->appendJs('pjAdminOptions.js');
	}

	public function pjActionBookingForm()
	{
	 	$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
        $arr = pjOptionModel::factory()
            ->where('t1.foreign_id', $this->getForeignId())
            ->where('t1.tab_id', 3)
            ->orderBy('t1.order ASC')
            ->findAll()
            ->getData();

        $this->set('arr', $arr);
        $this->appendJs('pjAdminOptions.js');
	}
		
	public function pjActionUpdate()
	{
        if (self::isPost() && $this->_post->check('options_update'))
        {
            if (pjAuth::factory('pjAdminOptions', $this->_post->toString('next_action'))->hasAccess())
            {
                $pjOptionModel = new pjOptionModel();

                foreach ($this->_post->raw() as $key => $value)
                {
                    if (preg_match('/value-(string|text|int|float|enum|bool|color)-(.*)/', $key) === 1)
                    {
                        list(, $type, $k) = explode("-", $key);
                        if (!empty($k))
                        {
                            $_value = ':NULL';
                            if ($value)
                            {
                                switch ($type)
                                {
                                    case 'string':
                                    case 'text':
                                    case 'enum':
                                    case 'color':
                                        $_value = $this->_post->toString($key);
                                        break;
                                    case 'int':
                                    case 'bool':
                                        $_value = $this->_post->toInt($key);
                                        break;
                                    case 'float':
                                        $_value = $this->_post->toFloat($key);
                                        break;
                                }
                            }

                            $pjOptionModel
                                ->reset()
                                ->where('foreign_id', $this->getForeignId())
                                ->where('`key`', $k)
                                ->limit(1)
                                ->modifyAll(array('value' => $_value));
                        }
                    }
                }

                $i18n_arr = $this->_post->toI18n('i18n');
                if (!empty($i18n_arr))
                {
                    pjMultiLangModel::factory()->updateMultiLang($i18n_arr, 1, 'pjOption', 'data');
                }

                switch ($this->_post->toString('next_action'))
                {
                    case 'pjActionBooking':
                        $err = 'AO02';
                        break;
                    case 'pjActionBookingForm':
                        $err = 'AO03';
                        break;
                }

                pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminOptions&action=" . $this->_post->toString('next_action') . "&err=$err");
            }
            else
            {
                $this->sendForbidden();
                return;
            }
        }
	}

	public function pjActionUpdateTheme()
	{
		$this->setAjax(true);
		
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if(!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		
		if (!$this->_post->has('theme'))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid parameters.'));
		}
		
		pjOptionModel::factory()
			->where('foreign_id', $this->getForeignId())
			->where('`key`', 'o_theme')
			->limit(1)
			->modifyAll(array('value' => 'theme1|theme2|theme3|theme4|theme5|theme6|theme7|theme8|theme9|theme10::' . $this->_post->toString('theme')));
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Theme has been changed.'));
	}
	
	
	public function pjActionPreview()
	{
        $this->appendJs('pjAdminOptions.js');
	}

	public function pjActionInstall()
	{
		$category_arr = pjCategoryModel::factory()
				->select('t1.*, t2.content AS category_name')
				->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjCategory' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
				->orderBy("category_name ASC")->findAll()->getData();
		$this->set('category_arr', $category_arr);		
		
        $this->appendJs('pjAdminOptions.js');
	}
}
?>