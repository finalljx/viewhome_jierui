<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<html lang="zh_cn">
	<head>  
        <title>移动办公</title>
	
	
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=1"/>
		<link rel="stylesheet"  href="/view/jqueryMobile/jquery.mobile-1.2.0.css" />

		
		<script src="/view/jqueryMobile/jquery.js"></script>
		
		<script src="/view/jqueryMobile/jquery.mobile-1.2.0.js"></script>
		
		<script src="/view/js/hori.js?tag=201211136"></script>

		<script type="text/javascript">
		  function openmail(){
			if (window.navigator.userAgent.match(/iPad/i) || window.navigator.userAgent.match(/iPhone/i) || window.navigator.userAgent.match(/iPod/i)) {
				window.location.href="mailto:";

			} else if (window.navigator.userAgent.match(/android/i)) {
				var runMail=new cherry.bridge.NativeOperation("application", "runTraveler", []).dispatch();
				var travelerScript = new cherry.bridge.ScriptOperation(function(){
					var result = runMail.returnValue;
					if(!result || result==false || result=='false'){
						alert('请先安装 traveler客户端!');
					}
				});
				travelerScript.addDependency(runMail);
				travelerScript.dispatch();
				cherry.bridge.flushOperations();
			}
		 }
		 function registdevice(){
			var type = "android";
			if (window.navigator.userAgent.match(/iPad/i) || window.navigator.userAgent.match(/iPhone/i) || window.navigator.userAgent.match(/iPod/i)) {
				type = "iphone";
			}

			$.hori.getDeviceId(function(resultid){
					if(resultid == ""){
						alert("无法获取设备ID");
						return;
					}
					
					$.hori.getDeviceToken(function(resulttoken){
							if(resulttoken == ""){
								//alert("无法获取设备token");
								//return;
							}
							resulttoken = resulttoken.replace(/\s+/g,"");
							$.ajax({
								type: "POST", url: "/view/oa?data-action=regisdevice&data-device-type="+type+"&data-device-token="+resulttoken+"&data-device-id="+resultid+"&random="+Math.random(),
								success: function(response){
									
								},
								error:function(response){
								}
							});
						}
					);
				}
			);
		}

		
		function inittodos(){
			// var icount=0;
			if (icount!=gcount){
				var url = "/view/oa/todosnum/Produce/GeneralMessage.nsf/GetAllMsgInfoAgent?openagent&random="+Math.random();
				$.ajax({
					type: "POST", url: url, data:'data-xml=yes^~^app|8|vwTaskUnDoneForMobile|vwTaskUnDoneForMobile^~^msg|5|msgByDateDownUnRdView|msgByDateDownRdView^~^flowinfo|5|FlowUndoView|FlowDoneView', dataType: "text", cache:false,
					success: function(response){
						$("#spanTodo").html(response);
					},
					error:function(response){
						alert("错误:"+response.responseText);
					}
				});
				icount= gcount;
			}
		}
			/*
				调整气泡位置
			*/
		function adjustBubble(){
			var imgOffset=$("#imgToDo").offset();
			var divOneOffset=$("#divOne").offset();
			var spanTodo=$("#spanTodo").get(0);
			spanTodo.style.position="fixed";
			//68为图片宽度
			if(window.navigator.userAgent.match(/iPad/i) || window.navigator.userAgent.match(/iPhone/i) || window.navigator.userAgent.match(/iPod/i)) {
				spanTodo.style.top=divOneOffset.top-10;
				spanTodo.style.left=imgOffset.left+78;
				
	
			}else if(window.navigator.userAgent.match(/android/i)) {
				
				spanTodo.style.top=divOneOffset.top-10;
				spanTodo.style.left=imgOffset.left+68+10;
			}else{
				//alert('other')
				spanTodo.style.top=divOneOffset.top;
				spanTodo.style.left=imgOffset.left+68+10;
			}
		}
		var gcount=1;
		var icount=0;
		$(document).ready(function(){
			try{
				var hori=$.hori;
				registdevice();
				/*设置标题*/
				hori.setHeaderTitle("首页");
				/*隐藏后退按钮*/
				hori.hideBackBtn();
				/*注册注销事件*/
				cherry.bridge.registerEvent("case", "navButtonTouchUp", function() {
						hori.backPage(1);
					});
				//刷新气泡显示代办条数
				cherry.bridge.registerEvent("case", "casePresented", function() {
						//alert("niubility");
						// 调用代办条数
						inittodos();
				});
				// 调整气泡位置
				adjustBubble();
			//如果浏览器调试模式显示气泡数   Produce/DigiFlowMobileHome.nsf/DF_FlowBackTrace?openagent&login
				if($.hori.browerDebug){
					inittodos();
				}
			//ios 隐藏邮件图标
			
			if(hori.getMobileType()=="apple"){
				
				$("#divMail").hide();
			}
			}catch(e){

			}
			
		});
		
		</script>
		<style>
			a{text-decoration:none;}
			.bubble-count { font-size: 11px; font-weight: bold; padding: .2em .5em; margin-left:-.5em;}
		</style>
    </head>
	<body >
		<div data-role="page" id="home" style="background:url(/view/png/sugon/bg_empty.jpg);-moz-background-size:cover;background-repeat:repeat;" >
		<!--
			<div data-role="header">
				<a data-icon="home" data-role="button" data-rel="back">返回</a>
				<h1>首页</h1>
				<a data-icon="home" data-role="button" href="javascript:void(0)" onclick="pushtest();" >推送</a>
			</div>
		-->
			<div data-role="content" align="center">
			
				
				<div class="ui-grid-b" id="divOne">
                    <div class="ui-block-a">
						<a href="javascript:void(0);" onclick="gcount=gcount+1;$.hori.showLoading();$.hori.loadPage(encodeURI('/view/oa/todosmobile/Produce/DigiFlowMobile.nsf/agGetMsgViewData?openagent&login&0.47540903102505816&server=<%=request.getParameter("oaServerName")%>&dbpath=DFMessage/dfmsg_<%=request.getParameter("itcode")%>.nsf&view=vwTaskUnDoneForMobile&thclass=&page=1&count=20'))">
							<img id= "imgToDo" width="68" height="68" src="/view/png/sugon/dbsy.png" />
						</a>
						
						<span id="spanTodo" class="bubble-count ui-btn-up-c ui-btn-corner-all">0</span>

                        <br/>
                        <span style="color:#434343"><strong>待办事宜</strong></span>
                    </div>
					
					 <div class="ui-block-b">
						<a href="javascript:void(0);" onclick="$.hori.showLoading();$.hori.loadPage(encodeURI('/view/oa/messagelist/Produce/DigiFlowMobile.nsf/agGetMsgViewData?openagent&login&0.6922244625974295&server=<%=request.getParameter("oaServerName")%>&dbpath=DFMessage/dfmsg_<%=request.getParameter("itcode")%>.nsf&view=vwMsgUnRdForMobile&thclass=&page=1&count=20&pageFrom=homepage'))">
							<img width="68" height="68" src="/view/png/sugon/wdxx.png" />
						</a>
		
                        <br/>
                        <span style="color:#434343"><strong>未读消息</strong></span>
                    </div>

					<div class="ui-block-c">
						<a href="javascript:void(0)" onclick="$.hori.showLoading();$.hori.loadPage('/view/oa/phonenumber/Produce/WeboaConfig.nsf/telSearchForm?openform','/view/Resources/searchContact.xml')">
                        <img width="68" height="68" src="/view/png/sugon/dhcx.png">
						</a>
                        <br/>
                        <span style="color:#434343"><strong>电话查询</strong></span>
                    </div>
			    </div>
				<br/>
				<div class="ui-grid-b">
					<div class="ui-block-a" id="divMail" >
						<a href="javascript:void(0);" onclick="openmail()">
							<img width="68" height="68" src="/view/png/sugon/gryj.png">
						</a>
                        <br/>
                        <span style="color:#434343"><strong>个人邮件</strong></span>
                    </div>
				</div>
		</div>

		<iframe src="/view/oa?data-action=createuser" border="0" frameborder="no" framespacing="0" width="0" height="0"></iframe>

		<!--  
                    <div class="ui-block-b">
						<a href="javascript:void(0);" onclick="$.hori.showLoading();$.hori.loadPage(encodeURI('/view/oa/messagelist/Produce/DigiFlowMobile.nsf/agGetMsgViewData?openagent&login&0.6922244625974295&server=<%=request.getParameter("oaServerName")%>&dbpath=DFMessage/dfmsg_<%=request.getParameter("itcode")%>.nsf&view=vwMsgUnRdForMobile&thclass=&page=1&count=20&pageFrom=homepage'))">
							<img width="68" height="68" src="/view/png/sugon/wdxx.png" />
						</a>
                        <br/>
                        <span style="color:#434343"><strong>未读消息</strong></span>
                    </div>
					 <div class="ui-block-c">
						<a href="javascript:void(0);" onclick="$.hori.showLoading();$.hori.loadPage(encodeURI('/view/oa/orderdelivery/Application/OrderDelivery.nsf/m_mobileNewAgent?openagent&login&itcode=<%=request.getParameter("itcode") %>'))">
							<img width="68" height="68" src="/view/png/sugon/fhsq.png" />
						</a>
                        <br/>
                        <span style="color:#434343"><strong>66666</strong></span>
                    </div>
                </div>
                <br/>

                <div class="ui-grid-b">
					
                    
                    <div class="ui-block-a">
						<a href="javascript:void(0)" onclick="$.hori.showLoading();$.hori.loadPage('/view/oa/phonenumber/Produce/WeboaConfig.nsf/telSearchForm?openform','/view/Resources/searchContact.xml')">
                        <img width="68" height="68" src="/view/png/sugon/dhcx.png">
						</a>
                        <br/>
                        <span style="color:#434343"><strong>电话查询</strong></span>
                    </div>
                    <div class="ui-block-b">
						<a href="javascript:void(0);" onclick="$.hori.showLoading();$.hori.loadPage('/view/oa/newslist/Application/DigiFlowInfoPublish.nsf/InfoByDateView_2?readviewentries?login&start=1&count=20')">
							<img width="68" height="68" src="/view/png/sugon/qyxw.png">
						</a>
                        <br/>
                        <span style="color:#434343"><strong>企业新闻</strong></span>    
                    </div>
                     
					<div class="ui-block-c" id="divMail" >
						<a href="javascript:void(0);" onclick="openmail()">
							<img width="68" height="68" src="/view/png/sugon/gryj.png">
						</a>
                        <br/>
                        <span style="color:#434343"><strong>个人邮件</strong></span>
                    </div>
                   
                </div>
				<br/>-->
	</body>
</html>
