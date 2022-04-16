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
<%--导入分页插件--%>
<link type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
<script src="jquery/bs_pagination-master/localization/en.js"></script>
<script src="jquery/bs_pagination-master/js//jquery.bs_pagination.min.js"></script>
<%--layer插件--%>
<script type="text/javascript" src="jquery/layer-3.5.1/layer.js"></script>

<script type="text/javascript">

	// 定义一个函数，发送请求不同页码对应的数据
	function refresh(page, pageSize){
		var selectName = $.trim($("#select-name").val());
		var selectOwner = $.trim($("#select-owner").val());
		var selectStartDate = $("#select-startTime").val();
		var selectEndDate = $("#select-endTime").val();
		// 发送查询所有文章列表的异步请求
		$.ajax({
			url:"workbench/activity/queryPagination.do",
			data:{
				page: page,
				pageSize:pageSize,
				name:selectName,
				owner:selectOwner,
				startDate:selectStartDate,
				endDate:selectEndDate
			},
			type:"post",
			dataType:"json",
			success:function (data){
				// 清空原来的内容
				$("#userInfoBody").html("");
				var activities = data.list;
				for (var i = 0; i < activities.length; i++) {
					var body = "";
					var activity = activities[i];
					body += '<tr class="active">';
					body += '<td><input name="check" type="checkbox" value="'+activity.id+'"/></td>';
					body += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detailActivity.do?id='+activity.id+'\'">'+activity.name+'</a></td>';
					body += '<td>'+ activity.owner+ '</td>';
					body += '<td>'+ activity.startDate +'</td>';
					body += '<td>'+ activity.endDate +'</td>';
					body += '</tr>';
					$("#userInfoBody").append(body);
				}

				// 取消全选按钮
				$("#checkAll").prop("checked", false);

				//bootstrap的分页插件
				$("#activityPage").bs_pagination({
					currentPage: data.pageNum, // 页码
					rowsPerPage: data.pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: data.pages, // 总页数
					totalRows: data.total, // 总记录条数
					visiblePageLinks: 4, // 显示几个卡片
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//回调函数，用户每次点击分页插件进行翻页的时候就会触发该函数
					onChangePage: function (event, obj) {
						//currentPage:当前页码 rowsPerPage:每页记录数
						refresh(obj.currentPage, obj.rowsPerPage);
						//refresh(1, $("#userPage").bs_pagination('getOption', 'rowsPerPage'));
					}
				});
			}
		})
	}

	$(function(){

		$(".time").datetimepicker({
			minView: "month", //语言
			language:  'zh-CN', //日期的格式
			format: 'yyyy-mm-dd', //可以选择的最小视图
			initialDate:new Date(),//初始化显示的日期
			autoclose: true, //设置选择完日期或者时间之后，日否自动关闭日历
			todayBtn: true, //设置是否显示"今天"按钮,默认是false
			clearBtn:true, //设置是否显示"清空"按钮，默认是false
			pickerPosition: "bottom-left"
		});

		// 页面加载完毕，查询第一页，每页3条数据
		refresh(1, 3);

		// 为创建按钮绑定单击事件
		$("#createActivityBtn").click(function (){

			// 将当前登录的用户，设置一个默认的选项
			// 在js中写EL表达式，一定要套在字符串里
			var id = "${sessionScope.sessionUser.id}";
			$("#create-marketActivityOwner").val(id);

			// 显示创建市场活动的模态窗口
			$("#createActivityModal").modal("show");
		})

		// 为创建市场活动的模态窗口的保存按钮绑定单击事件
		$("#saveBtn").click(function (){
			var owner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val());
			var startDate =$("#create-startTime").val();
			var endDate = $("#create-endTime").val();
			var cost = $.trim($("#create-cost").val());
			var description = $.trim($("#create-describe").val());

			// 表单验证
			if (owner == ""){
				layer.alert("所有者不能为空", {icon:7});
				return;
			}
			if (name == ""){
				layer.alert("名称不能为空", {icon:7});
				return;
			}
			if (startDate == "" || endDate == ""){
				layer.alert("开始日期或结束日期不能为空", {icon:7});
				return;
			}
			if (startDate > endDate){
				layer.alert("开始日期不能比结束日期大", {icon:7});
				return;
			}

			var nonZero = /^(([1-9]\d*)|0)$/;
			if (!nonZero.test(cost)){
				layer.alert("成本只能为非负整数", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/activty/saveCreateActivity.do",
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						// 重置表单
						$("#createActivityModelForm")[0].reset();
						// 隐藏创建市场活动的模态窗口
						$("#createActivityModal").modal("hide");

						// 刷新市场活动列，显示第一列数据，保持每页显示条数不变
						refresh(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

		// 为查询按钮绑定事件
		$("#selectBtn").click(function (){
			refresh(1, 3);
		});

		// 为全选按钮绑定事件
		$("#checkAll").click(function (){
			// 如果“全选”按钮时选中状态，则列表中所有checkbox都选中
			$("input[name=check]").prop("checked", this.checked);
		})

		/*
		动态生成的元素（不能以普通绑定事件的形式来进行操作），我们要以on方法的形式来触发事件
		语法格式：$(需要绑定事件的外层元素).on("绑定事件的方式", 需要绑定的jquery对象, 回调函数)
		*/
		$("#userInfoBody").on("click", $("input[name=check]"), function ()
		{
			$("#checkAll").prop("checked", $("input[name=check]").length==$("input[name=check]:checked").length);
		})

		// 为删除按钮绑定事件
		$("#deleteActivityBtn").click(function (){
			// 找到复选框所有挑√的复选框的jquery对象
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要删除的记录", {icon:7})
			} else {
				var param = [];
				for(var i = 0; i < $check.length; i++) {
					// 将查询出来的试题id以','分割放入数组中
					param.push($($check[i]).val());
				}
				if (confirm("您确定删除吗？")){
					$.ajax({
						url:"workbench/activity/deleteActivityByIds.do?id="+param,
						type:"post",
						dataType:"json",
						success:function (data){
							if (data.code == "1"){
								layer.alert("删除成功", {icon:6});
								refresh(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							} else {
								layer.alert("系统忙，请稍后重试...", {icon:5});
							}
						}
					})
				}
			}
		});

		// 为修改市场活动创建单击事件
		$("#updateActivityBtn").click(function (){
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要修改的市场活动", {icon:7})
				return;
			}
			if ($check.length > 1){
				layer.alert("每次只能选择一条市场活动", {icon:7})
				return;
			}

			var id = $check[0].value;
			$.ajax({
				url:"workbench/activity/queryActivityById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data){
					$("#edit-id").val(data.id);
					$("#edit-marketActivityOwner").val(data.owner);
					$("#edit-marketActivityName").val(data.name);
					$("#edit-startTime").val(data.startDate);
					$("#edit-endTime").val(data.endDate);
					$("#edit-cost").val(data.cost);
					$("#edit-describe").val(data.description);
				}
			})

			// 显示修改市场的模态窗口
			$("#editActivityModal").modal("show");
		});

		// 为修改模态窗口的更新按钮绑定单击事件
		$("#editActivityBtn").click(function (){
			var id = $("#edit-id").val();
			var owner = $("#edit-marketActivityOwner").val();
			var name = $.trim($("#edit-marketActivityName").val());
			var startDate =$("#edit-startTime").val();
			var endDate = $("#edit-endTime").val();
			var cost = $.trim($("#edit-cost").val());
			var description = $.trim($("#edit-describe").val());

			// 表单验证
			if (owner == ""){
				layer.alert("所有者不能为空", {icon:7});
				return;
			}
			if (name == ""){
				layer.alert("名称不能为空", {icon:7});
				return;
			}
			if (startDate == "" || endDate == ""){
				layer.alert("开始日期或结束日期不能为空", {icon:7});
				return;
			}
			if (startDate > endDate){
				layer.alert("开始日期不能比结束日期大", {icon:7});
				return;
			}

			var nonZero = /^(([1-9]\d*)|0)$/;
			if (!nonZero.test(cost)){
				layer.alert("成本只能为非负整数", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/activity/saveEditActivity.do",
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						// 隐藏修改市场活动的模态窗口
						$("#editActivityModal").modal("hide");
						layer.alert("修改成功", {icon:6});
						// 刷新市场活动列，显示当前列数据，保持每页显示条数不变
						refresh($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

		// 为“批量导出”按钮绑定单击事件
		$("#exportActivityAllBtn").click(function (){
			// 发送同步请求
			window.location.href="workbench/activity/exportAllActivities.do";
		});

        // 为“批选择导出”按钮绑定单击事件
        $("#exportActivityCheckedBtn").click(function (){
            // 找到复选框所有挑√的复选框的jquery对象
            var $check = $("input[name=check]:checked");
            if ($check.length == 0){
                layer.alert("请选择需要导出的市场活动", {icon:7})
            } else {
                var param = [];
                for(var i = 0; i < $check.length; i++)
                {
                    // 将勾选的出来的市场活动id以','分割放入数组中
                    param.push($($check[i]).val());
                }
                // 发送同步请求
                window.location.href="workbench/activity/exportCheckedActivities.do?id="+param;
            }
        });

        // 给“导入”按钮添加单击事件
        $("#importActivityBtn").click(function (){
			// 收集参数
			var activityFileName = $("#activityFile").val();
			var type = activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLowerCase(); // xls,XLS,Xls...
			if (type != "xls"){
				layer.alert("请选择xls文件类型的文件", {icon:7});
				return;
			}

			var activityFile = $("#activityFile")[0].files[0];
			if (activityFile.size > (5*1024*1024)){
				layer.alert("文件大小不能超过5MB", {icon:7});
				return;
			}

			// FormData是ajax提供的接口，可以模拟键值对向后台提交参数
			// ForData最大的优势是不仅可以提交文本数据，还可以提交二进制数据
			var formData = new FormData();
			formData.append("activityFile", activityFile);
			// 发送请求
			$.ajax({
				url:"workbench/activity/importActivity.do",
				data:formData,
				type:"post",
				dataType:"json",
				processData: false, // processData处理数据
				contentType: false, // contentType发送数据的格式
				success:function (data){
					if (data.code == "1"){
						layer.alert(data.message, {icon:6});
						// 关闭模态窗口
						$("#importActivityModal").modal("hide");
						refresh(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
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

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityModelForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityForm" class="form-horizontal" role="form">
						<input id="edit-id" type="hidden">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="editActivityBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="select-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="select-owner" class="form-control" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="select-startTime" readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="select-endTime" readonly>
				    </div>
				  </div>
				  
				  <button id="selectBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createActivityBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="updateActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteActivityBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityCheckedBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="userInfoBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
				<footer class="message_footer">
					<nav>
						<%--分页插件--%>
						<div  style="height: 50px; position: relative;top: 30px;">
							<div id="activityPage"></div>
						</div>
					</nav>
				</footer>
			</div>
		</div>
		
	</div>
</body>
</html>