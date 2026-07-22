<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminCategories extends pjAdmin
{
	public function pjActionDeleteCategory()
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
		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
		}
		if (!($this->_get->toInt('id')))
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
		}
		if (!pjCategoryModel::factory()->set('id', $this->_get->toInt('id'))->erase()->getAffectedRows())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 105, 'text' => 'Category has not been deleted.'));
		}
		pjMultiLangModel::factory()->where('model', 'pjCategory')->where('foreign_id', $this->_get->toInt('id'))->eraseAll();
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Category has been deleted'));
		exit;
	}
	
	public function pjActionDeleteCategoryBulk()
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
	    if (!pjAuth::factory()->hasAccess())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
	    }
	    if (!$this->_post->has('record'))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $record = $this->_post->toArray('record');
	    if (empty($record))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    pjMultiLangModel::factory()->where('model', 'pjCategory')->whereIn('foreign_id', $record)->eraseAll();
	    pjCategoryModel::factory()->whereIn('id', $record)->eraseAll();
	    self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Categories has been deleted.'));
	    exit;
	}
	
	public function pjActionGetCategory()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$pjCategoryModel = pjCategoryModel::factory()->join('pjMultiLang', sprintf("t2.foreign_id = t1.id AND t2.model = 'pjCategory' AND t2.locale = '%u' AND t2.field = 'name'", $this->getLocaleId()), 'left');
			if ($q = $this->_get->toString('q'))
			{
			    $pjCategoryModel->where("(t2.content LIKE '%$q%')");
			}
			if ($this->_get->toString('status'))
			{
			    $status = $this->_get->toString('status');
			    if(in_array($status, array('T', 'F')))
			    {
			        $pjCategoryModel->where('t1.status', $status);
			    }
			}
			$column = 'name';
			$direction = 'ASC';
			$allowed_columns = array('name', 'status');
			if ($this->_get->toString('column') && in_array($this->_get->toString('column'), $allowed_columns) && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
			{
			    $column = $this->_get->toString('column');
			    $direction = strtoupper($this->_get->toString('direction'));
			}
			$total = $pjCategoryModel->findCount()->getData();
			$rowCount = $this->_get->toInt('rowCount') ?: 10;
			$pages = ceil($total / $rowCount);
			$page = $this->_get->toInt('page') ?: 1;
			$offset = ((int) $page - 1) * $rowCount;
			if ($page > $pages)
			{
				$page = $pages;
			}
			$category_arr = $pjCategoryModel
				->select("t1.*, t2.content AS name")
				->orderBy("`$column` $direction")
				->limit($rowCount, $offset)
				->findAll()
				->getData();
			$data = array();
			foreach($category_arr as $k => $v){
				$v['name'] = pjSanitize::clean($v['name']);
				$data[$k] = $v;
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
	    $this->setLocalesData();
	    
	    $this->set('has_create', pjAuth::factory('pjAdminCategories', 'pjActionCreateForm')->hasAccess());
	    $this->set('has_update', pjAuth::factory('pjAdminCategories', 'pjActionUpdateForm')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminCategories', 'pjActionDeleteCategory')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminCategories', 'pjActionDeleteCategoryBulk')->hasAccess());
	    
	    $this->appendJs('jquery.multilang.js', $this->getConstant('pjBase', 'PLUGIN_JS_PATH'), false, false);
	    $this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
	    $this->appendJs('pjAdminCategories.js');
	}
	
	public function pjActionCreate()
	{
	    $this->setAjax(true);
	    if (!pjAuth::factory()->hasAccess())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
	    }
	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!self::isPost())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
	    }
	    if (!$this->_post->toInt('category_create'))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $data = array();
	    $data['status'] = $this->_post->check('status') ? 'T' : 'F';	    
	    $id = pjCategoryModel::factory()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
	    if ($id !== false && (int) $id > 0)
	    {
	        if ($i18n_arr = $this->_post->toArray('i18n'))
	        {
	            pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $id, 'pjCategory', 'data');
	        }
	        self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Category has been added!'));
	    } else {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Category could not be added!'));
	    }
	}
	
	public function pjActionUpdate()
	{
	    $this->setAjax(true);
	    if (!pjAuth::factory()->hasAccess())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
	    }
	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!self::isPost())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
	    }
	    if (!$this->_post->toInt('category_update'))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    if (!$this->_post->toInt('id'))
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Missing, empty or invalid parameters.'));
	    }
	    $data = array();
	    $data['status'] = $this->_post->check('status') ? 'T' : 'F';
	    pjCategoryModel::factory()->where('id', $this->_post->toInt('id'))->limit(1)->modifyAll(array_merge($this->_post->raw(), $data));
	    if ($i18n_arr = $this->_post->toArray('i18n'))
	    {
	        pjMultiLangModel::factory()->updateMultiLang($i18n_arr, $this->_post->toInt('id'), 'pjCategory', 'data');
	    }
	    self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Category has been updated!'));
	}
	
	public function pjActionSaveCategory()
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
	    $pjCategoryModel = pjCategoryModel::factory();
	    $arr = $pjCategoryModel->find($this->_get->toInt('id'))->getData();
	    if (!$arr)
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Category not found.'));
	    }
	    if (!in_array($this->_post->toString('column'), $pjCategoryModel->getI18n()))
	    {
	        $pjCategoryModel->reset()->where('id', $this->_get->toInt('id'))->limit(1)->modifyAll(array($this->_post->toString('column') => $this->_post->toString('value')));
	    } else {
	        pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($this->_post->toString('column') => $this->_post->toString('value'))), $this->_get->toInt('id'), 'pjCategory', 'data');
	    }
	    
	    self::jsonResponse(array('status' => 'OK', 'code' => 201, 'text' => 'Category has been updated.'));
	    
	    exit;
	}
	
	public function pjActionCreateForm()
	{
	    $this->setAjax(true);
	    
	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!self::isGet())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
	    }
	    $this->setLocalesData();
	}
	
	public function pjActionUpdateForm()
	{
	    $this->setAjax(true);
	    
	    if (!$this->isXHR())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
	    }
	    if (!self::isGet())
	    {
	        self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
	    }
	    if ($this->_get->toInt('id'))
	    {
	        $id = $this->_get->toInt('id');
	        $arr = pjCategoryModel::factory()->find($id)->getData();
	        if (count($arr) === 0)
	        {
	            self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Category is not found.'));
	        }
	        $arr['i18n'] = pjMultiLangModel::factory()->getMultiLang($arr['id'], 'pjCategory');
	        $this->set('arr', $arr);
	        
	        $this->setLocalesData();
	    }else{
	        self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing parameters.'));
	    }
	}
}
?>