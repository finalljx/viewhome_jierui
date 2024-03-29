<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="/xsl/pub/scriptCss.xsl" />

	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head>							
				<xsl:apply-imports/>
				<style>
					*{font-size:18px}
					a:link{text-decoration:none;color:black;}
					a:hover{text-decoration:none;color:black;}
					a:visited{text-decoration:none;color:black;}
				</style>
			</head>
			<body>
				<div id="operation" data-role="dialog">
					<div data-role="content">
						<script>
							<![CDATA[
							function search(){
								var username = $("#username").val();
								if($.trim(username)==""){
									alert('请输入关键字');
									return ;
								}
								//username = encodeURI(escape(username));
								//showLoading();
								$.mobile.showPageLoadingMsg();
								var url = "/view/oa/operationsearch/Produce/DigiFlowMobile.nsf/SearchPsnAgent?openagent&searchKey="+username;
								$.ajax({
									type: "get", url: url,
									success: function(response){
										$.mobile.hidePageLoadingMsg();
										//hiddenLoading();
										$("#viewValue").html(response);
										$("#viewValue ul").listview();
										$("#viewValue ul").listview();    
									},
									error:function(response){
										$.mobile.hidePageLoadingMsg();
										//hiddenLoading();
										var rtext="";
										if(response.statusText=="timeout"){
											rtext="网络连接超时，请检查网络";
											alert(rtext);
										}else{
											alert("网络异常，请检查网络"+response.responseText);
										}
									}
								});
							}
							function sure(){
								var persons = $(':input:radio:checked');
								if(persons.length == 0){
									alert("请选择人员!");
								}else{
									var p1 = $(persons[0]).val();
									var p2 = $(persons[0]).attr("id");
									jq(p1, p2);
								}
							}

							function jq(optpsnid, tempauthors){
								var appserver = $("#appserver").val();
								var appdbpath = $("#appdbpath").val();
								var appdocunid = $("#appdocunid").val();
								var CurUserITCode = $("#CurUserITCode").val();

								var FlowMindInfo = $("#FlowMindInfo").val();
								if(FlowMindInfo=="" || FlowMindInfo==null || FlowMindInfo==" "){
									FlowMindInfo = "加签";
								}

								var MsgTitle = $("#MsgTitle").val();
								if(MsgTitle+""=="undefined")MsgTitle="";
								FlowMindInfo = encodeURI(escape(FlowMindInfo));
								MsgTitle = encodeURI(escape(MsgTitle));
								tempauthors = encodeURI(escape(tempauthors));
								
								var soap = "<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'><SOAP-ENV:Body><m:bb_dd_GetDataByView xmlns:m='http://sxg.bbdd.org' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><db_Flag xsi:type='xsd:string'>fromMobile</db_Flag><db_ServerName xsi:type='xsd:string'>"+appserver+"</db_ServerName><db_DbPath xsi:type='xsd:string'>"+appdbpath+"</db_DbPath><db_DocUID xsi:type='xsd:string'>"+appdocunid+"</db_DocUID><db_UpdInfo xsi:type='xsd:string'></db_UpdInfo><db_OptPsnID xsi:type='xsd:string'>"+CurUserITCode+"</db_OptPsnID><db_TempAuthors xsi:type='xsd:string'>"+tempauthors+"</db_TempAuthors><db_MsgTitle xsi:type='xsd:string'>"+MsgTitle+"</db_MsgTitle><db_ToNodeId xsi:type='xsd:string'></db_ToNodeId><db_Mind xsi:type='xsd:string'>"+FlowMindInfo+"</db_Mind><db_OptType xsi:type='xsd:string'>append</db_OptType><db_AppAgentName xsi:type='xsd:string'></db_AppAgentName><db_SelectPsn xsi:type='xsd:string'></db_SelectPsn></m:bb_dd_GetDataByView></SOAP-ENV:Body></SOAP-ENV:Envelope>";
								//SendMsgMobileAgent
								//alert(soap);
								//return false;
								$.mobile.showPageLoadingMsg();
									
								var url = "/view/oa/request/Produce/ProInd.nsf/THFlowBackTraceAgent?openagent&login";
								var data = "data-xml="+soap;
								$.ajax({
									type: "post", url: url, data:data,
									success: function(response){
										$.mobile.hidePageLoadingMsg();
										var result = response;
										alert(result);
										
										setTimeout("$.hori.backPage(1)",2000);
										
									},
									error:function(response){
										$.mobile.hidePageLoadingMsg();
										if(response.statusText=="timeout"){
											rtext="网络连接超时，请检查网络";
											alert(rtext);
										}else{
											alert("无法连接到服务器，请检查下网络"+response.responseText);
										}
										
									}
								});
							}

							function getOrg(value){
								if($("#"+value+"C").html().indexOf("-")!=-1){
									$("#"+value).html("");
									$("#"+value+"C").html("+");
									return;
								}
								
								var url = "/view/oa/operationsuborg/Produce/DigiFlowOrgSysMng.nsf/OrgTreeForAddressAgent?openagent";
								var data = "data-xml="+value+";;;<xsl:value-of select='//userid/text()'/>";
								$.mobile.showPageLoadingMsg();
								$.ajax({
									type: "post", url: url, data:data,
									success: function(response){
										$.mobile.hidePageLoadingMsg();
										$("#"+value).html(response);
										$("#"+value+"C").html("-");
									},
									error:function(response){
										$.mobile.hidePageLoadingMsg();
										var rtext="";
										if(response.statusText=="timeout"){
											rtext="网络连接超时，请检查网络";
											alert(rtext);
										}else{
											alert("网络异常，请检查网络"+response.responseText);
										}
									}
								});
							}
							function viewPerson(value){
								var url = "/view/oa/operationperson/Produce/DigiFlowMobile.nsf/ajaxGetPsnList?openagent&deptid="+value;
								$.ajax({
									type: "get", url: url,
									success: function(response){
										$.mobile.hidePageLoadingMsg();
										$("#viewValue").html(response);
										$("#viewValue ul").listview();
										$("#viewValue ul").listview();
										
										$( "#myCollapsibleSet" ).children().trigger("collapse");
									},
									error:function(response){
										$.mobile.hidePageLoadingMsg();
										if(response.statusText=="timeout"){
											rtext="网络连接超时，请检查网络";
											alert(rtext);
										}else{
											alert("无法连接到服务器，请检查下网络"+response.responseText);
										}
										
									}
								});
							}
							function back(){
								var content = $('#content');
								$.mobile.changePage(content)
							}
						]]>
						</script>
						<ul data-role="listview" data-inset="true" data-theme="d" style="margin-top:5px">
							<li data-role="list-divider">选择人员</li>
							<li>
							
								<div data-role="collapsible-set" id="myCollapsibleSet">
									<div data-role="collapsible" data-content-theme="c" data-collapsed="false">
									   <h3>选择人员</h3>
									   <table style="width:100%" cellspaceing="0" cellpadding="0" border="0">
											<tr><td align="right">
											<label for="username"><strong>人名或ITCode:</strong></label>
											</td><td>
											<input type="text" id="username" name="username" data-inline="true"></input>
											</td><td>
											<a data-role="button" data-inline="true" href="javascript:search();" onclick="search();">查询</a>
											</td></tr>
										</table>
									</div>
									<style>
										*{font-size:18px}
										a:link{text-decoration:none;color:black;}
										a:hover{text-decoration:none;color:black;}
										a:visited{text-decoration:none;color:black;}
									</style>
									<!-- <div data-role="collapsible" data-content-theme="c">
									   <h3>组织结构</h3>
									   <table style="width:100%" cellspaceing="0" cellpadding="0" border="0">
											<tr><td>
											<ul data-role="listview" data-inset="true">
												<li data-role="list-divider">通讯录</li> 
												<li>
													<div style="width:100%;height:5"></div>
													<span><a href="javascript:void(0)" onclick="getOrg('ComOrg')">  <strong><span id="ComOrgC">+</span></strong>&#160;&#160;  锦州银行</a></span>
													<hr/>
													<div id='ComOrg' style="padding-left:15px;"></div>
													
													<div style="width:100%;height:5"></div>
												</li>
											</ul>
											</td></tr>

										</table>
									</div> -->
								</div>

								<div style="width:100%;" align="center">
									<strong>
										<a href="javascript:sure();" data-role="button" data-inline="true"> 确定 </a>
										<a href="javascript:back();" data-role="button" data-inline="true"> 取消 </a>
									</strong>
								</div>
								
								<div id="viewValue" >
								</div>
							</li>				
						</ul>

					</div>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
