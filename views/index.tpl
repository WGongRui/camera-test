<!DOCTYPE html>

<html>
<head>
  <title>Beego</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta http-equiv="Expires" content="0">
  <meta http-equiv="Cache-Control" content="no-cache">
  <meta http-equiv="Pragma" content="no-cache">
  <script src="/static/js/mobileBUGFix.mini.js"></script>
  <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
</head>
    <body>
    <div id="loading" style="position: absolute;top: 40%;margin: 0 auto;width: 100%;display: none;">
        <img src="./static/img/loading.gif" style="width: 40px;height: 40px;">
    </div>
    <div class="camera" disabled="true">
        <a href="javascript:" >
            <div>
                <input id="camera" type="file" accept="image/*" capture="camera">
            </div>
        </a>
    </div>
    <div class="display">
        <abbr id="image-info"></abbr>
        <textarea id="base64" rows="5"></textarea>
        <img id="camera-img">
        <abbr id="card-info"></abbr>
    </div>
    </body>
</html>
<style>
    body{
        text-align:center;
    }
    .camera *{
        margin: 0 auto;
        width: 150px;
        height: 150px;
        border-radius: 50%;
    }
    .camera div {
        background-size: cover;
        background-image: url("/static/img/camera.png");
    }
    .camera input {
        opacity: 0;
    }
    .display * {
        width: 100%;
        margin-top: 10px;
    }
</style>
<script>
    document.getElementById("camera").addEventListener("change", function () {
        var imgFile = this.files[0]
        var blob = window.URL.createObjectURL(imgFile)
        var img = new Image();
        img.src = blob;
        img.onload = function () {
            var canvas = document.createElement("canvas")
            var ctx = canvas.getContext("2d")
            var w = img.width
            var h = img.height
            canvas.width = w
            canvas.height = h
            ctx.drawImage(img, 0, 0)

            document.getElementById("loading").style.display = 'block'

            var base64 = canvas.toDataURL()

            var clearBase64 = base64.substr(base64.indexOf(',') + 1)
            // 获取到Base显示在页面上
            document.getElementById("image-info").innerHTML = "Size : " + imgFile.size / 1024 + "KB" +
                "<br>Type : " + imgFile.type +
                "<br>FileName : " + imgFile.name
            document.getElementById("camera-img").src = blob
            document.getElementById("base64").innerText = clearBase64
            var cardInfo = document.getElementById("card-info")
            axios({
                method:'post',
                url: '/cardInfo',
                data: {
                    base64: clearBase64
                },
                headers: {
                    "Content-Type":"application/x-www-form-urlencoded"
                }}).
                then(function (response) {
                    console.log(response);
                    cardInfo.innerText = JSON.stringify(response.data)
                    document.getElementById("loading").style.display = 'none'
                })
                .catch(function (error) {
                    console.log(error);
                    cardInfo.innerText = error.data
                    document.getElementById("loading").style.display = 'none'
                });
        }
    })
</script>