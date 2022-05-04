<?php include("head.php") ?>

<?php
	include_once("config.php");
	include_once("functions.php");

	if (isset($_GET['id'])) {$id = $_GET['id'];} else {$id = "";}

	if (isset($_POST['edit'])) {
		if ((isset($_POST['updateuri'])) && (isset($_POST['updateactive']))) {
			$sql = "
				UPDATE ".$Database['tableuriname']." 
				SET 
					uri='".preg_replace('+/+','\/',trim($_POST['updateuri']))."', 
					active='".$_POST['updateactive']."'
				WHERE id='".$id."';
			";
			$pdo->exec($sql);
			header("Location: ".$_POST['referrer']);
		}
	}
	if (isset($_POST['delete'])) {
		$sql = "DELETE FROM ".$Database['tableuriname']." WHERE id='".$id."';";
		$pdo->exec($sql);
		header("Location: ".$_POST['referrer']);
	}

	echo "<div class='section'>";
	echo "<br><br>";
	echo "<b>ID: ".$id."</b>";
	echo "<br><br>";

	$sql = $pdo->prepare("SELECT * FROM ".$Database['tableuriname']." WHERE id = '".$id."';");
	$sql->execute();
	echo "<table class='section'>";
	while($row = $sql->fetch(PDO::FETCH_ASSOC)){
		echo "<form action='".$_SERVER['REQUEST_URI']."' method='POST' onsubmit='return confirm(\"Are you sure you want to change the record?\");'>
				<input type='hidden' name='referrer' value='".$_SERVER['HTTP_REFERER']."'>";
		echo "<tr>
				<td>URI:</td>
				<td>
					<textarea rows='6' cols='35' name='updateuri'>".$row['uri']."</textarea>
				</td>
			</tr>";
		echo "<tr>
				<td>Adds:</td>
				<td>".$row['adds']."</td>
			</tr>";
		echo "<tr>
				<td>Hits:</td>
				<td>".$row['hits']."</td>
			</tr>";
		echo "<tr>
				<td>Last Hit:</td>
				<td>".date("y/n/j G:i:s", strtotime($row['timestamp']))."</td>
			</tr>";
		if ($row['active']==0) {
			$active="<select name='updateactive'><option value=1>No</option><option value=1>Yes</option></select>";
		} else {
			$active="<select name='updateactive'><option value=1>Yes</option><option value=0>No</option></select>";
		}
		echo "<tr>
				<td>Active:</td>
				<td>".$active."</td>
			</tr>";
		echo "<tr>
				<td>Delete:</td>
				<td><input type='submit' name='delete' value='Delete' ></td>
			</tr>";
		echo "<tr>
				<td>Edit:</td>
				<td><input type='submit' name='edit' value='Edit' ></td>
				</form>
			</tr>";
	}
	echo "</table>";

	echo "<br><br>";

	echo "</div>";


?>