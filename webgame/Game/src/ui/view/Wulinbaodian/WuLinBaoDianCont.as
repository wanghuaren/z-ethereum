package ui.view.wulinbaodian
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.config.xmlres.server.Pub_BookResModel;
	import common.config.xmlres.server.Pub_InstanceResModel;
	import common.managers.Lang;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	import nets.packets.PacketCSEntryBossAction;
	import nets.packets.PacketCSOpenActTimeWaring;
	import nets.packets.PacketCSSInstanceStart;
	
	import ui.base.jiaose.JiaoSeMain;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.fuben.FuBenDuiWu;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.view.view4.chengjiu.ChengjiuWin;
	
	import world.FileManager;
	
	public class WuLinBaoDianCont extends UIWindow
	{
		private static var _instance:WuLinBaoDianCont = null;
		
		public var wulinPageCallFun:Function;//翻页回调
		public function WuLinBaoDianCont()
		{
			super(getLink(WindowName.win_wu_lin_bao_dian));
		}
		public static function getInstance(val:Function=null):WuLinBaoDianCont{
			if (_instance==null){
				_instance = new WuLinBaoDianCont();
			}
			
			return _instance;
		}
		override protected function init():void{
			super.init();
			super.sysAddEvent(mc["mc_page"],MoreLessPage.PAGE_CHANGE,changePage);
			mc["title"].gotoAndStop(2);
		}
		private function changePage(e:DispatchEvent=null):void
		{
			curPage=e.getInfo.count;
			if(wulinPageCallFun!=null){
				wulinPageCallFun("changePage",curPage);
			}
		}
		override public function mcHandler(target:Object):void{
			super.mcHandler(target);
			var name:String=target.name;
			if(name.indexOf("chuan")>=0){
				var tt:int=int(name.replace("chuan",""));
				clickBtnChuan(tt);
				return;
			}
			if(name.indexOf("btn_count")>=0){
				var dt:int=int(name.replace("btn_count",""));
				clickBtnQianwang(dt);
				return;
			}
		}
		private function clickBtnQianwang(_idx:int):void
		{
			if(curPageData!=null&&curPageData.length>0)
			{
				var m_ActModel:Pub_Action_DescResModel = curPageData[_idx-1];
				var obj:Object = new Object();
				obj["data"] = m_ActModel;
				itemClickByDayRenWu2(obj)
				
			}
		}
		
		private function clickBtnChuan(tt:int):void
		{
			if(curPageData!=null&&curPageData.length>0)
			{
				var m_ActModel:Pub_Action_DescResModel = curPageData[tt-1];
				//				var str:String = m_ActModel.
				var obj:Object = new Object();
				obj["data"] = m_ActModel;
				GameAutoPath.chuan(m_ActModel["action_para1"]);
				
			}
		}
		/**
		 *立即参与按钮、寻路 
		 * @param _obj
		 */
		public function itemClickByDayRenWu2(_obj:Object):void
		{
			
			var sprite:Object=_obj;
			var action_jointype:String=sprite["data"]["action_jointype"];
			
			if ("0" == action_jointype)
			{
				//该活动到时间会自动参加，保持在线即可
				Lang.showMsg({type: 4, msg: Lang.getLabel("20048_HuoDongJoin")});
				
			}
			else if ("1" == action_jointype)
			{
				//寻路		
				GameAutoPath.seek(sprite["data"]["action_para1"]);
			}
			else if ("2" == action_jointype)
			{
				//副本id
				var instance_id:int=sprite["data"]["action_para1"]
				FuBenDuiWu.groupid=instance_id;
				
				//instancesort:int;//副本类型(1单人，2多人)
				var instance_model:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(instance_id) as Pub_InstanceResModel;
				
				if (0 == instance_model.instancesort || 1 == instance_model.instancesort)
				{
					//单人副本快速进入
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=instance_id;
					this.uiSend(client1);
					
				}
				else
				{
					FuBenDuiWu.instance.open(true);
				}
			}
			else if ("3" == action_jointype)
			{
				MoTianWanJie.instance().open();
				
			}
			else if ("4" == action_jointype)
			{
				
				var cs:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
				cs.act_id=parseInt(sprite["data"]["action_id"]);
				cs.seek_id=parseInt(sprite["data"]["action_para1"]);
				cs.token=0;
				
				uiSend(cs);
				
			}
			else if ("5" == action_jointype)
			{
				var cs5:PacketCSEntryBossAction=new PacketCSEntryBossAction();
				cs5.action_id=parseInt(sprite["data"]["action_para1"]);
				
				uiSend(cs5);
				
			}
			else if ("100" == action_jointype)
			{
				//				ZhenYing.instance().requestCamp();
				if(sprite["data"]["action_para1"]==2){
					LianDanLu.instance().setType(1, true);
				}else if(sprite["data"]["action_para1"]==42){
					JiaoSeMain.getInstance().setType(2);
				}else if(sprite["data"]["action_para1"]==43){
					ChengjiuWin.getInstance().setType(2);
				}else{
				
				}
			}
			
		}
		public function setMaxPageFun(_curPage:int,_maxPage:int):void
		{
			mc["mc_page"].setMaxPage(_curPage,_maxPage);
		}
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open();
			
		}
		override protected function windowClose():void{
			super.windowClose();
		}
		
		private var curPageData:Array=null;
		/**
		 *	得到某页数据 
		 */
		public function showPage(curPage:int=1,arrCurPage:Array=null):void{
			if(curPage==1){
				mc.visible = true;
			}
			
			if(arrCurPage!=null){
				curPageData = new Array();
				for(var t:int = 0;t<4;t++){
					var curIdx:int = t+1;
					var mcbox:MovieClip = mc["itembox_"+curIdx];
					var chuanbtn:SimpleButton = mcbox["chuan"];
					
					if(arrCurPage[t]==null)
					{
						mcbox.visible = false;
					}else{
						mcbox.visible = true;
						
						var dataItem:Pub_BookResModel = arrCurPage[t]
						
						//						mcbox["txt_fuben_ci_shu"].htmlText=dataItem.action_name;
						var actionGroup:int = dataItem.action_group;
						
						var m_ActModel:Pub_Action_DescResModel = XmlManager.localres.ActionDescXml.getListByActionGroup(actionGroup) as Pub_Action_DescResModel;
						if(m_ActModel.action_start2!=0){
							mcbox["btn_count"+curIdx].visible = false;
							mcbox["chuan"+curIdx].visible = false;
						}else{
							mcbox["btn_count"+curIdx].visible = true;
							mcbox["chuan"+curIdx].visible = true;
						}
						if(m_ActModel.action_jointype==100){
							mcbox["btn_count"+curIdx].label = Lang.getLabel("wulinbaodian_dakaijiemian");
							mcbox["chuan"+curIdx].visible = false;
						}else{
							mcbox["btn_count"+curIdx].label = Lang.getLabel("wulinbaodian_lijiqianwang");
							mcbox["chuan"+curIdx].visible = true;
						}
						mcbox["txt_desc"].htmlText =	m_ActModel.action_desc;
						mcbox["txt_num"].htmlText =	m_ActModel.action_date;
						//					mcbox["txt_desc"].htmlText =	m_ActModel.action_join;
//						mcbox["icon"]["uil"].source = FileManager.instance.getActionDescIconById(m_ActModel.res_id);
						ImageUtils.replaceImage(mcbox["icon"],mcbox["icon"]["uil"],FileManager.instance.getActionDescIconById(m_ActModel.res_id));
						curPageData.push(m_ActModel);
					}
				}
			}
		}
		override public function getID():int
		{
			return 1076;
		}
	}
}