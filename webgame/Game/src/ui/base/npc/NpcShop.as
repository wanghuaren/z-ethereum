package ui.base.npc
{
	import com.engine.utils.HashMap;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Shop_NormalResModel;
	import common.config.xmlres.server.Pub_Shop_PageResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.res.ResCtrl;
	
	import display.components.CmbArrange;
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import ui.base.jineng.Jineng;
	import ui.base.paihang.PaiHang;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	/**
	 *	npc商店
	 *  andy 2012-01-29 
	 */
	public class NpcShop extends UIWindow
	{
		// 魔纹兑换商店编号
		public static const JIE_ZHI_SHOP_ID:int = 70200010;
		//药店编号【秦阳成】
		public static const YAO_SHOP_ID:int=70100008;
		//饰品店编号【秦阳成】
		public static const SHI_PIN_SHOP_ID:int=70100011;
		//兑换商店
		public static const DUI_HUAN_SHOP_ID:int=70200001;
		
//		坐骑商店【兑换】 2012-11-26 策划说去掉兑换商店
//		public static const ZUO_QI_SHOP_ID:int=70100013;
		//坐骑商店【购买】 2012-10-10
		public static const ZUO_QI_SHOP_BUY_ID:int=70100013;
		//公用商店【购买】 2012-12-21 翅膀
		public static const PUB_SHOP_BUY_ID:int=70100020;		
		//珍宝兑换商店编号
//		public static const ZHEN_BAO_DUI_HUAN_SHOP_ID:int = 70200012;
		//装备商店编号
		public static const ZHUANG_BEI_JUAN_ZHOU_SHOP_ID:int = 70200002;
		
		public var shopId:int=0;
		private var arrMenu:Array=null;
		
		private static var map:HashMap=new HashMap();
		
		
		private static var _instance:NpcShop;
		public static function instance():NpcShop{
			if(_instance==null){
				_instance=new NpcShop();
			}
			
			return _instance;
		}
		public function NpcShop()
		{
			
			blmBtn=7;
			super(getLink(WindowName.win_npc_shang_dian));
		}
		override public function get height():Number{
			return 484;
		}
		/**
		 *	@param v  商店编号
		 *  @param v1 打开分页 
		 */
		public function setshopId(v:int,v1:int=1,must:Boolean=false):void{
			shopId=v;
			type=v1;
			super.open(must);
		}
		override protected function openFunction():void{
			return;
			init();
		}
		
		override protected function init():void {
			//super.sysAddEvent(mc["ui_page"],MoreLessPage.PAGE_CHANGE,pageChangeHandle);
			super.sysAddEvent(mc["txt_page"],MoreLessPage.PAGE_CHANGE,pageChangeHandle);
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD,bagAddHandler);
			
			super.pageSize=12;	
			for(i=1;i<=pageSize;i++){
				child=mc["item"+i];
				child.mouseChildren=false;
				child.visible=false;
			}	
			initMenu();
			type= type==0?1:type;
			NpcShopFilter.instance().setMc(mc as MovieClip);
			
			//
			if(shopId == ZHUANG_BEI_JUAN_ZHOU_SHOP_ID)
			{
				type = Data.myKing.metier;
			}
			
			mcHandler({name:"cbtn"+type});
			
		}
		
		override public function mcHandler(target:Object):void {
			super.mcHandler(target);
			NpcShopFilter.instance().mcHandler(target);
			var name:String=target.name;
			
			//点击菜单
			if(name.indexOf("cbtn")>=0){
				var vtpye:int=int(name.replace("cbtn",""));
				
				type=vtpye;
				if(shopId==DUI_HUAN_SHOP_ID){
					if(type==1){
						mc["cmb_metier"].visible=true;
						mc["cmb_level"].visible=true;
						PaiHang.getInstance().setMetierCmb(mc["cmb_metier"] as CmbArrange,cmbFunction);
						(mc["cmb_metier"] as CmbArrange).changeSelected(Data.myKing.metier);
						NpcShopFilter.instance().setCmbLevel(mc["cmb_level"] as CmbArrange,cmbLevelFunction);
						(mc["cmb_level"] as CmbArrange).changeSelected(NpcShopFilter.instance().getDefautLevelIndex());
					}else{
						refresh();
					}
				}else{
					mc["cmb_metier"].visible=false;
					mc["cmb_level"].visible=false;
					mc["txt_num"].htmlText="";
					var len:int=cacheTypeData(type).length;
					//mc["ui_page"].setMaxPage(1,Math.ceil(len/10));
					setMaxPage(1,Math.ceil(len/pageSize));
				}
				return;
			}
			
			
			//点击物品
			if(name.indexOf("item")>=0){
				super.itemSelected(target);
				if(shopId.toString().indexOf("702")==0){
					NpcBuy.instance().setType(3,target.data,true,0,refresh);
				}else{
					NpcBuy.instance().setType(1,target.data,true);
				}
				return;
			}
			
			
			//点击装备兑换过滤选择 2013-08-22
			if(name.indexOf("btnEquipLevel")>=0){
				len=cacheTypeData(type).length;
				//mc["ui_page"].setMaxPage(1,Math.ceil(len/10));
//				setMaxPage(1,Math.ceil(len/pageSize));
				return;
			}
			
			switch(name) {
				case "btnUpPage":
					_cur--;
					
					if(_cur < 1)
					{
						_cur = 1;
					}
					setMaxPage(_cur,_max);
					break;
				case "btnNextPage":
					_cur++;
					if(_cur > _max)
					{
						_cur = _max;
					}	
					setMaxPage(_cur,_max);
					break;
				
				default:"";
			}
		}
		private function refresh():void{
			if(shopId == DUI_HUAN_SHOP_ID){
				if(type==1)
					(mc["cmb_level"] as CmbArrange).changeSelected(NpcShopFilter.instance().getLevelIndex());
				else{
					var len:int=cacheTypeData(type).length;
					if(_cur==0)_cur=1;
					setMaxPage(_cur,Math.ceil(len/pageSize));
					if(type==2){
						var whiteId:int=11800140;
						var arrParam:Array=[];
						var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(whiteId) as Pub_ToolsResModel;
						if(tool!=null){
							count=Data.beiBao.getBeiBaoCountById(whiteId);
							arrParam[0]=count;
							arrParam[1]=tool.tool_name;
						}
						mc["txt_num"].htmlText=Lang.getLabel("10236_npcshop",arrParam);
					}else{
						mc["txt_num"].text="";
					}
				}
			}
			
		}
		
		/**
		 *	装备兑换选择职业 
		 */
		private function cmbFunction(ds:DispatchEvent):void{
			if(type==1){
				NpcShopFilter.instance().equip_metier=ds.getInfo.data;
				var len:int=cacheTypeData(type).length;
				//mc["ui_page"].setMaxPage(1,Math.ceil(len/10));
				setMaxPage(1,Math.ceil(len/pageSize));
			}else{
				
			}
		}
		/**
		 *	装备兑换选择等级 
		 */
		private function cmbLevelFunction(ds:DispatchEvent):void{
			var arrParam:Array=[];
			if(type==1){
				NpcShopFilter.instance().equip_level=ds.getInfo.data;
				var len:int=cacheTypeData(type).length;
				//mc["ui_page"].setMaxPage(1,Math.ceil(len/10));
				setMaxPage(1,Math.ceil(len/pageSize));
				
				var itemId:int=NpcShopFilter.instance().arrJuanZhou[NpcShopFilter.instance().getLevelIndex()];
				if(itemId>0){
					var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(itemId) as Pub_ToolsResModel;
					if(tool!=null){
						var count:int=Data.beiBao.getBeiBaoCountById(itemId);
						arrParam[0]=count;
						arrParam[1]=tool.tool_name;
					}
				}else{
					mc["txt_num"].htmlText="";
				}
				itemId=NpcShopFilter.instance().arrJuanZhou2[NpcShopFilter.instance().getLevelIndex()];
				if(itemId>0){
					tool=XmlManager.localres.getToolsXml.getResPath(itemId) as Pub_ToolsResModel;
					if(tool!=null){
						count=Data.beiBao.getBeiBaoCountById(itemId);
						arrParam[2]=count;
						arrParam[3]=tool.tool_name;
					}
				}else{
					mc["txt_num"].htmlText="";
				}
				//<font color='#FF9600'>当前拥有：</font>#param个#param<br/>               #param个#param
				//2013-11-28 去掉饰品卷轴
				mc["txt_num"].htmlText=Lang.getLabel("10226_npcshop",arrParam);
				
			}else{
				
			}
		}
		
		private function pageChangeHandle(e:DispatchEvent):void{
			var page:int=e.getInfo.count;
			initMenuList(page);
		}
		
		private var _cur:int;
		private var _max:int;
		public function setMaxPage(cur:int,max:int):void
		{
			mc['txt_page'].text = cur.toString() + "/" + max.toString();
			
			_cur = cur;			
			_max = max;
			
			(mc['txt_page'] as TextField).dispatchEvent(new DispatchEvent(MoreLessPage.PAGE_CHANGE,{count:cur}));
			
		}
		/**
		 *	材料数量有变化
		 *  2013-03-11 
		 */
		private function bagAddHandler(e:DispatchEvent):void {
			var itemId:int=int(e.getInfo.itemid);
			if(shopId==DUI_HUAN_SHOP_ID)
				setMaxPage(_cur,_max);
		}
		override public function winClose():void{
			super.winClose();
			//2012-12-10 andy 两个门派的买药任务
//			if(NpcShop.YAO_SHOP_ID==shopId){
//				if(MissionMain.instance.checkTaskIsHave(50100077,2)||
//					MissionMain.instance.checkTaskIsHave(50100146,2)||
//					MissionMain.instance.checkTaskIsHave(50100077,3)||
//					MissionMain.instance.checkTaskIsHave(50100146,3)
//				)
//					GameAutoPath.seek(30100136);
//			}
		}
		/**************内部方法***********/
		//初始化菜单
		private function initMenu():void{
			arrMenu=XmlManager.localres.getPubShopPageXml.getResPath2(shopId) as Array;
			var len:int=arrMenu.length;
			var menu:*=null;
			var item:Pub_Shop_PageResModel;
			
			for(i=1;i<=blmBtn;i++){
				menu=mc["cbtn"+i];
				if(menu==null)continue;
				item=arrMenu[i-1];
				if(i<=len){
					menu.visible=true;
					menu.label=item.page_name;
				}else{
					menu.visible=false;
				}
			}
			autoSetMenuWidth();
		}
		//初始化菜单列表
		private function initMenuList(page:int=1):void{
			var arr:Array=pageData(type,page);
			var len:int=arr.length;
			var child:*=null;
			var bag:StructBagCell2=null;
			var _skillID:int = 0;
			var tool:Pub_ToolsResModel=null;
			for(i=1;i<=super.pageSize;i++){
				child=mc["item"+i];
				child.mouseChildren=false;
				bag=arr[i-1];
				if (bag){
					if (bag.hasDataFilled==false){
						bag.hasDataFilled = true;
						if(bag.need_id>0){
							tool=XmlManager.localres.getToolsXml.getResPath(bag.need_id) as Pub_ToolsResModel;
							bag.need_name=tool.tool_name;
							bag.need_color=tool.tool_color;
						}
						
					}
				}
				if(i<=len){
					child.visible=true;
					
					child["txt_name"].htmlText="<font color='#"+ResCtrl.instance().arrColor[bag.toolColor]+"'>"+bag.itemname+"</font>";
					_skillID = Jineng.instance.checkSkillID(bag.itemid);
					if(Jineng.instance.hasStudySkill(_skillID))
					{
						child["txt_name"].htmlText += "<font color='#00FF00'><b>["+Lang.getLabel("pub_hasStudy")+"]</b></font>";
					}
					
					//兑换商店 702
					if(shopId.toString().indexOf("702")==0){
						child["txt_price"].htmlText=bag.need_num+Lang.getLabel("pub_ge")+" <font color='#"+ResCtrl.instance().arrColor[bag.need_color]+"'>"+bag.need_name+"</font>";
						//装备兑换
						if(shopId==DUI_HUAN_SHOP_ID){
							var count:int=Data.beiBao.getBeiBaoCountById(bag.need_id,true);
							if(count<bag.need_num){
								child["txt_price"].htmlText="<font color='#ff0000'>"+bag.need_num+Lang.getLabel("pub_ge")+"</font> <font color='#"+ResCtrl.instance().arrColor[bag.need_color]+"'>"+bag.need_name+"</font>";
							}
							if((type==1||type==2||type==5)&&
								Data.beiBao.isRoleHave(bag.itemid)||
								Data.beiBao.getBeiBaoCountById(bag.itemid)>0){
								child["txt_name"].htmlText="<font color='#"+ResCtrl.instance().arrColor[bag.toolColor]+"'>"+bag.itemname+"</font> "+Lang.getLabel("10227_npcshop");
							}
						}
					}else{
						child["txt_price"].htmlText=bag.buyprice1+" <font color='#ff9b0f'>"+Lang.getLabel("pub_yin_liang")+"</font>";
					}
					
					super.itemEvent(child,bag);	
					ItemManager.instance().setToolTipByData(child,bag);
					
					
				}else{
					child.visible=false;
				}
			}
		}
		//缓存数据
		public function cacheTypeData(type:int,shopid:int=0):Array{
			var arrRet:Array=null;
			if(shopid==0)shopid=shopId;
			var key:String=shopid+"_"+type;
			
			if(map.containsKey(key)){
				arrRet= map.get(key);
			}else{
				var arr:Array=XmlManager.localres.getPubShopNormalXml.getResPath2(shopid,type) as Array;
				arrRet=new Array();//329
				var bag:StructBagCell2=null;
				var tool:Pub_ToolsResModel=null;
				for each(var item:Pub_Shop_NormalResModel in arr){
					bag=new StructBagCell2();
					bag.itemid=item.tool_id;
					bag.equip_source=2;
					bag.need_id=item.need_tool_id;
					bag.need_num=item.need_tool_num;
					//					Data.beiBao.fillCahceData(bag);
					arrRet.push(bag);
				}
				XmlManager.localres.getToolsXml.fillItemData(arrRet);
				map.put(key,arrRet);
			}
			//二次过滤数据
			arrRet=NpcShopFilter.instance().filter(arrRet,shopid,type);
			return arrRet;
		}
		//分页数据
		private function pageData(type:int,page:int):Array{
			var arr:Array=cacheTypeData(type);
			var len:int=arr.length;
			var start:int=(page-1)*super.pageSize;
			var end:int=page*super.pageSize;
			var arrRet:Array=new Array();
			for(i=0;i<len;i++){
				if(i>=start&&i<end){
					arrRet.push(arr[i]);
				}
			}
			return arrRet;
		}
		
		override public function getID():int
		{
			return 1019;
		}
		
		/**
		 *	自动适应标签宽度 
		 *  @2012-05-17
		 */
		private function autoSetMenuWidth():void{
			var menu:*;
			for(i=1;i<=blmBtn;i++){
				menu=mc["cbtn"+i];
				if(menu==null)continue;
				num=menu["label"].length;
				//menu.width=num==2?45:num==3?55:65;
			}
			
			for(i=2;i<=blmBtn;i++){
				mc["cbtn"+i].x=mc["cbtn"+(i-1)].x+mc["cbtn"+(i-1)].width-3;
			}
		}
		
	}
}