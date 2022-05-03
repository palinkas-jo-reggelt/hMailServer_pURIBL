<?php include("head.php") ?>

<?php
	include_once("config.php");
	include_once("functions.php");

	if (isset($_GET['id'])) {$id = trim($_GET['id']);} else {$id = "";}

	echo "<div class='section'>";
	echo "<br><br>";
	echo "Black/White List Entry Creation Results:";
	echo "<br><br>";

	$sql = $pdo->prepare("
		SELECT *
		FROM ".$Database['tableuriname']." 
		WHERE id = '".$id."';
	");
	$sql->execute();
	$count = $sql->rowCount();
	if ($count > 0){
		while($row = $sql->fetch(PDO::FETCH_ASSOC)){
			echo "<table class='section'>";
			echo "<tr>
					<td>ID:</td>
					<td>".$row['id']."</td>
				</tr>";
			echo "<tr>
					<td>Trunk:</td>
					<td>".$row['trunk']."</td>
				</tr>";
			echo "<tr>
					<td>Branch:</td>
					<td>".$row['branch']."</td>
				</tr>";
			echo "<tr>
					<td>Node:</td>
					<td>".$row['node']."</td>
				</tr>";
			echo "</table>";
			echo "<br><br>Record entered successfully.";
		}
	} else {
		echo "ERROR: Missing field data. Please try again.";
	}
	
	echo "<br><br>";

	echo "</div>";

?>