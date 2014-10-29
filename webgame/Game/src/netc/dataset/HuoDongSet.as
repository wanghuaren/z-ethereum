package netc.dataset
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_CommendResModel;
	import common.config.xmlres.server.Pub_Limit_TimesResModel;
	
	import engine.event.DispatchEvent;
	import engine.net.dataset.VirtualSet;
	import engine.utils.HashMap;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCActGetDiscoveringTreasure2;
	import netc.packets2.PacketSCActRank2;
	import netc.packets2.PacketSCActRankPoint2;
	import netc.packets2.PacketSCActWeekOnline2;
	import netc.packets2.PacketSCActivityUpdate2;
	import netc.packets2.PacketSCArChange2;
	import netc.packets2.PacketSCArList2;
	import netc.packets2.PacketSCCampRank2;
	import netc.packets2.PacketSCCityInfoUpdate2;
	import netc.packets2.PacketSCGetCampActRankAward2;
	import netc.packets2.PacketSCGetDayPrizeListInfo2;
	import netc.packets2.PacketSCGetDayPrizeListInfoUpdate2;
	import netc.packets2.PacketSCGetLimitList2;
	import netc.packets2.PacketSCLimitUpdate2;
	import netc.packets2.PacketSCOpenActIds2;
	import netc.packets2.PacketSCSignInAwardData2;
	import netc.packets2.PacketSCSignInData2;
	import netc.packets2.StructActRecList2;
	import netc.packets2.StructActivityPrizeInfo2;
	import netc.packets2.StructCampPlayerRankInfo2;
	import netc.packets2.StructCityFightInfoData2;
	import netc.packets2.StructDayPrizeInfo2;
	import netc.packets2.StructExpBack2;
	import netc.packets2.StructLimitInfo2;
	import netc.packets2.StructSignInItem2;
	
	import nets.packets.PacketCSActWeekOnline;

	public class HuoDongSet extends VirtualSet
	{

		public function init2():void
		{

			var vo:PacketCSActWeekOnline=new PacketCSActWeekOnline();

			DataKey.instance.send(vo);

			//
//			var vo2:PacketCSActGetDiscoveringTreasure = new PacketCSActGetDiscoveringTreasure();
//			
//			DataKey.instance.send(vo2);

		}

		/**
		 * 记次数
		 */
		public const dayTuiJianTaskLimit_id:int=80700651;
		/**
		 * 领了没?
		 */
		//public const dayTuiJianTaskLimit_id_LinQu:int = 80700655;
		//                                                 80700879,80700880,80700881,80700882
		public const dayTuiJianTaskLimit_id_LinQu:Array=[80700879, 80700880, 80700881, 80700882];

		//
		/**
		 *
		 * 3	60100908
		   6	60100909
		   10	60100910
		   14	60100911
		 */
		//public const dayTuiJianTaskDropid:int = 60100549;
		public const dayTuiJianTaskDropid:Array=[60100908, 60100909, 60100910, 60100911];
		private var _dayTuiJianTaskList:Vector.<Pub_CommendResModel>;


		private var _dayTuiJianlist:Vector.<StructActRecList2>=new Vector.<StructActRecList2>();

		/**
		 * 领取
		 */
		private var _arrItemactivityprizelist:Vector.<StructActivityPrizeInfo2>=new Vector.<StructActivityPrizeInfo2>();

		/**
		 *
		 */
		private var _dayTaskList:Vector.<Object>;
		private var _dayHuoDongList:Vector.<Object>;
		private var _bossHuoDongList:Vector.<Object>;
		private var _duoRenHuoDongList:Vector.<Object>;
		private var _kuaFuHuoDongList:Vector.<Object>;

		private var _huoYue:int;

		public static const HUOYUE_UPD:String="HUOYUE_UPD";
		public static const TUIJIAN_LIST_UPD:String="TUIJIAN_LIST_UPD";
		public static const LING_QU_UPD:String="LING_QU_UPD";

		public static const LIMIT_ADD:String="LIMIT_ADD";

		//
		private var _dayTaskAndDayHuoDongLimit:Vector.<StructLimitInfo2>;
		//找回活动经验 andy
		private var vecExp:Vector.<StructExpBack2>=null;
		//经验找回每页显示条数 andy
		public const expBackPageSize:int=9;
		//andy
		public static const EXP_BACK_UPD:String="EXP_BACK_UPD";
		//andy 2012-08-13 可找回多少经验
		public static const EXP_BACK_COUNT:String="EXP_BACK_COUNT";


		//签到 2012-06-12
		private var _qianDao:PacketSCSignInData2=null;
		//抽奖 2012-06-12
		private var _chouJiang:PacketSCSignInAwardData2=null;

		//积分排行
		public static const ACT_NUM:int=4;

		private var _actRankList:Vector.<PacketSCActRank2>;

		private var _zhenYingFuLi:PacketSCCampRank2;

		private var _myJiFen:ActRankPoint3;

		//皇城争霸排行
		private var _arrIteminfo_list:Vector.<StructCityFightInfoData2>;
		//OpenActIds
		private var _arrItemids:Vector.<int>=new Vector.<int>();

		//
		private var _dayTuiTianLinQuList:Vector.<StructDayPrizeInfo2>;


		private var _weekOnline:PacketSCActWeekOnline2;


		private var _xunBao:PacketSCActGetDiscoveringTreasure2;


		public function setXunBao(p:PacketSCActGetDiscoveringTreasure2):void
		{

			_xunBao=p;

		}

		public function get xunBao():PacketSCActGetDiscoveringTreasure2
		{
			if (null == _xunBao)
			{
				_xunBao=new PacketSCActGetDiscoveringTreasure2();
				_xunBao.state=0;
			}

			return _xunBao;
		}


		public function setWeekOnline(p:PacketSCActWeekOnline2):void
		{

			_weekOnline=p;

		}

		public function get weekOnline():PacketSCActWeekOnline2
		{
			return _weekOnline;
		}


		public function setDayTuiJianLinQu(p:PacketSCGetDayPrizeListInfo2):void
		{

			_dayTuiTianLinQuList=new Vector.<StructDayPrizeInfo2>().concat(p.arrItemactivityprizelist);

		}

		public function syncDayTuiJianLinQu(p:PacketSCGetDayPrizeListInfoUpdate2):void
		{
			var len:int=dayTuiJianLinQu.length;

			var find:Boolean=false;

			for (var j:int=0; j < len; j++)
			{

				if (dayTuiJianLinQu[j].limitid == p.activityprizelist.limitid)
				{
					find=true;

					dayTuiJianLinQu[j].isget=p.activityprizelist.isget;

					break;

				}

			} //end for


			if (!find)
			{
				var s:StructDayPrizeInfo2=new StructDayPrizeInfo2();
				s.limitid=p.activityprizelist.limitid;
				s.isget=p.activityprizelist.isget;

				dayTuiJianLinQu.push(s);

			}


		}

		public function get dayTuiJianLinQu():Vector.<StructDayPrizeInfo2>
		{
			if (null == _dayTuiTianLinQuList)
			{
				_dayTuiTianLinQuList=new Vector.<StructDayPrizeInfo2>();
			}

			return _dayTuiTianLinQuList;
		}

		public function isGet(limit_id:int):int
		{
			var _isGet:int=0;

			var len:int=dayTuiJianLinQu.length;

			for (var j:int=0; j < len; j++)
			{
				if (limit_id == dayTuiJianLinQu[j].limitid)
				{
					_isGet=dayTuiJianLinQu[j].isget;

					break;

				}

			}

			return _isGet;
		}

		public function isCanGet():Boolean
		{

			var _isCanGet:Boolean=false;

			var len:int=dayTuiJianLinQu.length;

			//
			var arr:Vector.<Pub_CommendResModel>=dayTuiJianTaskList;

			var kLen:int=arr.length;

			for (var k:int=0; k < kLen; k++)
			{
				//			
				var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(arr[k].limit_id) as Pub_Limit_TimesResModel;

				var limitCount:int;

				if (null == model2)
				{
					limitCount=0;

				}
				else
				{
					limitCount=model2.max_times;
				}


				//== 改为 >= ，以防策划数据填写有误
				var itemData_count:int=arr[k].curnum;

				var _isGet:int=arr[k].isGet(Data.huoDong.isGet);

				//排序规则调整为：可领取奖励的任务→可接取的任务→已完成的任务→不可接取的任务。

				if (itemData_count >= limitCount && 0 == _isGet)
				{
					//arr1.push(arr[k]);
					_isCanGet=true;
					break;
				}


			}

			return _isCanGet;


		}


		public function get zhengbaTopList():Vector.<StructCityFightInfoData2>
		{
			if (null == _arrIteminfo_list)
			{
				_arrIteminfo_list=new Vector.<StructCityFightInfoData2>();
			}

			return _arrIteminfo_list;
		}

		public function syncByOpenActIds(p:PacketSCOpenActIds2):void
		{
			_arrItemids=new Vector.<int>().concat(p.arrItemids);

		}

		public function syncByZhengBaTopList(p:PacketSCCityInfoUpdate2):void
		{
			_arrIteminfo_list=new Vector.<StructCityFightInfoData2>();
			_arrIteminfo_list=_arrIteminfo_list.concat(p.arrIteminfo_list);
		}

		public function syncByActRankList(p:PacketSCActRank2):void
		{
			var i:int;
			var len:int;

			if (null == _actRankList)
			{
				_actRankList=new Vector.<PacketSCActRank2>();
			}

			len=_actRankList.length;

			var find:Boolean=false;
			var Itemlist:Vector.<StructCampPlayerRankInfo2>;

			for (i=0; i < len; i++)
			{
				if (_actRankList[i].actid == p.actid)
				{
					Itemlist=new Vector.<StructCampPlayerRankInfo2>();

					_actRankList[i].arrItemlist=Itemlist.concat(p.arrItemlist);
					_actRankList[i].camp.point1=p.camp.point1;
					_actRankList[i].camp.point2=p.camp.point2;
					_actRankList[i].index=p.index;
					find=true;

					break;
				}

			}

			//
			if (!find)
			{
				var scp:PacketSCActRank2=new PacketSCActRank2();
				scp.actid=p.actid;
				Itemlist=new Vector.<StructCampPlayerRankInfo2>();
				scp.arrItemlist=Itemlist.concat(p.arrItemlist);
				scp.camp.point1=p.camp.point1;
				scp.camp.point2=p.camp.point2;
				scp.index=p.index;

				_actRankList.push(scp);
			}

		}



		public function syncByDayTaskAndDayHuoDongLimit(p:PacketSCLimitUpdate2):void
		{
			var i:int;
			var len:int;

			if (null == _dayTaskAndDayHuoDongLimit)
			{
				_dayTaskAndDayHuoDongLimit=new Vector.<StructLimitInfo2>();
			}

			len=_dayTaskAndDayHuoDongLimit.length;

			//
			var find:Boolean=false;

			for (i=0; i < len; i++)
			{
				if (_dayTaskAndDayHuoDongLimit[i].limitid == p.limitinfo.limitid)
				{
					_dayTaskAndDayHuoDongLimit[i].curnum=p.limitinfo.curnum;
					_dayTaskAndDayHuoDongLimit[i].maxnum=p.limitinfo.maxnum;
					_dayTaskAndDayHuoDongLimit[i].rmbmaxnum=p.limitinfo.rmbmaxnum;
					find=true;
					this.dispatchEvent(new DispatchEvent(HuoDongSet.HUOYUE_UPD, null));

					break;
				}
			}

			if (!find)
			{
				var s:StructLimitInfo2=new StructLimitInfo2();
				s.curnum=p.limitinfo.curnum;
				s.maxnum=p.limitinfo.maxnum;
				s.rmbmaxnum=p.limitinfo.rmbmaxnum;
				s.limitid=p.limitinfo.limitid;

				_dayTaskAndDayHuoDongLimit.push(s);
			}

		}


		public function setDayTaskAndDayHuoDongLimit(p:PacketSCGetLimitList2):void
		{
			var i:int;
			var len:int;

			if (null == _dayTaskAndDayHuoDongLimit)
			{
				_dayTaskAndDayHuoDongLimit=new Vector.<StructLimitInfo2>();
			}

			//

			var find:Boolean=false;
			var noFind:Vector.<StructLimitInfo2>=new Vector.<StructLimitInfo2>();

			var jLen:int=_dayTaskAndDayHuoDongLimit.length;

			len=p.arrItemlimitlistinfo.length;
			for (i=0; i < len; i++)
			{
				find=false;
				jLen=_dayTaskAndDayHuoDongLimit.length;

				for (var j:int=0; j < jLen; j++)
				{
					if (_dayTaskAndDayHuoDongLimit[j].limitid == p.arrItemlimitlistinfo[i].limitid)
					{
						_dayTaskAndDayHuoDongLimit[j]=p.arrItemlimitlistinfo.splice(i, 1)[0];
						i=-1;
						len=p.arrItemlimitlistinfo.length;
						find=true;
						break;
					}

				}

				if (!find)
				{
					noFind.push(p.arrItemlimitlistinfo.splice(i, 1)[0]);
					i=-1;
					len=p.arrItemlimitlistinfo.length;
				}
			}

			//
			len=noFind.length;
			for (i=0; i < len; i++)
			{
				var a:StructLimitInfo2=noFind.shift();
				_dayTaskAndDayHuoDongLimit.push(a);

				this.dispatchEvent(new DispatchEvent(LIMIT_ADD, null));

			}


		}

		public function getDayTaskAndDayHuoDongLimit():Vector.<StructLimitInfo2>
		{
			if (null == _dayTaskAndDayHuoDongLimit)
			{
				_dayTaskAndDayHuoDongLimit=new Vector.<StructLimitInfo2>();
			}

			return _dayTaskAndDayHuoDongLimit;
		}

		/**
		 * 积分排行
		 */
		public function getActRankList():Vector.<PacketSCActRank2>
		{
			if (null == _actRankList)
			{
				_actRankList=new Vector.<PacketSCActRank2>();
			}

			return _actRankList;

		}

		public function getZhenYingFuLi():PacketSCCampRank2
		{
			if (null == _zhenYingFuLi)
			{
				_zhenYingFuLi=new PacketSCCampRank2();

					//这个协议的arrItemplayers没有用了
					//_zhenYingFuLi.data.arrItemplayers = null;
			}

			return _zhenYingFuLi;
		}

		public function getOpenActIds():Vector.<int>
		{
			return _arrItemids;
		}

		public function isAtOpenActIds(actID:int):Boolean
		{

			var _ret:Boolean=false;
			var _list:Vector.<int>=getOpenActIds();
			var _length:int=_list.length;

			for (var i:int=0; i < _length; ++i)
			{
				if (_list[i] == actID)
				{
					_ret=true;
					break;
				}
			}

			return _ret;
		}

		/**
		 *	@2012-07-31 andy 根据一个活动id获得这个活动
		 */
		public function getLimitById(id:int):StructLimitInfo2
		{
			var ret:StructLimitInfo2=null;

			if (null == _dayTaskAndDayHuoDongLimit)
			{
				_dayTaskAndDayHuoDongLimit=new Vector.<StructLimitInfo2>();
			}

			//
			for each (var item:StructLimitInfo2 in _dayTaskAndDayHuoDongLimit)
			{
				if (item.limitid == id)
				{
					ret=item;
					break;
				}
			}

			return ret;
		}


		public function HuoDongSet(pz:HashMap)
		{
			refPackZone(pz);
		}

		/**
		 *	数据有变化
		 */
		public function syncByArChange(p:PacketSCArChange2):void
		{
			var i:int;
			var len:int;

			len=this._dayTuiJianlist.length;

			for (i=0; i < len; i++)
			{
//				if (this._dayTuiJianlist[i].arid == p.ar_id)
//				{
					//this._dayTuiJianlist[i].cur_num = this._dayTuiJianlist[i].count = p.cur_num;
//					this._dayTuiJianlist[i].count=p.cur_num;
//					this._dayTuiJianlist[i].change_type=p.change_type;
//				}
			}

			this.dispatchEvent(new DispatchEvent(TUIJIAN_LIST_UPD, null));
		}

		public function syncByDayTuiJianLimit(p:PacketSCLimitUpdate2):void
		{
			var i:int;
			var len:int;

			len=this._dayTuiJianlist.length;

			for (i=0; i < len; i++)
			{
				if (this._dayTuiJianlist[i].limit_id == p.limitinfo.limitid)
				{
					//this._dayTuiJianlist[i].cur_num = this._dayTuiJianlist[i].count = p.cur_num;
					this._dayTuiJianlist[i].count=p.limitinfo.curnum;
						//this._dayTuiJianlist[i].change_type = p.change_type;
				}
			}

			this.dispatchEvent(new DispatchEvent(TUIJIAN_LIST_UPD, null));

		}

		public function syncByArList(p:PacketSCArList2):void
		{

//			if (1 == p.sort)
//			{
//				_dayTuiJianlist=p.arrItemactlist;
//			}


		}

		public function get dayTuiJian():Vector.<StructActRecList2>
		{
			return this._dayTuiJianlist;
		}

		public function get dayTask():Vector.<Object>
		{
			if (null == this._dayTaskList)
			{
				_dayTaskList=XmlManager.localres.ActionDescXml.getListBySort(1) as Vector.<Object>;
			}

			return this._dayTaskList.concat();
		}

		public function get dayTuiJianTaskList():Vector.<Pub_CommendResModel>
		{
			if (null == this._dayTuiJianTaskList)
			{
				_dayTuiJianTaskList=XmlManager.localres.CommendXml.getList() as Vector.<Pub_CommendResModel>;
			}

			//upd ar_complete
			var len:int=_dayTuiJianTaskList.length;

			for (var i:int=0; i < len; i++)
			{
				var limit_id:int=_dayTuiJianTaskList[i].limit_id;

				var limit_info:StructLimitInfo2=this.getLimitById(limit_id);

				if (null != limit_info)
				{
					_dayTuiJianTaskList[i].curnum=limit_info.curnum;
					_dayTuiJianTaskList[i].maxnum=limit_info.maxnum;
					_dayTuiJianTaskList[i].rmbmaxnum=limit_info.rmbmaxnum;
				}

			}

			return _dayTuiJianTaskList.concat();
		}

		public function get dayHuoDong():Vector.<Object>
		{
			if (null == this._dayHuoDongList)
			{
				_dayHuoDongList=XmlManager.localres.ActionDescXml.getListBySort(2) as Vector.<Object>;
			}

			return this._dayHuoDongList.concat();
		}

		public function bossHuoDong(value:int=3):Vector.<Object>
		{
//			if (null == this._bossHuoDongList)
//			{
//				_bossHuoDongList=XmlManager.localres.ActionDescXml.getListBySort(value);
//			}
//			return this._bossHuoDongList.concat();
			return XmlManager.localres.ActionDescXml.getListBySort(value) as Vector.<Object>;
		}

		public function get duoRenHuoDong():Vector.<Object>
		{
			if (null == this._duoRenHuoDongList)
			{
				_duoRenHuoDongList=XmlManager.localres.ActionDescXml.getListBySort(4) as Vector.<Object>;
				var _add:Vector.<Object>=XmlManager.localres.ActionDescXml.getListBySort(41) as Vector.<Object>;
				_duoRenHuoDongList=_duoRenHuoDongList.concat(_add);
			}

			return this._duoRenHuoDongList.concat();
		}

		public function get kuaFuHuoDong():Vector.<Object>
		{
			if (null == this._kuaFuHuoDongList)
			{
				_kuaFuHuoDongList=XmlManager.localres.ActionDescXml.getListBySort(8) as Vector.<Object>;
			}

			return this._kuaFuHuoDongList.concat();
		}

		/**
		 *
		 */
		public function syncByActivityPrizeList(list:Vector.<StructActivityPrizeInfo2>, activity:int=-1):void
		{
			var i:int;
			var len:int;

			//clear

			_arrItemactivityprizelist=list;


			//
			if (-1 != activity)
			{
				_huoYue=activity;
				this.dispatchEvent(new DispatchEvent(HUOYUE_UPD, activity));
			}

			//参数需要是activity
			this.dispatchEvent(new DispatchEvent(LING_QU_UPD, activity));
		}

		public function syncByActivityUpdate(p:PacketSCActivityUpdate2):void
		{
			syncByActivityPrizeList(p.arrItemactivityprizelist, p.activity);
		}

		public function get linQu():Vector.<StructActivityPrizeInfo2>
		{
			return _arrItemactivityprizelist;
		}

		public function get huoYue():int
		{
			return _huoYue;
		}

		//PacketSCGetCampActRankAward2
		public function setAward(p:PacketSCGetCampActRankAward2):void
		{

		}


		public function setZhenYingFuLi(p:PacketSCCampRank2):void
		{
			_zhenYingFuLi=p;

		}

		public function syncMyJiFen(p:PacketSCActRankPoint2):void
		{
			//upd总积分
			this.myJiFen.cur_point_total=p.cur_point_total;
			this.myJiFen.prev_point_total=p.prev_point_total;

			//upd 分活动积分
			var j:int;

			var actid:int;

			for (j=0; j < this.myJiFen.pointList.length; j++)
			{
				actid=this.myJiFen.pointList[j].actid;
				if (actid == p.actid)
				{
					this.myJiFen.pointList[j].cur_point=p.point;
				}

			}

			//
			for (j=0; j < this.myJiFen.pointList.length; j++)
			{
				actid=this.myJiFen.pointList[j].actid;

				for (var k:int=0; k < p.arrItemprev_acts.length; k++)
				{
					if (actid == p.arrItemprev_acts[k].actid)
					{
						this.myJiFen.pointList[j].prev_point=p.arrItemprev_acts[k].point;

					}

				}
			}

		}


		public function get myJiFen():ActRankPoint3
		{
			if (null == this._myJiFen)
			{
				this._myJiFen=new ActRankPoint3();
			}

			return this._myJiFen;
		}



		/***********签到**************/
		public function setQianDao(v:PacketSCSignInData2=null):void
		{
			_qianDao=v;
		}

		public function getQianDao():PacketSCSignInData2
		{
			return _qianDao;
		}

		/**
		 *	获得某天是否签到 【目前每月只看28天】
		 */
		public function getIsQianDaoByDay(day:int=0):Boolean
		{
			if (_qianDao == null)
				return false;
			if (day == 0)
				day=_qianDao.dayIndex;
			if (day == 0)
				day=1;
			return (_qianDao.sign & Math.pow(2, day - 1)) > 0;
		}

		/**
		 *	获得某天是否补签 【目前每月只看28天】
		 */
		public function getIsBuQianByDay(day:int=0):Boolean
		{
			if (_qianDao == null)
				return false;
			if (day == 0)
				day=_qianDao.dayIndex;
			if (day == 0)
				day=1;
			return (_qianDao.patch & Math.pow(2, day - 1)) > 0;
		}

		/**
		 *	连续签到天数【补签不算连续，从今天向前2天】
		 */
		public function getLianXuTimes():int
		{
			var ret:int=0;
			var end:int=_qianDao.dayIndex - 3;
			end=end < 0 ? 0 : end;
			for (var i:int=_qianDao.dayIndex; i > end; i--)
			{
				if (getIsQianDaoByDay(i))
					ret++;
				else
				{
					if (i == _qianDao.dayIndex)
						continue;
					else
						break;
				}
			}
			return ret;
		}

		/**
		 *	累计签到天数【补签也算】
		 */
		public function getLeiJiTimes():int
		{
			var ret:int=0;
			if (_qianDao == null)
				return 0;
			for (var i:int=1; i <= _qianDao.dayIndex; i++)
			{
				if (getIsQianDaoByDay(i))
					ret++;
				else if (getIsBuQianByDay(i))
					ret++;
				else
				{
				}
			}
			//2014-02-12 andy 策划调整签到累计显示规则：累计奖励只能领取一次，累计天数不清零
			//ret=0//_qianDao.
			return ret;
		}

		/**
		 *	今天可抽奖次数
		 */
		public function countChouJiangTimes():int
		{
			if (_qianDao == null)
				return 0;
			var ret:int=_qianDao.alltimes - _qianDao.times;

			return ret < 0 ? 0 : ret;
		}

		/**
		 *	累计奖励是否领取
		 */
		public function getIsLingJiangByDay(day:int=0):Boolean
		{
			if (_qianDao == null)
				return false;
			if (day <= 0)
				day=1;
			return (_qianDao.accumulatestate & Math.pow(2, day - 1)) > 0;
		}

		/***********抽奖**************/
		public function setChouJiang(v:PacketSCSignInAwardData2):void
		{
			_chouJiang=v;
		}

		public function getChouJiang():PacketSCSignInAwardData2
		{
			return _chouJiang;
		}

		/**
		 *	得到中将ID的索引
		 */
		public function getZhongJiangIndex(v:int=0):int
		{
			var ret:int=-1;
			if (_chouJiang == null)
				return 0;
			for each (var item:StructSignInItem2 in _chouJiang.arrItemitemlist)
			{
				if (item.itemid == v)
				{
					ret=_chouJiang.arrItemitemlist.indexOf(item);
					break;
				}
			}
			return ret;
		}


	}
}
