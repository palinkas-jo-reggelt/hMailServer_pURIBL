<?php include("head.php") ?>

<?php
	include_once("config.php");
	include_once("functions.php");

	if (isset($_GET['page'])) {
		$page = $_GET['page'];
		$display_pagination = 1;
	} else {
		$page = 1;
		$total_pages = 1;
		$display_pagination = 0;
	}
	
	if (isset($_GET['search'])) {
		$search = trim($_GET['search']);
		$search_ph = trim($_GET['search']);
		$search_SQL = " AND domain LIKE '%".$search."%'";
		$search_res = " for search term \"<b>".$search."</b>\"";
		$search_page = "&search=".$search;
	} else {
		$search = "";
		$search_ph = "";
		$search_SQL = "";
		$search_res = "";
		$search_page = "";
	}

	if (isset($_GET['clear'])) {
		header("Location: domains.php");
	}

	if(isset($_POST['shortcircuit'])){
		if(!empty($_POST['shortcircuit'])) {
			$keys = array_keys($_POST['shortcircuit']);
			for ($i = 0; $i < count($_POST['shortcircuit']); $i++){
				$sql = "
					UPDATE ".$Database['tabledomname']."
					SET shortcircuit = '".$_POST['shortcircuit'][$keys[$i]]."'
					WHERE id = '".$keys[$i]."';
				";
				$pdo->exec($sql);
			}
		}
	}

	if(isset($_POST['delete'])){
		if(!empty($_POST['delete'])) {
			$sql = "
				DELETE FROM ".$Database['tabledomname']."
				WHERE id = '".$_POST['delete']."';
			";
			$pdo->exec($sql);
			$sql = "
				DELETE FROM ".$Database['tableuriname']."
				WHERE uri LIKE '%".$_POST['domain']."%';
			";
			$pdo->exec($sql);
		}
	}
	
	echo "
	<div class='section'>
		<div style='line-height:24px;'>
			<form autocomplete='off' id='myForm' action='domains.php' method='GET'><br>
				<input type='text' size='20' name='search' placeholder='Search Term...' value='".$search_ph."'>
				<input type='submit' name='submit2' value='Search' >
				<button class='button' type='submit' name='clear'>Reset</button>
			</form>
		</div>
	</div>
	
	<div class='section'>
		<div style='float:left;'>";

	$offset = ($page-1) * $no_of_records_per_page;
	
	$total_pages_sql = $pdo->prepare("
		SELECT Count( * ) AS count 
		FROM ".$Database['tabledomname']." 
		WHERE id > 0".$search_SQL
	);
	$total_pages_sql->execute();
	$total_rows = $total_pages_sql->fetchColumn();
	$total_pages = ceil($total_rows / $no_of_records_per_page);

	$sql = $pdo->prepare("
		SELECT * FROM ".$Database['tabledomname']." 
		WHERE id > 0".$search_SQL."
		ORDER BY domain ASC
		LIMIT ".$offset.", ".$no_of_records_per_page.";
	");
	$sql->execute();

	if ($total_pages < 2){
		$pagination = "";
	} else {
		$pagination = "(Page: ".number_format($page)." of ".number_format($total_pages).")";
	}

	if ($total_rows == 1){$singular = '';} else {$singular= 's';}
	if ($total_rows == 0){
		if ($search == ""){
			echo "Please enter a search term";
		} else {
			echo "No results ".$search_res.$shortcircuit_res;
		}	
	} else {
		if ($total_pages == 1){
			echo "";
		} else {
			echo "
			<span class='nav'>
				<ul>
				";
			if($page <= 1){echo "<li>First</li>";} else {echo "<li><a href=\"?page=1".$search_page."\">First</a><li>";}
			if($page <= 1){echo "<li>Prev</li>";} else {echo "<li><a href=\"?page=".($page - 1).$search_page."\">Prev</a></li>";}
			if($page >= $total_pages){echo "<li>Next</li>";} else {echo "<li><a href=\"?page=".($page + 1).$search_page."\">Next</a></li>";}
			if($page >= $total_pages){echo "<li>Last</li>";} else {echo "<li><a href=\"?page=".$total_pages.$search_page."\">Last</a></li>";}
			echo "
				</ul>
			</span>";
		}
		echo "
		</div>
		<div style='float:right;padding:10px 0;'>
			<span style='font-size:0.8em;'>Results: ".number_format($total_rows)." Record".$singular." ".$pagination."</span>
		</div>
		<div class='clear'></div>
		
		<form autocomplete='off' id='domForm' action='".$_SERVER['REQUEST_URI']."' method='POST'>
			<div class='div-table'>
				<div class='div-table-row-header'>
					<div class='div-table-col uriwidth'>Domain</div>
					<div class='div-table-col'>Last</div>
					<div class='div-table-col center'>Adds</div>
					<div class='div-table-col center'>Hits</div>
					<div class='div-table-col center'>Short Circuit</div>
					<div class='div-table-col center'>Delete</div>
				</div>";
		
		while($row = $sql->fetch(PDO::FETCH_ASSOC)){
			if ($row['shortcircuit']) {$checked = "checked";} else {$checked = "";}
			echo "
				<div class='div-table-row'>
					<div class='div-table-col uriwidth truncate whitespace' data-column='Domain'><a href='./index.php?search=".$row['domain']."'>".$row['domain']."</a></div>
					<div class='div-table-col center' data-column='Last'>".date("y/m/d H:i:s", strtotime($row['timestamp']))."</div>
					<div class='div-table-col center' data-column='Adds'>".number_format($row['adds'])."</div>
					<div class='div-table-col center' data-column='Hits'>".number_format($row['hits'])."</div>
					<div class='div-table-col center' data-column='Short Circuit'>
						<div class='onoffswitch'>
							<input type='hidden' name='shortcircuit[".$row['id']."]' value='0'>
							<input type='checkbox' name='shortcircuit[".$row['id']."]' class='onoffswitch-checkbox' id='activeswitch".$row['id']."' value='1' onchange='submitFunction()' ".$checked.">
							<label class='onoffswitch-label' for='activeswitch".$row['id']."'>
								<div class='onoffswitch-inner'></div>
								<div class='onoffswitch-switch'></div>
							</label>
						</div>
					</div>
					<div class='div-table-col center' data-column='Delete'>
						<input type='checkbox' style='height:10px;margin:0;' name='delete' value='".$row['id']."' onClick='return confirmSubmit()' onchange='submitFunction()'>
						<input type='hidden' name='domain' value='".$row['domain']."'>
					</div>
				</div>";
		}
		echo "
			</div>
		</form>
		"; // End table

		if ($total_pages == 1){
			echo "";
		} else {
			echo "
		<span class='nav'>
			<ul>
				";
			if($page <= 1){echo "<li>First</li>";} else {echo "<li><a href=\"?page=1".$search_page."\">First</a><li>";}
			if($page <= 1){echo "<li>Prev</li>";} else {echo "<li><a href=\"?page=".($page - 1).$search_page."\">Prev</a></li>";}
			if($page >= $total_pages){echo "<li>Next</li>";} else {echo "<li><a href=\"?page=".($page + 1).$search_page."\">Next</a></li>";}
			if($page >= $total_pages){echo "<li>Last</li>";} else {echo "<li><a href=\"?page=".$total_pages.$search_page."\">Last</a></li>";}
			echo "
			</ul>
		</span>";
		}
	}

?>
<script>
	function submitFunction() {
		document.getElementById("domForm").submit();
	}
</script>
<script>
	function confirmSubmit(){
		var agree=confirm("Are you sure you to delete this record?\n\nWarning: Deleting domain will also delete all URIs associated with the domain.\n\nDisable \"short circuit\" if you're not sure.");
		if (agree)
			return true ;
		else
			return false ;
	}
</script>

	</div> <!-- end of section -->

<?php include("foot.php") ?>