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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<link type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
<script src="jquery/bs_pagination-master/localization/en.js"></script>
<script src="jquery/bs_pagination-master/js//jquery.bs_pagination.min.js"></script>

<script type="text/javascript" src="jquery/layer-3.5.1/layer.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">
	// 定义一个函数，发送请求不同页码对应的数据
	function refresh(page, pageSize){
		var selectOwner = $.trim($("#select-owner").val());
		var selectFullName = $.trim($("#select-fullName").val());
		var selectContactsName = $.trim($("#select-contactsName").val());
		var selectSource = $("#select-source").val();

		// 发送查询所有联系人列表的异步请求
		$.ajax({
			url:"workbench/contacts/queryPagination.do",
			data:{
				page: page,
				pageSize:pageSize,
				fullname:selectFullName,
				owner:selectOwner,
				customerId:selectContactsName,
				source:selectSource
			},
			type:"post",
			dataType:"json",
			success:function (data){
				// 清空原来的内容
				$("#contactsBody").html("");
				var contacts = data.list;
				for (var i = 0; i < contacts.length; i++) {
					var body = "";
					var c = contacts[i];
					body += '<tr>';
					body += '<td><input name="check" type="checkbox" value="'+c.id+'"/></td>';
					body += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detailContacts.do?id='+c.id+'\'"">'+c.fullname+'</a></td>';
					body += '<td>'+c.customerId+'</td>';
					body += '<td>'+c.owner+'</td>';
					body += '<td>'+c.source+'</td>';
					body += '</tr>';
					$("#contactsBody").append(body);
				}

				// 取消全选按钮
				$("#checkAll").prop("checked", false);

				//bootstrap的分页插件
				$("#contactsPage").bs_pagination({
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
		$("#edit-customerName").typeahead({
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

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		refresh(1, 3);

		// 为“查询”按钮绑定单击事件
		$("#queryBtn").click(function (){
			refresh(1, 3);
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
		$("#contactsBody").on("click", $("input[name=check]"), function ()
		{
			$("#checkAll").prop("checked", $("input[name=check]").length==$("input[name=check]:checked").length);
		});

		// 为“创建”按钮绑定单击事件
		$("#createContactsBtn").click(function (){
			// 显示创建联系人的模态窗口
			$("#createContactsModal").modal("show");
		});

		// 为“保存”按钮绑定单击事件
		$("#saveContactsBtn").click(function (){
			// 收集参数
			var owner = $("#create-owner").val();
			var source = $("#create-source").val();
			var fullname = $.trim($("#create-fullname").val());
			var appellation = $("#create-appellation").val();
			var email = $.trim($("#create-email").val());
			var job = $.trim($("#create-job").val());
			var mphone = $.trim($("#create-mphone").val());
			var customerName = $.trim($("#create-customerName").val());
			var description = $.trim($("#create-describe").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime =$("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());

			// 表单验证
			if (fullname == ""){
				layer.alert("名字不能为空", {icon:7});
				return;
			}

			var mphoneTrue = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if (!mphoneTrue.test(mphone)){
				layer.alert("手机号格式有误", {icon:7});
				return;
			}

			var emailTrue = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!emailTrue.test(email)){
				layer.alert("邮箱格式有误", {icon:7});
				return;
			}

			if (customerName == ""){
				layer.alert("客户名称不能为空", {icon:7});
				return;
			}

			if (nextContactTime == ""){
				layer.alert("下次联系时间不能为空", {icon:7});
				return;
			}
			if (address == ""){
				layer.alert("详细地址不能为空", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/contacts/saveCreateContacts.do",
				data:{
					owner:owner,
					source:source,
					fullname:fullname,
					appellation:appellation,
					email:email,
					job:job,
					mphone:mphone,
					customerId:customerName,
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
						$("#createContactsForm")[0].reset();
						// 关闭“创建”联系人的模态窗口
						$("#createContactsModal").modal("hide");
						// 刷新联系人列，显示第一列数据，保持每页显示条数不变
						refresh(1, $("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

		// 为“修改"按钮绑定单击事件”
		$("#editContactsBtn").click(function (){
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要修改的联系人", {icon:7})
				return;
			}
			if ($check.length > 1){
				layer.alert("每次只能选择一个联系人", {icon:7})
				return;
			}

			var id = $check[0].value;
			$.ajax({
				url:"workbench/contacts/queryContactsById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data){
					$("#edit-id").val(data.id);
					$("#edit-source").val(data.source);
					$("#edit-fullname").val(data.fullname);
					$("#edit-email").val(data.email);
					$("#edit-job").val(data.job);
					$("#edit-customerName").val(data.customerId);
					$("#edit-mphone").val(data.mphone);
					$("#edit-appellation").val(data.appellation);
					$("#edit-describe").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-address").val(data.address);

				}
			})

			// 展现修改客户的模态窗口
			$("#editContactsModal").modal("show");
		})

		// 为“更新”按钮绑定单击事件
		$("#editContacts").click(function (){
			// 收集参数
			var id = $("#edit-id").val();
			var owner = $("#edit-owner").val();
			var source = $("#edit-source").val();
			var fullname = $.trim($("#edit-fullname").val());
			var appellation = $("#edit-appellation").val();
			var email = $.trim($("#edit-email").val());
			var job = $.trim($("#edit-job").val());
			var mphone = $.trim($("#edit-mphone").val());
			var customerName = $.trim($("#edit-customerName").val());
			var description = $.trim($("#edit-describe").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime =$("#edit-nextContactTime").val();
			var address = $.trim($("#edit-address").val());

			// 表单验证
			if (fullname == ""){
				layer.alert("名字不能为空", {icon:7});
				return;
			}

			var mphoneTrue = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if (!mphoneTrue.test(mphone)){
				layer.alert("手机号格式有误", {icon:7});
				return;
			}

			var emailTrue = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!emailTrue.test(email)){
				layer.alert("邮箱格式有误", {icon:7});
				return;
			}

			if (customerName == ""){
				layer.alert("客户名称不能为空", {icon:7});
				return;
			}

			if (nextContactTime == ""){
				layer.alert("下次联系时间不能为空", {icon:7});
				return;
			}
			if (address == ""){
				layer.alert("详细地址不能为空", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/contacts/editContacts.do",
				data:{
					id:id,
					owner:owner,
					source:source,
					fullname:fullname,
					appellation:appellation,
					email:email,
					job:job,
					mphone:mphone,
					customerId:customerName,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						// 关闭“修改”联系人的模态窗口
						$("#editContactsModal").modal("hide");
						// 刷新联系人列，显示当前列数据，保持每页显示条数不变
						refresh($("#contactsPage").bs_pagination('getOption', 'currentPage')
								,$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

		// 为“删除”按钮绑定单击事件
		$("#deleteContactsBtn").click(function (){
			// 找到复选框所有挑√的复选框的jquery对象
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要删除的联系人", {icon:7})
			} else {
				var param = [];
				for(var i = 0; i < $check.length; i++) {
					// 将查询出来的试题id以','分割放入数组中
					param.push($($check[i]).val());
				}
				if (confirm("您确定删除吗？")){
					$.ajax({
						url:"workbench/contacts/deleteContactsByIds.do?id="+param,
						type:"post",
						dataType:"json",
						success:function (data){
							if (data.code == "1"){
								layer.alert("删除成功", {icon:6});
								refresh(1, $("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
							} else {
								layer.alert("系统忙，请稍后重试...", {icon:5});
							}
						}
					})
				}
			}
		});
	});
	
</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form id="createContactsForm" class="form-horizontal" role="form">
					
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
							<label for="create-source" class="col-sm-2 control-label">来源<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<c:forEach items="${requestScope.sourceList}" var="source">
										<option id="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									  <c:forEach items="${requestScope.appellationList}" var="appellation">
										  <option id="${appellation.id}">${appellation.value}</option>
									  </c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>

						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
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
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间<span style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址<span style="font-size: 15px; color: red;">*</span></label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveContactsBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<input id="edit-id" type="hidden">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
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
							<label for="edit-source" class="col-sm-2 control-label">来源<span style="font-size: 15px; color: red;">*</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<c:forEach items="${requestScope.sourceList}" var="source">
										<option id="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼<span style="font-size: 15px; color: red;">*</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<c:forEach items="${requestScope.appellationList}" var="appellation">
										<option id="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机<span style="font-size: 15px; color: red;">*</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱<span style="font-size: 15px; color: red;">*</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
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
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间<span style="font-size: 15px; color: red;">*</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址<span style="font-size: 15px; color: red;">*</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="editContacts" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
						<input id="select-fullName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
						<input id="select-contactsName" class="form-control" type="text">
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
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="select-source">
						  <option></option>
						  <c:forEach items="${requestScope.sourceList}" var="source">
							  <option id="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				 <%-- <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input id="search-" class="form-control time1" type="text" readonly>
				    </div>
				  </div>--%>
				  
				  <button id="queryBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createContactsBtn" type="button" class="btn btn-primary" data-toggle="modal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editContactsBtn" type="button" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteContactsBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<%--<td>生日</td>--%>
						</tr>
					</thead>
					<tbody id="contactsBody">

					</tbody>
				</table>

				<footer class="message_footer">
					<nav>
						<%--分页插件--%>
						<div  style="height: 50px; position: relative;top: 30px;">
							<div id="contactsPage"></div>
						</div>
					</nav>
				</footer>
			</div>
		</div>
		
	</div>
</body>
</html>