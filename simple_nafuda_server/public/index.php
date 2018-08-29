<?php
require_once("../vendor/autoload.php");

define("TG", 'bc2018');
define("IMG_DIR", __DIR__ . "/" . TG);

$handlers = function (FastRoute\RouteCollector $r) {
    $r->addRoute('GET', '/{uid}/', 'form');
    $r->addRoute('GET', '/{uid}/json', 'json');
    $r->addRoute('POST', '/{uid}/upload/{num}', 'upload');
    $r->addRoute('POST', '/{uid}/delete/{num}', 'delete');
};
$dispatcher = FastRoute\cachedDispatcher($handlers, [
    'cacheFile' => __DIR__ . '/../route.cache',
    'cacheDisabled' => true
]);
$uri = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];
$routeInfo = $dispatcher->dispatch($method, $uri);
switch ($routeInfo[0]) {
    case FastRoute\Dispatcher::NOT_FOUND:
        echo "NotFound";
        break;
    case FastRoute\Dispatcher::METHOD_NOT_ALLOWED:
        $allowedMethods = $routeInfo[1];
        echo "Forbidden";
        break;
    case FastRoute\Dispatcher::FOUND:
        $handler = $routeInfo[1];
        $vars = $routeInfo[2];
        echo $handler($vars);
        break;
}

function form($args)
{
    $s = generate_something($args);

    $list = exists_img_list($s);
    include 'form.php';
}

function exists_img_list($s)
{
    if (!file_exists($s['base_img_dir'])) {
        mkdir($s['$base_img_dir']);
    }

    $list = [];
    for ($i = 1; $i < 10; $i++) {
        if (file_exists("{$s['base_img_dir']}/{$i}.png")) {
            $list[$i] = true;
        } else {
            $list[$i] = false;
        }
    }
    return $list;
}

function json($args)
{
    $s = generate_something($args);
    $list = [];
    foreach (exists_img_list($s) as $k => $exists) {
        if ($exists) {
            $list[] = "{$k}.png";
        }
    }

    header('content-type: application/json');
    echo json_encode([
        "last_update"=>time(), # fix me!!!
        "list" => $list
    ], JSON_PRETTY_PRINT);

}

function upload($args)
{
    $tmp = $_FILES['image']['tmp_name'];
    if (!is_uploaded_file($tmp)) {
        throw new \InvalidArgumentException("not upload file");
    }

    if (filesize($tmp) > 1024 * 1024 * 5) {
        throw new \InvalidArgumentException("too large. 5MB is max.");
    }

    $img_size = getimagesize($tmp);
    if ($img_size[0] > 5000 || $img_size[1] > 5000) {
        throw new \InvalidArgumentException("too big. 5000px is max.");
    }

    $imgmanager = new \Intervention\Image\ImageManager();

    $image = $imgmanager
        ->make($tmp)
        ->orientate()
        ->widen(300, function ($constraint) {
            $constraint->upsize();
        })
        ->heighten(400, function ($constraint) {
            $constraint->upsize();
        });

    $s = generate_something($args);

    if (!file_exists($s['base_img_dir'])) {
        mkdir($s['base_img_dir']);
    }

    $image->save("{$s['base_img_dir']}/{$s['num']}.png", 60);

    redirect($s['your_form_url']);
}

function delete($args)
{
    $s = generate_something($args);
    $file_path = "{$s['base_img_dir']}/{$s['num']}.png";
    if (file_exists($file_path)) {
        unlink($file_path);
    }
    redirect($s['your_form_url']);
}

#
###
#

function generate_something($args)
{
    $rtn = [];

    $uid = $args['uid'];
    if (strlen($uid) != 64) {
        throw new \InvalidArgumentException('invalid nafuda id (len)' . strlen($uid));
    }
    if (preg_match('/[^A-Za-z[0-9]]/u', $uid)) {
        throw new \InvalidArgumentException('invalid nafuda id (char)');
    }
    $rtn['uid'] = $uid;

    $rtn['base_img_dir'] = IMG_DIR . '/' . $uid;
    $rtn['base_img_url'] = '/' . TG . '/' . $uid;

    $rtn['your_form_url'] = $uid . "/";

    if (isset($args['num'])) {
        $num = (int)$args['num'];
        if ($num > 10 || 1 > $num) {
            throw new \InvalidArgumentException("invalid num");
        }
        $rtn['num'] = $num;
    }

    return $rtn;
}

function redirect($url)
{
    header("Location: /{$url}");
    exit;
}

function e($str, $rtn = false)
{
    if ($rtn) {
        return htmlspecialchars($str, ENT_QUOTES);
    } else {
        echo htmlspecialchars($str, ENT_QUOTES);
        return;
    }
}

