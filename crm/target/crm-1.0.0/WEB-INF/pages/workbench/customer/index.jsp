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

<link type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
<script src="jquery/bs_pagination-master/localization/en.js"></script>
<script src="jquery/bs_pagination-master/js//jquery.bs_pagination.min.js"></script>

<script type="text/javascript" src="jquery/layer-3.5.1/layer.js"></script>
<script type="text/javascript">
	// 定义一个函数，发送请求不同页码对应的数据
	function refresh(page, pageSize){
		var selectName = $.trim($("#select-name").val());
		var selectWebsite = $.trim($("#select-website").val());
		var selectPhone = $.trim($("#select-phone").val());
		var selectOwner = $.trim($("#select-owner").val());

		// 发送查询客户列表的异步请求
		$.ajax({
			url:"workbench/customer/Pagination.do",
			data:{
				page: page,
				pageSize:pageSize,
				name:selectName,
				owner:selectOwner,
				website:selectWebsite,
				phone:selectPhone
			},
			type:"post",
			dataType:"json",
			success:function (data){
				// 清空原来的内容
				$("#customerInfoBody").html("");
				var customers = data.list;
				for (var i = 0; i < customers.length; i++) {
					var body = "";
					var customer = customers[i];
					body += '<tr>';
					body += '<td><input name="check" type="checkbox" value="'+customer.id+'"/></td>';
					body += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detailCustomer.do?id='+customer.id+'\'">'+customer.name+'</a></td>';
					body += '<td>'+customer.owner+'</td>';
					body += '<td>'+customer.phone+'</td>';
					body += '<td>'+customer.website+'</td>';
					body += '</tr>';
					$("#customerInfoBody").append(body);
				}

				// 取消全选按钮
				$("#checkAll").prop("checked", false);

				//bootstrap的分页插件
				$("#customerPage").bs_pagination({
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

		// 为“创建”按钮绑定单击事件
		$("#saveCreateCustomerBtn").click(function () {
			$("#createCustomerModal").modal("show");
		});

		// 为“保存”按钮绑定单击事件
		$("#saveCreateCustomer").click(function (){
			// 收集参数
			var owner = $("#create-customerOwner").val();
			var name = $.trim($("#create-customerName").val());
			var website = $.trim($("#create-website").val());
			var phone = $.trim($("#create-phone").val());
			var description = $.trim($("#create-describe").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime =$("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());

			// 表单验证
			if (name == ""){
				layer.alert("名字不能为空", {icon:7});
				return;
			}
			if (website == ""){
				layer.alert("公司网站不能为空", {icon:7});
				return;
			}
			if (phone == ""){
				layer.alert("公司座机不能为空", {icon:7});
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
				url:"workbench/customer/saveCreateCustomer.do",
				data:{
					owner:owner,
					name:name,
					phone:phone,
					website:website,
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
						$("#createCustomerForm")[0].reset();
						// 关闭“创建”客户的模态窗口
						$("#createCustomerModal").modal("hide");
						// 刷新客户列，显示第一列数据，保持每页显示条数不变
						refresh(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
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
		})

		/*
		动态生成的元素（不能以普通绑定事件的形式来进行操作），我们要以on方法的形式来触发事件
		语法格式：$(需要绑定事件的外层元素).on("绑定事件的方式", 需要绑定的jquery对象, 回调函数)
		*/
		$("#customerInfoBody").on("click", $("input[name=check]"), function ()
		{
			$("#checkAll").prop("checked", $("input[name=check]").length==$("input[name=check]:checked").length);
		})

		// 为“修改"按钮绑定单击事件”
		$("#editCustomer").click(function (){
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要修改的客户", {icon:7})
				return;
			}
			if ($check.length > 1){
				layer.alert("每次只能选择一个客户", {icon:7})
				return;
			}

			var id = $check[0].value;
			$.ajax({
				url:"workbench/customer/queryCustomerById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data){
					$("#edit-id").val(data.id);
					$("#edit-customerOwner").val(data.owner);
					$("#edit-customerName").val(data.name);
					$("#edit-phone").val(data.phone);
					$("#edit-website").val(data.website);
					$("#edit-describe").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-address").val(data.address);
				}
			})

			// 展现修改客户的模态窗口
			$("#editCustomerModal").modal("show");
		})

		// 为“更新”按钮绑定单击事件
		$("#editCustomerBtn").click(function (){
			// 收集参数
			var id = $("#edit-id").val();
			var owner = $("#edit-customerOwner").val();
			var name = $.trim($("#edit-customerName").val());
			var website = $.trim($("#edit-website").val());
			var phone = $.trim($("#edit-phone").val());
			var description = $.trim($("#edit-describe").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime =$("#edit-nextContactTime").val();
			var address = $.trim($("#edit-address").val());

			// 表单验证
			if (name == ""){
				layer.alert("名字不能为空", {icon:7});
				return;
			}
			if (website == ""){
				layer.alert("公司网站不能为空", {icon:7});
				return;
			}
			if (phone == ""){
				layer.alert("公司座机不能为空", {icon:7});
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
				url:"workbench/customer/editCreateCustomer.do",
				data:{
					id:id,
					owner:owner,
					name:name,
					phone:phone,
					website:website,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						// 关闭“修改”客户的模态窗口
						$("#editCustomerModal").modal("hide");
						// 刷新客户列，显示当前列数据，保持每页显示条数不变
						refresh($("#customerPage").bs_pagination('getOption', 'currentPage')
								,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
						layer.alert("修改成功", {icon:6});
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

		// 为“删除”按钮绑定单击事件
		$("#deleteCustomerBtn").click(function (){
			// 找到复选框所有挑√的复选框的jquery对象
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要删除的客户", {icon:7})
			} else {
				var param = [];
				for(var i = 0; i < $check.length; i++) {
					// 将查询出来的试题id以','分割放入数组中
					param.push($($check[i]).val());
				}
				if (confirm("您确定删除吗？")){
					$.ajax({
						url:"workbench/customer/deleteCustomerByIds.do?id="+param,
						type:"post",
						dataType:"json",
						success:function (data){
							if (data.code == "1"){
								layer.alert("删除成功", {icon:6});
								refresh(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
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

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form id="createCustomerForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
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
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
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
					<button id="saveCreateCustomer" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<input id="edit-id" type="hidden">
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
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
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
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
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间<span style="font-size: 15px; color: red;">*</span></label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址<span style="font-size: 15px; color: red;">*</span></label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="editCustomerBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>

	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
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
				      <div class="input-group-addon">公司座机</div>
				      <input id="select-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input id="select-website" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="queryBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="saveCreateCustomerBtn" type="button" class="btn btn-primary" data-toggle="modal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editCustomer" type="button" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteCustomerBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerInfoBody">

					</tbody>
				</table>
				<footer class="message_footer">
					<nav>
						<%--分页插件--%>
						<div  style="height: 50px; position: relative;top: 30px;">
							<div id="customerPage"></div>
						</div>
					</nav>
				</footer>
			</div>
			
		</div>
		
	</div>
</body>
</html>