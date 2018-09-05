<!doctype html>
<html lang="ja">
<head>
    <meta name="viewport" content="width=480">
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

<p>こちらの画面で画像をアップロードした後、「ネットワークがある状態で」電子名札のrebootが必要です。<br>
（起動時の情報表示に、wlan0などでIPが振られえいることを確認してください）<br>
reboot後、nafuda slideshow前にDownloadが行われます。</p>

<p>
Max file size は ５MB です。アップロードに失敗する場合は、resizeしてください
</p>

<h2>一覧</h2>

<?php foreach ($list as $i => $exists) { $num = $i;?>

    <?php if ($exists) { ?>
        <form action="delete/<?php e($num)?>" method="post">
            <?php e($num)?>. <img src="<?php e($s['base_img_url'])?>/<?php e($num)?>.png" class="thumbnail">
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

<hr>

<p>
電子名札の情報やドキュメントなどが記載された、公式のGithubはこちらからどうぞ<br>
<a href="https://github.com/builderscon/electronic_badge_2018" target="_blank">github/builderscon/electronic_badge_2018</a>
</p>

<p>
初期に登録されていた注意書きや、メルカリ様ロゴなどは以下からDLできます<br>
<a href="https://github.com/builderscon/electronic_badge_2018/tree/master/bootup/virtual_sd_builder/skel/img" target="_blank">IMG</a>
</p>

</body>
</html>