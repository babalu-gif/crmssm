<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String base = request.getContextPath() + "/";
    String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + base;
%>
<html>
<head>
    <base href="<%=url%>">
    <!--引入jquery-->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!--引入echarts插件-->
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <title>演示echarts插件</title>
    <script type="text/javascript">
        $(function () {
            //当容器加载完成之后，对容器调用工具函数

            // 基于准备好的dom，初始化echarts实例
            var myChart = echarts.init(document.getElementById('main'));

            // 指定图表的配置项和数据
            var option = {
                title: {
                    text: '漏斗图',
                    subtext: '纯属虚构'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c}%"
                },
                toolbox: {
                    feature: {
                        dataView: {readOnly: false},
                        restore: {},
                        saveAsImage: {}
                    }
                },
                legend: {
                    data: ['展现','点击','访问','咨询','订单']
                },

                series: [
                    {
                        name:'漏斗图',
                        type:'funnel',
                        left: '10%',
                        top: 60,
                        //x2: 80,
                        bottom: 60,
                        width: '80%',
                        // height: {totalHeight} - y - y2,
                        min: 0,
                        max: 100,
                        minSize: '0%',
                        maxSize: '100%',
                        sort: 'descending',
                        gap: 2,
                        label: {
                            show: true,
                            position: 'inside'
                        },
                        labelLine: {
                            length: 10,
                            lineStyle: {
                                width: 1,
                                type: 'solid'
                            }
                        },
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1
                        },
                        emphasis: {
                            label: {
                                fontSize: 20
                            }
                        },
                        data: [
                            {value: 60, name: '访问'},
                            {value: 40, name: '咨询'},
                            {value: 20, name: '订单'},
                            {value: 80, name: '点击'},
                            {value: 100, name: '展现'}
                        ]
                    }
                ]
            };


            // 使用刚指定的配置项和数据显示图表。
            myChart.setOption(option);
        });
    </script>
</head>
<body>
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<div id="main" style="width: 600px;height:400px;"></div>
</body>
</html>