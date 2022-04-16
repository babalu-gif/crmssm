# crm的技术架构：
    视图层(view)：展示数据，跟用户交互。
    html,css,js,jquery,bootstrap(ext|easyUI),jsp
    控制层(Controller)：控制业务处理流程(接收请求,接收参数,封装参数;根据不同的请求调用业务层处理业务;根据处理结果，返回响应信息)
    (servlet,)springMVC(,webwork,struts1,struts2)
    业务层(Service)：处理业务逻辑(处理业务的步骤以及操作的原子性)
    JAVASE(工作流:activiti|JBPM)
    持久层(Dao/Mapper)：操作数据库.
    (jdbc,)mybatis(,hibernate,ibatis)

    整合层：维护类资源,维护数据库资源
    spring(IOC,AOP)(,ejb,corba)

# 软件公司的组织结构：
    研发部(程序员,美工,DBA),测试部,产品部,实施部,运维部,市场部

# 软件开发的生命周期：
    1)招标
    投标----------标书
        甲方
        乙方
    2)可行性分析---------可行性分析报告
        技术,经济
    3)需求分析-----------需求文档
        产品经理,需求调研
        项目原型:容易确定需求,开发项目时作为jsp网页.
    4)分析与设计
        架构设计----------架构文档
            物理架构设计：
                应用服务器:tomcat(apache),weblogic(bea-->oracle),websphere(ibm),jboss(redhat),resin(MS)
                web  javaee:13种协议
                servlet,jsp,xml,jdbc
                mq ....
                数据库服务器：mysql,oracle,DB2,sqlserver,达梦
                逻辑架构设计：代码分层.
                视图层-->控制层-->业务层-->持久层-->数据库
                技术选型：java,.net
        项目设计---------项目设计文档
            物理模型设计：哪些表，哪些字段，字段的类型和长度，以及表和表之间的关系。
            逻辑模型设计：哪些类，哪些属性和方法，方法的参数和返回值，以及类和类之间关系。
    
        界面设计-----项目原型
                企业级应用 朴素
                互联网应用 炫酷
        算法设计------算法设计文档
    5)搭建开发环境-----------技术架构文档
        创建项目,添加jar包,添加配置文件,添加静态页面,添加公共类以及其它资源;能够正常启动运行。
    6)编码实现-------注释
    7)测试-----------测试用例
    8)试运行---------使用手册
    9)上线-----------实施文档
    10)运维----------运维手册
    11)文档编纂

# CRM项目的核心业务：
    1)CRM项目的简介：Customer Relationship Management 客户关系管理系统
    企业级应用,传统应用;给销售或者贸易型公司使用,在市场,销售,服务等各个环节中维护客户关系，
    CRM项目的宗旨：增加新客户,留住老客户，把已有客户转化为忠诚客户。

    2)CRM是一类项目,我们的CRM是给一个大型的进出口贸易公司来使用的，做大宗商品的进出口贸易;商品是受管家管制的。

    3)CRM项目的核心业务：
        系统管理功能：不是直接处理业务数据，为了保证业务管理的功能正常安全运行而设计的功能。
        用户登录,安全退出,登录验证等
        给超级管理员，开发和运维人员使用。
        业务管理功能：处理业务数据
        市场活动：市场部，设计市场活动营销活动
        线索：销售部(初级销售),增加线索
        客户和联系人：销售部(高级销售),有效地区分和跟踪客户和联系人.
        交易：销售部(高级销售),更好地区分和统计交易的各个阶段。
        售后回访：客服部,妥善安排售后回访。主动提醒。
        统计图表：管理层,统计交易表中各个阶段数据量。

# 搭建开发环境：
    1)创建项目：crm-project
        设置JDK.
        创建工程：crm
        补全目录结构：
        设置编码格式：UTF-8
    2)添加jar包：添加依赖---参考课件。
    3)添加配置文件：参考课件。

# 记住密码
    访问index.jsp--->后台  .html 如果上次记住密码，自动填充账号和密码；否则，不填
                            如何判断上次是否记住密码？
                            --上次登录成功，判断是否需要记住密码。如果需要记住密码，则往该浏览器写cookie
                                        而且cookie的值必须是该用户的loginAct和loginPwd
                            --下次登录时，判断该用户是否有cookie；如果有，自动填写账号和密码
                ---->浏览器显示
    
    获取cookie
        使用EL表达式
            ${cookie.loginAct.value}
            ${cookie.loginPwd.value}

# 登录验证功能
    过滤器
        implements Filter
        在web.xml配置        

    拦截器
        implements HandlerInterceptor
        在springmvc.xml配置

# 页面切割技术
    1)<frameset>和<frame>
    <frameset> 用来切割页面
        <frameset cols="20%,60%,20%" rows="10%,80%,10%">
    <frame> 用来显示页面
        <frame src="url">

         <frameset cols="20%,60%,20%">
            <frame src="url1" name="f1">
            <frame src="url2" name="f2">
            <frame src="url3" name="f3">
        </frameset>
        每一个<frame>标签就是一个独立的浏览器窗口

        <a href="url" target="f3">test</a>
    2)<div>和<iframe>
        <div> 切割页面
        <iframe> 显示页面

        <div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
			<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
		</div>
    
