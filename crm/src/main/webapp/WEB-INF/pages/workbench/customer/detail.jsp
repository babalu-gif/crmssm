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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
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

		// 为“保存备注”按钮绑定单击事件
		$("#saveCreateRemarkBtn").click(function (){
			var noteContent = $.trim($("#remark").val());
			var customerId = "${requestScope.customer.id}";
			// 表单验证
			if (noteContent == ""){
				layer.alert("备注不能为空", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/customer/saveCreateCustomerRemark.do",
				data:{
					noteContent:noteContent,
					customerId:customerId
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
						html += '<font color="gray">客户</font> <font color="gray">-</font> <b>${requestScope.customer.name}</b>';
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
						// 关闭“创建”线索的模态窗口
						$("#createContactsModal").modal("hide");

						var htmlStr = "";
						htmlStr += '<tr id="tBody_'+data.retData.id+'">';
						htmlStr += '<td><a onclick="window.location.href=\'workbench/contacts/detailContacts.do?id='+data.retData.id+'\'" style="text-decoration: none;">'+data.retData.fullname+'</a></td>';
						htmlStr += '<td>'+data.retData.email+'</td>';
						htmlStr += '<td>'+data.retData.mphone+'</td>';
						htmlStr += '<td><a href="javascript:void(0);" onclick="deleteContacts(\''+data.retData.id+'\')" data-toggle="modal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
						htmlStr += '</tr>';
						$("#contactsBody").append(htmlStr);
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		});

		// 为“编辑"按钮绑定单击事件”
		$("#editCustomer").click(function (){
			$.ajax({
				url:"workbench/customer/queryCustomerById.do",
				data:{
					id:"${requestScope.customer.id}"
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
						// 填充数据
						$("#owner").text(data.retData.owner);
						$("#phone").text(phone);
						$("#website").text(website);
						$("#description").text(description);
						$("#contactSummary").text(contactSummary);
						$("#nextContactTime").text(nextContactTime);
						$("#address").text(address);
						$("#editBy").html("${sessionScope.sessionUser.name}&nbsp;&nbsp;");
						$("#editTime").text(data.retData.editTime);
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
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
				url:"workbench/customer/saveEditCustomerRemark.do",
				data:{
					id:id,
					noteContent:noteContent
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						$("#div_"+id+" h5").text(noteContent);
						$("#div_"+id+" small").text(data.retData.editTime+" 由${sessionScope.sessionUser.name}"+"修改");
						// 清空备注编辑框的内容
						$("#remark").val("")
						// 隐藏修改线索备注的模态窗口
						$("#editRemarkModal").modal("hide");
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
			url:"workbench/customer/deleteCustomerRemarkById.do",
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

	// 为“删除”交易添加单击事件
	function deleteTran(id){
		if (confirm("您确定删除该交易吗？")){
			$.ajax({
				url:"workbench/transaction/deleteTranById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						/*layer.alert(data.message, {icon:6});*/
						// 刷新备注信息
						$("#tBody_"+id).remove();
					} else {
						layer.alert("系统忙，请稍后重试...", {icon:5});
					}
				}
			})
		}
	}

	// “删除”联系人的函数
	function deleteContacts(id){
		if (confirm("您确定删除该联系人吗？")){
			$.ajax({
				url:"workbench/contacts/deleteContactsById",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						$("#tBody_"+id).remove();
					} else {
						layer.alert("系统忙，请稍后重试...");
					}
				}
			})
		}
	}
	
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
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="${requestScope.customer.name}" readonly>
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

	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="ModalLabel">修改客户</h4>
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.customer.name} <small><a href="${requestScope.customer.website}" target="_blank">${requestScope.customer.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="editCustomer" type="button" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="owner">${requestScope.customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="name">${requestScope.customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="website">${requestScope.customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="phone">${requestScope.customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${requestScope.customer.editBy}&nbsp;&nbsp;</b><small id="editTime" style="font-size: 10px; color: gray;">${requestScope.customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="contactSummary">
					${requestScope.customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div id="nextContactTime" style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">
					${requestScope.customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="address">
					${requestScope.customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${requestScope.remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-${remark.createBy}.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="div_${remark.id} h5">${remark.noteContent}</h5>
					<font color="gray">客户</font> <font color="gray">-</font> <b>${requestScope.customer.name}</b>
					<smallc id="div_${remark.id} small" style="color: gray;"> ${remark.editFlag=='1'?remark.editTime:remark.createTime} 由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</smallc>
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
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<%--<td>可能性</td>--%>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tranBody">
						<c:forEach items="${requestScope.tranList}" var="tran">
							<tr id="tBody_${tran.id}">
								<td><a href="workbench/transaction/detailTran.do?id=${tran.id}" style="text-decoration: none;">${tran.name}</a></td>
								<td>${tran.money}</td>
								<td>${tran.stage}</td>
								<td>${tran.expectedDate}</td>
								<td>${tran.type}</td>
								<td><a href="javascript:void(0);" onclick="deleteTran('${tran.id}')"  data-toggle="modal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/toSave.do" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="contactsTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactsBody">
						<c:forEach items="${requestScope.contactsList}" var="contacts">
							<tr id="tBody_${contacts.id}">
								<td><a href="workbench/contacts/detailContacts.do?id=${contacts.id}" style="text-decoration: none;">${contacts.fullname}</a></td>
								<td>${contacts.email}</td>
								<td>${contacts.mphone}</td>
								<td><a href="javascript:void(0);" onclick="deleteContacts('${contacts.id}')" data-toggle="modal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a id="createContactsBtn" href="javascript:void(0);" data-toggle="modal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>