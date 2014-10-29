package ui.view.view2.liandanlu
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_GemResModel;
	import common.managers.Lang;
	import common.utils.ControlPage;
	import common.utils.CtrlFactory;
	import common.utils.drag.MainDrag;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructGemInfo2;
	import netc.packets2.StructGemInfoPos2;
	
	import nets.packets.PacketCSEquipStrongClear;
	import nets.packets.PacketCSGemDown;
	import nets.packets.PacketCSGemUp;
	import nets.packets.PacketSCEquipInherit;
	import nets.packets.PacketSCEquipStrongClear;
	import nets.packets.PacketSCGemDown;
	import nets.packets.PacketSCGemUp;
	
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;
	import ui.base.jiaose.JiaoSe;

	/**
	 *	宝石镶嵌【锻造】
	 *  andy 2014-05-13  第一次做
	 *  andy 2014-05-14  第二次做
	 *  andy 2014-05-16  第三次做，愚蠢的决定，三天做三个版本
	 */
	public class BSXQ extends UIPanel
	{
		//原装备
		private var curData:StructBagCell2;
		private var selectItem:MovieClip;
		private var sp_equip_content:Sprite;
		
		private static var _instance:BSXQ;
		public static function instance():BSXQ{
			if(_instance==null){
				_instance=new BSXQ();
			}
			return _instance;
		}
		
		public function BSXQ(){
			super(this.getLink(WindowName.win_bs_xq));
		}
		override public function init():void{
			super.init();
			
			var gem:Pub_GemResModel=null;
			sp_equip_content=new Sprite();
			for(i=1;i<=JiaoSe.EQUIP_COUNT;i++){
				child=ItemManager.instance().getStoneEquip(i) as MovieClip;
				child.name=	"equip_item"+i;
				if(child==null)continue;
				child["mc_select"].visible=false;
				child["mc_select"].mouseChildren=false;
				child["mc_icon"].mouseChildren=false;
				child["mc_bg_name"].gotoAndStop(i);
				gem=XmlManager.localres.pubGemXml.getResPath(i) as Pub_GemResModel;
				if(gem==null)continue;
				if(Data.myKing.level>=gem.open_lv){
					//身上装备
					var equip:StructBagCell2=Data.beiBao.getRoleEquipByPos(BeiBaoSet.ZHUANGBEI_INDEX+i-1);
					//对应宝石
					var stones:Vector.<StructGemInfo2>=Data.beiBao.getStoneByEquipPos(i);
					var haveStone:Boolean=false;
					for each(var stone:StructGemInfo2 in stones){
						if(stone.toolId>0){
							haveStone=true;
							break;
						}
					}
					
					

					if((equip!=null&&equip.equip_hole>0)||(equip==null&&haveStone)){
						sp_equip_content.addChild(child);
					}
				}	
			}
			CtrlFactory.getUIShow().showList2(sp_equip_content,1,0,66);
			sp_equip_content.x=0;
			//sp_equip_content.y=15;
			mc["sp_equip2"].source=sp_equip_content;
			show();
			
			//
			ItemManager.instance().removeToolTip(mc["mc_result"]);
			for(var k:int=0;k<3;k++){
				child=mc["mc_stone"+(k+1)];
				child["txt_name"].htmlText="";
				
				CtrlFactory.getUIShow().setColor(child, 1);
				ItemManager.instance().removeToolTip(child["mc_stone_icon"]);
			}
			selectItem=null;
			curData=null;
			
			//显示宝石
			super.pageSize=14;
			super.curPage=1;
			setPage();
			
			NewGuestModel.getInstance().handleNewGuestEvent(1017,1,mc);
		}	
		private function setPage():void{
			arrPage=Data.beiBao.getBeiBaoBySort(17,true);	
			arrPage.sortOn("stoneLevel",Array.NUMERIC|Array.DESCENDING);
			//2014-06-13 根据装备筛选宝石
			if(curData!=null){
				var gem:Pub_GemResModel=XmlManager.localres.pubGemXml.getResPath(curData.equip_type) as Pub_GemResModel;
				var stoneTypes:String=gem.gem_sort1+""+gem.gem_sort2+""+gem.gem_sort3+""+gem.gem_sort4+"";
				var stoneType:String="";
				var temp:Array=[];
				for each(var bag:StructBagCell2 in arrPage){
					stoneType=bag.itemid.toString().substr(4,1);
					if(stoneTypes.indexOf(stoneType)!=-1){
						temp.push(bag);
					}
				}
				arrPage=temp;
			}else{
				arrPage=[];
			}
			
			if(curPage==0)curPage=1;
			ControlPage.getInstance().setPage(mc["mc_page"],arrPage,pageSize,curPage,pageChangeHandle);
		}
		/**
		 *	翻页 
		 */
		private function pageChangeHandle(e:DispatchEvent):void{
			super.curPage=e.getInfo.count;
			
			var len:int=super.arrPage.length;
			var start:int=(curPage-1)*super.pageSize;
			var end:int=curPage*super.pageSize;;
			var arrBag:Array=[];
			for(var i:int=0;i<len;i++){
				if(i>=start&&i<end){
					arrBag.push(super.arrPage[i]);
				}
			}
			len=arrBag.length;
			for(i=0;i<super.pageSize;i++){
				if(i<len){
					//MainDrag.getInstance().regDrag(mc["item"+(i+1)],arrBag[i]);
					ItemManager.instance().setToolTipByData(mc["item"+(i+1)],arrBag[i]);
				}else{
					ItemManager.instance().removeToolTip(mc["item"+(i+1)]);
				}
			}
		}
		
		override public function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
			
			//点击宝石摘除
			if(name.indexOf("mc_stone_icon")==0&&target.data!=null&&target.parent.name.indexOf("mc_stone")==0){
				var targetpos:int=int(selectItem.name.replace("equip_item",""));
				var holePos:int=int(target.parent.name.replace("mc_stone",""));
				
				CSGemDown(targetpos,holePos);
				
				return;
			}
		}	
		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			
			if(name.indexOf("item")==0){
				if(target.data==null)return;
				
				CSGemUp(target.data.pos);
				return;
			}
			//点击装备
			if(target.name.indexOf("equip_item")==0||target.parent.name.indexOf("equip_item")==0){
				selectItem=target.name.indexOf("equip_item")==0?target as MovieClip:target.parent;
				curData=selectItem["mc_icon"].data;
				selectItem["mc_select"].visible=true;
				NewGuestModel.getInstance().handleNewGuestEvent(1017,2,mc);
				for(i=1;i<=JiaoSe.EQUIP_COUNT;i++){
					child=sp_equip_content.getChildByName("equip_item"+i) as MovieClip;
					if(child==null)continue;
					child["mc_select"].visible=child==selectItem;
				}
				clickItem();
				return;
			}
			if(name.indexOf("mc_not_show")==0&&target.parent.name.indexOf("item")==0){
			
			}
			
			switch(name){	
				case "":
					
					break;
			}
		}

		public function dragUp(end:Sprite,start:StructBagCell2):void{
			if(end==null || start==null)return;
			var holePos:int=int(end.parent.name.replace("mc_stone",""));
			//CSGemUp(start.pos,holePos);
		}
		
		private function show():void{
			for(i=1;i<=JiaoSe.EQUIP_COUNT;i++){
				selectChange(i);
			}
		}
		private function selectChange(equip_pos:int):void{
			var equip:StructBagCell2=null;
			var stones:Vector.<StructGemInfo2>=null;
			var stone:StructGemInfo2=null;
			var stoneData:StructBagCell2=null;
			stones=Data.beiBao.getStoneByEquipPos(equip_pos);
			//test
//				stones=new Vector.<StructGemInfo2>();
//				stone=new StructGemInfo2();stone.toolId=11701001;
//				stones.push(stone);
			
			child=sp_equip_content.getChildByName("equip_item"+equip_pos) as MovieClip;
			if(child==null)return;
			child["txt_name"].mouseEnabled=false;
			equip=Data.beiBao.getRoleEquipByPos(BeiBaoSet.ZHUANGBEI_INDEX+equip_pos-1);
			if(equip==null){
				ItemManager.instance().removeToolTip(child["mc_icon"]);
				child["txt_name"].text="";
			}else{
				child["txt_name"].htmlText=ResCtrl.instance().getFontByColor(equip.itemname,equip.toolColor);
				ItemManager.instance().setToolTipByData(child["mc_icon"],equip);;
			}
			for(var k:int=0;k<3;k++){
				
				ItemManager.instance().removeToolTip(child["stone"+(k+1)]);
				if(equip!=null&&k<equip.equip_hole){
					CtrlFactory.getUIShow().setColor(child["stone"+(k+1)], 1);
					child["stone"+(k+1)].visible=true;
				}else{
					CtrlFactory.getUIShow().setColor(child["stone"+(k+1)], 2);
					child["stone"+(k+1)].visible=false;
					//如果这个孔有宝石也显示
					if(stones!=null&&k<stones.length&&stones[k]!=null&&stones[k].toolId>0)child["stone"+(k+1)].visible=true;
				}
			}
			var haveStone:Boolean=false;
			if(stones!=null&&stones.length>0){
				for(k=0;k<stones.length;k++){
					stone=stones[k];
					if(stone.toolId==0)continue;
					stoneData=new StructBagCell2();
					stoneData.itemid=stone.toolId;
					Data.beiBao.fillCahceData(stoneData);
					ItemManager.instance().setToolTipByData(child["stone"+(k+1)],stoneData);
					haveStone=true;
				}
			}else{
				
			}
			child["mc_xq"].visible=!haveStone;
			child["mc_xq"].mouseEnabled=child["mc_xq"].mouseChildren=false;
		}
		/**
		 *	选中装备 
		 */
		public function clickItem():void{
			if(curData!=null)
				ItemManager.instance().setToolTipByData(mc["mc_result"],curData,1);
			else
				ItemManager.instance().removeToolTip(mc["mc_result"]);
			var gem:Pub_GemResModel=XmlManager.localres.pubGemXml.getResPath(getSelectEquipPos()) as Pub_GemResModel;
			for(var k:int=0;k<3;k++){
				child=mc["mc_stone"+(k+1)];
				ItemManager.instance().removeToolTip(child["mc_stone_icon"]);
				child["txt_name"].htmlText="";
				//child["txt_desc"].htmlText="";

				if(curData!=null&&k<curData.equip_hole){
					CtrlFactory.getUIShow().setColor(child, 1);
					if(gem!=null){
						child["txt_name"].htmlText=Lang.getLabel("1023"+gem["gem_sort"+(k+1)]+"_baoshi");
					}
				}else{
					CtrlFactory.getUIShow().setColor(child, 2);
					child["txt_name"].htmlText=Lang.getLabel("10235_resctrl");
				}
			}
			var stones:Vector.<StructGemInfo2>=null;
			var stone:StructGemInfo2=null;
			var stoneData:StructBagCell2=null;
			stones=Data.beiBao.getStoneByEquipPos(getSelectEquipPos());
			
			if(stones!=null&&stones.length>0){
				for(k=0;k<stones.length;k++){
					stone=stones[k];
					if(stone.toolId==0)continue;
					child=mc["mc_stone"+(k+1)];
					if(child==null)continue;
					stoneData=new StructBagCell2();
					stoneData.itemid=stone.toolId;
					Data.beiBao.fillCahceData(stoneData);
					ItemManager.instance().setToolTipByData(child["mc_stone_icon"],stoneData);
					//child["txt_name"].htmlText=ResCtrl.instance().getFontByColor(stoneData.itemname,stoneData.toolColor);
					//child["txt_desc"].htmlText=stoneData.desc;
				}
			}
			super.curPage=1;
			setPage();
		}
		
		override public function windowClose() : void {
			// 面板关闭事件
			NewGuestModel.getInstance().handleNewGuestEvent(1017,-1,null);
			super.windowClose();
			
		}
		/**
		 *	 
		 */
		override protected function reset():void{
			this.curData=null;
			

			
		}
		/**************通信**************/
		/**
		 * 镶嵌宝石
		 * 2014-05-14
		 */
		private function CSGemUp(gempos:int,hole:int=0):void{
			if(selectItem==null){
				Lang.showMsg(Lang.getClientMsg("10015_lian_dan_lu"));
				return;
			}
			var targetpos:int=int(selectItem.name.replace("equip_item",""));
			NewGuestModel.getInstance().handleNewGuestEvent(1017,3,mc);
			this.uiRegister(PacketSCGemUp.id,SCGemUpReturn);
			var client:PacketCSGemUp=new PacketCSGemUp();
			
			client.gempos=gempos;
			client.targetpos=targetpos;
			client.holepos=hole;
			this.uiSend(client);
		}
		private function SCGemUpReturn(p:PacketSCGemUp):void{
			if(p==null)return;
			if(super.showResult(p)){
				selectChange(getSelectEquipPos());
				setPage();
				clickItem();
				//ItemManager.instance().showWindowEffect("effect_zhuang_bei_success",mc,230,160);
			}else{
				
			}
			
		}
		/**
		 * 摘除宝石
		 * 2014-05-14
		 */
		private function CSGemDown(targetpos:int,hole:int):void{
			if(targetpos==0||hole==0){
				return;
			}
			
			this.uiRegister(PacketSCGemDown.id,SCGemDownReturn);
			var client:PacketCSGemDown=new PacketCSGemDown();
			
			client.gempos=targetpos;
			client.holepos=hole;
			this.uiSend(client);
		}
		private function SCGemDownReturn(p:PacketSCGemDown):void{
			if(p==null)return;
			if(super.showResult(p)){
				selectChange(getSelectEquipPos());
				setPage();
				clickItem();
			}else{
				
			}
			
		}
		
		
		/************/
		
		private function getSelectEquipPos():int{
			return int(selectItem.name.replace("equip_item",""));
		}
		
		
	}
}