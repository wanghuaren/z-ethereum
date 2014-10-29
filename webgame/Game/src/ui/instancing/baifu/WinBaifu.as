package ui.instancing.baifu
{
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;

	import flash.display.Sprite;

	import model.baifu.BaiFuModel;
	import model.baifu.BaifuVO;

	import netc.DataKey;

	import nets.packets.PacketCSAutoSeek;
	import nets.packets.PacketCSAutoSend;

	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.beibao.BeiBao;
	import ui.base.vip.ChongZhi;
	import ui.base.vip.Vip;
	import ui.view.view4.yunying.XunBaoChouJiang;
	import ui.view.view4.yunying.ZhiZunVIP;

	/**
	 *@author WangHuaren
	 *2014-3-31_下午1:45:19
	 **/
	public class WinBaifu extends UIWindow
	{
		public function WinBaifu()
		{
			super(getLink(WindowName.win_bai_fu_huo_dong));
		}
		private static var _instance:WinBaifu=null;

		public static function get instance():WinBaifu
		{
			if (_instance == null)
			{
				_instance=new WinBaifu();
			}
			return _instance;
		}
		private var btnPos:Array=[];

		override protected function init():void
		{
			super.init();
			for (var i:int=0; i < 8; i++)
			{
				btnPos.push(mc["btn" + i].x);
				btnPos.push(mc["btn" + i].y);
			}
			mcHandler({name: "btn0", parent: mc});
		}

		private function showContent(num:int):void
		{
			for (var i:int=0; i < 8; i++)
			{
				mc["MCContent" + i].visible=false;
				mc["btn" + i].mouseChildren=false;
				mc["btn" + i].buttonMode=true;
				mc["btn" + i].gotoAndStop(1);

				if (BaiFuModel.instance.baifuData.isJoinYellowCity)
				{
					mc["btn2"].visible=true;
					CtrlFactory.getUIShow().setBtnEnabled(mc["btn2"], true);
					if (i > 1)
					{
						mc["btn" + i].x=btnPos[i * 2];
						mc["btn" + i].y=btnPos[i * 2 + 1];
					}
				}
				else
				{
					mc["btn2"].visible=false;
					CtrlFactory.getUIShow().setBtnEnabled(mc["btn2"], false);
					if (i > 2)
					{
						mc["btn" + i].x=btnPos[(i - 1) * 2];
						mc["btn" + i].y=btnPos[(i - 1) * 2 + 1];
					}
				}
			}
			mc["MCContent" + num].visible=true;
			mc["btn" + num].gotoAndStop(2);
			if (Lang.getLabel("Shi_Huang_Mo_Ku") == "1")
			{
				mc["btn7"].visible=true;
				CtrlFactory.getUIShow().setBtnEnabled(mc["btn7"], true);
			}
			else
			{
				mc["btn7"].visible=false;
				CtrlFactory.getUIShow().setBtnEnabled(mc["btn7"], false);
			}

			fillData(BaiFuModel.instance.baifuData);
		}

		private function fillData(value:BaifuVO):void
		{
			var currMC:Sprite=mc["MCContent" + m_index];
			currMC["txt1"].text=value.date;
			currMC["txt2"].text=value.area;
			switch (m_index)
			{
				case 0:
					//百服庆典礼包
					for (var i:int=0; i < BaiFuModel.instance.resData0.length; i++)
					{
						if (i < 4)
						{
							ItemManager.instance().setToolTip(currMC["item" + i], BaiFuModel.instance.resData0[i].id, 0, 1, BaiFuModel.instance.resData0[i].num);
						}
					}
					///////////////////测试 
//					CtrlFactory.getUIShow().setBtnEnabled(currMC["btnSubmit"], true);

					if (BaiFuModel.instance.baifuData.isGetHappy)
					{
						currMC["lingqu_btn"].gotoAndStop(1);
					}
					else
					{
						currMC["lingqu_btn"].gotoAndStop(2);
					}
					break;
				case 1:
					//百服双倍经验
					break;
				case 2:
					//百服皇城霸主
					for (i=0; i < BaiFuModel.instance.resData2.length; i++)
					{
						if (i < 3)
						{
							for (var j:int=0; j < BaiFuModel.instance.resData2[i].length; j++)
							{
								if (j < 7)
								{
									ItemManager.instance().setToolTip(currMC["item" + (i * 7 + j)], BaiFuModel.instance.resData2[i][j].id, 0, 0, BaiFuModel.instance.resData2[i][j].num);
								}
							}
						}
					}
					break;
				case 3:
					//集齐兑换大奖
					for (i=0; i < BaiFuModel.instance.wordID.length; i++)
					{
						var m_id:int=BaiFuModel.instance.wordID[i];
						if (BaiFuModel.instance.wordData[m_id] == 0)
						{
							StringUtils.setUnEnable(currMC["item" + i]);
							ItemManager.instance().setToolTip(currMC["item" + i], m_id);
							if (i < 4)
							{
								StringUtils.setUnEnable(currMC["item" + i + 1]);
								ItemManager.instance().setToolTip(currMC["item" + i + 1], m_id);
								StringUtils.setUnEnable(currMC["item" + i + 2]);
								ItemManager.instance().setToolTip(currMC["item" + i + 2], m_id);
							}
							else if (i < 6)
							{
								StringUtils.setUnEnable(currMC["item" + i + 1]);
								ItemManager.instance().setToolTip(currMC["item" + i + 1], m_id);
							}
						}
						else
						{
							StringUtils.setEnable(currMC["item" + i]);
							ItemManager.instance().setToolTip(currMC["item" + i], m_id, 0, 0, BaiFuModel.instance.wordData[m_id]);
							if (i < 4)
							{
								StringUtils.setEnable(currMC["item" + i + 1]);
								ItemManager.instance().setToolTip(currMC["item" + i + 1], m_id, 0, 0, BaiFuModel.instance.wordData[m_id]);
								StringUtils.setEnable(currMC["item" + i + 2]);
								ItemManager.instance().setToolTip(currMC["item" + i + 2], m_id, 0, 0, BaiFuModel.instance.wordData[m_id]);
							}
							else if (i < 6)
							{
								StringUtils.setEnable(currMC["item" + i + 1]);
								ItemManager.instance().setToolTip(currMC["item" + i + 1], m_id, 0, 0, BaiFuModel.instance.wordData[m_id]);
							}
						}
					}
					CtrlFactory.getUIShow().setBtnEnabled(currMC["btnSubmit0"], BaiFuModel.instance.baifuData.getWord[0] == 0);
					CtrlFactory.getUIShow().setBtnEnabled(currMC["btnSubmit1"], BaiFuModel.instance.baifuData.getWord[1] == 0);
					CtrlFactory.getUIShow().setBtnEnabled(currMC["btnSubmit2"], BaiFuModel.instance.baifuData.getWord[2] == 0);
					break;
				case 4:
					//百服寻宝礼包
					for (i=0; i < BaiFuModel.instance.resData4.length; i++)
					{
						if (i < 12)
						{
							ItemManager.instance().setToolTip(currMC["item" + i], BaiFuModel.instance.resData4[i].id, 0, 0, BaiFuModel.instance.resData4[i].num);
						}
					}
					break;
				case 5:
					//百服魔王来袭
					for (i=0; i < BaiFuModel.instance.resData5.length; i++)
					{
						if (i < 6)
						{
							ItemManager.instance().setToolTip(currMC["item" + i], BaiFuModel.instance.resData5[i].id, 0, 0, BaiFuModel.instance.resData5[i].num);
						}
					}
					break;
				case 6:
					//百服充值返利
					break;
				case 7:
					//百服始皇魔窟
					break;
			}
		}
		private var m_index:int=0;

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			if (target.parent == mc && target.name.indexOf("btn") == 0)
			{
				m_index=int(target.name.replace("btn", ""));
				showContent(m_index);
			}
			switch (target.name)
			{
				case "btnSubmit":
					switch (m_index)
					{
						case 0:
							BaiFuModel.instance.getData(1, 1);
							break;
						case 4:
							XunBaoChouJiang.getInstance().open();
							break;
						case 5:
							var m_seek:PacketCSAutoSeek=new PacketCSAutoSeek();
							m_seek.seekid=BaiFuModel.instance.baifuData.monsterSendID;
							DataKey.instance.send(m_seek);
							break;
						case 6:
							ChongZhi.getInstance().open();
							break;
						case 7:
							m_seek=new PacketCSAutoSeek();
							m_seek.seekid=BaiFuModel.instance.baifuData.sendID;
							DataKey.instance.send(m_seek);
							break;
					}
					break;
				case "btnSubmit0":
					switch (m_index)
					{
						case 3:
							BaiFuModel.instance.getData(3, 1);
							break;
					}
					break;
				case "btnSubmit1":
					switch (m_index)
					{
						case 3:
							BaiFuModel.instance.getData(3, 2);
							break;
					}
					break;
				case "btnSubmit2":
					switch (m_index)
					{
						case 3:
							BaiFuModel.instance.getData(3, 3);
							break;
					}
					break;
				case "btnTrans":
					switch (m_index)
					{
						case 5:
							var m_send:PacketCSAutoSend=new PacketCSAutoSend();
							m_send.seekid=BaiFuModel.instance.baifuData.monsterSendID;
							DataKey.instance.send(m_send);
							break;
						case 7:
							m_send=new PacketCSAutoSend();
							m_send.seekid=BaiFuModel.instance.baifuData.sendID;
							DataKey.instance.send(m_send);
							break;
					}
					break;
			}
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		override public function winClose():void
		{
			super.winClose();
		}
	}
}
