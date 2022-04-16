<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String base = request.getContextPath() + "/";
	String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + base;
%>
<html>
<head>
	<base href="<%=url%>">
<head>
<meta charset="UTF-8">
</head>
<body>
	<script type="text/javascript">
		document.location.href = "settings/qx/user/toLogin.do";
	</script>
</body>
</html>