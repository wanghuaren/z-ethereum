package ui.view.view5.saloon
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_Top_PrizeResModel;
	import common.utils.CtrlFactory;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	/**
	 * 【排行榜奖励展示】界面
	 * 
	 */ 
	public class SaloonTopList extends UIWindow
	{
		private static var _instance:SaloonTopList;
		
		public static function getInstance():SaloonTopList
		{
			if (null == _instance)
			{
				_instance=new SaloonTopList();
			}
			
			return _instance;
		}
		
		public var saloon_id:int;
		
		/**
		 * 共6行，每行的格子个数
		 */ 
		public static const  line:Array = [8,8,8,8,8,8];
		
		public function SaloonTopList()
		{
			super(getLink(WindowName.win_saloon_top_list));
		}
		
		//面板初始化
		override protected function init():void
		{
			reset();			
		}
		
		public function reset():void
		{
			
			for(i=0;i<line.length;i++)
			{
				mc["txt_ming" + i.toString()].htmlText = "";			
			}
		
			clearItem(line);
		
			//
			showPackage(line);
			
			
		}
		
		/**
		 * 排行前三颜色
		 */ 
		private function getColor(k_x:int,k_content:String):String
		{
			if(1 == k_x)
			{
				return  "<b><font color='#FFBF12'>" +k_content + "</font></b>";
				
			}else if(2 == k_x)
			{
				return  "<b><font color='#F95EFF'>" + k_content + "</font></b>";
				
			}else if(3 == k_x)
			{
				return  "<b><font color='#00E4FF'>" + k_content + "</font></b>";
				
			}else
			{
				return  k_content;
			}
			
			return "";
		}
		
		/**
		 *	物品列表 
		 */
		private function showPackage(line:Array):void
		{
			
			var m:Pub_Top_PrizeResModel = XmlManager.localres.TopPrizeXml.getResPath(saloon_id) as Pub_Top_PrizeResModel;
								
			if(null == m)
			{
				return;
			}
			
			var len:int = line.length;
			
			for(var k:int=1;k<=len;k++)
			{								
				mc["txt_ming" + (k-1).toString()].htmlText = getColor(k,m["desc"+ k.toString()]);			
								
					var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(m["drop" + k.toString()]) as Vector.<Pub_DropResModel>;
										
					var item:Pub_ToolsResModel;
					arrayLen=arr.length;
					
					var iLen:int = line[k-1];
					for(var i:int=1;i<=iLen;i++)
					{
						item=null;
						child=mc["pic"+ k.toString() + i.toString()];
						if(i<=arrayLen)
							item=XmlManager.localres.getToolsXml.getResPath(arr[i-1].drop_item_id) as Pub_ToolsResModel;
						if(item!=null){
//							child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
							ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
							child["r_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);		
							var bag:StructBagCell2=new StructBagCell2();
							bag.itemid=item.tool_id;
							Data.beiBao.fillCahceData(bag);
													
							child.data=bag;
							CtrlFactory.getUIShow().addTip(child);
							ItemManager.instance().setEquipFace(child);
							
							//
							child.visible = true;
							
						}else{
							child["uil"].unload();
							child["r_num"].text="";
							child.data=null;
							CtrlFactory.getUIShow().removeTip(child);
							ItemManager.instance().setEquipFace(child,false);
							//
							child.visible = false;
						}
					}
				
			
			}
			
			
		}
		
		/**
		 *	换页时清理格子数据 
		 * 
		 */
		private function clearItem(line:Array):void
		{
						
			for(var k:int=1;k<=line.length;k++)
			{
				//----------------------------------------------------
				var _loc1:*;
				var len:int = line[k];
				
				for(i=1;i<=len;i++)
				{
					//_loc1=mc.getChildByName("item"+i);
					_loc1=mc.getChildByName("pic"+ k.toString() + i.toString());
					_loc1["uil"].unload();
					_loc1["r_num"].text="";
					_loc1.mouseChildren=false;
					_loc1.data=null;
					
					ItemManager.instance().setEquipFace(_loc1,false);
					
					_loc1.visible = false;
				}
				//----------------------------------------------------
			
			}
			
			
		}
		
		
		//列表中条目处理方法
//		private function callback(itemData:StructBagCell2,index:int,arr:Array):void 
//		{
//			//var pos:int=itemData.pos;
//			var pos:int= itemData.huodong_pos;
//			//var sprite:*=mc.getChildByName("item"+pos);			
//			var sprite:*=mc.getChildByName("pic"+pos);
//			
//			if(sprite==null)return;
//			sprite.mouseChildren=false;
//			sprite.data=itemData;
//			
//			ItemManager.instance().setEquipFace(sprite);
//			
//			sprite["uil"].source=itemData.icon;
//			sprite["r_num"].text=itemData.sort==13?"":itemData.num;
//			CtrlFactory.getUIShow().addTip(sprite);
//			//new MainDrag(sprite,null);
//		}
		
		
		
		
	}
}