<?php 
$path = __DIR__.'/clip.txt';
if (isset($_POST['clip'])) {
	file_put_contents($path, str_replace("\r", "", $_POST['clip']));
	header("Location: $_SERVER[REQUEST_URI]");
}
?><!doctype html>
<html>
<head><title>Clipboard</title></head>
<body>
	<form method="POST">
		<textarea name="clip" style="width:100%; height:60vh;"><?php echo htmlspecialchars(file_get_contents($path)); ?></textarea>
		<br><input type="submit" value="update"> <input type="reset" value="reset" onclick="this.form.clip.value = ''; this.form.submit();">
	</form>
</body>
</html>
