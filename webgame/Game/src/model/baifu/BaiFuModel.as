package model.baifu
{
	import common.config.xmlres.GameData;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Hundred_FightResModel;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import engine.support.IPacket;
	
	import flash.utils.Dictionary;
	
	import netc.Data;
	import netc.DataKey;
	
	import nets.packets.PacketCSGetHundredSrvItem;
	import nets.packets.PacketSCGetHundredSrv;
	import nets.packets.PacketSCGetHundredSrvData;
	import nets.packets.PacketSCGetHundredSrvItem;
	
	import ui.instancing.baifu.WinBaifu;
	import ui.instancing.baifu.WinBaifuYellowCityResult;

	/**
	 *@author WangHuaren
	 *2014-3-31_下午1:43:07
	 **/
	public class BaiFuModel
	{
		public function BaiFuModel()
		{
			//////////测试 ///////////
//			addData(new PacketSCGetHundredSrv());

			DataKey.instance.register(PacketSCGetHundredSrvItem.id, getCSGetHundredSrvItem);
		}
		private static var _instance:BaiFuModel=null;

		public static function get instance():BaiFuModel
		{
			if (_instance == null)
			{
				_instance=new BaiFuModel();
			}
			return _instance;
		}
		/**
		 * 是否有百服活动
		 * */
		public var isBaiFuBegin:Boolean=false;

		public var baifuData:BaifuVO=new BaifuVO();
		/**
		 * 百服庆典礼包
		 * */
		public var resData0:Vector.<DropItemVO>=new Vector.<DropItemVO>();
		/**
		 * 百服皇城争霸礼包
		 * */
		public var resData2:Vector.<Vector.<DropItemVO>>=new Vector.<Vector.<DropItemVO>>();
		/**
		 * 百服寻宝
		 * */
		public var resData4:Vector.<DropItemVO>=new Vector.<DropItemVO>();
		/**
		 * 百服魔王来袭
		 * */
		public var resData5:Vector.<DropItemVO>=new Vector.<DropItemVO>();
		/**
		 * 百服集字,各个字对应的物品ID
		 *11800341	决
		 *11800342	战
		 *11800343	百
		 *11800344	服
		 *11800345	庆
		 *11800346	典
		 *11800347	活
		 *11800348	动
	   * */
		public var wordID:Array=[11800341, 11800342, 11800343, 11800344, 11800345, 11800346, 11800347, 11800348];
		private var packetGetHundredSrvItem:PacketCSGetHundredSrvItem=new PacketCSGetHundredSrvItem();

		public function get wordData():Dictionary
		{
			var m_dic_num:Dictionary=new Dictionary();
			for (var i:int=0; i < wordID.length; i++)
			{
				m_dic_num[wordID[i]]=Data.beiBao.getBeiBaoCountById(wordID[i], true);
			}
			return m_dic_num;
		}

		public function getData(type:int, index:int):void
		{
			selectType=type;

			packetGetHundredSrvItem.type=type;
			packetGetHundredSrvItem.index=index;
			DataKey.instance.send(packetGetHundredSrvItem);
		}
		private var selectType:int=0;

		public function getCSGetHundredSrvItem(p:PacketSCGetHundredSrvItem):void
		{
			Lang.showResult(p);
		}

		public function addData(p:IPacket):void
		{
			//两个协议都需要些数据,单独来处理
			if (resData2.length == 0)
			{
				////////////////////////////百服皇城争霸三个展示
				baifuData.HCDropID=GameData.getHundredFightXml().getListBySort() as Vector.<Vector.<Pub_Hundred_FightResModel>>;
				for (var i:int=0; i < baifuData.HCDropID.length; i++)
				{
					var m_resList:Vector.<Pub_Hundred_FightResModel>=baifuData.HCDropID[i];
					resData2[i]=new Vector.<DropItemVO>();
					var m_model:Pub_Hundred_FightResModel;
					for (j=0; j < m_resList.length; j++)
					{
						if (m_resList.length > j)
						{
							m_model=m_resList[j];
							m_dropItemVO=new DropItemVO();
							m_dropItemVO.index=m_model.id
//							m_dropItemVO.id=m_model.tool_id;
							m_dropItemVO.id=m_model.tool_id_show;
							resData2[i].push(m_dropItemVO);
						}
					}
//					resData2[i][j - 1].id=Pub_DropXml2.YUAN_BAO_TOOL_ID;
				}
			}
			if (p as PacketSCGetHundredSrv)
			{
				var m_p1:PacketSCGetHundredSrv=p as PacketSCGetHundredSrv;
				var str1:String=m_p1.begin_date + "";
				var str2:String=m_p1.end_date + "";
				baifuData.date=str1.substr(0, 4) + Lang.getLabel("pub_nian") + str1.substr(4, 2) + Lang.getLabel("pub_yue") + str1.substr(6, 2) + Lang.getLabel("pub_ri") + "----";
				baifuData.date+=str2.substr(0, 4) + Lang.getLabel("pub_nian") + str2.substr(4, 2) + Lang.getLabel("pub_yue") + str2.substr(6, 2) + Lang.getLabel("pub_ri");

				baifuData.area=Lang.getLabel("pub_di") + m_p1.server_show_num + Lang.getLabel("pub_fu");
				baifuData.isJoinYellowCity=m_p1.is_server == 1 ? true : false;

				if (resData0.length == 0)
				{
					//////////////////////百服全民庆典礼包
					var m_dropList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(baifuData.happyDropID) as Vector.<Pub_DropResModel>;
					var m_dropModel:Pub_DropResModel;
					var m_dropItemVO:DropItemVO
					for (var j:int=0; j < m_dropList.length; j++)
					{
						m_dropModel=m_dropList[j];
						m_dropItemVO=new DropItemVO();
						m_dropItemVO.id=m_dropModel.drop_item_id;
						m_dropItemVO.num=m_dropModel.drop_num;
						resData0.push(m_dropItemVO);
					}
					//////////////////////////////////百服寻宝展示
					m_dropList=GameData.getDropXml().getResPath2(baifuData.findDropID) as Vector.<Pub_DropResModel>;
					for (j=0; j < m_dropList.length; j++)
					{
						m_dropModel=m_dropList[j];
						m_dropItemVO=new DropItemVO();
						m_dropItemVO.id=m_dropModel.drop_item_id;
						m_dropItemVO.num=m_dropModel.drop_num;
						resData4.push(m_dropItemVO);
					}
					////////////////////////////////百服魔王来袭掉落物品展示
					m_dropList=GameData.getDropXml().getResPath2(baifuData.monsterDropID) as Vector.<Pub_DropResModel>;
					for (j=0; j < m_dropList.length; j++)
					{
						m_dropModel=m_dropList[j];
						m_dropItemVO=new DropItemVO();
						m_dropItemVO.id=m_dropModel.drop_item_id;
						m_dropItemVO.num=m_dropModel.drop_num;
						resData5.push(m_dropItemVO);
					}
				}
			}
			else if (p as PacketSCGetHundredSrvData)
			{
				var m_p2:PacketSCGetHundredSrvData=p as PacketSCGetHundredSrvData;
				baifuData.isGetHappy=m_p2.data.action1_log == 0 ? true : false;
				baifuData.HCGetState1=BitUtil.convertToBinaryArr(m_p2.data.action2_log1);
				baifuData.HCGetState2=BitUtil.convertToBinaryArr(m_p2.data.action2_log2);
				baifuData.HCGetState3=BitUtil.convertToBinaryArr(m_p2.data.action2_log3);
				baifuData.getWord=BitUtil.convertToBinaryArr(m_p2.data.action3_log);
			}
			switch (selectType)
			{
				case 1:
					if (WinBaifu.instance.mc != null)
						WinBaifu.instance.mcHandler({name: "btn0", parent: WinBaifu.instance.mc});
					break;
				case 2:
					if (WinBaifuYellowCityResult.instance.mc != null)
						WinBaifuYellowCityResult.instance.fillData();
					break;
				case 3:
					if (WinBaifu.instance.mc != null)
						WinBaifu.instance.mcHandler({name: "btn3", parent: WinBaifu.instance.mc});
					break;
			}
		}
	}
}
