package ui.view.view1.fuben
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_InstanceResModel;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.CheckPlayerMenu;
	import ui.frame.ImageUtils;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.desctip.GameTip;
	
	import world.FileManager;
	import world.WorldEvent;
	
	/**
	 *	副本队伍选择
	 *  suhang 2012-2-13
	 */
	public class FuBenDuiWu extends UIWindow
	{
		//玩家副本报名数据
		private var sslVec:Vector.<StructSignList2>;
		private var sprite : Sprite = new Sprite;
		private var showAll : Boolean = true;
		private var score : int = 0;
		public static var groupid : int;
		
		/**
		 * 
		 */ 
		public var btnZoomClick:Boolean = false;
		
		/**
		 * 从世界聊天频道获得要加入的副本ID 
		 */		
		private var m_instanceIDFromWorld:int;
		/**
		 * 从世界聊天频道获得要加入的副本队伍ID 
		 */	
		private var m_signIDFromeWorld:int;
		
		public function FuBenDuiWu(){
			
			super(getLink(WindowName.win_jia_dui));
		}
		
		public static var _instance : FuBenDuiWu = null;
		
		public static function get instance() : FuBenDuiWu {
			if (null == _instance)
			{
				_instance=new FuBenDuiWu();
				
				DataKey.instance.register(PacketSCPlayerListUpdate.id,SCPlayerListUpdate_Sta);
			}
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			
			this.visible = false;
			
			btnZoomClick = false;
			
			//副本报名信息列表返回
			uiRegister(PacketSCInstanceList.id,SCInstanceList);
			//玩家副本报名数据更新
			uiRegister(PacketSCPlayerListUpdate.id,SCPlayerListUpdate);
			//创建副本报名信息返回
			uiRegister(PacketSCCreateSign.id,SCCreateSign);
			//加入副本报名队伍返回
			uiRegister(PacketSCJoinSign.id,SCJoinSign);
			//快速加入队伍
			uiRegister(PacketSCFastJoin.id,SCFastJoin);
			//离开副本报名队伍返回
			uiRegister(PacketSCLeftSign.id,SCLeftSign);
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,messageTimer);
			
			//setTimeout(function():void{
				getInstanceList();
				
				if(!_autoJoin()){
					this.visible = true;
				}
				
			//},100);
			
			
		
		}
		
		private function messageTimer(e:WorldEvent) : void 
		{
			score++;
			if(score==2){
				getInstanceList();
			}
		}
		public var instanceListCount:int=0;
		private function SCInstanceList(p:IPacket) : void {
			var value:PacketSCInstanceList = p as PacketSCInstanceList;
			var sslVec2:Vector.<StructSignList2> = value.arrItemsignlist;
			var frea:Boolean = false;
			if(sslVec!=null&&sslVec2.length==sslVec.length){
				var list1:Vector.<StructSignPlayerInfo2>;
				var list2:Vector.<StructSignPlayerInfo2>;
				
				var sslVec2Len:uint = sslVec2.length;
				for(var i:int=0;i<sslVec2Len;i++){
					list1 = sslVec[i].arrItemplayerlist;
					list2 = sslVec2[i].arrItemplayerlist;
					if(list1.length==list2.length&&sslVec[i].entertype==sslVec2[i].entertype){
						for(var j:int=0;j<list1.length;j++){
							if(list1[j].roleid!=list2[j].roleid){
								frea = true;
								break;
							}
						}
					}else{
						frea = true;
						break;
					}
				}
			}else{
				frea = true;
			}
			
			if(frea){
				sslVec = sslVec2;
				showList();	
			}
		}
		
		private function SCLeftSign(p:PacketSCLeftSign2) : void {
			if(showResult(p)){
				getInstanceList();
				this.visible = true;
			}
		}
		
		private function showList() : void 
		{
			while(sprite.numChildren>0){
				sprite.removeChildAt(0);
			}
			var value:Pub_InstanceResModel = XmlManager.localres.getInstanceXml.getResPath(groupid) as Pub_InstanceResModel;
			if(sslVec!=null&&sslVec.length>0){
				sslVec.forEach(
					function(itemData:StructSignList2,index:int,arr:Vector.<StructSignList2>):void{
						var sspi:Vector.<StructSignPlayerInfo2> =itemData.arrItemplayerlist;
						var nowNum:int = sspi.length;
						var total:int = value.max_num;//itemData.entertype<3?itemData.entertype+3:5;
						if(nowNum==total&&!showAll)return;
						var itemDO:MovieClip = GamelibS.getswflink("game_index", "jiaru_item") as MovieClip;
						
						for(var k:int =5;k>=1;k--)
						{
							if(k <= value.max_num){
							
								itemDO["bd" + k.toString()]["mc_hole"].visible = true;								
							 
							}else{
								itemDO["bd" + k.toString()]["mc_hole"].visible = false;	
							}
							
							itemDO["bd"+k.toString()]["mc_hole"].mouseChildren = false;
						}
						
						itemDO["renshu"].text = nowNum+"/"+total;
						
						itemDO["jiangli"].text = value.instance_name;
//						itemDO["icon"].source = FileManager.instance.getFuBen2IconById(value.res_id);
						
						if(nowNum<total){
							itemDO["yiman"].visible = false;
						}else{
							itemDO["jiaru"].visible = false;
							itemDO["jiaru"].mouseChildren = true;
						}
						
						var len:int = sspi.length;
						for(var i:int=0;i<len;i++){
//							itemDO["bd"+(i+1)]["uil"].source = FileManager.instance.getHeadIconSById(sspi[i].iconid);
							ImageUtils.replaceImage(itemDO["bd"+(i+1)],itemDO["bd"+(i+1)]["uil"],FileManager.instance.getHeadIconSById(sspi[i].iconid));
							itemDO["bd"+(i+1)]["username"].text = sspi[i].rolename.length>6?sspi[i].rolename.substr(0,5)+"..":sspi[i].rolename;
							itemDO["bd"+(i+1)]["level"].text = sspi[i].level+Lang.getLabel("pub_ji");
							itemDO["bd"+(i+1)]["data"] = sspi[i];
							itemDO["bd"+(i+1)].mouseChildren = false;
						}
						
						for(var j:int=total;j<5;j++){
							itemDO["bd"+(j+1)].gotoAndStop(2);
							itemDO["bd"+(i+1)]["data"] = null;
						}
	                    
						itemDO.name = "item"+index;
						itemDO.data = itemData;
						itemDO.mouseChildren = true;
						itemDO.mouseEnabled = true;
						itemDO.y = index*(itemDO.height-35)-10;
						sprite.addChild(itemDO);
						
					}
				);
			}
			
			var itemDO2:MovieClip = GamelibS.getswflink("game_index", "jiaru_item") as MovieClip;
			itemDO2.y = sslVec.length*(itemDO2.height-35)-10;
			itemDO2["jiangli"].text = value.instance_name;
			itemDO2.data = {};
			itemDO2.data.signid = 0;
			itemDO2["yiman"].visible = false;			
			itemDO2["renshu"].text = "0/"+value.max_num;
			
			for(var k:int =5;k>=1;k--)
			{
				if(k <= value.max_num){
				//if(k <= 2){
					
					itemDO2["bd" + k.toString()]["mc_hole"].visible = true;								
					
				}else{
					itemDO2["bd" + k.toString()]["mc_hole"].visible = false;	
				}
				
				itemDO2["bd"+k.toString()]["mc_hole"].mouseChildren = false;
			}
			
			sprite.addChild(itemDO2);
			
			mc["list"].source = sprite;
		}
		
		public static function SCPlayerListUpdate_Sta(p:IPacket) : void {
			
			if(!FuBenDuiWu.instance.isOpen){
				
				FuBenDuiWu.instance.open(true);
				
				//
				var value:PacketSCPlayerListUpdate = p as PacketSCPlayerListUpdate;
				if(MyDuiWu._instance==null||MyDuiWu._instance.parent==null){
					UIMovieClip.currentObj = null;
					MyDuiWu.instance.open(true);
					//MyDuiWu.instance;
				}
				MyDuiWu._instance.showMessage(value);
				
				//
				GameTip.removeIconByActionId(MyDuiWu.ICONSN);
				
				//this.x = (GameIni.MAP_SIZE_W-this.width-MyDuiWu._instance.width)/2+10;
				//MyDuiWu._instance.x = (GameIni.MAP_SIZE_W-this.width-MyDuiWu._instance.width)/2+this.width+7;
				
				
			}
			
			
		}
		
		private function SCPlayerListUpdate(p:IPacket) : void {
			var value:PacketSCPlayerListUpdate = p as PacketSCPlayerListUpdate;
			if(MyDuiWu._instance==null||MyDuiWu._instance.parent==null){
				UIMovieClip.currentObj = null;
				MyDuiWu.instance.open();
			}
			MyDuiWu._instance.showMessage(value);
			this.x = (GameIni.MAP_SIZE_W-this.width-MyDuiWu._instance.width)/2+10;
			MyDuiWu._instance.x = (GameIni.MAP_SIZE_W-this.width-MyDuiWu._instance.width)/2+this.width+7;
		}
		
		private function SCCreateSign(p:IPacket) : void {
			if(showResult(p)){
				getInstanceList();
				this.visible = true;
			}
		}
		
		private function SCJoinSign(p:PacketSCJoinSign2) : void {
			if(showResult(p)){
				getInstanceList();
				this.visible = true;
			}else{
				
				if(19002 == p.tag){
				this.winClose();
				}
			}
		}
		
		public function getInstanceList():void{
			score = 0;
			var vo:PacketCSInstanceList = new PacketCSInstanceList();
			vo.groupid = groupid;
			uiSend(vo);
		}
			
		private function SCFastJoin(p:IPacket) : void {
			if(showResult(p)){
				this.visible = true;
			}
		}
		
		override public function mcHandler(target:Object):void 
		{
			super.mcHandler(target);
			
			_openCheckPlayerMenu(target);
			
			var vo2:PacketCSCreateSign;
			
			switch(target.name)
			{
				case "showType":
					target.selected=!target.selected;
					showAll = !target.selected;
					showList();
					break;
				case "jiaru":
					if(target.parent.data.signid==0){
						vo2 = new PacketCSCreateSign();
						vo2.groupid = groupid;
						uiSend(vo2);
					}else{
						var vo:PacketCSJoinSign = new PacketCSJoinSign();
						vo.signid = target.parent.data.signid;
						vo.groupid = groupid;
						uiSend(vo);	
					}
					break;
				case "btnQuikeEnter":
					var vo3:PacketCSFastJoin = new PacketCSFastJoin();
					vo3.groupid = groupid;
					uiSend(vo3);
					break;
				case "btnCreateArm":
					vo2 = new PacketCSCreateSign();
					vo2.groupid = groupid;
					uiSend(vo2);
					break;
				case "closeWin":
					if(MyDuiWu._instance==null||MyDuiWu._instance.parent==null){
						winClose();
					}else{
						alert.ShowMsg(Lang.getLabel("20008_fuben"),4,null,function():void{
							var vo:PacketCSLeftSign = new PacketCSLeftSign();
							vo.signid = MyDuiWu.signid;
							uiSend(vo);
							winClose();
							if(MyDuiWu.instance.isOpen)MyDuiWu.instance.winClose();
						});	
					}
					break;
				case "btnChangeFuBen":
					if(MyDuiWu._instance==null||MyDuiWu._instance.parent==null){
						winClose();
						
						FuBen.instance.open(true);
					}else{
						alert.ShowMsg(Lang.getLabel("20008_fuben"),4,null,function():void{
							var vo:PacketCSLeftSign = new PacketCSLeftSign();
							vo.signid = MyDuiWu.signid;
							uiSend(vo);
							winClose();
							FuBen.instance.open();
							if(MyDuiWu.instance.isOpen)MyDuiWu.instance.winClose();
						});	
					}
					
					break;
			}
		}	
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
			
			if(!btnZoomClick){
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,messageTimer);
				sslVec = null;
				while(sprite.numChildren>0){
					sprite.removeChildAt(0);
				}
			}
			
			btnZoomClick = false;
			
		}
		
		
		private function _openCheckPlayerMenu(target:Object):void
		{
			var _name:String = target.name;
			var _data:Object = null; 
			
			if(0 == _name.indexOf("bd"))
			{
				_data = target.data;
				if(null == _data)
				{
					return ;
				}
				
				if(Data.myKing.roleID == _data.roleid)
				{
					return ;
				}
				
				CheckPlayerMenu.getInstance().setData(_data);
				CheckPlayerMenu.getInstance().setPosition((target as MovieClip).stage.mouseX,(target as MovieClip).stage.mouseY);
				CheckPlayerMenu.getInstance().open(true,false);
			}
			
		}
		
		/**
		 * 从世界频道获得副本信息和队伍信息
		 * @param instanceID
		 * @param signID
		 * 
		 */		
		public function setFromWorld(instanceID:int,signID:int):void
		{
			this.m_instanceIDFromWorld = instanceID;
			this.m_signIDFromeWorld = signID;
			
			groupid = this.m_instanceIDFromWorld;
		}
		
		/**
		 * 自动加入到指定副本队伍 
		 * @param instanceID
		 * @param signID
		 * 
		 */		
		private function _autoJoin():Boolean
		{
			if(m_instanceIDFromWorld <= 0 || m_signIDFromeWorld <= 0)
			{
				return false;
			}

			var vo:PacketCSJoinSign = new PacketCSJoinSign();
			vo.signid = m_signIDFromeWorld
			vo.groupid = m_instanceIDFromWorld;
			uiSend(vo);	
			
			m_instanceIDFromWorld = 0;
			m_signIDFromeWorld = 0;
			
			return true;
		}
		
		override public function get height():Number{
			return 505;
		}
	}
}



