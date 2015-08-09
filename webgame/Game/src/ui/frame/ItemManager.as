package ui.frame
{
	import com.engine.utils.HashMap;
	
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import scene.libclass.GameTinyNpc;
	import scene.libclass.SmBody;
	
	import ui.view.view1.buff.BuffIcon;

	/**
	 *	窗口条目管理
	 *  2012-01-29
	 *  根据自己需要，进行缓存
	 */
	public final class ItemManager
	{
		private var _mapitem_fuben_cube:HashMap;

		public function get mapitem_fuben_cube():HashMap
		{
			if (null == _mapitem_fuben_cube)
			{
				_mapitem_fuben_cube=new HashMap();
			}

			return _mapitem_fuben_cube;

		}

		public function getitem_fuben_cube(index_id:int):DisplayObject
		{
			if (mapitem_fuben_cube.containsKey(index_id))
			{
				return mapitem_fuben_cube.get(index_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('fu_ben', 'item_fuben_cube');
				var d:DisplayObject=new c() as DisplayObject;
				mapitem_fuben_cube.put(index_id, d);
				return d;
			}
		}

		/**
		 *	锻造条目
		 *  2013-12-21 andy
		 */
		private var _mapDuanZao:HashMap;

		public function get mapDuanZao():HashMap
		{
			if (null == _mapDuanZao)
			{
				_mapDuanZao=new HashMap();
			}

			return _mapDuanZao;

		}
		/**
		 *	翅膀条目
		 *  2013-12-21 andy
		 */
		private var _mapChiBang:HashMap;

		public function get mapChiBang():HashMap
		{
			if (null == _mapChiBang)
			{
				_mapChiBang=new HashMap();
			}

			return _mapChiBang;

		}
		private var _mapitem_now_map_npc:HashMap;

		public function get mapitem_now_map_npc():HashMap
		{
			if (null == _mapitem_now_map_npc)
			{
				_mapitem_now_map_npc=new HashMap();
			}

			return _mapitem_now_map_npc;

		}

		public function getitem_now_map_npc(index_id:int):DisplayObject
		{
			if (mapitem_now_map_npc.containsKey(index_id))
			{
				return mapitem_now_map_npc.get(index_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('game_index', 'item_now_map_npc');
				var d:DisplayObject=new c() as DisplayObject;
				mapitem_now_map_npc.put(index_id, d);
				return d;
			}
		}

		private var _mapitem_bangpai_tulong:HashMap;

		public function get mapitem_bangpai_tulong():HashMap
		{
			if (null == _mapitem_bangpai_tulong)
			{
				_mapitem_bangpai_tulong=new HashMap();
			}

			return _mapitem_bangpai_tulong;

		}

		public function getitem_bangpai_tulong(index_id:int):DisplayObject
		{
			if (mapitem_bangpai_tulong.containsKey(index_id))
			{
				return mapitem_bangpai_tulong.get(index_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('bang_pai', 'item_bangpai_tulong');
				var d:DisplayObject=new c() as DisplayObject;
				mapitem_bangpai_tulong.put(index_id, d);
				return d;
			}
		}

		private var _mapitem_bangpai_AgreeList:HashMap;

		public function get mapitem_bangpai_AgreeList():HashMap
		{
			if (null == _mapitem_bangpai_AgreeList)
			{
				_mapitem_bangpai_AgreeList=new HashMap();
			}

			return _mapitem_bangpai_AgreeList;

		}

		public function getitem_bangpai_AgreeList(index_id:int):DisplayObject
		{
			if (mapitem_bangpai_AgreeList.containsKey(index_id))
			{
				return mapitem_bangpai_AgreeList.get(index_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('bang_pai', 'item_bangpai_AgreeList');

				if (null == c)
				{
					c=GamelibS.getswflinkClass('game_index2', 'item_bangpai_AgreeList');
				}

				var d:DisplayObject=new c() as DisplayObject;
				mapitem_bangpai_AgreeList.put(index_id, d);
				return d;
			}
		}

		private var _mapitem_bangpai_yanfa:HashMap;

		public function get mapitem_bangpai_yanfa():HashMap
		{
			if (null == _mapitem_bangpai_yanfa)
			{
				_mapitem_bangpai_yanfa=new HashMap();
			}

			return _mapitem_bangpai_yanfa;

		}

		public function getitem_bangpai_yanfa(index_id:int):DisplayObject
		{
			if (mapitem_bangpai_yanfa.containsKey(index_id))
			{
				return mapitem_bangpai_yanfa.get(index_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('bang_pai', 'item_bangpai_yanfa');
				var d:DisplayObject=new c() as DisplayObject;
				mapitem_bangpai_yanfa.put(index_id, d);
				return d;
			}
		}

		private var _mapitem_bangpai_huodong:HashMap;

		public function get mapitem_bangpai_huodong():HashMap
		{
			if (null == _mapitem_bangpai_huodong)
			{
				_mapitem_bangpai_huodong=new HashMap();
			}

			return _mapitem_bangpai_huodong;

		}

		public function getitem_bangpai_huodong(index_id:int):DisplayObject
		{
			if (mapitem_bangpai_huodong.containsKey(index_id))
			{
				return mapitem_bangpai_huodong.get(index_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('game_index', 'item_bangpai_huodong');
				var d:DisplayObject=new c() as DisplayObject;
				mapitem_bangpai_huodong.put(index_id, d);
				return d;
			}
		}

		private var _mapitem_ji_neng:HashMap;

		public function get mapitem_ji_neng():HashMap
		{
			if (null == _mapitem_ji_neng)
			{
				_mapitem_ji_neng=new HashMap();
			}

			return _mapitem_ji_neng;

		}

		public function getitem_ji_neng(index_id:int):DisplayObject
		{
			if (mapitem_ji_neng.containsKey(index_id))
			{
				return mapitem_ji_neng.get(index_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('ji_neng', 'item_ji_neng');
				var d:DisplayObject=new c() as DisplayObject;
				mapitem_ji_neng.put(index_id, d);
				return d;
			}
		}

		private var _mapFriend:HashMap;
		private var _mapEnemy:HashMap
		private var _mapNpc:HashMap;
		private var _equipStrong:HashMap;

		private var _mapHuoDong_TuiJian:HashMap;
		private var _mapHuoDong_TuiJianTask:HashMap;
		private var _mapHuoDong_TaskAndHuoDong:HashMap;
		private var _mapHuoDong_DiGongBoss:HashMap;
		private var _mapHuoDong_TaskAndHuoDong2:HashMap;
		private var _mapFuBen_List:HashMap;
		private var _mapFuBenChuanSong_List:HashMap;
		private var _mapSrtongStone_List:HashMap;
		

		private var _chengjiu_itemList:HashMap;
		private var _mapJiaZu_MemberList:HashMap;
		private var _mapJiaZu_LogList:HashMap;
		private var _mapJiaZu_AgreeList:HashMap;

		private var _XDH_ShengJia:HashMap;
		private var _XDH_ZhiChiList:HashMap;

		private var _arrSmBody:Array;
		private var _arrSmBodyGprs:Array;
		private var _mapPoint:HashMap;

		private var _mapPaiHangTitle:HashMap;
		private var _mapStoneEquip:HashMap;
		private var _map7RiDengLi:HashMap;

		private var _mapBagCell:HashMap;
		private var _mapChengJiu:HashMap;
		private var _mapTabBtn:HashMap;
		private var _mapOneBtn:HashMap;
		private var _mapHelpBtn1:HashMap;
		private var _mapHelpBtn2:HashMap;
		private var _arrSiLiao:Array;
		private var _mapQuicksay:HashMap;
		private var _mapQuicksayPrivate:HashMap;

		private var _mapDiGong:HashMap;
		private var _mapBuff:HashMap;
		private var _mapBuffPet:HashMap;
		private static var _instance:ItemManager;

		public function get mapBuffPet():HashMap
		{
			if (null == _mapBuffPet)
			{
				_mapBuffPet=new HashMap();
			}

			return _mapBuffPet;

		}

		public function get mapBuff():HashMap
		{
			if (null == _mapBuff)
			{
				_mapBuff=new HashMap();
			}

			return _mapBuff;

		}

		public function get mapDiGong():HashMap
		{
			if (null == _mapDiGong)
			{
				_mapDiGong=new HashMap();
			}

			return _mapDiGong;

		}

		public function get mapQuicksayPrivate():HashMap
		{
			if (null == _mapQuicksayPrivate)
			{
				_mapQuicksayPrivate=new HashMap();
			}

			return _mapQuicksayPrivate;
		}

		public function get mapQuicksay():HashMap
		{
			if (null == _mapQuicksay)
			{
				_mapQuicksay=new HashMap();
			}

			return _mapQuicksay;
		}

		public function get arrSiLiao():Array
		{
			if (null == _arrSiLiao)
			{
				_arrSiLiao=new Array();
			}

			return _arrSiLiao;
		}

		public function get mapHelpBtn2():HashMap
		{
			if (null == _mapHelpBtn2)
			{
				_mapHelpBtn2=new HashMap();
			}

			return _mapHelpBtn2;
		}

		public function get mapHelpBtn1():HashMap
		{
			if (null == _mapHelpBtn1)
			{
				_mapHelpBtn1=new HashMap();
			}

			return _mapHelpBtn1;
		}

		public function get mapOneBtn():HashMap
		{
			if (null == _mapOneBtn)
			{
				_mapOneBtn=new HashMap();
			}

			return _mapOneBtn;
		}

		public function get mapTabBtn():HashMap
		{
			if (null == _mapTabBtn)
			{
				_mapTabBtn=new HashMap();
			}

			return _mapTabBtn;
		}

		public function get mapChengJiu():HashMap
		{
			if (null == _mapChengJiu)
			{
				_mapChengJiu=new HashMap();
			}

			return _mapChengJiu;
		}

		public function get mapBagCell():HashMap
		{
			if (null == _mapBagCell)
			{
				_mapBagCell=new HashMap();
			}

			return _mapBagCell;
		}

		public function get mapStoneEquip():HashMap
		{
			if (null == _mapStoneEquip)
			{
				_mapStoneEquip=new HashMap();
			}

			return _mapStoneEquip;
		}

		public function get equipStrong():HashMap
		{
			if (null == _equipStrong)
			{
				_equipStrong=new HashMap();
			}

			return _equipStrong;
		}

		public function get _7RiDengLu():HashMap
		{
			if (null == _map7RiDengLi)
			{
				_map7RiDengLi=new HashMap();
			}

			return _map7RiDengLi;
		}


		public function get mapPaiHangTitle():HashMap
		{
			if (null == _mapPaiHangTitle)
			{
				_mapPaiHangTitle=new HashMap();
			}

			return _mapPaiHangTitle;
		}

		public function get mapPoint():HashMap
		{
			if (null == _mapPoint)
			{
				_mapPoint=new HashMap();
			}

			return _mapPoint;
		}

		public function get arrSmBodyGprs():Array
		{
			if (null == _arrSmBodyGprs)
			{
				_arrSmBodyGprs=new Array();
			}

			return _arrSmBodyGprs;
		}

		public function get arrSmBody():Array
		{
			if (null == _arrSmBody)
			{
				_arrSmBody=new Array();
			}

			return _arrSmBody;
		}

		public function get mapFuBen_List():HashMap
		{
			if (null == _mapFuBen_List)
			{
				_mapFuBen_List=new HashMap();
			}

			return _mapFuBen_List;
		}


		public function get mapFuBenChuanSong_List():HashMap
		{
			if (null == _mapFuBenChuanSong_List)
			{
				_mapFuBenChuanSong_List=new HashMap();
			}

			return _mapFuBenChuanSong_List;
		}
		
		public function get mapSrtongStone_List():HashMap
		{
			if (null == _mapSrtongStone_List)
			{
				_mapSrtongStone_List=new HashMap();
			}
			
			return _mapSrtongStone_List;
		}


		public function get mapHuoDong_TaskAndHuoDong():HashMap
		{
			if (null == _mapHuoDong_TaskAndHuoDong)
			{
				_mapHuoDong_TaskAndHuoDong=new HashMap();
			}

			return _mapHuoDong_TaskAndHuoDong;
		}

		public function get mapHuoDong_DiGongBoss():HashMap
		{
			if (null == _mapHuoDong_DiGongBoss)
			{
				_mapHuoDong_DiGongBoss=new HashMap();
			}

			return _mapHuoDong_DiGongBoss;
		}


		public function get mapHuoDong_TaskAndHuoDong2():HashMap
		{
			if (null == _mapHuoDong_TaskAndHuoDong2)
			{
				_mapHuoDong_TaskAndHuoDong2=new HashMap();
			}

			return _mapHuoDong_TaskAndHuoDong2;
		}



		public function get mapJiaZu_MemberList():HashMap
		{
			if (null == _mapJiaZu_MemberList)
			{
				_mapJiaZu_MemberList=new HashMap();
			}

			return _mapJiaZu_MemberList;

		}

		public function get mapJiaZu_LogList():HashMap
		{

			if (null == _mapJiaZu_LogList)
			{
				_mapJiaZu_LogList=new HashMap();
			}

			return _mapJiaZu_LogList;


		}
		public function get chengjiu_bar():HashMap
		{

			if (null == _chengjiu_itemList)
			{
				_chengjiu_itemList=new HashMap();
			}

			return _chengjiu_itemList;


		}

		public function get mapJiaZu_AgreeList():HashMap
		{

			if (null == _mapJiaZu_AgreeList)
			{
				_mapJiaZu_AgreeList=new HashMap();
			}

			return _mapJiaZu_AgreeList;


		}





		public function get mapHuoDong_TuiJian():HashMap
		{
			if (null == _mapHuoDong_TuiJian)
			{
				_mapHuoDong_TuiJian=new HashMap();
			}

			return _mapHuoDong_TuiJian;
		}

		public function get mapHuoDong_TuiJianTask():HashMap
		{
			if (null == _mapHuoDong_TuiJianTask)
			{
				_mapHuoDong_TuiJianTask=new HashMap();
			}

			return _mapHuoDong_TuiJianTask;
		}

		public function get XDH_ShengJia():HashMap
		{
			if (null == _XDH_ShengJia)
			{
				_XDH_ShengJia=new HashMap();
			}

			return _XDH_ShengJia;
		}

		public function get XDH_ZhiChiList():HashMap
		{
			if (null == _XDH_ZhiChiList)
			{
				_XDH_ZhiChiList=new HashMap();
			}

			return _XDH_ZhiChiList;
		}

		public function get mapNpc():HashMap
		{
			if (null == _mapNpc)
			{
				_mapNpc=new HashMap();
			}

			return _mapNpc;
		}

		public function get mapFriend():HashMap
		{
			if (null == _mapFriend)
			{
				_mapFriend=new HashMap();
			}

			return _mapFriend;
		}

		public function get mapEnemy():HashMap
		{
			if (null == _mapEnemy)
			{
				_mapEnemy=new HashMap();
			}

			return _mapEnemy;
		}

		public static function instance():ItemManager
		{
			if (_instance == null)
			{
				_instance=new ItemManager();
			}
			return _instance;
		}

		public function ItemManager()
		{

		}

		/***************根据ID缓存************/
		/**
		 *	好友条目
		 */
		public function getFriendItem(id:int):Sprite
		{
			if (mapFriend.containsKey(id))
			{
				return mapFriend.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_hao_you");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapFriend.put(id, sp);
				return sp;
			}
		}

		/**
		 *	敌人条目
		 */
		public function getEnemyItem(id:int):Sprite
		{
			if (mapEnemy.containsKey(id))
			{
				return mapEnemy.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_enemy");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapEnemy.put(id, sp);
				return sp;
			}
		}

		/**
		 *	成就
		 */
		public function getChengJiuItem(id:int):Sprite
		{
			if (mapChengJiu.containsKey(id))
			{
				return mapChengJiu.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "win_chengjiu_item");
				var sp:Sprite=new c() as Sprite;
				mapChengJiu.put(id, sp);
				return sp;
			}
		}

		/**
		 *	7日登录礼包
		 */
		public function get7RiDengLuItem(id:int):Sprite
		{
			if (_7RiDengLu.containsKey(id))
			{
				return _7RiDengLu.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_7RiDengLu");
				var sp:Sprite=new c() as Sprite;
				_7RiDengLu.put(id, sp);
				return sp;
			}
		}

		/**
		 * 每日推荐条目
		 */
		public function getHuoDongTuiJianItem(id:int):Sprite
		{
			if (mapHuoDong_TuiJian.containsKey(id))
			{
				return mapHuoDong_TuiJian.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("huo_dong", "Item_HuoDong_TuiJian");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapHuoDong_TuiJian.put(id, sp);
				return sp;
			}
		}

		/**
		 * 每日推荐任务条目
		 */
		public function getHuoDongTuiJianTaskItem(id:int):Sprite
		{
			if (mapHuoDong_TuiJianTask.containsKey(id))
			{
				return mapHuoDong_TuiJianTask.get(id);
			}
			else
			{

				//huo_dong
				var c:Class=GamelibS.getswflinkClass("huo_dong", "Item_HuoDong_TuiJian");

				if (null == c)
				{
					c=GamelibS.getswflinkClass("huodong_tuijian", "Item_HuoDong_TuiJian");
				}

				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapHuoDong_TuiJianTask.put(id, sp);
				return sp;
			}
		}

		/**
		 * 每日任务条目
		 */
		public function getHuoDongTaskAndHuoDongItem(id:int):Sprite
		{
			if (mapHuoDong_TaskAndHuoDong.containsKey(id))
			{
				return mapHuoDong_TaskAndHuoDong.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "Item_HuoDong_TaskAndHuoDong");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapHuoDong_TaskAndHuoDong.put(id, sp);
				return sp;
			}
		}

		/**
		 * 地宫boss条目
		 */
		public function getHuoDongTaskAndDiGongBossItem(id:int):Sprite
		{
			if (mapHuoDong_DiGongBoss.containsKey(id))
			{
				return mapHuoDong_DiGongBoss.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "Item_HuoDong_TaskAndHuoDong_Boss");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapHuoDong_DiGongBoss.put(id, sp);
				return sp;
			}
		}

		/**
		 *
		 */
		public function getHuoDongTaskAndHuoDongItem2(id:int):Sprite
		{
			if (mapHuoDong_TaskAndHuoDong2.containsKey(id))
			{
				return mapHuoDong_TaskAndHuoDong2.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "Item_HuoDong_TaskAndHuoDong2");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapHuoDong_TaskAndHuoDong2.put(id, sp);
				return sp;
			}
		}


		/**
		 * 家族族员条目
		 */
		public function getJiaZuMemberList(index_id:int):Sprite
		{
			if (mapJiaZu_MemberList.containsKey(index_id))
			{
				return mapJiaZu_MemberList.get(index_id);

			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("jia_zu", "ItemRender_JzMemberList");
				var sp:Sprite=new c() as Sprite;
				//sp.mouseChildren=false;
				//sp.mouseEnabled = false;
				mapJiaZu_MemberList.put(index_id, sp);
				return sp;
			}

		}

		/**
		 * 家族动态条目
		 */
		public function getJiaZuLogList(index_id:int):Sprite
		{
			if (mapJiaZu_LogList.containsKey(index_id))
			{
				return mapJiaZu_LogList.get(index_id);

			}
			else
			{
				//var c:Class=GamelibS.getswflinkClass("bang_pai", "ItemRender_BpLogList");
				var c:Class=GamelibS.getswflinkClass("game_index2", "ItemRender_BpLogList");


				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapJiaZu_LogList.put(index_id, sp);
				return sp;
			}

		}
		
		/**
		 * 成就条目
		 */
		public function getChengJiuList(index_id:int):Sprite
		{
			if (chengjiu_bar.containsKey(index_id))
			{
				return chengjiu_bar.get(index_id);
				
			}
			else
			{
				//var c:Class=GamelibS.getswflinkClass("bang_pai", "ItemRender_BpLogList");
				var c:Class=GamelibS.getswflinkClass("game_index2", "item_chengjiu");
				
				
				var sp:Sprite=new c() as Sprite;
				sp.mouseEnabled=false;
				chengjiu_bar.put(index_id, sp);
				return sp;
			}
			
		}
		/**
		 * 申请加入家族列表
		 */
		public function getJiaZuAgreeList(index_id:int):Sprite
		{
			if (mapJiaZu_AgreeList.containsKey(index_id))
			{
				return mapJiaZu_AgreeList.get(index_id);

			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("jia_zu", "ItemRender_JzAgreeList");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapJiaZu_AgreeList.put(index_id, sp);
				return sp;
			}

		}



		/**
		 * 副本传送界面条目
		 */
		public function getFuBenItem(instance_id:int):Sprite
		{
			if (mapFuBen_List.containsKey(instance_id))
			{
				return mapFuBen_List.get(instance_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("fu_ben", "ItemRender_FuBenList");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapFuBen_List.put(instance_id, sp);
				return sp;
			}

		}

		/**
		 * 副本寻路传送界面条目
		 */
		public function getFuBenChuanSongItem(instance_id:int):Sprite
		{
			if (mapFuBenChuanSong_List.containsKey(instance_id))
			{
				return mapFuBenChuanSong_List.get(instance_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("chuan_song", "item_fuben_chuan_song");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapFuBenChuanSong_List.put(instance_id, sp);
				return sp;
			}

		}
		
		/**
		 * 装备强化石条目
		 */
		public function getStrongStoneItem(instance_id:int):Sprite
		{
			if (mapSrtongStone_List.containsKey(instance_id))
			{
				return mapSrtongStone_List.get(instance_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_strong_stone");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				mapSrtongStone_List.put(instance_id, sp);
				return sp;
			}
			
		}

		/**
		 * 仙道会身价列表条目
		 */
		public function getXDHShengJiaItem(id:int):Sprite
		{
			if (XDH_ShengJia.containsKey(id))
			{
				return XDH_ShengJia.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("jing_ji_chang", "ItemRender_ShengJia");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				XDH_ShengJia.put(id, sp);
				return sp;
			}
		}

		/**
		 * 仙道会支持列表条目
		 */
		public function getXDHZhiChiListItem(id:int):Sprite
		{
			if (XDH_ZhiChiList.containsKey(id))
			{
				return XDH_ZhiChiList.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("jing_ji_chang", "ItemRender_ZhiChiList");
				var sp:Sprite=new c() as Sprite;
				sp.mouseChildren=false;
				XDH_ZhiChiList.put(id, sp);
				return sp;
			}
		}

		/**
		 *	小地图npc条目
		 */
		public function getNpcItem(id:int):GameTinyNpc
		{
			if (mapNpc.containsKey(id))
			{
				return mapNpc.get(id);
			}
			else
			{
				mapNpc.put(id, new GameTinyNpc());
				return mapNpc.get(id);
			}
		}


		/**
		 *	小地图导航点
		 */
		public function getMapPoint(id:int):Sprite
		{
			if (GamelibS.isApplicationClass("mapPoint") == false)
				return null;
			if (mapPoint.containsKey(id))
			{
				return mapPoint.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "mapPoint");
				var sp:Sprite=new c() as Sprite;
				mapPoint.put(id, sp);
				return sp;
			}
		}

		/**
		 *	锻造条目
		 */
		public function getDuanZaoItem(id:int):Sprite
		{
			if (mapDuanZao.containsKey(id))
			{
				return mapDuanZao.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_duan_zao");
				var sp:Sprite=new c() as Sprite;
				mapDuanZao.put(id, sp);
				return sp;
			}
		}
		/**
		 *	翅膀条目
		 */
		public function getChiBangItem(id:int):Sprite
		{
			if (mapChiBang.containsKey(id))
			{
				return mapChiBang.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_duan_zao");
				var sp:Sprite=new c() as Sprite;
				mapChiBang.put(id, sp);
				return sp;
			}
		}

		/**
		 *	排行榜称号
		 */
		public function getPaiHangTitle(id:int):Sprite
		{
			if (mapPaiHangTitle.containsKey(id))
			{
				return mapPaiHangTitle.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "title" + id);

				var sp:Sprite=null;
				if (c != null)
				{
					sp=new c() as Sprite;
					mapPaiHangTitle.put(id, sp);
				}
				else
				{
					sp=new Sprite();
				}

				return sp;
			}
		}

		private var _mapitem_zu_yuan2:HashMap;

		public function get mapitem_zu_yuan2():HashMap
		{
			if (null == _mapitem_zu_yuan2)
			{
				_mapitem_zu_yuan2=new HashMap();
			}

			return _mapitem_zu_yuan2;

		}

		public function getitem_zu_yuan2(index_id:int):DisplayObject
		{
			if (mapitem_zu_yuan2.containsKey(index_id))
			{
				return mapitem_zu_yuan2.get(index_id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('bang_pai', 'item_zu_yuan2');

				if (null == c)
				{
					c=GamelibS.getswflinkClass('game_index2', 'item_zu_yuan2');
				}

				var d:DisplayObject=new c() as DisplayObject;
				mapitem_zu_yuan2.put(index_id, d);
				return d;
			}
		}

		/**
		 *	buff【左上角】【主角】
		 *  @2012-10-09 andy
		 */
		public function getBuffIcon(id:int):BuffIcon
		{
			if (mapBuff.containsKey(id))
			{
				return mapBuff.get(id);
			}
			else
			{
				var bufficon:BuffIcon=new BuffIcon();
				mapBuff.put(id, bufficon);
				return bufficon;
			}
		}

		/**
		 *	buff【左上角】【伙伴】
		 *  @2012-10-10 andy
		 */
		public function getBuffIconPet(id:int):BuffIcon
		{
			if (mapBuffPet.containsKey(id))
			{
				return mapBuffPet.get(id);
			}
			else
			{
				var bufficon:BuffIcon=new BuffIcon();
				mapBuffPet.put(id, bufficon);
				return bufficon;
			}
		}

		/**
		 *	镶嵌宝石 装备
		 */
		public function getStoneEquip(id:int):Sprite
		{
			if (mapStoneEquip.containsKey(id))
			{
				return mapStoneEquip.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_stone_equip");
				var sp:Sprite=new c() as Sprite;
				mapStoneEquip.put(id, sp);
				return sp;
			}
		}
		
		/**
		 *	战力神兵
		 */
		private var _mapitem_zl_sb:HashMap;
		public function get mapitem_zl_sb():HashMap
		{
			if (null == _mapitem_zl_sb)
			{
				_mapitem_zl_sb=new HashMap();
			}
			
			return _mapitem_zl_sb;
			
		}
		public function getZLSB(id:int):Sprite
		{
			if (mapitem_zl_sb.containsKey(id))
			{
				return mapitem_zl_sb.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_zl_sb");
				var sp:Sprite=new c() as Sprite;
				mapitem_zl_sb.put(id, sp);
				return sp;
			}
		}
		/**
		 *	战力角色
		 */
		private var _mapitem_zl_js:HashMap;
		public function get mapitem_zl_js():HashMap
		{
			if (null == _mapitem_zl_js)
			{
				_mapitem_zl_js=new HashMap();
			}
			
			return _mapitem_zl_js;
			
		}
		public function getZLJS(id:int):Sprite
		{
			if (mapitem_zl_js.containsKey(id))
			{
				return mapitem_zl_js.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_zl_js");
				var sp:Sprite=new c() as Sprite;
				mapitem_zl_js.put(id, sp);
				return sp;
			}
		}
		
		
		/**
		 *
		 */
		public function getDiGongItem(index_id:int):DisplayObject
		{
			if (mapDiGong.containsKey(index_id))
			{
				return mapDiGong.get(index_id);

			}
			else
			{

				var c:Class=GamelibS.getswflinkClass("game_index", "item_chuan_song");
				var d:DisplayObject=new c() as DisplayObject;
				mapDiGong.put(index_id, d);
				return d;

			}
		}

		/**
		 *	主界面聊天窗口【左下】 快速回复
		 */
		public function getQuickSay(id:int):Sprite
		{
			if (mapQuicksay.containsKey(id))
			{
				return mapQuicksay.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_quick_say");
				var sp:Sprite=new c() as Sprite;
				mapQuicksay.put(id, sp);
				return sp;
			}
		}

		/**
		 *	主界面聊天窗口【左下】 快速回复
		 *  @2012-09-20 由于可以存在多个聊天框，快捷回复条目无法做缓存
		 */
		public function getQuickSayPrivate(id:int):Sprite
		{
//			if(mapQuicksayPrivate.containsKey(id)){
//				return mapQuicksayPrivate.get(id);
//			}else{
			var c:Class=GamelibS.getswflinkClass("game_index", "item_quick_say");
			var sp:Sprite=new c() as Sprite;
			//mapQuicksayPrivate.put(id,sp);
			return sp;
			//}
		}

		/**
		 *	炼丹炉装备列表条目
		 *  2013-04-12
		 */
		public function getEquipStrong(id:int):Sprite
		{
			if (equipStrong.containsKey(id))
			{
				return equipStrong.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_equip_strong");
				var sp:Sprite=new c() as Sprite;
				sp.name="item" + id;
				equipStrong.put(id, sp);
				return sp;
			}
		}


		/***************限制数量缓存************/
		/**
		 *	小地图玩家条目
		 *
		 */
		public function getSmBody():SmBody
		{
			//if(GamelibS.isApplicationClass("mSmBody")==false)return null;
			var sm:SmBody=null;
			for each (sm in arrSmBody)
			{
				if (sm.parent == null)
				{
					sm.reset();
					return sm;
				}
			}
			//强制限制在200个点
			if (arrSmBody.length < 200)
			{
				sm=new SmBody();
				arrSmBody.push(sm);
			}
			else
			{
				arrSmBody.shift();
			}

			//
			sm.reset();

			return sm;
		}

		/**
		 *	小雷达gprs玩家条目
		 */
		public function getSmBodyGprs():SmBody
		{
			//if(GamelibS.isApplicationClass("mSmBody")==false)return null;
			var sm:SmBody=null;
			for each (sm in arrSmBodyGprs)
			{
				if (sm.parent == null)
				{
					return sm;
				}
			}
			//强制限制在100个点
			if (arrSmBodyGprs.length < 100)
			{
				sm=new SmBody();
				arrSmBodyGprs.push(sm);
			}
			else
			{
				arrSmBodyGprs.shift();
			}
			return sm;
		}

		/**
		 *	好友私聊条目【30个】
		 */
		public function getSiLiao():Sprite
		{
			var sm:Sprite=null;
			for each (sm in arrSiLiao)
			{
				if (sm.parent == null)
				{
					return sm;
				}
			}
			//强制限制在300个点  最多10个聊天窗口，每个聊天窗口最多保留30条记录
			if (arrSiLiao.length <= 300)
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_si_liao");
				sm=new c() as Sprite;
				arrSiLiao.push(sm);
			}
			else
			{
				arrSiLiao.shift();
			}
			return sm;
		}

		/**************** 特效 ****************/
		/**
		 *	特效显示
		 *  2014-01-08
		 *  @param linkName 连接名字
		 *  @param mc       特效容器
		 *  @param showX    显示坐标X
		 *  @param showY    显示坐标Y
		 */
		public function showWindowEffect(linkName:String, mc:DisplayObjectContainer, showX:int, showY:int):void
		{
			var m_effect:MovieClip=mc.getChildByName(linkName) as MovieClip;
			if (m_effect != null)
			{
				m_effect.play();
				m_effect.x=showX;
				m_effect.y=showY;
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", linkName);
				if (c == null)
					return;
				m_effect=new c() as MovieClip;
				m_effect.name=linkName;
				m_effect.mouseEnabled=m_effect.mouseChildren=false;
				m_effect.x=showX;
				m_effect.y=showY;
				mc.addChild(m_effect);
				//多播放两次，首次播放不出来
				m_effect.gotoAndPlay(1);
				m_effect.gotoAndPlay(1);
				m_effect.gotoAndPlay(1);

			}
		}


		/****************条目公用方法****************/
		/**
		 *	设置装备元件容貌
		 *  @param v1     元件 【1.底纹 mc_color】
		 *  @param isShow 是否显示
		 */
		public function setEquipFace(v1:MovieClip, isShow:Boolean=true):void
		{
			if (null == v1)
				return;
	
			if (v1.hasOwnProperty("mc_color"))
			{
				var mc_color:MovieClip=v1.getChildByName("mc_color") as MovieClip;
				if (mc_color != null)
				{
					mc_color.visible=isShow;
					if (v1.hasOwnProperty("data") && v1.data != null && v1.data.hasOwnProperty("toolColor"))
					{
						mc_color.gotoAndStop(v1.data.toolColor);
						var mc_effect:MovieClip=mc_color.getChildByName("mc_effect") as MovieClip;
						if(mc_effect!=null){
							mc_effect.visible=(v1.data.effect==1);
						}	
					}
				}
			}
			if (v1.hasOwnProperty("lengque"))
			{
				var lengque:MovieClip=v1.getChildByName("lengque") as MovieClip;
				if (lengque != null)
				{
					isShow ? lengque.gotoAndStop(1) : lengque.gotoAndStop(37);
				}
			}
			if (v1.hasOwnProperty("bg"))
			{
				var bg:MovieClip=v1.getChildByName("bg") as MovieClip;
				if (bg != null)
				{
					bg.gotoAndStop(1);
				}
			}
			if (v1.hasOwnProperty("txt_num"))
			{
				var txt_num:TextField=v1.getChildByName("txt_num") as TextField;
				if (txt_num != null)
				{
					if (v1.hasOwnProperty("data") && v1.data != null)
					{
						//文本显示规则：叠加数量大于1 或者包裹数量大于1
						var plie_num:int=0;
						var num:int=0;
						if (v1.data.hasOwnProperty("plie_num"))
							plie_num=v1.data.plie_num;
						if (v1.data.hasOwnProperty("num"))
							num=v1.data.num;

						//2014-02-11 策划调整只要数量为1，就不显示下标
						if (num > 1)
						{
							txt_num.visible=true;
							txt_num.text=num + "";
						}
						else
							txt_num.visible=false
					}
				}
			}

			//2013-02-25 是否可交易锁
			if (v1.hasOwnProperty("mc_trade_lock"))
			{
				var mc_trade_lock:MovieClip=v1.getChildByName("mc_trade_lock") as MovieClip;
				if (mc_trade_lock != null)
				{
					if (v1.hasOwnProperty("data") && v1.data != null)
					{
						mc_trade_lock.visible=!v1.data.isTrade;
					}
					else
						mc_trade_lock.visible=false
				}
			}
			//2013-02-25 摆摊锁定
			if (v1.hasOwnProperty("mc_booth_lock"))
			{
				var mc_booth_lock:MovieClip=v1.getChildByName("mc_booth_lock") as MovieClip;
				if (mc_booth_lock != null)
				{
					if (v1.hasOwnProperty("data") && v1.data != null)
					{
						mc_booth_lock.visible=v1.data.lock;
						CtrlFactory.getUIShow().setColor(v1, v1.data.lock ? 2 : 1);
					}
					else
					{
						mc_booth_lock.visible=false;
						CtrlFactory.getUIShow().setColor(v1, 1);
					}
				}
			}
			
			if (v1.hasOwnProperty("txt_star")&&v1["txt_star"]!=null)
			{
				if (v1.hasOwnProperty("data") && v1.data != null)
				{
					v1["txt_star"].htmlText=(v1.data.equip_strongLevel>0&&v1.data.sort==13)?"<b>+"+v1.data.equip_strongLevel+"</b>":"";
				}					
			}
		}

		/**
		 *	道具悬浮 2013-05-06
		 *  @param mc     悬浮元件
		 *  @param itemId 道具ID
		 *  @param cachId 缓存编号【可不填写】
		 */
		public function setToolTip(mc:MovieClip, itemId:int, cachId:int=0, iconSize:int=0, tool_num:int=0):StructBagCell2
		{
			if (mc == null || itemId == 0)
				return null;
			var bag:StructBagCell2=null;
			if (cachId == 0)
			{
				bag=new StructBagCell2();
			}
			else
			{
				bag=this.getBagCell(cachId);
			}
			bag.itemid=itemId;
			Data.beiBao.fillCahceData(bag);
			if (tool_num > 0)
			{
				bag.num=tool_num;
			}
			
			setToolTipByData(mc,bag,iconSize);
			return bag;
		}

		/**
		 *	道具悬浮 2013-05-06
		 *  @param mc     悬浮元件
		 *  @param itemId 道具ID
		 *  @param cachId 缓存编号【可不填写】
		 *  @param isBigIcon 是否显示大图标
		 */
		public function setToolTipByData(mc:MovieClip, bag:StructBagCell2, iconSize:int=0):void
		{
			if (mc == null || bag == null)
				return;
			mc.data=bag;
			mc.mouseChildren=false;
			if (mc["uil"] != null){
//				mc["uil"].source=isBigIcon ? bag.iconBig : bag.icon;
				ImageUtils.replaceImage(mc,mc["uil"],iconSize==0 ? bag.icon:iconSize==1?bag.iconBig:bag.iconBigBig );
			}
			if (mc["txt_num"] != null)
				mc["txt_num"].htmlText=bag.num;
			
			CtrlFactory.getUIShow().addTip(mc);
			ItemManager.instance().setEquipFace(mc);
		}

		/**
		 *	移除道具悬浮 2013-05-06
		 *  @param mc     悬浮元件
		 */
		public function removeToolTip(mc:MovieClip):void
		{
			if (mc == null)
				return;

			mc.data=null;
			if (mc["uil"] != null)
				mc["uil"].unload();
			ImageUtils.cleanImage(mc);
			if (mc["txt_num"] != null)
				mc["txt_num"].text="";
			if (mc["txt_star"]!=null)
			{
				mc["txt_star"].text="";				
			}
			CtrlFactory.getUIShow().removeTip(mc);
			ItemManager.instance().setEquipFace(mc, false);
		}

		public function getEquipFaceByData(data:StructBagCell2):String
		{
			if (null == data)
			{
				return ResCtrl.instance().arrColor[1];
			}

			if (data.hasOwnProperty("toolColor"))
			{
				return ResCtrl.instance().arrColor[data.toolColor];
			}

			return ResCtrl.instance().arrColor[1];
		}

		/**
		 *	临时重复用structbagcell2
		 *  @param id  自己定义编号
		 *  10001 炼丹炉升级后装备
		 *  10002 装备悬浮对比装备
		 *  10003 角色装备升级前后悬浮对比
		 *  10004 神翼噬魂材料1
		 *  10005 神翼噬魂材料2
		 *  10006 神翼噬魂材料3
		 *  10007 神翼噬魂材料选择
		 *  10008 强化材料
		 *  10009 镶嵌宝石
		 *  10010 传承后装备
		 *  10011 神武材料
		 *  10012 宝石升级后
		 *  10013 神器零件升级后
		 *  10014 充值宝石
		 *  10015 强化石
		 *  10016 镇魔窟1
		 *  10017 镇魔窟2
		 */
		public function getBagCell(id:int):StructBagCell2
		{
			if (mapBagCell.containsKey(id))
			{
				var bag:StructBagCell2=mapBagCell.get(id);
				Data.beiBao.clearCahceData(bag);
				return bag;
			}
			else
			{
				var c:StructBagCell2=new StructBagCell2();
				mapBagCell.put(id, c);
				return c;
			}
		}
	}
}
