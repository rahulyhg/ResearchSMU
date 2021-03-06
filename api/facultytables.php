<?php
	header('Content-Type: application/json');
	$debug = false;
	require 'vendor/autoload.php';
	$app = new \Slim\Slim();

	// DataTables PHP library
	include( "../../php/DataTables.php" );
 
	// Alias Editor classes so they are easy to use
	use
    	DataTables\Editor,
	    DataTables\Editor\Field,
	    DataTables\Editor\Format,
	    DataTables\Editor\Join,
	    DataTables\Editor\Upload,
	    DataTables\Editor\Validate;


	$app->post('/datatable',function(){
		$mysqli = new mysqli("localhost", "root", "toor", "DBGUI");

		session_start();
		//Arguments
		if(isset($_SESSION['userId']))
		{
			$userId = $_SESSION['userId'];
			//$department = ltrim($department, '0');
		} else {
		 	//if($debug) echo "Department = %";
			$userId = "%";
		}


		// if(isset($_POST['institution']))
		// {
		// 	$institution = $_POST['institution'];
		// 	$institution = ltrim($institution, '0');
		// } else {
		//  	//if($debug) echo "Institution = %";
		// 	$institution = "%";
		// }

		
		// TABLE MAGIC TIME, Create temp table, Drop if it already exists
		$sqldrop = "DROP TABLE IF EXISTS `DBGUI`.`TEMP` ";
		$stmt0 = $mysqli -> prepare($sqldrop);
		$stmt0 -> execute();
		$stmt0 -> close();
		
		$sql = "CREATE TABLE TEMP(ResearchOp_ID int primary key, rName VARCHAR(48), 
					name VARCHAR(90),  
					dName VARCHAR(45), iName VARCHAR(45), gradStudents VARCHAR(270), 
					description MEDIUMTEXT)";
		
		$stmt = $mysqli -> prepare($sql);
		$stmt -> execute();
		$stmt -> close();
		
		// Insert required info into temporary table
		$sql1 = "INSERT into TEMP SELECT 
					ResearchOp.ResearchOp_ID, 
					ResearchOp.name, 
					Concat(Users.fName, ' ', Users.lName), 
					Department.name, 
					Institution.name,
					ResearchOp.gradStudents, 
					ResearchOp.description
				from 
					ResearchOp join Users on ResearchOp.user_ID = Users.user_ID 
				WHERE 
					Users.user_ID LIKE (?)";

		$stmt1 = $mysqli -> prepare($sql1);
		$stmt1 -> bind_param('ss', $institution, $department);
		$stmt1 -> execute();
		$stmt1 -> close();
		
		$table = 'TEMP';
		 
		// Table's primary key
		$primaryKey = 'ResearchOp_ID';
		 
		// Array of database columns which should be read and sent back to DataTables.
		// The `db` parameter represents the column name in the database, while the `dt`
		// parameter represents the DataTables column identifier. In this case simple
		// indexes


		$columns = array(
			array( 'db' => 'ResearchOp_ID',			'dt' => 'ResearchOp_ID' ),
			array( 'db' => 'rName',    				'dt' => "rName" ),
			array( 'db' => 'name',    				'dt' => "pName" ),
			//array( 'db' => 'lName',    				'dt' => "fName" ),
			//array( 'db' => 'startDate',				'dt' => "startDate" ), 
			//array( 'db' => 'endDate',  				'dt' => "endDate" ),
			//array( 'db' => 'numPositions',    		'dt' => "numPositions" ),
			array( 'db' => 'gradStudents',			'dt' => 'gradStudents'),
			array( 'db' => 'dName',    				'dt' => "dName" ),
			array( 'db' => 'iName',    				'dt' => "iName" ),
			// array( 'db' => 'paid',					'dt' => "paid" ), 
			// array( 'db' => 'workStudy',  			'dt' => "workStudy" ),
			// array( 'db' => 'acceptsUndergrad',		'dt' => "acceptsUndergrad"), 
			// array( 'db' => 'acceptsGrad',  			'dt' => "acceptsGrad" ),
			array( 'db' => 'description',			'dt' => "descript" )
		);
		 
		// SQL server connection information
		$sql_details = array(
			'user' => 'root',
			'pass' => 'toor',
			'db'   => 'DBGUI',
			'host' => 'localhost'
		);
		 
		 
		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
		 * If you just want to use the basic configuration for DataTables with PHP
		 * server-side, there is no need to edit below this line.
		 */
		 
		require( 'ssp.class.php' );
		 
		//echo json_encode($columns);

		//$result = SSP::simple( $_POST, $sql_details, $table, $primaryKey, $columns );
	
		$result =  json_encode(
		 	SSP::simple( $_POST, $sql_details, $table, $primaryKey, $columns )
		 );
		echo $result;
	
		// $sqldrop = "DROP TABLE IF EXISTS `DBGUI`.`TEMP` ";
		// $stmt0 = $mysqli -> prepare($sqldrop);
		// $stmt0 -> execute();
		// $stmt0 -> close();
	});
	$app-> run();
?>