# 模态窗口
## 定义
    模拟的敞口，本质上是<div>，通过设置z-index大小来实现，初始时，z-index初始参数是<0，所以不显示
                                                需要显示时，z-index的值设置成>0即可
               
## 控制模态窗口的显示与隐藏
    1）方式1：通过data-toggle="modal" data-target="模态窗口的id"
    2）方式2：通过js函数控制
        选择器(选中div).modal("show"); // 显示选中的模态窗口
        选择器(选中div).modal("hide"); // 隐藏选中的模态窗口
    3）方式3：通过标签的属性：data-dismiss=""
        点击添加了data-dismiss=""属性的标签，自动关闭该标签所在的模态窗口

# 导出市场活动
    技术准备
        1）使用java生成excel文件：图形化API iText、apache-poi
            添加依赖
                <dependency>
                  <groupId>org.apache.poi</groupId>
                  <artifactId>poi</artifactId>
                  <version>3.15</version>
                </dependency>
            使用封装类生成excel文件
            
        2）文件下载
            filedownloadtest.jsp
            ActivityController
                |->fileDownload()

        所有文件下载是同步请求

# 导入市场活动
    1）把用户计算机上的excel文件上传到服务器（文件上传）
    2）使用java解析excel文件，获取excel文件中的数据
    3）把解析出来的数据添加到数据库
    4）返回响应信息

## 技术准备
    1）文件上传
        fileuploadtest.jsp
        FileUploadtextController
    2）使用java解析excel文件

# 线索转换：
    线索是给初级销售人员使用；如果线索没有购买意向，则删除线索，如果线索有购买意向，则把该线索信息转换到客户和联系人表中，把该线索删除。

    数据转换：
        把该线索中有关公司的信息转换到客户表中
        把该线索中有关个人的信息转换到联系人表中
        把该线索下所有备注信息转换到客户备注表中一份
        把该线索下所有备注信息转换到联系人备注表中一份
        把该线索和市场活动的关联关系转换联系人和市场活动的关联关系表中
        如果需要创建交易，则往交易表中添加一条记录
        如果需要创建交易，则还需要把该线索下所有备注转换到交易备注表中一份
        删除该线索下所有的备注
        删除该线索和市场活动的关联关系
        删除该线索

    以上所有操作必须在同一个事务中完成,在同一个service方法中完成。

# 可能性的可配置
    配置文件：
     a)xxxx.properties配置文件：key1=value1
	                            key2=value2
				    .....

				    适合配置简单数据，几乎没有冗余数据，效率高
				    解析相对简单：Properties，BundleResource
	 b)xxx.xml配置文件：标签语言.
	   <studentList>
		   <student email="zs@163.com">
			<id>1001</id>
			<name>zs</name>
			<age>20</age>
		   </student>
		   <student email="ls@163.com">
			<id>1002</id>
			<name>ls</name>
			<age>20</age>
		   </student>
	   </studentList>
	                            适合配置复杂数据，产生冗余数据，效率低
				    解析相对复杂：dom4j,jdom
	  配置可能性：possibility.properties
	              阶段的名称做key，可能性做value    

    1）提供配置文件，由用户提供，保存在后台服务器上
    2）用户每次选择阶段，向后台发送请求
    3）后台提供controller，接收请求，根据选择的阶段，解析配置文件，获取相应的可能性
    4）把可能性返回前台，显示在输入框

# 客户名称自动补全
    自动补全插件：bs_typeahead
        1)引入开发包：.css,.js
	2)创建容器：<div> <input type="text">
	3)当容器加载完成之后，对容器调用工具函数：

# 分析交易阶段的图标：
    图标的数量：跟交易总的阶段数量一致
    每一个阶段对应显示一个图标
    图标的种类：三类
    图标的颜色：绿色和黑色
    图标的顺序：跟阶段的顺序一致
    图标数量的变化：阶段的数量可能变化，图标的数量也可能变化
    图标的实现：
    <span class="glyphicon glyphicon-ok-circle" data-content="" style="color: #90F790;">
    -----------
    
    显示交易阶段的图标：
    按照顺序查询交易所有的阶段：stageList
    遍历stageList,显示每一个阶段对应图标，图标上显示的阶段的名称从遍历出的阶段中获取。

# 统计图表
    以更专业、更形象的形式展示系统中的数据。

    销售漏斗图：展示商品销售数据、销售业绩
    展示交易表中的数据,统计交易表中各个阶段的数量

     报表插件:jfreechart,iReport,锐浪,echarts

    echarts的使用：
    1)引入开发包：echarts.min.js
    2)创建容器：<div id="main" style="width: 600px;height:400px;"></div>
    3)当容器加载完成之后，对容器调用工具函数：