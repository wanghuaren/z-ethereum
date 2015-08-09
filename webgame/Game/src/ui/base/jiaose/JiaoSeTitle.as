package ui.base.jiaose
{
	import com.engine.utils.HashMap;
	
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_TitleResModel;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import display.components.CmbArrange;
	
	import engine.event.DispatchEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketCSDisplayTitleSet;
	import nets.packets.PacketSCDisplayTitleSet;


	/**
	 * 角色称号信息	
	 * andy 
	 * 2013-08-27
	 */
	public class JiaoSeTitle extends EventDispatcher
	{
		private var mc:Sprite;
		private var cmb:CmbArrange;
		
		private var i:int=0;

		private static var _instance:JiaoSeTitle;
		public static function getInstance():JiaoSeTitle{
			if(_instance==null){
				_instance=new JiaoSeTitle();
			}
			return _instance;
		}
		
		public function setMc(v:Sprite):void{
			mc=v;
			cmb=mc["mc_cmb"];
			mc["btnUsedNot"].visible= false;
			mc["btnUsed"].visible= false;
			DataKey.instance.register(PacketSCDisplayTitleSet.id,SCDisplayTitleSet);
			Data.myKing.addEventListener(MyCharacterSet.TITLE_USED_UPDATE,TITLE_USED_UPDATE);
			refresh();
		}
		
		
		private var arrCmb:Array=[];
		public function refresh():void{
			//获得的称号是32位表示
			var titleOwn:int=Data.myKing.Title;
			//使用的称号
			var titleUsed:int=Data.myKing.DisplayTitle;
			var titleModel:Pub_TitleResModel=null;
			//称号列表
			arrCmb=[];
			//称号总属性
			var mapAtt:HashMap=new HashMap();
			for(i=1;i<=32;i++){
				//拥有的称号
				if(BitUtil.getBitByPos(titleOwn,i)==1){
					titleModel=XmlManager.localres.titleXml.getResPath(i) as Pub_TitleResModel;
					if(titleModel!=null){
						arrCmb.push({label:titleModel.title_name,data:i});
						countAtt(titleModel.func1,titleModel.value1,mapAtt);
						countAtt(titleModel.func2,titleModel.value2,mapAtt);
						countAtt(titleModel.func3,titleModel.value3,mapAtt);
						countAtt(titleModel.func4,titleModel.value4,mapAtt);
					}
				}
			}
			//总属性
			var attAll:String="";
			for each(var attId:int in mapAtt.keys()){
				attAll+=Att.getAttName(attId)+" "+mapAtt.get(attId)+"<br/>";
			}
			mc["txt_att_all"].htmlText=attAll;
			
			//称号数量
			var countUsed:int=0;
			for(i=1;i<=32;i++){
				//使用的称号
				if(BitUtil.getBitByPos(titleUsed,i)==1){
					countUsed++;
				}
			}
			mc["txt_count"].text=countUsed+"/"+arrCmb.length;
			//称号下拉框
			
			cmb.rowCount=5;
			cmb.overHeight=5;
			cmb.addItems=arrCmb;
			cmb.addEventListener(DispatchEvent.EVENT_COMB_CLICK,cmbFunction);
			if(arrCmb.length>0)
				cmb.changeSelected(0);

		}	
		
		/**
		 *	当前选中称号
		 */
		private function cmbFunction(ds:DispatchEvent):void{
			var titleId:int=ds.getInfo.data;
			var att:String="";
			var titleModel:Pub_TitleResModel=XmlManager.localres.titleXml.getResPath(titleId) as Pub_TitleResModel;
			if(titleModel==null)return;
			if(titleModel.func1>0){
				att+=Att.getAttName(titleModel.func1)+" "+titleModel.value1+"<br/>";
			}
			if(titleModel.func2>0){
				att+=Att.getAttName(titleModel.func2)+" "+titleModel.value2+"<br/>";
			}
			if(titleModel.func3>0){
				att+=Att.getAttName(titleModel.func3)+" "+titleModel.value3+"<br/>";
			}
			if(titleModel.func4>0){
				att+=Att.getAttName(titleModel.func4)+" "+titleModel.value4+"<br/>";
			}
			mc["txt_att"].htmlText=att;
//			if(BitUtil.getBitByPos(Data.myKing.DisplayTitle,titleId)==1){
//				mc["btnUsedNot"].visible= true;
//			}else{
//				mc["btnUsedNot"].visible= false;
//			}
//			
//			//2014-01-18 系统称号不能设置
//			if(titleModel.title_sort==2){
//				CtrlFactory.getUICtrl().setUnEnable(mc["btnUsedNot"]);
//				CtrlFactory.getUICtrl().setUnEnable(mc["btnUsed"]);
//			}else{
//				CtrlFactory.getUICtrl().setEnable(mc["btnUsedNot"]);
//				CtrlFactory.getUICtrl().setEnable(mc["btnUsed"]);
//			}	

			mc["txt_att_desc"].htmlText=titleModel.title_desc;
		}
		
		
		private function countAtt(attId:int,attValue:int,map:HashMap):void{
			if(attId>0){
				if(map.containsKey(attId)){
					map.put(attId,map.get(attId)+attValue);
				}else{
					map.put(attId,attValue);
				}
			}
		}
		
		/**
		 *	设置称号 
		 */
		private var setTitleId:int=0;
		public function setTitle(titleId:int,wear:int):void{
			var client:PacketCSDisplayTitleSet=new PacketCSDisplayTitleSet();
			client.title=titleId;
			client.flag=wear;
			DataKey.instance.send(client);
			setTitleId=titleId;
		}
		
		private function SCDisplayTitleSet(p:PacketSCDisplayTitleSet):void{
			if(Lang.showResult(p)){
				
			}else{
			
			}
		}
		
		private function TITLE_USED_UPDATE(e:Event):void{
			mc["btnUsedNot"].visible= BitUtil.getBitByPos(Data.myKing.DisplayTitle,setTitleId)==1;
		}
		
	}
}






