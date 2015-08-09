package ui.view.view4.yunying
{
	import common.config.PubData;
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.packets2.PacketSCGetStartPrizeState2;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSGetStartPrize;
	import nets.packets.PacketCSGetStartPrizeState;
	import nets.packets.PacketSCGetStartPrize;
	import nets.packets.PacketSCGetStartPrizeState;
	
	import scene.king.SkinByWin;
	
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;

	/**
	 * 开服豪礼 
	 * @author wangwen
	 * 
	 */	
	public class KaiFuHaoLi extends UIWindow
	{
		private static const MAX_VIP_LEVEL:int=12;
		//皇者礼包         急速 礼包      决战礼包   开服豪华礼包
		private var id_arr:Array=[60100151, 60100152, 60100153, 60100154];
		/**
		 * 坐骑预览
		 */
		public const zuoqiList:Array=[0, 0, 0, 10610017];
		
		private var dataKai:PacketSCGetStartPrizeState2=null;

		private static var _instance:KaiFuHaoLi;

		public function KaiFuHaoLi()
		{
			super(getLink(WindowName.win_kai_fu_hao_li));
		}

		public static function getInstance():KaiFuHaoLi
		{
			if(_instance==null){
				_instance=new KaiFuHaoLi();
			}
			return _instance;
		}
		
		override protected function openFunction():void{
			init();
		}
		override protected function init():void{
			super.init();
			
			super.uiRegister(PacketSCGetStartPrize.id, packetSCGetStartPrize);
			CSGetStartPrizeState();
			mc["mcZuoQiPreview"].visible=false;
			_repaint();
			
		}	
		override public function mcHandler(target:Object):void
		{
			var _name:String=target.name;
			switch (_name)
			{
				case "btnZuoQiPreviewClose":
					mc["mcZuoQiPreview"].visible=false;
					break;
				case "btnZuoQi4":
					var horseid:int=zuoqiList[4 - 1];
					show(horseid, mc);
					break;
				case "btnSubmit":
					var tppName:String=target.parent.parent.name;
					var type:int=int(tppName.replace("itembox", ""));
					sendStartPrize(type);
					break;
				case "btndianjiyulan":		
					if (mc["yulanchibang"].visible)
					{
						mc["yulanchibang"].visible=false;
					}
					else
					{
						mc["yulanchibang"].visible=true;
					}
					break;
				default:
					break;
			}
		}
		private var boxItemNum:int=3;
		private var rewardArr:Array=[];
		private static const CELL_NUM:int=7; //每个item中9个物品格子
		
		private function _repaint():void
		{
			//通过掉落 ID 查询获得的奖励
			if (rewardArr.length == 0)
			{
				for each (var _id:int in id_arr)
				{
					var _RewardList:Vector.<Pub_DropResModel>=null;
					_RewardList=XmlManager.localres.getDropXml.getResPath2(_id) as Vector.<Pub_DropResModel>;
					rewardArr.push(_RewardList);
				}
			}
			
			for (var j:int=0; j < id_arr.length; j++)
			{
				if (zuoqiList[j] > 0)
				{
					mc["JHJL"]["itembox" + (j + 1)]["btnZuoQi" + (j + 1)].visible=true;
				}
				else
				{
					mc["JHJL"]["itembox" + (j + 1)]["btnZuoQi" + (j + 1)].visible=false;
				}
				
			}
			
			var itemIdx:int=1;
			for each (var RewardList:Vector.<Pub_DropResModel> in rewardArr)
			{
				var _cSelectedRewardListLength:int=RewardList.length;
				var _cSelectedRewardListItem:Pub_ToolsResModel=null;
				var _bagCell:StructBagCell2=null;
				var _sprite:Object=null;
				for (var i:int=0; i < CELL_NUM; ++i)
				{
					var iconIdx:int=i + 1;
					_sprite=mc["JHJL"]["itembox" + itemIdx]["icon" + iconIdx];
					
					if (_sprite!=null&&_sprite.hasOwnProperty("data"))
						_sprite["data"]=null;
					
					if (i < _cSelectedRewardListLength)
					{
						_sprite.visible=true;
						_cSelectedRewardListItem=GameData.getToolsXml().getResPath(RewardList[i].drop_item_id) as Pub_ToolsResModel;
						
						//						_sprite["txt_num"].text = RewardList[i].drop_num;
						if (null != _cSelectedRewardListItem)
						{
							
							_bagCell=new StructBagCell2();
							_bagCell.itemid=_cSelectedRewardListItem.tool_id;
							Data.beiBao.fillCahceData(_bagCell);
							_bagCell.num=RewardList[i].drop_num;
							ItemManager.instance().setToolTipByData(_sprite as MovieClip, _bagCell,1);
						}
					}
					else
					{
						_sprite.visible=false;
					}
					
				}
				itemIdx++;
			}
			
			itemIdx=0;
			//			setData();
			//			_repaintBtn();
			mc["JHJLSP"].source=mc["JHJL"];
			mc["JHJLSP"].position=0;
		}
		
		/**
		 *获取开服豪礼信息
		 *
		 */
		public function CSGetStartPrizeState():void
		{
			super.uiRegister(PacketSCGetStartPrizeState.id, getSCStartPrizeStateMsg);
			var client:PacketCSGetStartPrizeState=new PacketCSGetStartPrizeState();
			super.uiSend(client);
		}
		
		/**
		 *获取初始化信息 返回
		 *
		 */
		private function getSCStartPrizeStateMsg(p:PacketSCGetStartPrizeState2):void
		{
			dataKai=p;
			if(KaiFuHaoLi.getInstance().isOpen){
				if (p.id1 == 0)
				{
					mc["JHJL"]["itembox1"]["lingqu_btn"].gotoAndStop(1);
				}
				else
				{
					mc["JHJL"]["itembox1"]["lingqu_btn"].gotoAndStop(2);
				}
				if (p.id2 == 0)
				{
					mc["JHJL"]["itembox2"]["lingqu_btn"].gotoAndStop(1);
				}
				else
				{
					mc["JHJL"]["itembox2"]["lingqu_btn"].gotoAndStop(2);
				}
				if (p.id3 == 0)
				{
					mc["JHJL"]["itembox3"]["lingqu_btn"].gotoAndStop(1);
				}
				else
				{
					mc["JHJL"]["itembox3"]["lingqu_btn"].gotoAndStop(2);
				}
				if (p.id4 == 0)
				{
					mc["JHJL"]["itembox4"]["lingqu_btn"].gotoAndStop(1);
				}
				else
				{
					mc["JHJL"]["itembox4"]["lingqu_btn"].gotoAndStop(2);
				}
			}
		}
		
		/**
		 *l领取礼包 发送
		 *
		 */
		private function sendStartPrize(_packId:int):void
		{
			var client:PacketCSGetStartPrize=new PacketCSGetStartPrize();
			client.packid=_packId;
			super.uiSend(client);
		}
		
		/**
		 *领取礼包  返回
		 * @param p
		 *
		 */
		private function packetSCGetStartPrize(p:PacketSCGetStartPrize):void
		{
			Lang.showResult(p);
			//			var obj:Object = Lang.getServerMsg(p.tag)
			//			Lang.showMsg(obj);
			if (p.tag == 0)
			{
				CSGetStartPrizeState();
			}
			else
			{
				
			}
		}
		
		
		public static function show(horseid_:int,mc:DisplayObject):void
		{
			//
			var horseid:int = horseid_;
			var skinZuoQi:SkinByWin;
			//坐骑形象
			if(skinZuoQi!=null&&skinZuoQi.parent!=null)
			{
				skinZuoQi.unload();
				skinZuoQi.parent.removeChild(skinZuoQi);
				skinZuoQi = null;
			}
			
			if(skinZuoQi==null){
				skinZuoQi=new SkinByWin();
				
				skinZuoQi.mouseChildren = false;
				skinZuoQi.mouseEnabled = false;
				
				skinZuoQi.x=212+190;//212+80;
				skinZuoQi.y=336-100 + 45;
				skinZuoQi.mouseChildren=skinZuoQi.mouseEnabled=false;
			}
			
			//
			var s0:int=0;
			var s1:int=horseid_;
			var s2:int=Data.myKing.s2;
			var s3:int=Data.myKing.s3;
			//				var s3:int= 0;
			
			var path:BeingFilePath=FileManager.instance.getMainByHumanId(s0,s1,s2,s3,Data.myKing.sex);
			
			//2012-10-19 变身情况下，不显示变身
			//2012-12-27 策划搞了很多变身的东西，都是以310开头
			if(s2.toString().indexOf("310")>=0){
				//s2 = s1;
				//s1=0;
				path.setS2(path.s1);
				path.setS1(0);
				
				path.swf_path2 = path.swf_path1;
				path.swf_path1 = "";
				
				path.xml_path2 = path.xml_path1;
				path.xml_path1 = "";
				
			}
			
			
			path.rightHand = FileManager.instance.getRightHand(Data.myKing.metier);
			
			skinZuoQi.setSkin(path,false);	
			
			mc["mcZuoQiPreview"].addChild(skinZuoQi);
			
			mc["mcZuoQiPreview"].visible = true;
		}

		override protected function windowClose():void{
			NewGuestModel.getInstance().handleNewGuestEvent(1064,4,null);
			super.windowClose();
			
		}

		
		public function isCanGetAward():Boolean
		{
			if(dataKai==null)return false;
			var bool:Boolean = false;        //是否能领取充值奖励
			if(dataKai.id1==0||dataKai.id2==0||dataKai.id3==0||dataKai.id4==0)
				return true;
			else
				return false;
		}

	}

}
