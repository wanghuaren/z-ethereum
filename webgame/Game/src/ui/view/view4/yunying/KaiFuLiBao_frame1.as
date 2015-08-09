
package ui.view.view4.yunying
{

	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSGetStartPrize;
	import nets.packets.PacketCSGetStartPrizeState;
	import nets.packets.PacketSCGetStartPrize;
	import nets.packets.PacketSCGetStartPrizeState;
	
	import ui.frame.ItemManager;

	/**
	 *开服礼包
	 * @author hpt
	 *
	 */
	public class KaiFuLiBao_frame1
	{
		private static var m_instance:KaiFuLiBao_frame1;
		private var mc:Sprite=null;

		private static const MAX_VIP_LEVEL:int=12;
		//皇者礼包         急速 礼包      决战礼包   开服豪华礼包
		private var id_arr:Array=[60100151, 60100152, 60100153, 60100154];
		/**
		 * 坐骑预览
		 */
		public const zuoqiList:Array=[0, 0, 0, 10603003];

		public function KaiFuLiBao_frame1()
		{
			DataKey.instance.register(PacketSCGetStartPrizeState.id, getSCStartPrizeStateMsg);
			DataKey.instance.register(PacketSCGetStartPrize.id, packetSCGetStartPrize);
		}

		public static function getInstance():KaiFuLiBao_frame1
		{
			if (null == m_instance)
			{
				m_instance=new KaiFuLiBao_frame1();
			}

			return m_instance;
		}


		public function setUI(ui:Sprite):void
		{
			mc=ui;
			if (null == mc)
			{
				//HuoDongZhengHe.getInstance()._onFrameScript_1();
				return;
			}
			sendClientMsg();

			_repaint();
		}


		private var boxItemNum:int=3;
		private var rewardArr:Array=[];
		private static const CELL_NUM:int=9; //每个item中9个物品格子

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
							ItemManager.instance().setToolTipByData(_sprite as MovieClip, _bagCell);
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

		//		private var vip:Pub_VipResModel;
		//		private function setData():void{
		//			
		//			if(null == mc){
		//				return;
		//			}
		//			
		//			vip=GameData.getVipXml().getResPath(1);
		//			var child:MovieClip=null;
		//			if(vip!=null){
		//				var arr:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(vip.gift_item);
		//				var len:int=arr.length;
		//				var item:Pub_ToolsResModel;
		//				
		//				for(var i:int=1;i<=6;i++){
		//					item=null;
		//					if(i<=len)
		//						item=GameData.getToolsXml().getResPath(arr[i-1].drop_item_id);
		//					child=mc["item"+i];
		//					if(child==null)continue;
		//					if(item!=null){
		//						if(i<=2){
		//							child["uil"].source=FileManager.instance.getIconXById(item.tool_icon);
		//						}else{
		//							child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
		//							
		//						}
		//						//mc["txt_name"+i].text=item.tool_name;
		//						child["txt_num"].text=arr[i-1].drop_num;
		//						if(arr[i-1].drop_num>=10000){
		//							child["txt_num"].text=arr[i-1].drop_num/10000+Lang.getLabel("pub_wan");
		//						}
		//						var bag:StructBagCell2=new StructBagCell2();
		//						bag.itemid=item.tool_id;
		//						Data.beiBao.fillCahceData(bag);
		//						child.data=bag;
		//						CtrlFactory.getUIShow().addTip(child);
		//						ItemManager.instance().setEquipFace(child);
		//					}else{
		//						child["uil"].unload();
		//						//mc["txt_name"+i].text="";
		//						ItemManager.instance().setEquipFace(child,false);
		//					}
		//					
		//					
		//					
		//				}
		//			}
		//		}


		//		private function _repaintBtn():void
		//		{
		//			var _cVIP:int = Data.myKing.VipByYB;
		//			var _vipResConfig:Pub_VipResModel = XmlManager.localres.VipXml.getResPath( 1 );
		//			var _toolConfig:Pub_ToolsResModel = null;
		//			if(null == _vipResConfig)
		//			{
		//				return ;
		//			}
		//			
		//			if(null == mc){
		//				return;
		//			}
		//			
		//			
		//			if(_cVIP >= _vipResConfig.vip_level)
		//			{
		//				if(VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
		//				{
		//					(mc['diyiye_btnLingQu'] as MovieClip).gotoAndStop(1);
		//					StringUtils.setEnable(mc['diyiye_btnLingQu']);
		//					(mc['diyiye_btnLingQu'] as MovieClip).mouseEnabled = true;
		//				}
		//				else
		//				{
		//					(mc['diyiye_btnLingQu'] as MovieClip).gotoAndStop(2);
		//					StringUtils.setUnEnable(mc['diyiye_btnLingQu']);
		//					(mc['diyiye_btnLingQu'] as MovieClip).mouseEnabled = false;
		//				}
		//			}
		//			else
		//			{
		//				StringUtils.setUnEnable(mc['diyiye_btnLingQu']);
		//				(mc['diyiye_btnLingQu'] as MovieClip).gotoAndStop(3);
		//				(mc['diyiye_btnLingQu'] as MovieClip).mouseEnabled = false;
		//			}
		//		}



		public function mcHandler(target:Object):void
		{
			var _name:String=target.name;
			if (mc == null)
				return;



			switch (_name)
			{
				case "btnZuoQiPreviewClose":
					mc["mcZuoQiPreview"].visible=false;
					break;
				case "btnZuoQi4":
					var horseid:int=KaiFuLiBao_frame1.getInstance().zuoqiList[4 - 1];
					HuoDongZhengHeZuoQi.show(horseid, mc);
					break;
				case "btnSubmit":
					var tppName:String=target.parent.parent.name;
					var type:int=int(tppName.replace("itembox", ""));
					sendStartPrize(type);
//					VipGift.getInstance().requestGetGift(1,_giftReturnCallback);
					break;
//				case "p_2_btn_look_VIP":  //查看更多天仙特权
//					ZhiZunVIP.getInstance().open(true);
//					break;
//				case "p_4_btnAddMoney":
//				case "p_3_btnAddMoney":
//				case "p_2_btnAddMoney":
//					HuoDongZhengHe.getInstance().isOpenVipChongzhi();
//					break;
				case "btndianjiyulan":

					if (mc["yulanchibang"].visible)
					{
//						showFly('F1');
						mc["yulanchibang"].visible=false;
					}
					else
					{
//						showFly('F2');
						mc["yulanchibang"].visible=true;
					}
					break;
//				case "chibangbtnClose":
//					yuLanChiBangClose();
//					break;
				default:
					break;
			}

		}

		public function yuLanChiBangClose():void
		{
			mc["yulanchibang"].visible=false;
		}

//		private var skinZuoQi:SkinByWin;
		/**
		 *显示翅膀
		 *
		 */
//		private  function showFly(fx:String):void{
//			var numchid:int = mc["yulanchibang"]["moxing"].numChildren;
//			if(numchid != 0){
//				for(var m:int = 0;m<numchid;m++){
//					mc["yulanchibang"]["moxing"].removeChildAt(0);
//				}
//			}
//			skinZuoQi=new SkinByWin();
//			skinZuoQi.x=0;
//			skinZuoQi.y=0;
//			skinZuoQi.mouseChildren=skinZuoQi.mouseEnabled=false;
//			var s0:int=31000040;
//			//Data.myKing.s0;
//			//var s1:int=Data.myKing.s1;
//			var s1:int=0;
//			var s2:int=Data.myKing.s2;
//			var s3:int=Data.myKing.s3;
//			//2012-10-19 变身情况下，不显示变身
//			//2012-12-27 策划搞了很多变身的东西，都是以310开头
//			if(s2.toString().indexOf("310")>=0){
//				s2 = Data.myKing.oldS2;
//			}
//			
//			var path:BeingFilePath=FileManager.instance.getMainByHumanId(s0,s1,s2,s3,Data.myKing.sex);
//			path.rightHand = FileManager.instance.getRightHand(Data.myKing.metier);
//			
//			skinZuoQi.setSkin(path);
//			//skinZuoQi.setAction("F2");
//			MapCl.setFangXiang(skinZuoQi.getRole(), KingActionEnum.DJ, fx, null,0,null);
//			mc["yulanchibang"]["moxing"].addChild(skinZuoQi);
//		}
		/////////////////////////通信   ////////////////////////////////////
		/**
		 *获取初始化信息
		 *
		 */
		private function sendClientMsg():void
		{
			var client:PacketCSGetStartPrizeState=new PacketCSGetStartPrizeState();
			DataKey.instance.send(client);
		}

		/**
		 *获取初始化信息 返回
		 *
		 */
		private function getSCStartPrizeStateMsg(p:PacketSCGetStartPrizeState):void
		{
			if (mc == null)
				return;
			Lang.showMsg(Lang.getServerMsg(p.tag));
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

		/**
		 *l领取礼包 发送
		 *
		 */
		private function sendStartPrize(_packId:int):void
		{
			var client:PacketCSGetStartPrize=new PacketCSGetStartPrize();
			client.packid=_packId;
			DataKey.instance.send(client);
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
				sendClientMsg();
			}
			else
			{

			}
		}


	}

}





