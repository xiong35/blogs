
# ImgFile和dataUrl的转换

```js
function fileToImage(file){
    var reader = new FileReader();
    reader.readAsDataURL(file);//读取图像文件 result 为 DataURL, DataURL 可直接 赋值给 img.src
    reader.onload = function(event){
        var img = document.getElementById("img").children[0];
        img.src = event.target.result;//base64
    }
}

function fileToCanvas(file){
    var reader = new FileReader();
    reader.readAsDataURL(file);//读取图像文件 result 为 DataURL, DataURL 可直接 赋值给 img.src
    reader.onload = function(event){
        var image = new Image();
        image.src = event.target.result;
        image.onload = function(){
            var canvas = document.getElementById("canvas");
            var imageCanvas = canvas.getContext("2d");
            imageCanvas.drawImage(image, 0, 0,300,300);
            canvasToImage(canvas);
        }
    }
}

function canvasToImage(canvas){
    var image = new Image();
    image.src = canvas.toDataURL("image/png");//base64
}

```