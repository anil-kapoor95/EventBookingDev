<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjPaypalExpressSDK extends pjPaymentsSDK
{
    protected $accessToken = null;

	protected function getEndPoint($path=null)
	{
		return $this->getSandbox()
			? 'https://api-m.sandbox.paypal.com/' . $path
			: 'https://api-m.paypal.com/' . $path;
	}
	
    protected static function guidv4($data=null)
	{
        $data = $data ? $data : openssl_random_pseudo_bytes(16);

        $data[6] = chr(ord($data[6]) & 0x0f | 0x40);
        $data[8] = chr(ord($data[8]) & 0x3f | 0x80);

        return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
	}
	
    /**
     * Make an HTTP call to PayPal API
     *
     * @param string $path
     * @param bool|array|string $params
     * @return array
     */
	protected function request($path=null, $params=null)
	{
        if (!$this->accessToken)
        {
            $this->accessToken = $this->requestAccessToken();
        }

		$http = new pjHttp();
		
		if (is_array($params))
		{
		    if (isset($params['payment_source']))
            {
                $http->addHeader("PayPal-Request-Id: " . self::guidv4());
                $http->addHeader("Prefer: return=representation");
            }
			$params = json_encode($params);
		}
		
		if ($params)
		{
			$http->setMethod("POST");
			if (!is_bool($params))
            {
			$http->setData($params, false);
            }
		} else {
			$http->setMethod("GET");
		}
		
        if ($this->accessToken)
        {
            // OAuth 2.0 access token
            $http->addHeader("Authorization: Bearer {$this->accessToken}");
        } else {
            // Fallback to Basic auth
            $http->addHeader("Authorization: Basic " . base64_encode($this->getMerchantId() . ":" . $this->getPrivateKey()));
        }

		$http
			->addHeader("Content-Type: application/json")
			->curlRequest($this->getEndPoint($path));
		
		$error = $http->getError();
		if ($error)
		{
			return array('status' => 'ERR', 'code' => 100, 'text' => $error['text']);
		}
		
        $result = json_decode($http->getResponse(), true);
		
		if (method_exists($http, 'getHttpCode') && !in_array($http->getHttpCode(), array(200, 201, 202)))
		{
            if (isset($result['details'][0]['description']))
            {
                $text = $result['details'][0]['description'];
            } elseif (isset($result['message'])) {
                $text = $result['message'];
            } else {
                $text = sprintf('HTTP status code: %u', $http->getHttpCode());
            }

			return array('status' => 'ERR', 'code' => 101, 'text' => $text);
		}
		
		if (!$http->getResponse())
		{
			return array('status' => 'ERR', 'code' => 102, 'text' => 'Empty response');
		}
		
		return array('status' => 'OK', 'code' => 200, 'text' => 'Success', 'result' => $result);
	}

    /**
     * Request OAuth 2.0 access token
     *
     * @return string|null
     */
    protected function requestAccessToken()
    {
        $http = new pjHttp();

        $http
            ->setMethod('POST')
            ->setUsername($this->getMerchantId())
            ->setPassword($this->getPrivateKey())
            ->addHeader('Content-Type: application/x-www-form-urlencoded')
            ->setData(array(
                'grant_type' => 'client_credentials',
            ))
            ->curlRequest($this->getEndPoint('v1/oauth2/token'));

        $result = json_decode($http->getResponse(), true);

        return isset($result['access_token']) ? $result['access_token'] : null;
    }

    /**
     * Show order details
     *
     * @param string $order_id
     * @return array
     * @throws Exception
     */
	public function getOrder($order_id)
	{
		$data = $this->request('v2/checkout/orders/' . $order_id);
		if ($data['status'] != 'OK')
		{
			throw new Exception($data['text']);
		}
		
		$response = new pjPaypalExpressSDKResponse($data['result']);
		if (!$response->isOK())
		{
			$error = $response->getError();
			throw new Exception(@$error['message']);
		}
		
		return $data['result'];
	}
	
    /**
     * Shows details for a subscription, by ID.
     *
     * @param string $subscription_id
     * @return array
     * @throws Exception
     */
	public function getSubscription($subscription_id)
    {
        $data = $this->request('v1/billing/subscriptions/' . $subscription_id);
        if ($data['status'] != 'OK')
        {
            throw new Exception($data['text']);
        }

        $response = new pjPaypalExpressSDKResponse($data['result']);
        if (!$response->isOK())
        {
            $error = $response->getError();
            throw new Exception(@$error['message']);
        }

        return $data['result'];
    }

    /**
     * Creates a product
     *
     * @param array $params
     * @return array
     * @throws Exception
     */
	public function createProduct($params)
	{
        $data = $this->request('v1/catalogs/products', $params);
        if ($data['status'] != 'OK')
		{
            throw new Exception($data['text']);
		}
		
        $response = new pjPaypalExpressSDKResponse($data['result']);
        if (!$response->isOK())
		{
            $error = $response->getError();
            throw new Exception(@$error['message']);
		}
		
        return $data['result'];
    }
		
    /**
     * Creates a plan
     *
     * @param array $params
     * @return array
     * @throws Exception
     */
    public function createSubscriptionPlan($params)
		{
        $data = $this->request('v1/billing/plans', $params);
        if ($data['status'] != 'OK')
        {
            throw new Exception($data['text']);
		}
		
        $response = new pjPaypalExpressSDKResponse($data['result']);
        if (!$response->isOK())
        {
            $error = $response->getError();
            throw new Exception(@$error['message']);
        }
		
        return $data['result'];
	}

    /**
     * Creates a subscription
     *
     * @param array $params
     * @return array
     * @throws Exception
     */
    public function createSubscription($params)
	{
        $data = $this->request('v1/billing/subscriptions', $params);
        if ($data['status'] != 'OK')
        {
            throw new Exception($data['text']);
        }
		
        $response = new pjPaypalExpressSDKResponse($data['result']);
        if (!$response->isOK())
		{
            $error = $response->getError();
            throw new Exception(@$error['message']);
		}
		
        return $data['result'];
    }

    /**
     * Creates an order
     *
     * @param array $params
     * @return array
     * @throws Exception
     */
    public function createOrder($params)
		{
        $data = $this->request('v2/checkout/orders', $params);
        if ($data['status'] != 'OK')
        {
            throw new Exception($data['text']);
		}
		
        $response = new pjPaypalExpressSDKResponse($data['result']);
        if (!$response->isOK())
        {
            $error = $response->getError();
            throw new Exception(@$error['message']);
        }
		
        return $data['result'];
	}

    /**
     * Capture payment for an order
     *
     * @param string $order_id
     * @return array
     * @throws Exception
     */
    public function captureOrder($order_id)
	{
        $data = $this->request('v2/checkout/orders/'.$order_id.'/capture', true);
        if ($data['status'] != 'OK')
        {
            throw new Exception($data['text']);
        }
		
        $response = new pjPaypalExpressSDKResponse($data['result']);
        if (!$response->isOK())
        {
            $error = $response->getError();
            throw new Exception(@$error['message']);
        }

        return $data['result'];
    }

    /**
     * Capture authorized payment on subscription
     *
     * @param string $subscription_id
     * @param array $params
     * @return array
     * @throws Exception
     */
    public function captureSubscription($subscription_id, $params)
		{
        $data = $this->request('v1/billing/subscriptions/'.$subscription_id.'/capture', $params);
        if ($data['status'] != 'OK')
        {
            throw new Exception($data['text']);
		}
		
        $response = new pjPaypalExpressSDKResponse($data['result']);
        if (!$response->isOK())
        {
            $error = $response->getError();
            throw new Exception(@$error['message']);
        }
		
        return $data['result'];
	}

    /**
     * Subscribes your webhook listener to events.
     *
     * @param array $params
     * @return mixed
     * @throws Exception
     */
    public function createWebHook($params)
    {
        $data = $this->request('v1/notifications/webhooks', $params);
        if ($data['status'] != 'OK')
        {
            throw new Exception($data['text']);
        }

        $response = new pjPaypalExpressSDKResponse($data['result']);
        if (!$response->isOK())
        {
            $error = $response->getError();
            throw new Exception(@$error['message']);
        }

        return $data['result'];
    }
}