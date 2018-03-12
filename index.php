<?php
$error = [ 'message' => '', 'type' => 'success' ];

/* Upload form reception */
if(isset($_FILES['file'])){
	$name = htmlentities(str_replace(['<', '>', ' '], ['', '', '_'], "uploads/".$_FILES['file']['name']));
	if ($_FILES['file']['error'] == UPLOAD_ERR_NO_FILE) $error = [ 'message' => 'fichier manquant', 'type' => 'success' ];
	else if ($_FILES['file']['error'] == UPLOAD_ERR_INI_SIZE) $error = [ 'message' => 'fichier dépassant la taille maximale autorisée par PHP', 'type' => 'success' ];
	else if ($_FILES['file']['error'] == UPLOAD_ERR_FORM_SIZE) $error = [ 'message' => 'fichier dépassant la taille maximale autorisée par le formulaire', 'type' => 'success' ];
	else if ($_FILES['file']['error'] == UPLOAD_ERR_PARTIAL) $error = [ 'message' => 'fichier transféré partiellement. Essayez encore', 'type' => 'success' ];
	else if ($_FILES['file']['error'] > 0) $error = [ 'message' => 'Unkown error : '.$_FILES['file']['error'], 'type' => 'danger' ];
	else if(move_uploaded_file($_FILES['file']['tmp_name'], $name)){
    //https://help.ubuntu.com/community/Antivirus
    
    $error = [ 'message' => 'Transfert réussit', 'type' => 'success' ];
  }else{
    $error = [ 'message' => 'Le fichier n’a pas pu être copié ! Contactez le webmaster.', 'type' => 'danger' ];
  }

}
?>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title>PirateBox</title>
</head>
<body>
	<header>
		<h1>PirateBox</h1>
    <p class="<?php echo $error['type'] ?>"><?php echo $error['message'] ?></p>
		<div id="upload">
			<form method="post" action="?" enctype="multipart/form-data">
				<input type="file" name="file" />
				<input type="submit" />
			</form>
		</div>
	</header>
  <main>
    <ul>
    <?php
      foreach (array_slice(scandir('uploads'), 2) as $file){
        echo '<li><a href="uploads/',$file,'">',$file,'</a></li>';
      }
    ?>
    </ul>
	</main>
</body>
</html>

