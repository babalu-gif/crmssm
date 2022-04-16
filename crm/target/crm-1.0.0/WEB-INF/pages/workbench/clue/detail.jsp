<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String base = request.getContextPath() + "/";
	String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + base;
%>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=url%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/layer-3.5.1/layer.js"></script>

<script type="text/javascript">
	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/

		$("#remarkDivList").on("mouseover", ".remarkDiv", function (){
			$(this).children("div").children("div").show();
		})

		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/

		$("#remarkDivList").on("mouseout", ".remarkDiv", function (){
			$(this).children("div").children("div").hide();
		})

		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/

		$("#remarkDivList").on("mouseover", ".myHref", function (){
			$(this).children("span").css("color","red");
		})

		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/

		$("#remarkDivList").on("mouseout", ".myHref", function (){
			$(this).children("span").css("color","#E6E6E6");
		})

		// 为“保存”按钮绑定单击事件
		$("#saveCreateRemarkBtn").click(function (){
			var noteContent = $.trim($("#remark").val());
			var clueId = "${requestScope.clue.id}";
			// 表单验证
			if (noteContent == ""){
				layer.alert("备注不能为空", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/clue/saveCreateClueRemark.do",
				data:{
					noteContent:noteContent,
					clueId:clueId
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						var html = "";
						html += '<div id="div_'+data.retData.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="${sessionScope.sessionUser.name}" src="image/user-${sessionScope.sessionUser.name}.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="div_'+data.retData.id+' h5">'+data.retData.noteContent+'</h5>';
						html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</b>';
						html += '<small id="div_'+data.retData.id+' small" style="color: gray;"> '+data.retData.createTime+' 由${sessionScope.sessionUser.name}创建</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" href="javascript:void(0);" onclick="updateRemark(\''+data.retData.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.retData.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';
						$("#remarkDiv").before(html);
						// 清空备注编辑框的内容
						$("#remark").val("");
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}

				}
			})
		});

        // 为全选按钮绑定事件
        $("#checkAll").click(function (){
            // 如果“全选”按钮时选中状态，则列表中所有checkbox都选中
            $("input[name=check]").prop("checked", this.checked);
        });

        /*
        动态生成的元素（不能以普通绑定事件的形式来进行操作），我们要以on方法的形式来触发事件
        语法格式：$(需要绑定事件的外层元素).on("绑定事件的方式", 需要绑定的jquery对象, 回调函数)
        */
        $("#tBody").on("click", $("input[name=check]"), function ()
        {
            $("#checkAll").prop("checked", $("input[name=check]").length==$("input[name=check]:checked").length);
        });

		// 为“关联市场活动”按钮绑定单击事件
		$("#bundActivityBtn").click(function (){
			// 初始化工作
			//清空搜索框
			$("#searchActivityTxt").val("");
			//清空搜索的市场活动列表
			$("#tBody").html("");

			// 显示“关联市场活动”的模态窗口
			$("#bundModal").modal("show");
		});

		//  给市场活动搜索框添加键盘弹起事件
		$("#searchActivityTxt").keyup(function (){
			// 收集参数
			var activityName = this.value;
			var clueId = "${requestScope.clue.id}";

			$.ajax({
				url:"workbench/clue/queryActivityForDetailByNameClueId.do",
				data:{
					activityName:activityName,
					clueId:clueId
				},
				type:"post",
				dataType:"json",
				success:function (data){
					var htmlStr = "";
					$.each(data, function (index, obj){
						htmlStr += '<tr>';
						htmlStr += '<td><input name="check" type="checkbox" value="'+obj.id+'"/></td>';
						htmlStr += '<td><a href="workbench/activity/detailActivity.do?id='+obj.id+'" style="text-decoration: none;">'+obj.name+'</a></td>';
						htmlStr += '<td>'+obj.startDate+'</td>';
						htmlStr += '<td>'+obj.endDate+'</td>';
						htmlStr += '<td>'+obj.owner+'</td>';
						htmlStr += '</tr>';
					})
					$("#tBody").html(htmlStr);
				}
			})
		});

        // 为“关联”按钮绑定单击事件
		$("#bundBtn").click(function (){
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要关联的市场活动", {icon:7});
				return;
			}

			var ids = "";
			for(var i = 0; i < $check.length; i++) {
				// 将查询出来的试题id以','分割放入数组中
				ids += "activityId="+$($check[i]).val()+"&";
			}
			ids+="clueId=${requestScope.clue.id}";

			$.ajax({
				url:"workbench/clue/saveBund.do",
				data:ids,
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						$.each(data.retData, function (index, obj){
							var h = "";
							h += '<tr id="tr_'+obj.id+'">';
							h += '<td>'+obj.name+'</td>';
							h += '<td>'+obj.startDate+'</td>';
							h += '<td>'+obj.endDate+'</td>';
							h += '<td>'+obj.owner+'</td>';
							h += '<td><a href="javascript:void(0);"  onclick="removeRelation(\''+obj.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
							h += '</tr>';
							$("#activityRelationBody").append(h);
						})

						// 隐藏“关联市场活动”的模态窗口
						$("#bundModal").modal("hide");
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})

		});

		// 为“转换”按钮绑定单击事件
		$("#convertBtn").click(function (){
			// 发送同步请求
			window.location.href="workbench/clue/toConvert.do?id=${requestScope.clue.id}";
		});

	});

	// 为更新“备注”信息绑定单击事件
	function updateRemark(id){
		var noteContent = $("#div_"+id+" h5").text();
		$("#noteContent").val(noteContent);

		// 显示“修改”线索的模态窗口
		$("#editRemarkModal").modal("show");

		// 为“更新”按钮绑定单击事件
		$("#updateRemarkBtn").click(function (){
			var noteContent = $.trim($("#noteContent").val());
			$.ajax({
				url:"workbench/clue/saveEditClueRemark.do",
				data:{
					id:id,
					noteContent:noteContent
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						$("#div_"+id).remove();
						var html = "";
						html += '<div id="div_'+data.retData.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="${sessionScope.sessionUser.name}" src="image/user-${sessionScope.sessionUser.name}.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="div_'+data.retData.id+' h5">'+data.retData.noteContent+'</h5>';
						html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</b>';
						html += '<small style="color: gray;"> '+data.retData.editTime+' 由${sessionScope.sessionUser.name}修改</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" href="javascript:void(0);" onclick="updateRemark(\''+data.retData.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.retData.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';
						$("#remarkDiv").before(html);
						// 隐藏修改线索备注的模态窗口
						$("#editRemarkModal").modal("hide");
						/*layer.alert(data.message, {icon:6});*/
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		})
	}

	// 为”删除“图标添加函数
	function deleteRemark(id){
		$.ajax({
			url:"workbench/clue/deleteClueRemarkById.do",
			data:{
				id:id
			},
			type:"post",
			dataType:"json",
			success:function (data){
				if (data.code == "1"){
					/*layer.alert(data.message, {icon:6});*/
					// 刷新备注信息
					$("#div_"+id).remove();
				} else {
					layer.alert("系统忙，请稍后重试...", {icon:5});
				}
			}
		})
	}

	// 为”解除关联“绑定单击事件
	function removeRelation(activityId){
		if (confirm("您确定解除关联吗？")){
			$.ajax({
				url:"workbench/clue/saveUnbund.do",
				data:{
					clueId:"${requestScope.clue.id}",
					activityId:activityId
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						$("#tr_"+activityId).remove();
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		}
	}

</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchActivityTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="checkAll" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="bundBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateRemarkBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.clue.fullname}${requestScope.clue.appellation} <small>${requestScope.clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="convertBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.fullname}${requestScope.clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${requestScope.clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${requestScope.remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-${remark.createBy}.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="div_${remark.id} h5">${remark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</b>
					<small id="div_${remark.id} small" style="color: gray;"> ${remark.editFlag=='1'?remark.editTime:remark.createTime} 由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" href="javascript:void(0);" onclick="updateRemark('${remark.id}')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" href="javascript:void(0);" onclick="deleteRemark('${remark.id}')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityRelationBody">
						<c:forEach items="${requestScope.activityList}" var="activity">
							<tr id="tr_${activity.id}">
								<td><a href="workbench/activity/detailActivity.do?id=${activity.id}" style="text-decoration: none;">${activity.name}</a></td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a href="javascript:void(0);"  onclick="removeRelation('${activity.id}')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a id="bundActivityBtn" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>