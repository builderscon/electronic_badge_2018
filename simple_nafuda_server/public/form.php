<!doctype html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>electronic badge - builderscon tokyo 2018</title>
    <style>
        .thumbnail {
            max-width: 200px;
            max-height: 200px;
        }
    </style>
</head>
<body>

<h1>電子名札 画像設定ツール</h1>

<h2>一覧</h2>

<?php foreach ($list as $i => $exists) { $num = $i;?>

    <?php if ($exists) { ?>
        <form action="delete/<?php e($num)?>" method="post">
            <?php e($num)?>. <img src="<?php e($s['base_img_url'])?>/<?php e($num)?>.jpg" class="thumbnail">
            <button type="submit">削除</button>
        </form>
    <?php } else { ?>
        <form action="upload/<?php e($num)?>" method="post" enctype="multipart/form-data">
            <?php e($num)?>. 空
            <input type="file" name="image" accept="image/jpeg,image/png,image/gif">
            <button type="submit">アップロード</button>
        </form>
    <?php } ?>
<?php } ?>

</body>
</html>