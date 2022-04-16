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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="jquery/layer-3.5.1/layer.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">
	$(function (){
		$(".time1").datetimepicker({
			minView: "month", //语言
			language:  'zh-CN', //日期的格式
			format: 'yyyy-mm-dd', //可以选择的最小视图
			initialDate:new Date(),//初始化显示的日期
			autoclose: true, //设置选择完日期或者时间之后，日否自动关闭日历
			todayBtn: true, //设置是否显示"今天"按钮,默认是false
			clearBtn:true, //设置是否显示"清空"按钮，默认是false
			pickerPosition: "bottom-left"
		});

		$(".time2").datetimepicker({
			minView: "month", //语言
			language:  'zh-CN', //日期的格式
			format: 'yyyy-mm-dd', //可以选择的最小视图
			initialDate:new Date(),//初始化显示的日期
			autoclose: true, //设置选择完日期或者时间之后，日否自动关闭日历
			todayBtn: true, //设置是否显示"今天"按钮,默认是false
			clearBtn:true, //设置是否显示"清空"按钮，默认是false
			pickerPosition: "top-right"
		});

		// 自动补全函数
		$("#create-customerName").typeahead({
			source:function (jquery,process) {//每次键盘弹起，都自动触发本函数；我们可以向后台送请求，查询客户表中所有的名称，把客户名称以[]字符串形式返回前台，赋值给source
				//process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
				//jquery：在容器中输入的关键字
				//var customerName=$("#customerName").val();
				//发送查询请求
				$.ajax({
					url:'workbench/transaction/queryCustomerNameByName.do',
					data:{
						customerName:jquery
					},
					type:"post",
					dataType:"json",
					success:function (data) {//['xxx','xxxxx','xxxxxx',.....]
						process(data);
					}
				});
			}
		});

		// 为“创建市场活动源”添加单击事件
		$("#createSource").click(function (){
			//清空搜索框
			$("#searchActivityTxt").val("");
			//清空搜索的市场活动列表
			$("#tBody").html("");
			// 显示“查找市场活动”的模态窗口
			$("#findMarketActivity").modal("show");
		});

		//  给市场活动搜索框添加键盘弹起事件
		$("#searchActivityTxt").keyup(function (){
			// 收集参数
			var activityName = this.value;

			$.ajax({
				url:"workbench/transaction/queryActivityForDetailByName.do",
				data:{
					activityName:activityName
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
					$("#activityBody").html(htmlStr);
				}
			})
		});

		// 给所有市场活动的单选按钮添加单击事件
		$("#activityBody").on("click", "input[type='radio']", function (){
			// 获取市场活动的id和name
			var id = this.value;
			var activityName = $(this).attr("activityName");

			// 填充数据
			$("#create-activityId").val(id);
			$("#create-activitySrc").val(activityName);
			// 关闭模态窗口
			$("#findMarketActivity").modal("hide");
		});

		// 为“创建联系人”添加单击事件
		$("#findContactsBtn").click(function (){
			//清空搜索框
			$("#searchContactsTxt").val("");
			//清空搜索的市场活动列表
			$("#contactsBody").html("");
			// 显示“查找市场活动”的模态窗口
			$("#findContactsModal").modal("show");
		});

		//  给联系人搜索框添加键盘弹起事件
		$("#searchContactsTxt").keyup(function (){
			// 收集参数
			var contactsName = this.value;

			$.ajax({
				url:"workbench/transaction/queryContactsByName.do",
				data:{
					contactsName:contactsName
				},
				type:"post",
				dataType:"json",
				success:function (data){
					var htmlStr = "";
					$.each(data, function (index, obj){
						htmlStr += '<tr>';
						htmlStr += '<td><input value="'+obj.id+'" type="radio" contactsName='+obj.fullname+' name="contacts"/></td>';
						htmlStr += '<td>'+obj.fullname+'</td>';
						htmlStr += '<td>'+obj.email+'</td>';
						htmlStr += '<td>'+obj.mphone+'</td>';
						htmlStr += '</tr>';
					})
					$("#contactsBody").html(htmlStr);
				}
			})
		});

		// 给所有联系人的单选按钮添加单击事件
		$("#contactsBody").on("click", "input[type='radio']", function (){
			// 获取市场活动的id和name
			var id = this.value;
			var contactsName = $(this).attr("contactsName");

			// 填充数据
			$("#create-contactsId").val(id);
			$("#create-contactsName").val(contactsName);
			// 关闭模态窗口
			$("#findContactsModal").modal("hide");
		});

		// 为“阶段选择框”添加改变事件
		$("#create-stage").change(function (){
			var stageValue = $("#create-stage option:selected").text();
			$.ajax({
				url:"workbench/transaction/getPossibilityByStage.do",
				data:{
					stageValue:stageValue
				},
				type:"post",
				dataType:"json",
				success:function (data){
					$("#create-possibility").val(data+"%");
				}
			})
		});

		// 为“保存”按钮添加单击事件
		$("#saveTranBtn").click(function (){
			var owner = $("#create-owner").val();
			var money = $.trim($("#create-money").val());
			var name = $.trim($("#create-name").val());
			var expectedDate = $("#create-expectedDate").val();
			var stage = $("#create-stage").val();
			var type = $("#create-type").val();
			var source = $("#create-source").val();
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var activityId = $("#create-activityId").val();
			var contactsId = $("#create-contactsId").val();
			var customerName = $.trim($("#create-customerName").val());

			// 表单验证
			var nonZero = /^(([1-9]\d*)|0)$/;
			if (!nonZero.test(money)){
				layer.alert("金额只能为非负整数", {icon:7});
				return;
			}

			if (name == ""){
				layer.alert("交易名称不能为空", {icon:7});
				return;
			}

			if (expectedDate == ""){
				layer.alert("预计成交日期不能为空", {icon:7});
				return;
			}

			if (customerName == ""){
				layer.alert("客户名称不能为空", {icon:7});
				return;
			}
			if (activityId == ""){
				layer.alert("市场活动不能为空", {icon:7});
				return;
			}
			if (contactsId == ""){
				layer.alert("联系人名称不能为空", {icon:7});
				return;
			}
			if (nextContactTime == ""){
				layer.alert("下次联系时间不能为空", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/transaction/saveCreateTran.do",
				data:{
					owner:owner,
					money:money,
					name:name,
					expectedDate:expectedDate,
					customerName:customerName,
					stage:stage,
					type:type,
					source:source,
					activityId:activityId,
					contactsId:contactsId,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						window.location.href="workbench/transaction/index.do";
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

	})
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
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
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityBody">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchContactsTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsBody">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveTranBtn" type="button" class="btn btn-primary">保存</button>
			<button onclick="window.history.back()" type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">
					<c:forEach items="${userList}" var="user">
						<c:if test="${sessionScope.sessionUser.id == user.id}">
							<option value="${user.id}" selected>${user.name}</option>
						</c:if>
						<c:if test="${sessionScope.sessionUser.id != user.id}">
							<option value="${user.id}">${user.name}</option>
						</c:if>
					</c:forEach>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="create-expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
				  <c:forEach items="${stageList}" var="stage">
					  <option value="${stage.id}">${stage.value}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-type" class="col-sm-2 control-label">类型<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-type">
					<c:forEach items="${typeList}" var="type">
						<option id="${type.id}">${type.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" value="10%" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-source" class="col-sm-2 control-label">来源<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source">
					<c:forEach items="${sourceList}" var="source">
						<option id="${source.id}">${source.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源<span style="font-size: 15px; color: red;">*</span>&nbsp;&nbsp;<a id="createSource" href="javascript:void(0);" data-toggle="modal"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input id="create-activityId" type="hidden">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称<span style="font-size: 15px; color: red;">*</span>&nbsp;&nbsp;<a id="findContactsBtn" href="javascript:void(0);" data-toggle="modal"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input id="create-contactsId" type="hidden">
				<input type="text" class="form-control" id="create-contactsName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="create-nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>