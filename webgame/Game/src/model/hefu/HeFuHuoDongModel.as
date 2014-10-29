package model.hefu
{
	import common.config.XmlConfig;
	import common.config.xmlres.GameData;
	import common.config.xmlres.server.Pub_CombineResModel;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;

	import netc.Data;
	import netc.DataKey;

	import nets.packets.PacketCSMergeServerData;
	import nets.packets.PacketCSMergeServerItem;
	import nets.packets.PacketSCMergeServerData;
	import nets.packets.PacketSCMergeServerItem;

	import ui.view.hefu.HeFuHuongDongItem;
	import ui.view.view6.Alert;
	import ui.view.view6.GameAlert;

	public class HeFuHuoDongModel
	{
		/**
		 * 面板1活动数据 合服神秘商店
		 * */
		public var resData0:Vector.<HeFuHuongDongPanelVO>=new Vector.<HeFuHuongDongPanelVO>(4);
		/**
		 * 今天刷新次数，有上限
		 * */
		public var refreshNum:int=0;
		/**
		 * 是否可以购买神秘商店中物品1
		 * */
		public var canBuy0:Boolean=true;
		/**
		 * 是否可以购买神秘商店中物品2
		 * */
		public var canBuy1:Boolean=true;
		/**
		 * 是否可以购买神秘商店中物品3
		 * */
		public var canBuy2:Boolean=true;
		/**
		 * 是否可以购买神秘商店中物品4
		 * */
		public var canBuy3:Boolean=true;
		/**
		 * 面板2活动数据 合服折扣商店
		 * */
		public var resData1:Vector.<HeFuHuongDongPanelVO>=new Vector.<HeFuHuongDongPanelVO>(6);
		/**
		 * 面板3活动数据 合服超值礼包
		 * */
		public var resData2:Vector.<Vector.<HeFuHuongDongPanelVO>>=new Vector.<Vector.<HeFuHuongDongPanelVO>>(3)
		/**
		 * 是否可以购买天劫礼包
		 * */
		public var canGetTJ:Boolean=true;
		/**
		 * 是否可以购买王者礼包
		 * */
		public var canGetWZ:Boolean=true;
		/**
		 * 是否可以购买至尊礼包
		 * */
		public var canGetZZ:Boolean=true;
		/**
		 * 面板4活动数据 合服全民礼包
		 * */
		public var resData3:Vector.<HeFuHuongDongPanelVO>=new Vector.<HeFuHuongDongPanelVO>(5);
		/**
		 * 是否可以领取合服全民大礼包
		 * */
		public var canGetQM:Boolean=true;
		/**
		 * 面板5活动数据 合服皇城争霸 道 战 法 刺 一级 二级 三级
		 * */
		public var resData4:Vector.<Vector.<HeFuHuongDongPanelVO>>=new Vector.<Vector.<HeFuHuongDongPanelVO>>(7);
		/**
		 * 合服皇城争霸第一次领取物品编号
		 * */
		public var resID1:int=0;
		/**
		 * 合服皇城争霸第二次领取物品编号
		 * */
		public var resID2:int=0;
		/**
		 * 合服皇城争霸第三次领取物品编号
		 * */
		public var resID3:int=0;
		/**
		 * 面板6活动数据 合服充值返利
		 * */
		public var resData5:Vector.<HeFuHuongDongPanelVO>=new Vector.<HeFuHuongDongPanelVO>();
		/**
		 * 已充值
		 * */
		public var coin:int=0;
		/**
		 * 充值返利状态 0 未购买 1 已购买
		 * */
		public var canGetCZFL:Array=[];

		/**
		 * 是否可以免费领取
		 * */
		public function HeFuHuoDongModel()
		{
			DataKey.instance.register(PacketSCMergeServerData.id, backPanelData);
			DataKey.instance.register(PacketSCMergeServerItem.id, backGetItemData);
		}
		private static var _instance:HeFuHuoDongModel;

		public static function get instance():HeFuHuoDongModel
		{
			if (_instance == null)
			{
				_instance=new HeFuHuoDongModel();
			}
			return _instance;
		}
		private var sendData:PacketCSMergeServerData=new PacketCSMergeServerData();
		private var panelData:PacketSCMergeServerData=new PacketSCMergeServerData();
		private var currNum:int=0;

		/**
		 * 获取面板数据
		 * */
		public function getPanelData(num:int):void
		{
			currNum=num;
			DataKey.instance.send(sendData);
		}

		public function backPanelData(p:PacketSCMergeServerData):void
		{
			panelData=p;

			switch (currNum)
			{
				case 0:
					var m_model:Pub_CombineResModel;
					for (var i:int=0; i < panelData.arrItemaction1_items.length; i++)
					{
						m_model=GameData.getCombineXml().getResPath(panelData.arrItemaction1_items[i]) as Pub_CombineResModel;
						if (resData0[i] == null)
						{
							resData0[i]=new HeFuHuongDongPanelVO();
						}
						resData0[i].index=m_model.id;
						resData0[i].id=m_model.tool_id;

						if (m_model.need_coin1 > 0)
						{
							resData0[i].price=m_model.coin1 + Lang.getLabel("yinliang");
							resData0[i].nowPrice=m_model.need_coin1 + Lang.getLabel("yinliang");
						}
						else if (m_model.need_coin2 > 0)
						{
							resData0[i].price=m_model.coin2 + Lang.getLabel("lijin");
							resData0[i].nowPrice=m_model.need_coin2 + Lang.getLabel("lijin");
						}
						else if (m_model.need_coin3 > 0)
						{
							resData0[i].price=m_model.coin3 + Lang.getLabel("yuanbao");
							resData0[i].nowPrice=m_model.need_coin3 + Lang.getLabel("yuanbao");
						}
					}

					refreshNum=p.data.refresh_index;
					var arr:Array=BitUtil.convertToBinaryArr(p.data.action1_buylog);
					canBuy0=arr[0] == 0 ? true : false;
					canBuy1=arr[1] == 0 ? true : false;
					canBuy2=arr[2] == 0 ? true : false;
					canBuy3=arr[3] == 0 ? true : false;

					HeFuHuongDongItem.instance.showContent(resData0);
					break;
				case 1:
					var m_list:Vector.<Pub_CombineResModel>=GameData.getCombineXml().getListBySort(2) as Vector.<Pub_CombineResModel>;
					for (i=0; i < resData1.length; i++)
					{
						m_model=m_list[i];
						if (resData1[i] == null)
						{
							resData1[i]=new HeFuHuongDongPanelVO();
						}
						resData1[i].index=m_model.id;
						resData1[i].id=m_model.tool_id;
						if (m_model.need_coin1 > 0)
						{
							resData1[i].price=m_model.coin1 + Lang.getLabel("yinliang");
							resData1[i].nowPrice=m_model.need_coin1 + Lang.getLabel("yinliang");
						}
						else if (m_model.need_coin2 > 0)
						{
							resData1[i].price=m_model.coin2 + Lang.getLabel("lijin");
							resData1[i].nowPrice=m_model.need_coin2 + Lang.getLabel("lijin");
						}
						else if (m_model.need_coin3 > 0)
						{
							resData1[i].price=m_model.coin3 + Lang.getLabel("yuanbao");
							resData1[i].nowPrice=m_model.need_coin3 + Lang.getLabel("yuanbao");
						}
					}
					HeFuHuongDongItem.instance.showContent(resData1);
					break;
				case 2:
					m_list=GameData.getCombineXml().getListBySort(3) as Vector.<Pub_CombineResModel>;
					for (i=0; i < m_list.length; i++)
					{
						if (resData2[i] == null)
						{
							resData2[i]=new Vector.<HeFuHuongDongPanelVO>(8);
						}
						m_dropList=GameData.getDropXml().getResPath2(m_list[i].drop_id) as Vector.<Pub_DropResModel>;
						for (var j:int=0; j < resData2[i].length; j++)
						{
							if (m_dropList.length > j)
							{
								var m_dropModel:Pub_DropResModel=m_dropList[j];
								if (resData2[i][j] == null)
								{
									resData2[i][j]=new HeFuHuongDongPanelVO();
								}
								resData2[i][j].index=m_list[i].id;
								resData2[i][j].id=m_dropModel.drop_item_id;
								resData2[i][j].num=m_dropModel.drop_num;
							}
						}
					}

					arr=BitUtil.convertToBinaryArr(p.data.action3_buylog);
					canGetTJ=arr[0] == 0 ? true : false;
					canGetWZ=arr[1] == 0 ? true : false;
					canGetZZ=arr[2] == 0 ? true : false;

					HeFuHuongDongItem.instance.showContent(null, resData2);
					break;
				case 3:
					m_list=GameData.getCombineXml().getListBySort(4) as Vector.<Pub_CombineResModel>;
					var m_dropList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(m_list[0].drop_id) as Vector.<Pub_DropResModel>;
					for (i=0; i < resData3.length; i++)
					{
						if (m_dropList.length > i)
						{
							m_dropModel=m_dropList[i];
							if (resData3[i] == null)
							{
								resData3[i]=new HeFuHuongDongPanelVO();
							}
							resData3[i].index=m_list[0].id;
							resData3[i].id=m_dropModel.drop_item_id;
							resData3[i].num=m_dropModel.drop_num;
						}
					}
					//全民礼包   0是没有领
					canGetQM=p.data.action4_buylog == 0 ? true : false;
					HeFuHuongDongItem.instance.showContent(resData3);
					break;
				case 4:
					m_list=GameData.getCombineXml().getListBySort(5) as Vector.<Pub_CombineResModel>;
					var m_son:int=6;
					var m_item:HeFuHuongDongPanelVO;
					for (i=0; i < m_list.length; i++)
					{
						m_model=m_list[i];
						var m_sort:int=m_model.sort_id;

						if (m_sort < 20)
						{
							//道士
							if (resData4[0] == null)
							{
								resData4[0]=new Vector.<HeFuHuongDongPanelVO>();
							}
							if (resData4[0].length < m_son)
							{
								m_item=new HeFuHuongDongPanelVO();
								m_item.index=m_model.id;
								m_item.id=m_model.tool_id;
								resData4[0].push(m_item);
							}
						}
						else if (m_sort < 40)
						{
							//战士
							if (resData4[1] == null)
							{
								resData4[1]=new Vector.<HeFuHuongDongPanelVO>();
							}
							if (resData4[1].length < m_son)
							{
								m_item=new HeFuHuongDongPanelVO();
								m_item.index=m_model.id;
								m_item.id=m_model.tool_id;
								resData4[1].push(m_item);
							}
						}
						else if (m_sort < 50)
						{
							//法师
							if (resData4[2] == null)
							{
								resData4[2]=new Vector.<HeFuHuongDongPanelVO>();
							}
							if (resData4[2].length < m_son)
							{
								m_item=new HeFuHuongDongPanelVO();
								m_item.index=m_model.id;
								m_item.id=m_model.tool_id;
								resData4[2].push(m_item);
							}
						}
						else if (m_sort < 70)
						{
							//刺客
							if (resData4[3] == null)
							{
								resData4[3]=new Vector.<HeFuHuongDongPanelVO>();
							}
							if (resData4[3].length < m_son)
							{
								m_item=new HeFuHuongDongPanelVO();
								m_item.index=m_model.id;
								m_item.id=m_model.tool_id;
								resData4[3].push(m_item);
							}
						}
						else if (m_sort < 200)
						{
							//一级
							if (int((m_sort - 100) / 10) == Data.myKing.metier)
							{
								//是否本职业
								if (resData4[4] == null)
								{
									resData4[4]=new Vector.<HeFuHuongDongPanelVO>();
								}
								if (resData4[4].length < m_son)
								{
									m_item=new HeFuHuongDongPanelVO();
									m_item.index=m_model.id;
									m_item.id=m_model.tool_id;
									resData4[4].push(m_item);
								}
							}
						}
						else if (m_sort < 300)
						{
							//二级
							if (int((m_sort - 200) / 10) == Data.myKing.metier)
							{
								//是否本职业
								if (resData4[5] == null)
								{
									resData4[5]=new Vector.<HeFuHuongDongPanelVO>();
								}
								if (resData4[5].length < m_son)
								{
									m_item=new HeFuHuongDongPanelVO();
									m_item.index=m_model.id;
									m_item.id=m_model.tool_id;
									resData4[5].push(m_item);
								}
							}
						}
						else if (m_sort < 400)
						{
							//三级
							if (int((m_sort - 300) / 10) == Data.myKing.metier)
							{
								//是否本职业
								if (resData4[6] == null)
								{
									resData4[6]=new Vector.<HeFuHuongDongPanelVO>();
								}
								if (resData4[6].length < m_son)
								{
									m_item=new HeFuHuongDongPanelVO();
									m_item.index=m_model.id;
									m_item.id=m_model.tool_id;
									resData4[6].push(m_item);
								}
							}
						}
					}
					resID1=p.data.action5_buylog1;
					resID2=p.data.action5_buylog2;
					resID3=p.data.action5_buylog3;

					HeFuHuongDongItem.instance.showContent(null, resData4);
					break;
				case 5:
					//合服返利
					m_list=GameData.getCombineXml().getListBySort(6) as Vector.<Pub_CombineResModel>;
					for (j=0; j < m_list.length; j++)
					{
						m_dropList=GameData.getDropXml().getResPath2(m_list[j].drop_id) as Vector.<Pub_DropResModel>;
						for (i=0; i < m_dropList.length; i++)
						{
//							if (m_dropList.length > i)
//							{
							m_dropModel=m_dropList[i];
							while (resData5.length <= j * m_dropList.length + i)
							{
								resData5.push(null);
							}
							if (resData5[j * m_dropList.length + i] == null)
							{
								resData5[j * m_dropList.length + i]=new HeFuHuongDongPanelVO()
							}
							resData5[j * m_dropList.length + i].index=m_list[j].id;
							resData5[j * m_dropList.length + i].id=m_dropModel.drop_item_id;
							resData5[j * m_dropList.length + i].num=m_dropModel.drop_num;
							resData5[j * m_dropList.length + i].yuanBao=m_list[j].need_coin3;
//							}
						}
					}
					coin=p.data.action6_rmb;
					canGetCZFL=BitUtil.convertToBinaryArr(p.data.action6_buylog);

					HeFuHuongDongItem.instance.showContent(resData5);
					break;
			}
		}
		private var mergeItem:PacketCSMergeServerItem=new PacketCSMergeServerItem();

		/**
		 * 得到合服物品
		 * */
		public function getItem(resIndex:int=0):void
		{
			mergeItem.type=currNum + 1;
			mergeItem.index=resIndex;
			DataKey.instance.send(mergeItem);
		}

		public function backGetItemData(p:PacketSCMergeServerItem):void
		{
			Lang.showResult(p);
		}
	}
}
