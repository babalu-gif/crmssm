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

		$("#remarkDivList").on("mouseover", ".remarkDiv", function (){
			$(this).children("div").children("div").show();
		})

		$("#remarkDivList").on("mouseout", ".remarkDiv", function (){
			$(this).children("div").children("div").hide();
		})

		$("#remarkDivList").on("mouseover", ".myHref", function (){
			$(this).children("span").css("color","red");
		})

		$("#remarkDivList").on("mouseout", ".myHref", function (){
			$(this).children("span").css("color","#E6E6E6");
		})

		// 为“修改"按钮绑定单击事件”
		$("#editContactsBtn").click(function (){

			$.ajax({
				url:"workbench/contacts/queryContactsById.do",
				data:{
					id:"${requestScope.contacts.id}"
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

			// 展现修改联系人的模态窗口
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
						// 隐藏修改联系人的模态窗口
						$("#editContactsModal").modal("hide");
						// 填充数据
						$("#owner").text(data.retData.owner);
						$("#mphone").text(mphone);
						$("#source").text(source);
						$("#fullnameAppellation").text(fullname+appellation);
						$("#email").text(email);
						$("#job").text(job);
						$("#description").text(description);
						$("#customerName").text(customerName);
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

		// 为“保存备注”按钮绑定单击事件
		$("#saveRemarkBtn").click(function (){
			var noteContent = $.trim($("#remark").val());
			var contactsId = "${requestScope.contacts.id}";
			// 表单验证
			if (noteContent == ""){
				layer.alert("备注不能为空", {icon:7});
				return;
			}

			$.ajax({
				url:"workbench/contacts/saveCreateContactsRemark.do",
				data:{
					noteContent:noteContent,
					contactsId:contactsId
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
						html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${requestScope.contacts.fullname}${requestScope.contacts.appellation}-${requestScope.contacts.customerId}</b>';
						html += '<smallc id="div_'+data.retData.id+' smallc" style="color: gray;"> '+data.retData.createTime+' 由${sessionScope.sessionUser.name}创建</smallc>';
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

		// 为”关联市场活动“添加单击事件
		$("#bundActivityBtn").click(function (){
			//清空搜索框
			$("#searchActivityTxt").val("");
			//清空搜索的市场活动列表
			$("#tBody").html("");

			// 显示联系人和市场活动关联的模态窗口
			$("#bundActivityModal").modal("show");
		});

		//  给市场活动搜索框添加键盘弹起事件
		$("#searchActivityTxt").keyup(function (){
			// 收集参数
			var activityName = this.value;
			var contactsId = "${requestScope.contacts.id}";

			$.ajax({
				url:"workbench/contacts/queryActivityForDetailByNameContactsId.do",
				data:{
					activityName:activityName,
					contactsId:contactsId
				},
				type:"post",
				dataType:"json",
				success:function (data){
					var htmlStr = "";
					$.each(data, function (index, obj){
						htmlStr += '<tr>';
						htmlStr += '<td><input name="check" type="checkbox" value="'+obj.id+'"/></td>';
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
			ids+="contactsId=${requestScope.contacts.id}";

			$.ajax({
				url:"workbench/contacts/saveBund.do",
				data:ids,
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						$.each(data.retData, function (index, obj){
							var h = "";
							h += '<tr id="tr_'+obj.id+'">';
							h += '<td><a href="workbench/activity/detailActivity.do?id='+obj.id+'" style="text-decoration: none;">'+obj.name+'</a></td>';
							h += '<td>'+obj.startDate+'</td>';
							h += '<td>'+obj.endDate+'</td>';
							h += '<td>'+obj.owner+'</td>';
							h += '<td><a href="javascript:void(0);"  onclick="unbundActivity(\''+obj.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
							h += '</tr>';
							$("#activityBody").append(h);
						})

						// 隐藏“关联市场活动”的模态窗口
						$("#bundActivityModal").modal("hide");
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
				url:"workbench/contacts/saveEditContactsRemark.do",
				data:{
					id:id,
					noteContent:noteContent
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if (data.code == "1"){
						$("#div_"+id+" h5").text(noteContent);
						$("#div_"+id+" smallc").text(data.retData.editTime+" 由${sessionScope.sessionUser.name}"+"修改");
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
			url:"workbench/contacts/deleteContactsRemarkById.do",
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

	// 为“解除关联”添加事件
	function unbundActivity(activityId){
		if (confirm("您确定解除该关联吗？")){
			$.ajax({
				url:"workbench/contacts/saveUnbund.do",
				data:{
					contactsId:"${requestScope.contacts.id}",
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

	
	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
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
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
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
							<label for="edit-source" class="col-sm-2 control-label">来源<span style="font-size: 15px; color: red;">*</span></label>
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
							<label for="edit-appellation" class="col-sm-2 control-label">称呼<span style="font-size: 15px; color: red;">*</span></label>
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
							<label for="edit-mphone" class="col-sm-2 control-label">手机<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述<span style="font-size: 15px; color: red;">*</span></label>
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
			<h3>${requestScope.contacts.fullname}${requestScope.contacts.appellation} <small> - ${requestScope.contacts.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="editContactsBtn" type="button" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
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
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="owner">${requestScope.contacts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="source">${requestScope.contacts.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="customerName">${requestScope.contacts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="fullnameAppellation">${requestScope.contacts.fullname}${requestScope.contacts.appellation}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="email">${requestScope.contacts.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="mphone">${requestScope.contacts.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="job">${requestScope.contacts.job}</b></div>
			<%--<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;</b></div>--%>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.contacts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${requestScope.contacts.editBy}&nbsp;&nbsp;</b><small id="editTime" style="font-size: 10px; color: gray;">${requestScope.contacts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">
					${requestScope.contacts.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="contactSummary">
					&nbsp${requestScope.contacts.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="nextContactTime">&nbsp;${requestScope.contacts.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="address">
					${requestScope.contacts.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 20px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${requestScope.remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-${remark.createBy}.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="div_${remark.id} h5">${remark.noteContent}</h5>
					<font color="gray">联系人</font> <font color="gray">-</font> <b>${requestScope.contacts.fullname}${requestScope.contacts.appellation}-${requestScope.contacts.customerId}</b>
					<smallc id="div_${remark.id} smallc" style="color: gray;"> ${remark.editFlag=='1'?remark.editTime:remark.createTime} 由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</smallc>
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
					<button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
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
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
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
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<c:forEach items="${requestScope.activityList}" var="activity">
							<tr id="tr_${activity.id}">
								<td><a href="workbench/activity/detailActivity.do?id=${activity.id}" style="text-decoration: none;">${activity.name}</a></td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a href="javascript:void(0);" onclick="unbundActivity('${activity.id}')" data-toggle="modal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td><a href="../activity/detail.jsp" style="text-decoration: none;">发传单</a></td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a id="bundActivityBtn" href="javascript:void(0);" data-toggle="modal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>