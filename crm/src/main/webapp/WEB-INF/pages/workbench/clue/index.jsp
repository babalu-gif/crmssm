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
		var selectName = $.trim($("#select-fullname-appellation").val());
		var selectCompany = $.trim($("#select-company").val());
		var selectPhone = $.trim($("#select-phone").val());
		var selectSource = $("#select-source").val();
		var selectOwner = $.trim($("#select-owner").val());
		var selectMphone = $.trim($("#select-mphone").val());
		var selectState = $("#select-clueState").val();
		// 发送查询所有文章列表的异步请求
		$.ajax({
			url:"workbench/clue/Pagination.do",
			data:{
				page: page,
				pageSize:pageSize,
				fullname:selectName,
				owner:selectOwner,
				company:selectCompany,
				phone:selectPhone,
				source:selectSource,
				mphone:selectMphone,
				state:selectState
			},
			type:"post",
			dataType:"json",
			success:function (data){
				// 清空原来的内容
				$("#clueInfoBody").html("");
				var clues = data.list;
				for (var i = 0; i < clues.length; i++) {
					var body = "";
					var clue = clues[i];
					body += '<tr>';
					body += '<td><input name="check" type="checkbox" value="'+clue.id+'"/></td>';
					body += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detailClue.do?id='+clue.id+'\'">'+clue.fullname+clue.appellation+'</a></td>';
					body += '<td>'+clue.company+'</td>';
					body += '<td>'+clue.phone+'</td>';
					body += '<td>'+clue.mphone+'</td>';
					body += '<td>'+clue.source+'</td>';
					body += '<td>'+clue.owner+'</td>';
					body += '<td>'+clue.state+'</td>';
					body += '</tr>';
					$("#clueInfoBody").append(body);
				}

				// 取消全选按钮
				$("#checkAll").prop("checked", false);

				//bootstrap的分页插件
				$("#cluePage").bs_pagination({
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
			pickerPosition: "top-right"
		});

		refresh(1, 3);

		// 为查询按钮绑定事件
		$("#selectClueBtn").click(function (){
			refresh(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
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
		$("#clueInfoBody").on("click", $("input[name=check]"), function ()
		{
			$("#checkAll").prop("checked", $("input[name=check]").length==$("input[name=check]:checked").length);
		})

		// 为“创建”线索按钮绑定单击事件
		$("#saveCreateClueBtn").click(function (){
			// 显示创建“线索”的模态窗口”
			$("#createClueModal").modal("show");
		});

		// 为“保存按钮绑定单击事件”
		$("#saveClueBtn").click(function (){
			var owner = $("#create-clueOwner").val();
			var company = $.trim($("#create-company").val());
			var appellation = $("#create-call").val();
			var fullname = $.trim($("#create-surname").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val());
			var website = $.trim($("#create-website").val());
			var mphone = $.trim($("#create-mphone").val());
			var state = $("#create-status").val();
			var source = $("#create-source").val();
			var description = $.trim($("#create-describe").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());

			// 表单验证
			if (company == ""){
				layer.alert("公司不能为空", {icon:7});
				return;
			}
			if (fullname == ""){
				layer.alert("姓名不能为空", {icon:7});
				return;
			}
			if (phone == ""){
				layer.alert("公司座机不能为空", {icon:7});
				return;
			}
			if (website == ""){
				layer.alert("公司网站不能为空", {icon:7});
				return;
			}
			/*var phoneTrue = /^(\(\d{3,4}-)|\d{3.4}-)?\d{7,8}$/;
            if (!phoneTrue.test(phone)){
                layer.alert("公司座机格式错误，格式为：XXX-XXXXXXX、XXXX-XXXXXXXX、XXX-XXXXXXX、XXX-XXXXXXXX、XXXXXXX和XXXXXXXX, {icon:7});
                return;
            }*/

			if (mphone == ""){
				layer.alert("手机号不能为空", {icon:7});
				return;
			}
			var mphoneTrue = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if (!mphoneTrue.test(mphone)){
				layer.alert("手机号格式有误", {icon:7});
				return;
			}

			if (source == ""){
				layer.alert("线索来源不能为空", {icon:7});
				return;
			}
			if (state == ""){
				layer.alert("线索状态不能为空", {icon:7});
				return;
			}
			if (address == ""){
				layer.alert("地址不能为空", {icon:7});
				return;
			}

			if (email == ""){
				layer.alert("邮箱不能为空", {icon:7});
				return;
			}

			var emailTrue = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!emailTrue.test(email)){
				layer.alert("邮箱格式有误", {icon:7});
				return;
			}

			if (nextContactTime == ""){
				layer.alert("下次联系时间不能为空", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/clue/saveCreateClue.do",
				data:{
					owner:owner,
					company:company,
					appellation:appellation,
					fullname:fullname,
					job:job,
					email:email,
					phone:phone,
					website:website,
					mphone:mphone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						// 重置表单
						$("#createClueForm")[0].reset();
						// 关闭“创建”线索的模态窗口
						$("#createClueModal").modal("hide");
						// 刷新线索列，显示第一列数据，保持每页显示条数不变
						refresh(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

		// 为“删除”按钮绑定单击事件
		$("#deleteClueBtn").click(function (){
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
						url:"workbench/clue/deleteClueByIds.do?id="+param,
						type:"post",
						dataType:"json",
						success:function (data){
							if (data.code == "1"){
								layer.alert("删除成功", {icon:6});
								refresh(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
							} else {
								layer.alert("系统忙，请稍后重试...", {icon:5});
							}
						}
					})
				}
			}
		});


		// 为“修改”按钮绑定单击事件
		$("#editClueBtn").click(function (){
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要修改的线索", {icon:7})
				return;
			}
			if ($check.length > 1){
				layer.alert("每次只能选择一条线索", {icon:7})
				return;
			}

			var id = $check[0].value;
			$.ajax({
				url:"workbench/clue/queryClueById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data){
					$("#edit-id").val(data.id);
					$("#edit-clueOwner").val(data.owner);
					$("#edit-company").val(data.company);
					$("#edit-call").val(data.appellation);
					$("#edit-surname").val(data.fullname);
					$("#edit-job").val(data.job);
					$("#edit-email").val(data.email);
					$("#edit-phone").val(data.phone);
					$("#edit-website").val(data.website);
					$("#edit-mphone").val(data.mphone);
					$("#edit-status").val(data.state);
					$("#edit-source").val(data.source);
					$("#edit-describe").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-address").val(data.address);
				}
			})

			// 显示“修改”线索的模态窗口
			$("#editClueModal").modal("show");
		})

		// 为“修改”按钮绑定单击事件
		$("#updateClueBtn").click(function (){
			var id = $("#edit-id").val();
			var owner = $("#edit-clueOwner").val();
			var company = $.trim($("#edit-company").val());
			var appellation = $("#edit-call").val();
			var fullname = $.trim($("#edit-surname").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($("#edit-website").val());
			var mphone = $.trim($("#edit-mphone").val());
			var state = $("#edit-status").val();
			var source = $("#edit-source").val();
			var description = $.trim($("#edit-describe").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $.trim($("#edit-address").val());

			// 表单验证
			if (company == ""){
				layer.alert("公司不能为空", {icon:7});
				return;
			}
			if (fullname == ""){
				layer.alert("姓名不能为空", {icon:7});
				return;
			}
			if (phone == ""){
				layer.alert("公司座机不能为空", {icon:7});
				return;
			}
			if (website == ""){
				layer.alert("公司网站不能为空", {icon:7});
				return;
			}
			/*var phoneTrue = /^(\(\d{3,4}-)|\d{3.4}-)?\d{7,8}$/;
            if (!phoneTrue.test(phone)){
                layer.alert("公司座机格式错误，格式为：XXX-XXXXXXX、XXXX-XXXXXXXX、XXX-XXXXXXX、XXX-XXXXXXXX、XXXXXXX和XXXXXXXX, {icon:7});
                return;
            }*/

			if (mphone == ""){
				layer.alert("手机号不能为空", {icon:7});
				return;
			}
			var mphoneTrue = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if (!mphoneTrue.test(mphone)){
				layer.alert("手机号格式有误", {icon:7});
				return;
			}

			if (source == ""){
				layer.alert("线索来源不能为空", {icon:7});
				return;
			}
			if (state == ""){
				layer.alert("线索状态不能为空", {icon:7});
				return;
			}
			if (address == ""){
				layer.alert("地址不能为空", {icon:7});
				return;
			}

			if (email == ""){
				layer.alert("邮箱不能为空", {icon:7});
				return;
			}

			var emailTrue = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!emailTrue.test(email)){
				layer.alert("邮箱格式有误", {icon:7});
				return;
			}

			if (nextContactTime == ""){
				layer.alert("下次联系时间不能为空", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/clue/saveEditClue.do",
				data:{
					id:id,
					owner:owner,
					company:company,
					appellation:appellation,
					fullname:fullname,
					job:job,
					email:email,
					phone:phone,
					website:website,
					mphone:mphone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						// 隐藏修改市场活动的模态窗口
						$("#editClueModal").modal("hide");
						// 刷新市场活动列，显示当前列数据，保持每页显示条数不变
						refresh($("#cluePage").bs_pagination('getOption', 'currentPage')
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
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

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
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
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
									<c:forEach items="${appellationList}" var="appellation">
										<option id="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
									<c:forEach items="${clueStateList}" var="clueState">
										<option id="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<c:forEach items="${sourceList}" var="source">
										<option id="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveClueBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input id="edit-id" type="hidden">
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
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
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
									<c:forEach items="${appellationList}" var="appellation">
										<option id="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<c:forEach items="${clueStateList}" var="clueState">
										<option id="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<c:forEach items="${sourceList}" var="source">
										<option id="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" value="2017-05-01" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateClueBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input id="select-fullname-appellation" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="select-company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="select-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="select-source" class="form-control">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option id="${source.id}">${source.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="select-owner" class="form-control" type="text">
				    </div>
				  </div>
				  

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="select-mphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="select-clueState" class="form-control">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="clueState">
							  <option id="${clueState.id}">${clueState.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button id="selectClueBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="saveCreateClueBtn" type="button" class="btn btn-primary" data-toggle="modal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editClueBtn" type="button" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteClueBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueInfoBody">

					</tbody>
				</table>
				<footer class="message_footer">
					<nav>
						<%--分页插件--%>
						<div  style="height: 50px; position: relative;top: 30px;">
							<div id="cluePage"></div>
						</div>
					</nav>
				</footer>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 60px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>