package ui.base.shejiao.haoyou
{	
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.load.GamelibS;
	
	import fl.managers.FocusManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.HaoYouSet;
	import netc.packets2.PacketSCSayPrivate2;
	
	import nets.packets.PacketCSSayPrivate;
	import nets.packets.PacketCSTeamInvit;
	import nets.packets.PacketCWReportChat;
	import nets.packets.PacketWCReportChat;
	
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIActMap;
	import ui.frame.UIWindowManager;
	import ui.frame.WindowName;
	import ui.view.view1.chat.ChatFilterRobot;
	
	import world.FileManager;
	
	
	/**
	 * 私聊窗口
	 *  andy 2011-01-07
	 */
	public class GameChatFriend  extends Sprite{
		public var roleId:int=0;
		public var playerInfo:PacketSCSayPrivate2;
		private var i:int=0;
		private var ht:int=0;
		
		
		private var content:Sprite;
		private var mc:MovieClip;
		//快速聊天回复 2012-08-08
		private var arrQuickSay:Array;
		private var mc_quick_say:Sprite;
		private var child:MovieClip;
		
		public function get focusManager():FocusManager
		{
			return UIWindowManager.getInstance().GetFocusManager();
		}
		
		/**
		 *	@param v1 roleId
		 *  @param v2 roleName
		 *  @param v3 headIcon
		 *  @param v4 underwrite 
		 */	
		public function GameChatFriend() : void {			
			mc=GamelibS.getswflink("game_index",WindowName.win_si_liao) as MovieClip;
			this.addChild(mc);
			init();	
		}
		private function init() : void {
			
			
			
			mc["txt_chat"].addEventListener(KeyboardEvent.KEY_DOWN, chatKeydownHandler);
			mc["txt_chat"].maxChars=50;   
			mc.addEventListener(MouseEvent.CLICK,mcHandler);
			mc["mc_move"].addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			mc["mc_move"].addEventListener(MouseEvent.MOUSE_UP,downHandler);
			mc["mc_xiaLa"].addEventListener(MouseEvent.ROLL_OUT,downHandler);
			content=new Sprite();
			mc.addChild(content);
			mc["sp"].source=content;
			mc["sp"].overHeight=5;
			mc["mc_head"].mouseChildren=false;
			mc["mc_head"].buttonMode=true;
			mc["mc_xiaLa"].visible=false;
			//2012-08-08 快速回复
			mc["btnQuickSay"].mouseChildren=false;
			mc["btnQuickSay"].gotoAndStop(1);
			mc_quick_say=mc["mc_quick_say"];
			mc_quick_say.visible=false;
			arrQuickSay=Lang.getLabelArr("arrQuickSayPrivate");
			if(arrQuickSay!=null){
				var quick_content:Sprite=new Sprite();
				var len:int=arrQuickSay.length;
				for(i=0;i<len;i++){
					if(arrQuickSay[i]==null)continue;
					child=ItemManager.instance().getQuickSayPrivate(i) as MovieClip;
					child["txt_say"].text=arrQuickSay[i];
					child.mouseChildren=false;
					child.name="item_quick_say"+i;
					quick_content.addChild(child);
				}
				CtrlFactory.getUIShow().showList2(quick_content);
				mc_quick_say["sp_quick_say"].source=quick_content;
			}
			if(mc_quick_say.hasEventListener(MouseEvent.MOUSE_OVER)==false){
				mc_quick_say.addEventListener(MouseEvent.MOUSE_OUT,mouseOutQuickHandle);
				mc_quick_say.addEventListener(MouseEvent.MOUSE_OVER, mouseOverQuickHandle);
			}
//			mc["face"]["uil"].source=GameIni.GAMESERVERS+"pubres/chatFace.png";
			ImageUtils.replaceImage(mc["face"],mc["face"]["uil"],GameIni.GAMESERVERS+"pubres/chatFace.png");
		}
		public function setData(v:PacketSCSayPrivate2):void {
			if(v==null)return;
			roleId=v.userid;
			playerInfo=v;
			mc["face"].visible=false;
			mc["txt_name"].text=playerInfo.username;
			mc["txt_qianMing"].text=Data.haoYou.getQianMing(playerInfo.underwrite,playerInfo.underwrite_p1,playerInfo.underwrite_p2);
			if(playerInfo.headicon>0){
//				mc["mc_head"]["uil"].source=FileManager.instance.getHeadIconXById(playerInfo.headicon);
				ImageUtils.replaceImage(mc["mc_head"],mc["mc_head"]["uil"],FileManager.instance.getHeadIconXById(playerInfo.headicon));
			}	
			YellowDiamond.getInstance().handleYellowDiamondMC2(mc["mcQQYellowDiamond"], v.qqyellowvip);
			updateAll();
			
		}
		public function reset():void {
			roleId=0;
			playerInfo=null;
			mc["txt_name"].text="";
			mc["txt_qianMing"].text="";
			mc["mc_head"]["uil"].unload();
		}
		
		/**
		 *	显示窗口【关闭,最小化】 
		 */
		public function show(must:Boolean=false,minChat:Boolean=false):void{
			if(must){
				if(this.parent==null){
					this.x=(GameIni.MAP_SIZE_W - this.width) / 2;
					this.y=(GameIni.MAP_SIZE_H - this.height) / 2;
					this.x=this.x < 0 ? 50 : this.x;
					this.y=this.y < 0 ? 50 : this.y;
					PubData.AlertUI.addChild(this);
					this.stage.focus=mc["txt_chat"];
				}
			}else{
				if(this.parent!=null){
					PubData.AlertUI.removeChild(this);
					if(minChat){
						roleId=0;
						ChatWarningControl.getInstance().haveInfo(playerInfo,false);
					}
					reset();
					PubData.AlertUI.stage.focus=PubData.AlertUI.stage;
				}
			}
		}
		
		private function chatKeydownHandler(e : KeyboardEvent) : void {
			if(e.keyCode == 13) {
				send(mc["txt_chat"].text);
			}
		}
		//面板点击事件
		public function mcHandler(me:MouseEvent) : void {
			var target:Object=me.target;
			if (target.name.indexOf("F") == 0 && target.parent.name == "face")
			{
				target.parent.visible=false;
				if(mc["txt_chat"].text.length<44){
					mc["txt_chat"].text+="{" + target.name + "}";
					mc["txt_chat"].setSelection(mc["txt_chat"].text.length, mc["txt_chat"].text.length);	
				}
				focusManager.setFocus(mc["txt_chat"]);
				return;
			}else if(target.name.indexOf("h_")==0){
				mc["mc_xiaLa"].visible=false;
				//可能 target.label 的内容，与Lang文件内容不是完全匹配 改造一下
				UI_index.instance.playerAction(target,playerInfo.userid,playerInfo.username);
				
				return;
			}else if(target.name.indexOf("item_quick_say") == 0){
				var cnt:int=int(target.name.replace("item_quick_say",""));
				mc["txt_chat"].text=arrQuickSay[cnt];
				mc_quick_say.visible=false;
				mc["btnQuickSay"].gotoAndStop(2);
				mc["txt_chat"].setSelection(mc["txt_chat"].text.length, mc["txt_chat"].text.length);
				focusManager.setFocus(mc["txt_chat"]);
				return;
			}
			switch(target.name) {
				case "btnSend":
					send(mc["txt_chat"].text);
					break;
				case "btnFace":
					mc["face"].visible = !mc["face"].visible;
					break;
				case "btnClose":
				case "btnclose":	
					show(false,false);
					break;
				case "btnMin":
					show(false,true);
					break;
				case "btnLookMenu":
					mc["mc_xiaLa"].visible=!mc["mc_xiaLa"].visible;
					break;
				case "btnQuickSay":
					mc_quick_say.visible=!mc_quick_say.visible;
					mc["btnQuickSay"].gotoAndStop(mc_quick_say.visible?1:2);
					break;
				case "btnJuBao":
					juBao(roleId);
					break;
			}
		}
		public function downHandler(me:MouseEvent) : void {
			var name:String=me.target.name;
			switch(me.type) {
				case MouseEvent.MOUSE_DOWN:
					PubData.AlertUI.setChildIndex(this,PubData.AlertUI.numChildren-1);
					this.startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					this.stopDrag();
					break;
				case MouseEvent.ROLL_OUT:
					if(name.indexOf("mc_xiaLa")==0)mc["mc_xiaLa"].visible=false;
					break;
			}
		}
		
		//2012-07-16 andy 快速回复
		private function mouseOutQuickHandle(e:MouseEvent):void
		{
			if(e.target.name.indexOf("item_quick_say")>=0)
				e.target["bg"].gotoAndStop(1);
		}
		
		private function mouseOverQuickHandle(e:MouseEvent):void
		{
			if(e.target.name.indexOf("item_quick_say")>=0)
				e.target["bg"].gotoAndStop(2);
		}
		/*******通讯***********/
		private function send(chatstr:String):void{
			mc["txt_chat"].text="";
			if (ChatFilterRobot.instance.isVerify(roleId,chatstr))
			{
				//达到验证条件
				ChatFilterRobot.instance.open(true);
				return;
			}
			
			sendPrivateMsg(chatstr,roleId);
			
		}
		
		public static function sendPrivateMsg(chatstr:String,roleId:int):void{
			var client:PacketCSSayPrivate=new PacketCSSayPrivate();
			client.userid=roleId;
			client.username=Data.myKing.name;
			//2012-06-13 andy 防止玩家发送：带html标签的内容
			while(chatstr.indexOf("<")>=0)chatstr=chatstr.replace("<","");
			while(chatstr.indexOf(">")>=0)chatstr=chatstr.replace(">","");
			client.content=chatstr;
			
			DataKey.instance.send(client);
		}
		public function updateMsg(p:PacketSCSayPrivate2):void{
			if(p.content=="")return;
			showMsg(Data.haoYou.fmtChat(p.username,p.content));
		}
		
		
		public function getID():int
		{
			return 1022;
		}
		
		
		private function showMsg(msg:String,isUpdate:Boolean=true) : void {
			if(msg==null||msg=="")return;
			if(content.numChildren>=HaoYouSet.MAX_CHAT){
				ht=content.getChildAt(0).height;
				for(i=0;i<30;i++){content.getChildAt(i).y-=ht;}
				content.removeChildAt(0);
			}
			var disO:Sprite = ItemManager.instance().getSiLiao();
			while(disO.numChildren>1)disO.removeChildAt(1);
			disO["txt"].mouseWheelEnabled=false;
			disO["txt"].width=320;
			fontPic(disO as MovieClip,msg);
			
			//disO["txt"].htmlText=msg;
			disO.y = content.height;
			content.addChild(disO);
			if(isUpdate){
				mc["sp"].update();
				mc["sp"].position = 100;
				content.x=3;
			}
		}
		private function updateAll() : void {
			while(content.numChildren>0)content.removeChildAt(0);
			var p:PacketSCSayPrivate2=Data.haoYou.getChatById(roleId);
			if(p==null)return;
			var arrMsg:Array=p.arrMsg;
			var disO:DisplayObject; 
			for each(var msg:String in arrMsg){
				showMsg(msg,false);
			}
			mc["sp"].update();
			mc["sp"].position = 100;
			content.x=3;
		}
		/**
		 *	组队 
		 */
		private function team() : void {
			var vo:PacketCSTeamInvit=new PacketCSTeamInvit();
			vo.roleid=roleId;
			DataKey.instance.send(vo);
		}
		
		/**
		 * 举报 2014－04－23
		 */
		private function juBao(roleid:int=0) : void {
			DataKey.instance.register(PacketWCReportChat.id,juBaoReturn);
			var client:PacketCWReportChat=new PacketCWReportChat();
			client.targetid=roleid;
			DataKey.instance.send(client);
		}
		private function juBaoReturn(p:PacketWCReportChat) : void {
			if(Lang.showResult(p)){
				Lang.showMsg(Lang.getClientMsg("10169_chatfriend"));
			}else{
				
			}
		}
		
		/********内部方法**********/
		private function fontPic(chatItem:MovieClip,msg:String):void {
			//这个点很特别，必须的有，否则最后一个表情可能会换行
			var spaceStr:String=".   ";
			//把表情的两个大括号去掉
			msg=msg.replace(/{/g,"").replace(/}/g,"");
			chatItem["txt"].htmlText=msg; 
			
			var rect:Rectangle=null;
			var face:MovieClip=null;
			var faceId:String=null;
			chatItem["txt"].height=chatItem["txt"].textHeight+6;
			var msg:String=chatItem["txt"].text;
			//把表情搞出来
			var arrFace:Array=new Array();
			i=msg.indexOf("F");
			while(i>=0) {
				faceId=msg.substr(i,4);
				arrFace.push(faceId);
				msg=msg.replace(faceId,spaceStr);
				i=msg.indexOf("F");
			}
			//替换表情
			chatItem["txt"].htmlText=msg;
			var cnt:int=0;
			i=msg.indexOf(spaceStr,cnt++);
			while(i>=0) {
				if(arrFace.length==0)break;
				rect=chatItem["txt"].getCharBoundaries(i);
				faceId=arrFace.shift();
				var d:DisplayObject = GamelibS.getswflink("libface",faceId);
				i=msg.indexOf(spaceStr,i+4);
				if(null == d){
					continue;
				}
				
				face= d as MovieClip;
				
				face.x=rect.x + chatItem["txt"].x;
				face.y=rect.y-3;
				face.width=22;
				face.height=22;
				
				if(face!=null)
					chatItem.addChild(face);
				
			}
			
			while(msg.indexOf(spaceStr)>=0)msg=msg.replace(spaceStr,"<font color='#000000'>.</font>   ");
			chatItem["txt"].htmlText=msg.indexOf(Data.myKing.name)>=0?"<font color='#CFCCCC'>"+msg+"</font>":"<font color='#24D900'>"+msg+"</font>";
			chatItem["txt"].height=chatItem["txt"].textHeight+8;
			
		}
	}
}
