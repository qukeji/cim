<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="${request.contextPath}/favicon.ico">
    <title></title>
    <link href="${request.contextPath}/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

    <link rel="stylesheet" href="${request.contextPath}/style/2018/bracket.css">
    <link rel="stylesheet" href="${request.contextPath}/style/2018/common.css">

    <script src="${request.contextPath}/lib/2018/jquery/jquery.js"></script>
    <script src="${request.contextPath}/common/2018/common2018.js"></script>
    <script src="${request.contextPath}/common/2018/TideDialog2018.js"></script>
    <script>
        var id = ${id};
        $(function () {
            $('.video').css("width", '${videoRatio}');
            $('.image').css("width", '${photoRatio}');
            $('.file').css("width", '${fileRatio}');

            $("#edit").click(function () {
                var space = $("#space").val();
                if (!checkInteger(space)) {
                    $("#space").val("");
                    $("#space").attr("placeholder", "请输入大于0的整数!");
                    return;
                }
                if (parseFloat(space) <=parseFloat(${useTotal}) ) {
                    $("#space").val("");
                    $("#space").attr("placeholder", "空间大小必须大于租户已使用空间");
                    return;
                }
                $.ajax({
                    url: "${request.contextPath}/company/space/update",
                    type: 'POST',
                    data: {"id": id, "space": space},
                    success: function () {
                        var	dialog = new top.TideDialog();
                        dialog.showAlert( "修改成功");
                        top.TideDialogClose({refresh:'right'});
                    }
                })
            })
        })

        function checkInteger(num) {
            if (!isNaN(num) && num % 1 === 0 && num > 0) {
                return true;
            } else {
                return false;
            }
        }
    </script>
</head>

<style>
    html, body {
        width: 100%;
        height: 100%;
    }

    .zh_about {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .zh_about .zh_name {
        min-width: 10px;
    }

    .storage_color {
        display: flex;
        justify-content: flex-start;
        align-items: center;
    }

    .storage_icon {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        display: inline-block;
    }

    .progress-bar-lg {
        height: 34px;
        line-height: 34px;
    }

    .left-fn-title {
        min-width: 70px;
    }

    .wd-content-lable {
        width: 300px;
    }
</style>
<body class="collapsed-menu email">
<div class="bg-white modal-box">
    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
        <div class="zh_about tx-14 mg-b-15">
            <div class="zh_name tx-black">泰德网聚</div>
            <div class="zh_storage_about">已使用${useTotal}G/${space}G（剩余${residue}G）</div>
        </div>
        <div class="storage_color mg-b-15">
            <span class="mg-r-15"><i class="storage_icon bg-purple mg-r-5"></i>视频</span>
            <span class="mg-r-15"><i class="storage_icon bg-primary mg-r-5"></i>图片</span>
            <span><i class="storage_icon bg-danger mg-r-5"></i>文件</span>
        </div>
        <div class="progress mg-b-10">
            <div class="progress-bar progress-bar-lg bg-purple video" style="" role="progressbar"
                 aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">${videoRatio}
            </div>
            <div class="progress-bar progress-bar-lg bg-primary image" style="" role="progressbar"
                 aria-valuenow="30" aria-valuemin="0" aria-valuemax="100">${photoRatio}
            </div>
            <div class="progress-bar progress-bar-lg bg-danger file" style="" role="progressbar"
                 aria-valuenow="10" aria-valuemin="0" aria-valuemax="100">${fileRatio}
            </div>
        </div>
        <div class="d-flex justify-content-between align-items-center tx-12 mg-b-20">
            <span>视频使用：${useVideoSpace}G 占用${videoRatio}</span>
            <span>图片使用：${usePhotoSpace}G 占用${photoRatio}</span>
            <span>文件使用：${useFileSpace}G 占用${fileRatio}</span>
        </div>
        <div class="row flex-row align-items-center mg-b-15 mg-x-0-force">
            <label class="left-fn-title">编辑空间：</label>
            <label class="wd-content-lable d-flex disable_blank">
                <input type="text" class="textfield form-control" size="10" name="" id="space" value="">
            </label>
        </div>
        <div class="row mg-t--10  mg-x-0-force">
            <label class="left-fn-title"> </label>
            <label class="d-flex align-items-center tx-gray-800 tx-12">
                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                更改后的空间必须大于租户已使用空间
            </label>
        </div>
    </div><!-- modal-body -->
    <div class="btn-box">
        <div class="modal-footer">
            <button type="button" class="btn btn-primary tx-size-xs" id="edit">确认</button>
            <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs"
                    data-dismiss="modal">取消
            </button>
        </div>
    </div>

</div><!-- br-mainpanel -->

<script src="${request.contextPath}/lib/2018/popper.js/popper.js"></script>
<script src="${request.contextPath}/lib/2018/bootstrap/bootstrap.js"></script>
<script src="${request.contextPath}/lib/2018/moment/moment.js"></script>
<script src="${request.contextPath}/lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="${request.contextPath}/common/2018/bracket.js"></script>
<script>

</script>

</body>
</html>