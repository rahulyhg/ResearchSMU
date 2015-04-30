<?php

	$debug = true;
	require 'vendor/autoload.php';
	$app = new \Slim\Slim();
	
	$mysqli = new mysqli("localhost", "root", "toor", "DBGUI");
	if($mysqli->connect_errno)
		die("Connection failed: " . $mysqli->connect_errno);
	
	
	
	/*==========================================================\\
	||						Authenticate						||
	\\==========================================================*/
	function authenticate(){
		$provider = new League\OAuth2\Client\Provider\LinkedIn([
			'clientId' => '78byrh87ljeuap',
			'clientSecret' => 'smOpm0SlHgstRvMa',
			'redirectUri' => 'http://192.168.10.10/api/linkedin.php/linkedinSession',
			//'scopes' => ['w_share']
		]);
				
		if (!isset($_GET['code'])) {

			// If we don't have an authorization code then get one
			$authUrl = $provider->getAuthorizationUrl();
			$_SESSION['oauth2state'] = $provider->state;
			header('Location: '.$authUrl);
			exit;

		// Check given state against previously stored one to mitigate CSRF attack
		} elseif (empty($_GET['state']) || ($_GET['state'] !== $_SESSION['oauth2state'])) {

			unset($_SESSION['oauth2state']);
			exit('Invalid state');

		} else {

			// Try to get an access token (using the authorization code grant)
			$token = $provider->getAccessToken('authorization_code', [
				'code' => $_GET['code']
			]);

			// Use this to interact with an API on the users behalf
			//echo $token->accessToken;

			// Use this to get a new access token if the old one expires
			//echo $token->refreshToken;

			// Number of seconds until the access token will expire, and need refreshing
			//echo $token->expires;
			
			return $token;
		}
		
		
			
		//return $token;
	}
	
	
	/*==========================================\\
	||				Check Session				||
	\\==========================================*/
	$app->get('/linkedinSession', function(){
		global $mysqli, $debug;
		
		$token = NULL;
		
		if(/*(isset($_SESSION['accessToken']))*/true){
			session_start();
			$token = authenticate();
			
			$accessToken = $token->accessToken;
			$expires = $token->expires;
			
			$expiresDate = date("Y-m-d H:i:s", time() + $expires);			
			
			echo $accessToken."<br>";
			echo $expires."<br>";
			echo $expiresDate;
			
			$sql = "INSERT INTO Token (accessToken, expires) VALUES (?, ?)";
			$insert = $mysqli->prepare($sql);
			$insert->bind_param('ss', $accessToken, $expiresDate);
			
			if(!($insert->execute())){
				die(json_encode(array('Status' => 'Failure',
					'ERROR' => $mysqli->errno.':'.$mysqli->errno
				)));
			}
			
			$_SESSION['accessToken'] = $accessToken;
			$_SESSION['expires'] = $expires;
			
			$insert->close();
			
		} else {

			$sql = "SELECT TOP 1 accessToken, expires FROM LinkedIn ";
			
			if($result = $mysqli->query($sql)){
				$row = $result->fetch_now();
				$_SESSION['accessToken'] = $row['accessToken'];
				$_SESSION['expires'] = $row['expires'];
			}
		}
		
		//echo $token->expires;
	});
	
		
	
	/*==========================================================\\
	||							Post							||
	\\==========================================================*/
	$app->get('/linkedinPost', function() {
		global $mysqli, $debug;
		
		$accessToken = $_SESSION['accessToken'];
		
		$postId = 1;//$_POST['researchOpId'];
		
		if($debug) echo "Posting to LinkedIn... ".$postId."\n";

		//header('x-li-format: json');
		
		
		//Check if post is active:
		$sql = "SELECT active FROM ResearchOp WHERE researchOp_ID='$postId'";
		$stmt = $mysqli->prepare($sql);
		$stmt->execute();
		$stmt->bind_result($active);
		$stmt->fetch();
		$stmt->close();
		
		echo $active;
		
		if($active){
			//Prepare authentication
						
			//Get data from database
			$postDept;
			$postName;
			$postDescription;
			
			$sql = "SELECT dept_ID, name, description FROM ResearchOp WHERE researchOp_ID='$postId'";
			$stmt = $mysqli->prepare($sql);
			$stmt->execute();
			$stmt->bind_result($postDept, $postName, $postDescription);
			$stmt->fetch();
			$stmt->close();
			
			//Prepare data for LinkedIn post
			$postComment = "New Research Opportunity in " . $postDept . "!";
			$postTitle = "http://52.11.153.243/research-opporunity/" . $postId;
			$postDescription = (strlen($postDescription) > 256) ? substr($postDescription, 0, 253).'...' : $postDescription;
			
			$postData = json_encode(array('comment' => $postComment,
				'content' => array(
					'title' => $postTitle,
					'description' => $postDescription
				),
				'submitted-url' => $postTitle,
				'submitted-image-url' => 'https://avatars0.githubusercontent.com/u/6441254?v=3&s=400',
				'visibility' => array(
					'code' => 'anyone'
				)
			));
			$urlData = array(
				'x-li-format' => 'json',
				'Authorization' => 'Bearer'.$accessToken
			);
			
			
			//Post data to LinkedIn
			//$result = $linkedIn->$api('v1/people/~/shares?format=json', $urlData, 'POST', $postData);
			$curl = curl_init();
			$curl_setopt_array($curl, array(
				CURLOPT_URL => 'https://api.linkedin.com/v1/people/~/shares?format=json',
				CURLOPT_POST => 1,
				CURLOPT_RETURNTRANSFER => 1,
				CURLOPT_HTTPHEADER => array(
				'x-li-format' => 'json',
				'Authorization' => 'Bearer '.$accessToken
				),
				CURLOPT_POSTFIELDS => array(
				'comment' => $postComment,
				'content' => array(
					'title' => $postTitle,
					'description' => $postDescription
				),
				'submitted-url' => $postTitle,
				'submitted-image-url' => 'https://avatars0.githubusercontent.com/u/6441254?v=3&s=400',
				'visibility' => array(
					'code' => 'anyone'
				)))
			);
			
			//curl -v -X POST -d '{"comment": "Test Research OP", "content": {"title": "Testing From Curl!", "description": "Just testing if I can make posts from Curl...", "submitted-url": "http://52.11.153.243", "submitted-imate-url": "https://avatars0.githubusercontent.com/u/6441254?v=3&s=400"}, "visibility": {"code": "anyone"}}' -H "x-li-format: json" -H "Authorization: Bearer 75628ae2-0ccc-4e6c-ba7d-e4a35f0c170b" https://api.linkedin.com/v1/people/~/shares?format=json
			
			$response = curl_exec($curl);
			curl_close($curl);
			
			echo $result;
			
			if(!($result)){
				die(json_encode(array('Status' => 'Failure',
					'ERROR' => 'Shit\'s fucked'
				)));
			} else {
				echo "Shit worked\n";
			}
				
			
		} else {
			//Post is not active, so don't post it
			die(json_encode(array('Status' => 'Failed',
				'ERROR' => 'Post is not active, can\'t fetch data.')));
		}
	});
	
	
	
	$app->run();

?>