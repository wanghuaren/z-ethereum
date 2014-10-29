package model.jingjie
{
	import common.config.xmlres.XmlManager;
	import common.managers.Lang;
	
	import netc.Data;
	import netc.packets2.PacketSCPetData2;

	/**
	 * 境界是玩家和伙伴的一个固有属性，境界一共有10级，初始为0级 .玩家可以通过使用丹药提高境界
	 * [修改]境界一共有7级 ，每级暂定为10星，具体星的上限是可以配置的
	 * @author steven guo
	 *
	 */
	public class JingjieModel
	{
		private static var m_instance:JingjieModel;
		/**
		 * 境界球数量 上限
		 */
		public static const LIMIT:int=7;
		//境界 生命 属性加成
		private static const JINGJIE_SHENG_MING:int=1;
		//境界 攻击 属性加成
		private static const JINGJIE_GONG_JI:int=5;
		//境界 防御 属性加成
		private static const JINGJIE_FANG_YU:int=6;
		//最小可吃丹药与境界等级的差值
		public static const JINGJIE_LOWEST_LEVEL_DANYAO_CHAZHI:int=1;
		/**
		 * 境界等级列表，每个等级的境界的属性和名称都是不同的。(读取策划配置表格)
		 *
		 */
		//private var m_names:Array = null;
		/**
		 * 境界对象的列表，其中包括 当前玩家角色 ，以及该角色的伙伴列表
		 *
		 */
		private var m_petList:Array;
		/**
		 * 当前吃药的角色 索引【现在只有主角】
		 *
		 */
		private var m_cIndex:int=0;
		/**
		 * 境界等级的数值
		 */
		private var m_jingjieList:Array=[];
		/**
		 * 境界经验值
		 */
		private var m_jingjieValueList:Array=[];
		/**
		 * 境界增加的属性 ，比如： 攻击力 ，防御力 ，生命力
		 */
		private var m_jingjieAdd:Array=[];
		/**
		 * 是否直接通过元宝购买境界丹药，而不需要再通知玩家
		 */
		private var m_isTishi:Boolean;
		/**
		 * 当前已领的境界奖励等级【废弃】
		 */
		private var m_award_level:int;
		//new codes
		private var jingJieAreas:Array=[];
		/********* 境界区域是否开启 *********/
		public var mc_qingLongEnabled:Boolean=true; //默认开启
		public var mc_baiHuEnabled:Boolean=false;
		public var mc_xuanWuEnabled:Boolean=false;
		public var mc_zhuQueEnabled:Boolean=false;
		public var mc_qingLongTip:String="";
		public var mc_baiHuTip:String="";
		public var mc_xuanWuTip:String="";
		public var mc_zhuQueTip:String="";
		public var jingJieStarLevelLimit:int=0;
		/**
		 * 境界强化等级
		 */
		public var jingJieStarLevel:int=0;

		//-----------
		public function JingjieModel()
		{
			m_jingjieList[0]=0;
			m_jingjieList[1]=0;
			m_jingjieList[2]=0;
			m_jingjieList[3]=0;
			m_jingjieValueList[0]=0;
			m_jingjieValueList[1]=0;
			m_jingjieValueList[2]=0;
			m_jingjieValueList[3]=0;
			jingJieAreas[0]=[];
			jingJieAreas[1]=[];
			jingJieAreas[2]=[];
			jingJieAreas[3]=[];
		}

		public static function getInstance():JingjieModel
		{
			if (null == m_instance)
			{
				m_instance=new JingjieModel();
			}
			return m_instance;
		}

		/**
		 * 【废弃】
		 * @return
		 *
		 */
		public function getPetList():Array
		{
			return null;
//			m_petList = [];
//			
//			var _list:Array = Data.huoBan.getPetList();
//			var _petData:PacketSCPetData2 = null;
//			var _petData0:PacketSCPetData2 = null;  //如果 Pos 为 0 的时候暂时放到这里
//			
//			var _listLen:uint = _list.length;
//			//for(var i:int = 0; i<_list.length; ++i)
//			for(var i:int = 0; i<_listLen; ++i)
//			{
//				_petData =  _list[i] as PacketSCPetData2;
//				
//				if( 0 == _petData.Pos )
//				{
//					_petData0 = _petData;
//				}
//				else 
//				{
//					m_petList[_petData.Pos] = _petData;
//				}
//			}
//			
//			if(null != _petData0)
//			{
//				for(var n:int = 1; n<=3; ++n)
//				{
//					if(null == m_petList[n])
//					{
//						m_petList[n] = _petData0;
//						break;
//					}
//				}
//			}
//			
//			
//			return m_petList;
		}

		/**
		 * 获得一个宠物的索引 【废弃】
		 * @return
		 *
		 */
		public function getPetOneIndex():int
		{
			var _ret:int=0;
			var _list:Array=getPetList();
			if (null != _list || _list.length > 0)
			{
				for (var i:int=0; i < _list.length; ++i)
				{
					if (null != _list[i])
					{
						_ret=i;
						break;
					}
				}
			}
			return _ret;
		}

		/**
		 *
		 * @param petID【废弃】
		 * @return
		 *
		 */
		public function getPetIndexByID(petID:int):int
		{
			var _list:Array=getPetList();
			if (null == _list || _list.length <= 0)
			{
				return 0;
			}
			var _ret:int=0;
			for (var i:int=0; i < _list.length; ++i)
			{
				if (null != _list[i] && _list[i].PetId == petID)
				{
					_ret=i;
					break;
				}
			}
			return _ret;
		}

		/**
		 * 通过指定一个索引获得一个 伙伴 (宠物)  的对象。【废弃】
		 * @param index
		 * @return
		 *
		 */
		public function getPet(index:int):PacketSCPetData2
		{
			var _ret:PacketSCPetData2=null;
			if (index <= 0 || index >= 4)
			{
				return _ret;
			}
			var _list:Array=getPetList();
			if (_list && _list[index])
			{
				_ret=_list[index];
			}
			return _ret;
		}

		public function setIndex(index:int):void
		{
			this.m_cIndex=index;
			//打开境界界面，向服务器发起更新 角色 或者 伙伴 信息
			JingjieController.getInstance().requestCSBourn(this.m_cIndex);
		}

		public function getIndex():int
		{
			return m_cIndex;
		}

		/**
		 * 设置某个角色或者伙伴的境界值呀  【废弃】
		 * @param index
		 * @param value
		 *
		 */
		public function setJingjie(index:int, jingjie:int):void
		{
			if (index < 0 || index > 3)
			{
				return;
			}
			m_jingjieList[index]=jingjie;
		}

		public function getJingjie(index:int):int
		{
			if (index < 0 || index > 3)
			{
				return -1;
			}
			return m_jingjieList[index];
		}

		public function setJingjieValue(index:int, value:int):void
		{
			if (index < 0 || index > 3)
			{
				return;
			}
			m_jingjieValueList[index]=value;
		}

		public function getJingjieValue(index:int):int
		{
			if (index < 0 || index > 3)
			{
				return -1;
			}
			return m_jingjieValueList[index];
		}

		public function setAwardLevel(l:int):void
		{
			m_award_level=l;
		}

		public function getAwardLevel():int
		{
			return m_award_level;
		}

		/**
		 * 设置境界增加的属性
		 * @param index    角色索引，或者 伙伴
		 * @param g        攻击力
		 * @param f		        防御力
		 * @param s        生命力
		 * @return
		 *
		 */
		public function setJingjieAdd(index:int, g:int, f:int, s:int):void
		{
			if (index < 0 || index > 3)
			{
				return;
			}
			m_jingjieAdd[index]={gongji: g, fangyu: f, shengming: s};
		}

		public function getJingjieAdd(index:int):Object
		{
			return m_jingjieAdd[index];
		}

		/**
		 * 通过境界值 获得 属于那个等级 [废弃]
		 * @param value
		 * @return
		 *
		 */
		public function getJingjieLevel(value:int):int
		{
//			var _t:Pub_BournXml = XmlManager.localres.getPubBournXml;
//			var _m:Pub_BournResModel = null;
//			var _level:int = 0;
//			
//			//一共 10 个等级
//			for(var i:int=1 ; i<=10 ; ++i)
//			{
//				_m = _t.getResPath(i);
//				if( value >= _m.need_exp)
//				{
//					_level = i;
//				}
//				else
//				{
//					break;
//				}
//			}
//			
//			return _level;
			return 0;
		}

		/**
		 * 获得某个角色或者伙伴的境界的等级
		 * @return
		 *
		 */
		public function getLevelByIndex(index:int):int
		{
			return getJingjieLevel(getJingjieValue(index));
		}

		/**
		 * 获得当前选中的 角色 或者 伙伴的境界等级
		 * @return
		 *
		 */
		public function getLevel():int
		{
			return getLevelByIndex(getIndex());
		}

		/**
		 * 获得境界百分比的值
		 * @return
		 *
		 */
		public function getParcent():int
		{
			//该境界期 最大值
//			var _maxexp:int = 0;
//			var _t:Pub_BournXml = XmlManager.localres.getPubBournXml;
//			
//			//当前境界的等级
//			var _level:int = getLevelByIndex(m_cIndex);  //m_jingjieList[m_cIndex];
//			
//			var _m:Pub_BournResModel = _t.getResPath(_level);
//			var _mNext:Pub_BournResModel = _t.getResPath((_level+1));
//			
//			_maxexp = _mNext.need_exp - _m.need_exp;
//			
//			//当前的经验
//			var _cValue:int = getJingjieValue(m_cIndex);
//			var _p:int = (_cValue-_m.need_exp) / _maxexp * 100;
//			
//			if(_p > 100)
//			{
//				_p = 100;
//			}
			//return _p;
			return 0;
		}

		public function getCurrentParcent(index:int, level:int):int
		{
//			//该境界期 最大值
//			var _maxexp:int = 0;
//			var _t:Pub_BournXml = XmlManager.localres.getPubBournXml;
//			var _m:Pub_BournResModel = _t.getResPath(level);
//			
//			if(null == _m)
//			{
//				return 0;
//			}
//			
//			var _mNext:Pub_BournResModel = _t.getResPath((level+1));
//			
//			_maxexp = _mNext.need_exp - _m.need_exp;
//			
//			//当前的经验
//			var _cValue:int = getJingjieValue(index);
//			var _p:int = (_cValue-_m.need_exp) / _maxexp * 100;
//			
//			if(_p > 100)
//			{
//				_p = 100;
//			}
//			
//			return _p;
			return 0;
		}

		/**
		 * 获得百分比进度字符串
		 * @return
		 *
		 */
		public function getStringBar():String
		{
//			//该境界期 最大值
//			var _maxexp:int = 0;
//			var _t:Pub_BournXml = XmlManager.localres.getPubBournXml;
//			
//			//当前境界的等级
//			var _level:int = getLevel();
//			
//			var _m:Pub_BournResModel = _t.getResPath(_level);
//			var _mNext:Pub_BournResModel = _t.getResPath((_level+1));
//			
//			_maxexp = _mNext.need_exp - _m.need_exp;
//			
//			//当前的经验
//			var _cValue:int = getJingjieValue(getIndex());
//			
//			var _ret:String =Lang.getLabel("pub_jing_yan")+":"+ (_cValue-_m.need_exp) +"/"+_maxexp;
//			
//			return _ret;
			return null;
		}

		/**
		 * 是否直接通过元宝购买境界丹药，而不需要再通知玩家
		 * @param b
		 *
		 */
		public function setIsTishi(b:Boolean):void
		{
			this.m_isTishi=b;
		}

		public function getIsTishi():Boolean
		{
			return this.m_isTishi;
		}

		/**
		 * 根据境界等级返回适合的丹药
		 * @param index
		 *
		 */
		public function selectPillId(index:int):int
		{
			if (index < 0 || index > 3)
			{
				return 0;
			}
			var _level:int=this.m_jingjieList[index];
			var _beseId:int=10701000;
			var _ret:int=10701000 + _level;
			if (_level <= 0)
			{
				_ret=10701001;
			}
			return _ret;
		}

		/**
		 * 吃药的时候比较一下当前境界的等级 与 自身的等级是否相符合
		 * @return
		 *
		 */
		private function _canEat():Boolean
		{
			//人物的等级或者伙伴的等级
			var _level:int;
			if (0 == this.m_cIndex)
			{
				//获得人物的等级
				_level=Data.myKing.level;
			}
			else
			{
				//获得宠物的等级
				_level=getPet(this.m_cIndex).Level;
			}
			//人物或者伙伴的境界等级
			var _jingjieLevel:int;
			_jingjieLevel=getJingjie(this.m_cIndex);
			if (_jingjieLevel >= 10)
			{
				return false;
			}
			else
			{
				_jingjieLevel=_jingjieLevel + 1;
			}
			//从配置表格中找到当前境界等级的最低要求等级
			return false;
		}

		/**
		 * 通过境界的等级获得对应的字符串名称
		 * @param level
		 * @return
		 *
		 */
		public function getNameByLevel(level:int):String
		{
			if (level <= 0 || level >= 11)
			{
				return null;
			}
//			if(null == m_names)
//			{
//				m_names = [];
//				m_names[1] = "筑基期";
//				m_names[2] = "结丹期";
//				m_names[3] = "辟谷期";
//				m_names[4] = "元婴期";
//				m_names[5] = "出窍期";
//				m_names[6] = "分身期";
//				m_names[7] = "合体期";
//				m_names[8] = "渡劫期";
//				m_names[9] = "大乘期";
//				m_names[10] = "飞升期";
//			}
			return XmlManager.localres.getPubBournXml.getResPath(level)["bourn_desc"] + "期";
		}
		public var jingJieOrigList:Array=[];

		/**
		 * 验证境界是否开启
		 * @param condition
		 * @return
		 *
		 */
		public function checkJingJieAreaEnabled(conditionConfig:String):Boolean
		{
			if (conditionConfig == "")
			{
				return true;
			}
			var result:Boolean=false;
			var childCondition:String=null;
			if (conditionConfig.indexOf(";") == -1)
			{
				childCondition=conditionConfig;
				result=this.checkJingJieConditionPass(childCondition);
			}
			else
			{
				var configArr:Array=conditionConfig.split(";");
				var tempRes:Boolean=true;
				for each (childCondition in configArr)
				{
					tempRes=this.checkJingJieConditionPass(childCondition);
					if (tempRes == false)
					{
						break;
					}
				}
			}
			return result;
		}

		/**
		 * 验证境界具体的条件是否成立
		 * @param condition
		 * @return
		 *
		 */
		private function checkJingJieConditionPass(condition:String):Boolean
		{
			var config:Array=condition.split(",");
			var pos:int=int(config[0]);
			var level:int=int(config[1]);
			return this.jingJieOrigList[pos] >= level;
		}

		/**
		 * 重置境界数据
		 */
		private function resetJingJieData():void
		{
			this.jingJieOrigList.length=0;
			for each (var arr:Array in this.jingJieAreas)
			{
				arr.length=0;
			}
		}

		/**
		 * 获取境界区域
		 * @param index
		 * @return
		 *
		 */
		public function getJingJieArea(index:int):Array
		{
			return this.jingJieAreas[index];
		}

		/**
		 * 获取境界球的强化等级
		 * @param index
		 * @param pos
		 * @return
		 *
		 */
		public function getJingJieBall(index:int, pos:int):int
		{
			return this.jingJieAreas[index][pos];
		}
		private static var _OPEN_CONDITION_TITLE:String=null;
		private static var _OPEN_CONDITION_CONTENT:String=null;
		private static var _EXTRA_ATTR:String=null;
		private static var _JING_JIE_NAMES:Array=null;

		public static function get OPEN_CONDITION_TITLE():String
		{
			if (_OPEN_CONDITION_TITLE == null)
			{
				_OPEN_CONDITION_TITLE=Lang.getLabel("20305_JingJie_OpenCondition");
			}
			return _OPEN_CONDITION_TITLE;
		}

		public static function get OPEN_CONDITION_CONTENT():String
		{
			if (_OPEN_CONDITION_CONTENT == null)
			{
				_OPEN_CONDITION_CONTENT=Lang.getLabel("20303_JingJie_Level");
			}
			return _OPEN_CONDITION_CONTENT;
		}

		public static function get EXTRA_ATTR():String
		{
			if (_EXTRA_ATTR == null)
			{
				_EXTRA_ATTR=Lang.getLabel("20302_JingJie_ExtraAttr");
			}
			return _EXTRA_ATTR;
		}

		public static function get JING_JIE_NAMES():Array
		{
			if (_JING_JIE_NAMES == null)
			{
				_JING_JIE_NAMES=Lang.getLabelArr("arrJingJie");
				;
			}
			return _JING_JIE_NAMES;
		}

		/**
		 * 更新境界开启的提示
		 *
		 */
		private function updateJingJieOpenTip():void
		{
			//青龙
			var tip:String="<font color='#00FF00'>" + Lang.replaceParam(OPEN_CONDITION_TITLE, [JING_JIE_NAMES[0]]) + "</font>";
			//增加的基础属性
			//白虎
			//朱雀
			//玄武
		}

		/**
		 * 获取当前境界等级描述
		 * @param condition
		 * @return
		 *
		 */
		private function getConditionDesc(condition:String):String
		{
			var configArr:Array=condition.split(",");
			var pos:int=int(configArr[0]);
			var level:int=int(configArr[1]);
			var type:int=int((pos - 1) / LIMIT);
			var typeName:String=JING_JIE_NAMES[type];
			var strColor:String=this.jingJieOrigList[pos] >= level ? "#00FF00" : "#666666";
			var focusIndex:int=0;
			if (pos % LIMIT == 0)
			{
				focusIndex=LIMIT;
			}
			else
			{
				focusIndex=pos % LIMIT;
			}
			return "<font color='" + strColor + "'>" + Lang.replaceParam(OPEN_CONDITION_CONTENT, [JING_JIE_NAMES[type], focusIndex, level]) + "</font>";
		}

		/**
		 * 当前境界是否满星
		 */
		public function isLevelUpFull(type:int, starLimit:int):Boolean
		{
			var endPos:int=(type + 1) * LIMIT;
			if (this.jingJieOrigList[endPos] == starLimit)
			{
				return true;
			}
			return false;
		}
		/**
		 * 星界当前拥有的属性集合
		 */
		private var attrData:Array=[];

		private function updateAttr(key:int, value:int):void
		{
			if (this.attrData[key] != null)
			{
				this.attrData[key]+=value;
			}
			else
			{
				this.attrData[key]=value;
			}
		}
	}
}
