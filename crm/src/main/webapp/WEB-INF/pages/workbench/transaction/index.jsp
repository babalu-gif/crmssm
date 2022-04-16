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
		var selectOwner = $.trim($("#select-owner").val());
		var selectName = $.trim($("#select-name").val());
		var selectContactsName = $.trim($("#select-contactsName").val());
		var selectStage = $("#select-stage").val();
		var selectType = $("#select-type").val();
		var selectSource = $("#select-source").val();
		var selectCustomerName = $.trim($("#select-customerName").val());

		// 发送查询所有文章列表的异步请求
		$.ajax({
			url:"workbench/transaction/queryPagination.do",
			data:{
				page: page,
				pageSize:pageSize,
				name:selectName,
				owner:selectOwner,
				contactsId:selectContactsName,
				customerId:selectCustomerName,
				stage:selectStage,
				type:selectType,
				source:selectSource
			},
			type:"post",
			dataType:"json",
			success:function (data){
				// 清空原来的内容
				$("#transactionInfoBody").html("");
				var transactions = data.list;
				for (var i = 0; i < transactions.length; i++) {
					var body = "";
					var transaction = transactions[i];
					body += '<tr class="active">';
					body += '<td><input name="check" type="checkbox" value="'+transaction.id+'"/></td>';
					body += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detailTran.do?id='+transaction.id+'\'"">'+transaction.name+'</a></td>';
					body += '<td>'+transaction.customerId+'</td>';
					body += '<td>'+transaction.stage+'</td>';
					body += '<td>'+transaction.type+'</td>';
					body += '<td>'+transaction.owner+'</td>';
					body += '<td>'+transaction.source+'</td>';
					body += '<td>'+transaction.contactsId+'</td>';
					body += '</tr>';
					$("#transactionInfoBody").append(body);
				}

				// 取消全选按钮
				$("#checkAll").prop("checked", false);

				//bootstrap的分页插件
				$("#transactionPage").bs_pagination({
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
						//refresh(1, $("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));
					}
				});
			}
		})
	}


	$(function(){
		refresh(1, 3);

		// 为查询按钮绑定事件
		$("#queryTransactionBtn").click(function (){
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
		$("#transactionInfoBody").on("click", $("input[name=check]"), function ()
		{
			$("#checkAll").prop("checked", $("input[name=check]").length==$("input[name=check]:checked").length);
		});

		// 为“创建”按钮绑定单击事件
		$("#createTranBtn").click(function (){
			window.location.href="workbench/transaction/toSave.do";
		});

		// 为“更新”按钮绑定单击事件
		$("#editTranBtn").click(function (){
			// 判断
			var $check = $("input[name=check]:checked");
			if ($check.length == 0){
				layer.alert("请选择需要修改的交易", {icon:7})
				return;
			}
			if ($check.length > 1){
				layer.alert("每次只能选择一个交易", {icon:7})
				return;
			}
			var id = $check[0].value;
			window.location.href="workbench/transaction/toEdit.do?id="+id;
		});

		// 为“删除”按钮绑定单击事件
		$("#deleteTranBtn").click(function (){
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
						url:"workbench/transaction/deleteTranByIds.do?id="+param,
						type:"post",
						dataType:"json",
						success:function (data){
							if (data.code == "1"){
								layer.alert("删除成功", {icon:6});
								refresh(1, $("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));
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
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="select-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="select-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="select-customerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="select-stage" class="form-control">
						  <option></option>
						  <c:forEach items="${stageList}" var="stage">
							  <option id="${stage.id}">${stage.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="select-type" class="form-control">
						  <option></option>
						  <c:forEach items="${typeList}" var="type">
							  <option id="${type.id}">${type.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="select-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option id="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="select-contactsName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="queryTransactionBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createTranBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editTranBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteTranBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionInfoBody">

					</tbody>
				</table>

				<footer class="message_footer">
					<nav>
						<%--分页插件--%>
						<div  style="height: 50px; position: relative;top: 30px;">
							<div id="transactionPage"></div>
						</div>
					</nav>
				</footer>

			</div>
		</div>
	</div>
</body>
</html>