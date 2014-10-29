package ui.base.shejiao.haoyou
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCSayPrivate2;
	import netc.packets2.PacketWCSayRoleInfo2;
	
	import nets.packets.PacketCSSayRoleInfo;
	
	import ui.base.mainStage.UI_index;
	
	import world.FileManager;

	/**
	 *	好友信息提醒控制【私聊】
	 *  2012-03-21 
	 */
	public class ChatWarningControl
	{
		private var i:int=0;
		private var len:int=0;
		//最大显示10条警告信息
		private const maxWarning:int=10;
		//最大显示100个聊天窗口
		private const maxChat:int=100;
		//警告单个位置宽度
		private const warningWidth:int=42;
//		//当前聊天对象
//		public var curChatUserId:int=0;
		
	
		public var arrWarning:Array;
		public var mapChat:HashMap;
		private var item:PacketSCSayPrivate2;
		//警告信息容器
		private var mc_warning:Sprite;
		private var warning:ChatWarning;
		private var chat:GameChatFriend;
		
		
		
		private static var _instance:ChatWarningControl;
		public static function getInstance():ChatWarningControl{
			if(_instance==null)
				_instance=new ChatWarningControl();
			return _instance;
		}
		public function ChatWarningControl(){
			arrWarning=new Array();
			mapChat=new HashMap();
			
			mc_warning=new Sprite();
			mc_warning.name="mc_warning";
//			mc_warning.x=-170;
			mc_warning.x=0;
			mc_warning.y=-160;
			UI_index.indexMC["mrb"].addChild(mc_warning);			
			
			mc_warning.addEventListener(MouseEvent.CLICK,mouseHandle);
			mc_warning.addEventListener(MouseEvent.MOUSE_OVER,mouseHandle);
			mc_warning.addEventListener(MouseEvent.MOUSE_OUT,mouseHandle);
		}
		private function mouseHandle(me:MouseEvent):void{
			if(me.target is ChatWarning){
				switch(me.type){
					case MouseEvent.MOUSE_OVER:
						(me.target as ChatWarning).showName(true);
						break;
					case MouseEvent.MOUSE_OUT:
						(me.target as ChatWarning).showName(false);
						break;
					case MouseEvent.CLICK:
						warning=me.target as ChatWarning;
						if(warning!=null){
							openChatWindow(warning.playerInfo);
						}
						break;
				}
			}
		}
		/**
		 *	直接打开聊天窗口 
		 */
		public function openChatWindow(v:PacketSCSayPrivate2):void{
			//检测是否对话已经打开 2013-08-09
			if(checkChatByRoleid(v.userid))return;
			
			chat=getChat();
			//最多打开100个聊天窗口,淡定
			if(chat!=null){
				chat.setData(v);
				chat.show(true);
				warning=checkWarning(v.userid);
				if(warning!=null){
					hideWarning(warning);
				}
			}else{
				
			}
		}
		
		/**
		 *	有消息 
		 */
		public function haveInfo(p:PacketSCSayPrivate2,fly:Boolean=true):void{
			if(checkInit()==false)return;
			//如果是自己直接显示，不需要飞出来
			if(p.userid==Data.myKing.roleID){
				chat=checkChat(p.touserid);
				if(chat!=null)chat.updateMsg(p);
				return;
			}
			chat=checkChat(p.userid);
			if(chat!=null&&chat.parent!=null){
				//聊天窗口已经打开
				chat.updateMsg(p);
				Data.haoYou.getChatById(p.userid).isRead=true;
			}else{
				warning=checkWarning(p.userid);
				//提示信息已经存在
				if(warning!=null){
					warning.playEffect(true);
				}else{
					warning=getWarningMc();
					if(warning!=null){
						warning.setData(p);
						arrWarning.push(warning);
						resetWarningPostion();
						warning.playEffect(fly);
						warning.visible=true;
						flyWarning(warning);
					}else{
						//当前信息已经达到上限显示，顶掉最前面一个
						warning=arrWarning[0];
						hideWarning(warning);
						haveInfo(p,fly);
						
						//mapWarningNew.put(p.userid,p);
					}
				}
			}
		}
		/**
		 *	在主界面聊天区域，点击私聊【先向服务器请求获得玩家信息】 
		 */
		public function getChatPlayerInfo(roleId:int=0):void{
			if(roleId==0)return;
			if(checkInit()==false)return;
			var client:PacketCSSayRoleInfo=new PacketCSSayRoleInfo();
			client.roleid=roleId;
			DataKey.instance.send(client);
		}
		public function getChatPlayerInfoReturn(v:PacketWCSayRoleInfo2):void{
			if(v.roleid==0){
				Lang.showMsg(Lang.getClientMsg("10018_hao_you"));
				return;
			}
			var chat:PacketSCSayPrivate2=new PacketSCSayPrivate2();
			chat.userid=v.roleid;
			chat.username=v.name;
			chat.headicon=v.headicon;
			chat.underwrite=v.underwrite;
			chat.underwrite_p1=v.underwrite_p1;
			chat.underwrite_p2=v.underwrite_p2;
			chat.vip=v.vip;
			
			openChatWindow(chat);
		}
		
		/***********内部方法******************/
		/**
		 * 得到警告元件
		 */
		private function checkWarning(roleId:int):ChatWarning{
			var len:int
			for(i=0;i<maxWarning;i++){
				warning=mc_warning.getChildByName("chatWarning"+i) as ChatWarning;
				
				if(null != warning)
				{
					if(warning.visible==true&&warning.roleId==roleId){
						return warning;
					}
				}
			}
			return null;
		}
		/**
		 * 得到空闲警告元件
		 */
		private function getWarningMc():ChatWarning{
			for(i=0;i<maxWarning;i++){
				warning=mc_warning.getChildByName("chatWarning"+i) as ChatWarning;
			
				if(warning!=null&&warning.visible==false){
					return warning;
				}
			}
			return null;
		}
		/**
		 *	点击警告元件，隐藏
		 */
		private function hideWarning(v:ChatWarning):void{
			if(v==null)return;
			v.visible=false;
			v.playEffect(false);
			arrWarning.splice(arrWarning.indexOf(v),1);
			item=Data.haoYou.getChatById(v.roleId);
			if(item!=null)item.isRead=true;
			resetWarningPostion();
		}
		
		private function resetIcon(dis:DisplayObject):void{
			TweenLite.killTweensOf(dis,true);
		}
		
		/**
		 *	警告元件重新排序显示 
		 */
		private function resetWarningPostion():void{
			i=0;
			len=(maxWarning-arrWarning.length)*warningWidth/2;
			for each(warning in arrWarning){
				//TweenLite.to(warning,2,{alpha:1,x:len+i*warningWidth});
				TweenLite.to(warning,1.5,{alpha:1,x:len+i*warningWidth,onComplete:resetIcon,onCompleteParams: [warning]});
				i++;
			}
		}
		/**
		 *	警告元件重新排序显示 
		 */
		private function flyWarning(v:ChatWarning):void{
			len=(maxWarning-arrWarning.length)*warningWidth/2;
			v.alpha=0;
			v.x=maxWarning*warningWidth;
			//TweenLite.to(warning,1.5,{alpha:1,x:len+(arrWarning.length-1)*warningWidth});
			TweenLite.to(warning,1.25,{alpha:1,x:len+(arrWarning.length-1)*warningWidth,onComplete:resetIcon,onCompleteParams: [v]});
		}
		/**
		 * 检查是否有展开聊天窗口
		 */
		private function checkChat(roleId:int):GameChatFriend{
			len=mapChat.size();
			for(i=0;i<len;i++){
				chat=mapChat.get(i) as GameChatFriend;
				if(chat.roleId==roleId&&chat.parent!=null){
					return chat;
				}
			}
			return null;
		}
		/**
		 * 获得聊天窗口
		 */
		private function getChat():GameChatFriend{
			len=mapChat.size();
			for(i=0;i<len;i++){
				chat=mapChat.get(i) as GameChatFriend;
				if(chat.roleId==0){
					return chat;
				}
			}
			if(len<maxChat&&GamelibS.isApplicationClass("win_si_liao")){
				chat=new GameChatFriend();
				chat.name="chat"+len;
				mapChat.put(len,chat);
				return chat;
			}
			return null;
		}
		/**
		 * 检测聊天窗口中是否有这个玩家
		 * 2013-08-09
		 */
		private function checkChatByRoleid(roleId:int):Boolean{
			len=mapChat.size();
			for(i=0;i<len;i++){
				chat=mapChat.get(i) as GameChatFriend;
				if(chat.roleId==roleId){
					return true;
				}
			}
			return false;
		}
		private function checkInit():Boolean{
			if(mc_warning.numChildren==0){
				init();
			}
			if(mc_warning.numChildren>0)
				return true;
			else
				return false;
		}
		/**
		 *	 
		 */
		private function init():void{
			if(GamelibS.isApplicationClass("ChatWarningOne")){
				for(i=0;i<maxWarning;i++){
					warning=new ChatWarning();
					warning.name="chatWarning"+i;
					mc_warning.addChild(warning);
				}
			}
		}
		
	}
}