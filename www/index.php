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
		$search_SQL = "WHERE uri LIKE '%".$search."%'";
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
		header("Location: index.php");
	}

	if(isset($_POST['updateactive'])){
		if(!empty($_POST['updateactive'])) {  
			$keys = array_keys($_POST['updateactive']);
			for ($i = 0; $i < count($_POST['updateactive']); $i++){
				$sql = "
					UPDATE ".$Database['tableuriname']." 
					SET active='".$_POST['updateactive'][$keys[$i]]."'
					WHERE id='".$keys[$i]."';
				";
				$pdo->exec($sql);
			}
		}
	}

	echo "
	<div class='section'>
		<div style='line-height:24px;'>
			<form autocomplete='off' id='myForm' action='index.php' method='GET'><br>
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
		FROM ".$Database['tableuriname']." 
		".$search_SQL
	);
	$total_pages_sql->execute();
	$total_rows = $total_pages_sql->fetchColumn();
	$total_pages = ceil($total_rows / $no_of_records_per_page);

	$sql = $pdo->prepare("
		SELECT * FROM ".$Database['tableuriname']." 
		".$search_SQL."
		ORDER BY timestamp DESC
		LIMIT ".$offset.", ".$no_of_records_per_page
	);
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
			echo "No results ".$search_res;
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
		<div class='clear'></div>";


		echo "
		<form autocomplete='off' id='uriForm' action='".$_SERVER['REQUEST_URI']."' method='POST'>
			<div class='div-table'>
				<div class='div-table-row-header'>
					<div class='div-table-col uriwidth'>URI</div>
					<div class='div-table-col'>Last</div>
					<div class='div-table-col center'>Adds</div>
					<div class='div-table-col center'>Hits</div>
					<div class='div-table-col center'>De/Activate</div>
				</div>";
		
		while($row = $sql->fetch(PDO::FETCH_ASSOC)){
			if ($row['active']) {$checked = "checked";} else {$checked = "";}
			echo "
				<div class='div-table-row'>
					<div class='div-table-col uriwidth truncate whitespace' data-column='URI'><a href='./edit.php?id=".$row['id']."'>".$row['uri']."</a></div>
					<div class='div-table-col center' data-column='Last'>".date("y/m/d H:i:s", strtotime($row['timestamp']))."</div>
					<div class='div-table-col center' data-column='Adds'>".number_format($row['adds'])."</div>
					<div class='div-table-col center' data-column='Hits'>".number_format($row['hits'])."</div>
					<div class='div-table-col center' data-column='De/Activate'>
						<div class='onoffswitch'>
							<input type='hidden' name='updateactive[".$row['id']."]' value='0'>
							<input type='checkbox' name='updateactive[".$row['id']."]' class='onoffswitch-checkbox' id='activeswitch".$row['id']."' value='1' onchange='submitFunction()' ".$checked.">
							<label class='onoffswitch-label' for='activeswitch".$row['id']."'>
								<div class='onoffswitch-inner'></div>
								<div class='onoffswitch-switch'></div>
							</label>
						</div>
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
		</span>
		";
		}
	}


?>
<script>
	function submitFunction() {
		document.getElementById("uriForm").submit();
	}
</script>
<script>
$("#select-all").change(function(){
	$(".onoffswitch-checkbox").prop('checked', $(this).prop("checked"));
});

$('.onoffswitch-checkbox').change(function(){ 
	if(false == $(this).prop("checked")){
		$("#select-all").prop('checked', false);
	}
		if ($('.checkbox:checked').length == $('.checkbox').length ){
	$("#select-all").prop('checked', true);
	}
});
</script>

	</div> <!-- end of section -->

<?php include("foot.php") ?>