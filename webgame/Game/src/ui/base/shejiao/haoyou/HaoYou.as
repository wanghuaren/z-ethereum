package ui.base.shejiao.haoyou
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.dataset.HaoYouSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.PacketSCSayPrivate2;
	import netc.packets2.StructEnemyItem2;
	import netc.packets2.StructFriendData2;
	import netc.packets2.StructGridPlayerInfo2;
	
	import nets.packets.PacketCSEnemyList;
	import nets.packets.PacketCSFriendDel;
	import nets.packets.PacketCSPlayerGetGrid;
	import nets.packets.PacketCSTeamInvit;
	import nets.packets.PacketSCEnemyList;
	import nets.packets.PacketSCPlayerGetGrid;
	import nets.packets.PacketWCFriendDel;
	
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;
	
	
	/**
	 * 好友主界面
	 * @author andy
	 * @2011-10-26
	 */
	public class HaoYou extends UIWindow{
		//列表内容容器
		private var mc_content:Sprite;
		//下拉菜单内容
		private var arrXiaLa:Array;
		private var curItem:Object;
		private var curData:StructFriendData2;
		private var item:StructFriendData2;
		private var arr:Vector.<StructFriendData2>=null;
		//附近玩家取回的数据
		private var arrNear:Vector.<StructFriendData2>;
		//好友数据【分页】
		private var arrFriend:Vector.<StructFriendData2>;
		/*
		* 最大数量：类型【1.好友,2.仇敌,3.黑名单4.附近】
		*/
		public static var _instance:HaoYou;
		public static function getInstance():HaoYou{
			if(_instance==null)
				_instance=new HaoYou();
			return _instance;
		}
		
		public function HaoYou() : void {
			blmBtn=4;
			//窗体_新好友
			super(getLink(WindowName.win_hao_you));
		}
		
		public function setType(v:int,must:Boolean=false):void{
			type=v;
			super.open();
		}
		
		override protected function init():void
		{
			if(arrNear==null){
				arrNear=new Vector.<StructFriendData2>;
				arrFriend=new Vector.<StructFriendData2>;
				arrXiaLa=new Array();
				arrXiaLa[1]=[Lang.getLabel("pub_cha_kan"),Lang.getLabel("pub_si_liao"),Lang.getLabel("pub_zu_dui"),Lang.getLabel("pub_shan_chu"),Lang.getLabel("pub_la_hei")];
				arrXiaLa[2]=[Lang.getLabel("pub_cha_kan"),Lang.getLabel("pub_si_liao"),Lang.getLabel("pub_zu_dui"),Lang.getLabel("pub_add_friend"),Lang.getLabel("pub_la_hei"),Lang.getLabel("pub_fu_zhi")];
				arrXiaLa[4]=[Lang.getLabel("pub_cha_kan"),Lang.getLabel("pub_jie_chu")];
				arrXiaLa[3]=[Lang.getLabel("pub_cha_kan"),Lang.getLabel("pub_si_liao"),Lang.getLabel("pub_zu_dui"),Lang.getLabel("pub_add_friend")];
				mc_content=new Sprite();
				mc_content.y=170;
				mc_content.x=44;
				mc.addChild(mc_content);
				mc.swapChildren(mc_content,mc["mc_xiaLa"]);
			}
			super.sysAddEvent(mc_content,MouseEvent.MOUSE_OVER,overHandle);
			super.sysAddEvent(Data.haoYou,HaoYouSet.FRIEND_UPDATE,addFreindReturn);
			super.sysAddEvent(GameClock.instance,WorldEvent.CLOCK__SECOND200,shanShuo);
			super.sysAddEvent(Data.myKing,MyCharacterSet.UNDER_WRITE_UPDATE,underWriteUpdate);
			super.uiRegister(PacketSCPlayerGetGrid.id,getNearReturn);
			mc["mc_xiaLa"].addEventListener(MouseEvent.ROLL_OUT,mouseOutHandle);
			mc["mc_xiaLa"].visible=false;
			var headIcon:String=FileManager.instance.getHeadIconMById(Data.myKing.Icon);
//			mc["icon"].source=headIcon;
			ImageUtils.replaceImage(mc,mc["icon"],headIcon);
			mc["txt_mingZi"].text = Data.myKing.name;
			
			
			var v1:int = Data.myKing.UnderWrite;
			var v2:int = Data.myKing.UnderWrite_p1;
			var v3:int = Data.myKing.UnderWrite_p2;
			mc["txt_qianMing"].text=Data.haoYou.getQianMing(v1,v2,v3,true);
			super.sysAddEvent(mc["mc_action"]["ui_page"],MoreLessPage.PAGE_CHANGE,changePage);
			if(type==0)type=1;
			mcHandler({name:"cbtn"+type});	
			
			//test
			//Data.haoYou.setEnemyList(null);
		}
		// 面板双击事件
		override protected function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
			if(name.indexOf("item")>=0){
				ChatWarningControl.getInstance().getChatPlayerInfo(curData.roleid);
				mc["mc_xiaLa"].visible=false;
			}
		}	
		private function overHandle(e:MouseEvent):void{
			var nm:String=e.target.name;
			if(nm.indexOf("item")==0&&type!=2){
				item=e.target.data;
				e.target.tipParam=[item.rolename,item.jobName,item.level,XmlRes.getZhenYing(item.camp)];
			}
		}
		private function mouseOutHandle(e:MouseEvent):void{
			mc["mc_xiaLa"].visible=false;
		}
		override public function mcHandler(target : Object) : void {
			super.mcHandler(target);
			//下拉菜单
			mc["mc_xiaLa"].visible=false;
			//主菜单
			if(target.name.indexOf("cbtn")>=0){
				 var num:int=target.name.replace("cbtn","");
				 if(num!=type){
					curPage=0;
				 	type=num;
				 }
				 mc["mc_action"].gotoAndStop(type);
				 mc["mc_title"].gotoAndStop(type);
				 mc["mc_xiaLa"].visible=false;
				 var len:int=arrXiaLa[type].length;
				 for(i=1;i<=10;i++){
				 	if(i<=len){
						mc["mc_xiaLa"]["abtn"+i].label=arrXiaLa[type][i-1];
						mc["mc_xiaLa"]["abtn"+i].visible=true;
					}else{
						mc["mc_xiaLa"]["abtn"+i].visible=false;
					}
				 }
				 mc["mc_xiaLa"]["mc_bg"].height=len*30+20;
				 
				 if(type==3){
					 super.curPage=1;
					 super.total=1;
					 mc["mc_action"]["ui_page"].setMaxPage(super.curPage,super.total);
				 }else if(type==2){
					 enemyList();
				 }else{
					 count=Data.haoYou.getFriendCount(type);
					 super.total=Math.ceil(count/HaoYouSet.PAGE_COUNT);
					 mc["txt_count"].text=count+"/"+(type==1?100:20);
					 if(total==0){
					 	super.curPage=0;
					 }else{
					 	if(curPage>total)curPage=total;
						if(curPage==0)curPage=1;
					 }
					 mc["mc_action"]["ui_page"].setMaxPage(super.curPage,super.total);
				 }
				 return;
			}else if(target.name.indexOf("abtn")>=0){
				
				switch(target.label){
					case Lang.getLabel("pub_cha_kan"):
						//查看
						JiaoSeLook.instance().setRoleId(curData.roleid);
						break;
					case Lang.getLabel("pub_si_liao"):
						//私聊
						ChatWarningControl.getInstance().getChatPlayerInfo(curData.roleid);
						break;
					case Lang.getLabel("pub_zu_dui"):
						//组队
						team();
						break;
					case Lang.getLabel("pub_shan_chu"):
						//删除
						alert.ShowMsg(Lang.getLabel(type==1?"10038_hao_you":"10035_hao_you",[curData.rolename]),4,null,delFreind,type,0);
						break;
					case Lang.getLabel("pub_add_friend"):
						//加为好友
						GameFindFriend.addFriend(curData.rolename,1);
						break;
					case Lang.getLabel("pub_jie_chu"):
						//解除
						delFreind(4);
						break;
					case Lang.getLabel("pub_la_hei"):
						//拉黑
						GameFindFriend.addFriend(curData.rolename,4);
						break;
					case Lang.getLabel("pub_invite_jiazu"):
						//家族邀请
						UI_index.UIAct.jzInvite(curData.rolename);
						break;
					case Lang.getLabel("pub_fu_zhi"):
						//复制
						StringUtils.copyFont(curData.rolename);
						break;
					
				}
				return;
				
			}else if(target.name.indexOf("item")>=0){
				//点击列表条目
				(target as MovieClip).dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
				mc["mc_xiaLa"].y=mc.mouseY;
				mc["mc_xiaLa"].x=mc.mouseX;
				mc["mc_xiaLa"].visible=true;
				this.curItem=target;
				if(target.data is StructEnemyItem2){
					var struct:StructFriendData2=new StructFriendData2();
					struct.roleid=(target.data as StructEnemyItem2).userid;
					struct.rolename=(target.data as StructEnemyItem2).king_name;
					this.curData=struct;
				}else
					this.curData=target.data;
				super.itemSelected(target);
				return;
				
			}
			switch(target.name) {
				case "btn_addFriend":
				case "btn_addFriend2":
					//输入好友名字，添加好友
					GameFindFriend.getInstance().setType(1);
					break;
				case "btn_addBlack":
					//输入好友名字，添加黑名单
					GameFindFriend.getInstance().setType(4);
					break;
				case "btn_addFriendNear":
					//2012-07-01 附近好友，直接添加
					var roleName:String=target.parent.data.rolename;
					GameFindFriend.addFriend(roleName,1);
					break;
			}
		}
		/**
		 *	翻页 【好友列表，附近玩家】
		 */
		private function changePage(e:DispatchEvent=null):void{
			super.curPage=e.getInfo.count;
			if(type==3){
				var cleint:PacketCSPlayerGetGrid=new PacketCSPlayerGetGrid();
				cleint.noteam=2;
				cleint.page=super.curPage;
				super.uiSend(cleint);
			}else if(type==2){
				var vecEnemy:Vector.<StructEnemyItem2>=Data.haoYou.getEnemyByPage(curPage);
				while(mc_content.numChildren>0)mc_content.removeChildAt(0);
				vecEnemy.forEach(callback1);
				CtrlFactory.getUIShow().showList2(mc_content,1,0,42);
			}else{
				arrFriend=Data.haoYou.getFriendByPage(super.curPage,type);
				WCFriendList();
			}
		}
		
		/************通讯****************/
		/**
		 *	添加好友 
		 */
		private function addFreindReturn(e:DispatchEvent=null):void{
			if(type!=3)
			mcHandler(mc["cbtn"+type]);
		}
		/**
		 *	删除好友返回 
		 */
		private function delFreind(obj:int=0) : void {
			if(curData==null||obj==0)return;
			this.uiRegister(PacketWCFriendDel.id,delFreindReturn);
			var client:PacketCSFriendDel=new PacketCSFriendDel();
			client.roleid=curData.roleid;
			client.type=obj;
			this.uiSend(client);
		}
		private function delFreindReturn(p:PacketWCFriendDel) : void {
			if(super.showResult(p)){
				if(type!=3)
					mcHandler(mc["cbtn"+type]);
			}else{
				
			}
		}

		/**
		 *	组队 
		 */
		private function team() : void {
			if(curData==null)return;
			var vo:PacketCSTeamInvit=new PacketCSTeamInvit();
			vo.roleid=curData.roleid;
			uiSend(vo);
		}

		/**
		 *	得到附近玩家 
		 *  @2012-07-12 分页显示
		 */
		private function getNearReturn(p:PacketSCPlayerGetGrid=null):void{
			if(type!=3)return;
			super.total=p.totalpage;
			var vecPlayer:Vector.<StructGridPlayerInfo2>=p.arrItemGridPlayerInfo;
			var len:int=vecPlayer.length;
		
			if(super.total==0){
				mc["mc_action"]["ui_page"].count=0;
			}
			mc["txt_count"].text="";
			mc["mc_action"]["ui_page"].max=super.total;
			mc["mc_action"]["ui_page"].setStatus();
			while(arrNear.length>0)arrNear.pop();
			
			

			var player:StructGridPlayerInfo2=null;
			
			for (i= len- 1; i >= 0; i--)
			{
				player=vecPlayer[i];
				if (player.roleID != Data.myKing.roleID)
				{
					item=new StructFriendData2();
					item.roleid=player.roleID;
					item.level=player.level;
					item.rolename=player.rolename;
					item.headicon=player.headicon;
					item.headIconPath=FileManager.instance.getHeadIconSById(item.headicon);
					item.job=player.metier;
					item.jobName=XmlRes.GetJobNameById(item.job);
					item.vip=player.vip;
					item.camp=player.camp;
					item.online=1;
					item.underwrite=player.underwrite;
					item.underwrite_p1=player.underwrite_p1;
					item.underwrite_p2=player.underwrite_p2;
					item.qqyellowvip=player.qqyellowvip;
					
					item.qianMing=Data.haoYou.getQianMing(player.underwrite,player.underwrite_p1,player.underwrite_p2,true);
					
					arrNear.push(item);
				}
			}
			WCFriendList();
		}

		/**
		 *	好友列表 
		 */
		public function WCFriendList(e:DispatchEvent=null) : void {
			if(type==3){
				//附近玩家
				arr=arrNear;
			}else{
				arr=this.arrFriend;
			}
			while(mc_content.numChildren>0)mc_content.removeChildAt(0);
			arr.forEach(callback);
			CtrlFactory.getUIShow().showList2(mc_content,1,0,28);
			//指引
			if(type==3&&arrNear.length>0){
				
			}
		
		}
		//列表中条目处理方法
		private function callback(itemData:StructFriendData2,index:int,arr:Vector.<StructFriendData2>):void {
			var sprite:MovieClip=ItemManager.instance().getFriendItem(itemData.roleid) as MovieClip;
			super.itemEvent(sprite,itemData,true);
			sprite["txt_name"].mouseEnabled=false;
//			sprite["txt_qianMing"].mouseEnabled=false;
			sprite["mcQQYellowDiamond"].mouseEnabled=false;
			sprite["bg"].mouseEnabled=false;
			
			
			sprite["name"]="item"+(index+1);
			sprite["txt_name"].text=itemData.rolename;
			sprite["txt_prof"].text=itemData.jobName;
			sprite["txt_level"].text=itemData.level.toString();
//			sprite["txt_qianMing"].text=itemData.qianMing.substring(0,10)+"...";
//			sprite["uil_head"].source=itemData.headIconPath;
			
			YellowDiamond.getInstance().handleYellowDiamondMC2(sprite["mcQQYellowDiamond"], itemData.qqyellowvip);

			CtrlFactory.getUIShow().setColor(sprite,itemData.online==1?1:2);
			sprite.alpha=itemData.online==1?1:.6;
			mc_content.addChild(sprite);
			//悬浮信息
			Lang.addTip(sprite,"hao_you_tip");
			sprite.tipParam=[itemData.rolename,itemData.jobName,itemData.level];
			//2012－07－10
			sprite["btn_addFriendNear"].visible=type==3;
		}
		private function callback1(itemData:StructEnemyItem2,index:int,arr:Vector.<StructEnemyItem2>):void {
			var sprite:*=ItemManager.instance().getEnemyItem(index);
			if(sprite==null)return;
			sprite["name"]="item"+(index+1);
			sprite.data=itemData;
			//地图名字
			var mapName:String="";
			var map:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(itemData.map_id) as Pub_MapResModel;
			if(map!=null)mapName=map.map_title;
			//日期时间
			var date:Date=new Date();
			date.time=itemData.killtime*1000;
			var datetime:String=date.fullYear+"."+(date.month+1)+"."+date.date+" "+date.hours+":"+(date.minutes<10?"0"+date.minutes:date.minutes);
			var desc:String=Lang.getLabel("10237_haoyou",[(curPage-1)*HaoYouSet.PAGE_COUNT_ENEMY+(index+1),datetime,itemData.king_name,mapName]) ;
			
			sprite["txt_desc"].htmlText=desc;
			
			mc_content.addChild(sprite);
		
		}
		
		/**
		 *	 仇人列表
		 */
		private function enemyList():void
		{
			this.uiRegister(PacketSCEnemyList.id, SCEnemyListReturn);
			var cleint:PacketCSEnemyList=new PacketCSEnemyList();

			uiSend(cleint);
			
			SCEnemyListReturn(null);
		}
		
		private function SCEnemyListReturn(p:PacketSCEnemyList):void
		{
			
				count=Data.haoYou.getEnemyCount();
				super.total=Math.ceil(count/HaoYouSet.PAGE_COUNT_ENEMY);
				mc["txt_count"].text=count+"/"+(type==1?100:20);
				if(total==0){
					super.curPage=0;
				}else{
					if(curPage>total)curPage=total;
					if(curPage==0)curPage=1;
				}
				mc["mc_action"]["ui_page"].setMaxPage(super.curPage,super.total);
		}

		/******内部方法******/

		/**
		 *	如果好友有信息，闪烁【200毫秒】 
		 */
		private var timeCount:int=0;
		private function shanShuo(w:WorldEvent):void{
			//附近玩家5秒刷新
			timeCount++;
			if(type==3&&timeCount%25==0){
				//mcHandler({name:"cbtn3"});
			}
			if(type==2)return;
			if(arr==null||arr.length==0)return;
			var len:int=arr.length;
			var child:MovieClip;
			var chat:PacketSCSayPrivate2
			for(i=1;i<=len;i++){
				child=mc_content.getChildByName("item"+i) as MovieClip;
				if(child!=null&&child.hasOwnProperty("data")&&child.data!=null){
					chat=Data.haoYou.getChatById(child.data.roleid);
//					if(chat!=null&&chat.isRead==false){
//						if(child["uil_head"].x==4){
//							child["uil_head"].x=6;child["uil_head"].y=10;
//						}else{
//							child["uil_head"].x=4;child["uil_head"].y=8;
//						}
//					}else{
//						child["uil_head"].x=4;child["uil_head"].y=8;
//					}
				}
			}
		}
		/**
		 * 签名有更新
		 */
		private function underWriteUpdate(e:DispatchEvent):void{
			var v1:int = Data.myKing.UnderWrite;
			var v2:int = Data.myKing.UnderWrite_p1;
			var v3:int = Data.myKing.UnderWrite_p2;
			mc["txt_qianMing"].text=Data.haoYou.getQianMing(v1,v2,v3,true);
		}
		
		override protected  function windowClose() : void {
			super.windowClose();
		}
		
		override public function getID():int
		{
			return 1009;
		}
	}
}
