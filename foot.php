
	<br>
	<div class="footer">
		&#169; <?php echo date("Y"); ?> Pálinkás Jó Reggelt
<?php 
(int)$versionGitHub = file_get_contents('https://raw.githubusercontent.com/palinkas-jo-reggelt/hMailServer_pURIBL/main/VERSION');
(int)$versionLocal = file_get_contents('VERSION');
if ($versionLocal < $versionGitHub) {
	echo "<br><br>Upgrade to version ".$versionGitHub." available at <a href='https://github.com/palinkas-jo-reggelt/hMailServer-IDS-Viewer'>GitHub</a>";
}
?>
	</div>

</div> <!-- end WRAPPER -->
</body>
</html>