<#import "../global.ftl" as global />
<@compress single_line=true>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <@global.importMiniui 'bootstrap'/>
    <@global.importPlugin 'echarts/echarts.min.js'/>
    <@global.importUeditorParser/>
    <@global.importFontIcon/>
    <@global.resources "css/index-tab.css"/>
    <style type="text/css">
        #cpu {
            width: 98%;
            height: 300px;
        }
        #pv {
            width: 95%;
            height: 300px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="mini-clearfix ">
        <div class="mini-col-4">
            <div class="mini-panel mini-panel-primary" title="故障预测与监控" width="auto"
                 showCollapseButton="true" showCloseButton="false" style="height: 320px">
                <table class="panel-table" style="width: 90%;margin: auto;font-family: Georgia,"Times New Roman",Times,sans-serif;">
                    <tbody>
                    <tr>
                        <td class="post-title"><a href="http://127.0.0.1:1022/dashboard/34" id="post_title_link_6805304">近期数据</a></td>
                    </tr>
                    <tr>
                        <td class="post-title"><a href="http://127.0.0.1:1022/dashboard/33" id="post_title_link_6805304">故障预测</a></td>
                    </tr>
                    <tr>
                        <td class="post-title"><a href="http://127.0.0.1:3000/dashboard/db/testdata-graph-panel-last-1h?orgId=1" id="post_title_link_6892123">数据采集与展示</a></td>
                    </tr>
                    <tr>
                        <td class="post-title"><a href="http://127.0.0.1/#/system-status" id="post_title_link_6805304">MQQT服务器监控</a></td>
                    </tr>
                    <tr>
                        <td class="post-title"><a href="http://127.0.0.1:61208/" id="post_title_link_6805304">MQQT HTop信息</a></td>
                    </tr>
                    <tr>
                        <td class="post-title"><a href="http://127.0.0.1:8888/" id="post_title_link_6805304">Jupyter notebook</a></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="mini-col-8">
            <div class="mini-panel mini-panel-primary" title="MQTT-server QPS" width="auto"
                 showCollapseButton="true" showCloseButton="false">
                <div id="pv"></div>
            </div>
        </div>
    </div>
    <div class="mini-clearfix ">
        <div class="mini-col-12">
            <div class="mini-panel mini-panel-primary" title="CPU使用率" width="auto"
                 showCollapseButton="true" showCloseButton="false">
                <div id="cpu"></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
    <@global.importRequest/>
</@compress>
<@global.importWebsocket/>
<script type="text/javascript">
    var cpuOption = {
        title: {
            text: "",
            subtext: ""
        },
        tooltip: {
            trigger: "axis"
        },
        toolbox: {},
        calculable: false,
        xAxis: [
            {
                type: "category",
                boundaryGap: false,
                data: [],
                splitLine: {
                    show: false
                }
            }
        ],
        yAxis: [
            {
                type: "value",
                name: "%",
                position: "left",
                max: 100,
                splitLine: {
                    show: true
                }
            }
        ],
        series: [
            {
                name: "使用率",
                type: "line",
                detail: {formatter: '{value}%'},
                data: [],
                smooth: true,
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0,
                            color: 'rgb(255, 12, 0)'
                        }, {
                            offset: 1,
                            color: 'rgb(112, 255, 0)'
                        }])
                    }
                }
            }
        ]
    };
    var pvOption = {
        title: {
            text: "",
            subtext: ""
        },
        tooltip: {
            trigger: "axis"
        },
        toolbox: {},
        calculable: false,
        xAxis: [
            {
                type: "category",
                name: "time",
                boundaryGap: false,
                data: [],
                splitLine: {
                    show: false
                }
            }
        ],
        yAxis: [
            {
                type: "value",
                name: "request/sec",
                position: "left",
                splitLine: {
                    show: true
                }
            }
        ],
        series: [
            {
                name: "QPS",
                type: "line",
                detail: {formatter: 'request/sec'},
                data: [],
                smooth: true,
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0,
                            color: 'rgb(255, 12, 0)'
                        }, {
                            offset: 1,
                            color: 'rgb(112, 255, 0)'
                        }])
                    }
                }
            }
        ]
    };
    for (var i = 0; i < 30; i++) {
        cpuOption.xAxis[0].data.push("");
        cpuOption.series[0].data.push(0);
    }

    for (var i = 0; i < 20; i++) {
        pvOption.xAxis[0].data.push("");
        pvOption.series[0].data.push(0);
    }

    var pvChart = echarts.init(document.getElementById('pv'));
    pvChart.setOption(pvOption);

    var cpuChart = echarts.init(document.getElementById('cpu'));
    cpuChart.setOption(cpuOption);
    Socket.open(function (socket) {
        window.onunload = function (e) {
            socket.sub("system-monitor", {type: "cancel"});
        }
        socket.sub("system-monitor", {type: "cpu"}, "cpuRender");
        socket.sub("pv", {type: "get"}, "pvGet");
        socket.on("pvGet", function (obj) {
            pvOption.xAxis[0].data.shift();
            pvOption.series[0].data.shift();
            var date = new Date();
            pvOption.xAxis[0].data.push(date.getMinutes() + "-" + date.getSeconds());
            pvOption.series[0].data.push(obj);
            pvChart.setOption(pvOption, true);
        });
        socket.on("cpuRender", function (obj) {
            cpuOption.xAxis[0].data.shift();
            cpuOption.series[0].data.shift();
            var date = new Date();
            var cb = 0;
            for (var i = 0; i < obj.length; i++) {
                var cpuInfo = obj[i];
                cb += cpuInfo.perc.combined;
            }
            cpuOption.xAxis[0].data.push(date.getMinutes() + "-" + date.getSeconds());
            cpuOption.series[0].data.push(((cb / 4) * 100).toFixed(2) - 0);
            cpuChart.setOption(cpuOption, true);
        });
    });

    function bytesToSize(bytes) {
        if (bytes === 0) return '0 B';
        if (bytes < 1024)return bytes + 'b';
        var k = 1024, // or 1024
                sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
                i = Math.floor(Math.log(bytes) / Math.log(k));
        return (bytes / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
    }
</script>