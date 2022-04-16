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


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="jquery/layer-3.5.1/layer.js"></script>
<script type="text/javascript">
	$(function(){
		$(".time").datetimepicker({
			minView: "month", //语言
			language:  'zh-CN', //日期的格式
			format: 'yyyy-mm-dd', //可以选择的最小视图
			initialDate:new Date(),//初始化显示的日期
			autoclose: true, //设置选择完日期或者时间之后，日否自动关闭日历
			todayBtn: true, //设置是否显示"今天"按钮,默认是false
			clearBtn:true, //设置是否显示"清空"按钮，默认是false
			pickerPosition: "top-right"
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		// 为“搜索”图标添加单击事件
		$("#searchActivity").click(function (){
			// 展示搜索市场活动的模态窗口
			$("#searchActivityModal").modal("show");
		});

		// 为搜索框添加键盘弹起事件
		$("#activityNameTxt").keyup(function (){
			var activityName = this.value;
			$.ajax({
				url:"workbench/clue/queryActivityConvertByNameClueId.do",
				data:{
					activityName:activityName,
					clueId:"${requestScope.clue.id}"
				},
				type:"post",
				dataType:"json",
				success:function (data){
					var htmlStr = "";
					$.each(data, function (index, obj){
						htmlStr += '<tr>';
						htmlStr += '<td><input value="'+obj.id+'" type="radio" activityName='+obj.name+' name="activity"/></td>';
						htmlStr += '<td>'+obj.name+'</td>';
						htmlStr += '<td>'+obj.startDate+'</td>';
						htmlStr += '<td>'+obj.endDate+'</td>';
						htmlStr += '<td>'+obj.owner+'</td>';
						htmlStr += '</tr>';
					})
					$("#tBody").html(htmlStr);
				}
			})
		});

		// 给所有市场活动的单选按钮添加单击事件
		$("#tBody").on("click", "input[type='radio']", function (){
			// 获取市场活动的id和name
			var id = this.value;
			var activityName = $(this).attr("activityName");

			// 填充数据
			$("#activityId").val(id);
			$("#activity").val(activityName);
			// 关闭模态窗口
			$("#searchActivityModal").modal("hide");
		});

		// 为“转换”按钮绑定单击事件
		$("#convertClueBtn").click(function (){
			var clueId = "${requestScope.clue.id}";
			var money = $.trim($("#amountOfMoney").val());
			var name = $.trim($("#tradeName").val());
			var expectedDate = $.trim($("#expectedClosingDate").val());
			var stage = $.trim($("#stage").val());
			var activityId = $("#activityId").val();
			var isCreateTran = $("#isCreateTransaction").prop("checked");
			// 表单验证
			if (money < 0){
				layer.alert("交易金额不能小于0", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/clue/convertClue.do",
				data:{
					clueId:clueId,
					money:money,
					name,name,
					expectedDate:expectedDate,
					stage:stage,
					activityId:activityId,
					isCreateTran:isCreateTran
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						// 跳转到线索主页面
						window.location.href="workbench/clue/index.do";
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="activityNameTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
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
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${requestScope.clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${requestScope.clue.fullname}${requestScope.clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${requestScope.clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<c:forEach items="${requestScope.stageList}" var="stage">
					<option id="${stage.id}">${stage.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a id="searchActivity" href="javascript:void(0);" data-toggle="modal" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		  	<input id="activityId" type="hidden">
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${requestScope.clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="convertClueBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input onclick="window.history.back()" class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>