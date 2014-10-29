package model.jingjie
{
	import common.managers.Lang;
	
	import engine.support.IPacket;
	
	import flash.events.EventDispatcher;
	
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSBourn;
	import nets.packets.PacketCSBuyPill;
	import nets.packets.PacketCSEatPill;
	import nets.packets.PacketSCBourn;
	import nets.packets.PacketSCBuyPill;
	import nets.packets.PacketSCEatPill;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	//import ui.view.jingjie.JingJie2Win;

	/**
	 * 境界模块的控制器
	 * @author steven guo
	 *
	 */
	public class JingjieController extends EventDispatcher
	{
		//用于开启还是关闭测试
		private var m_test:Boolean=false;
		private static var m_instance:JingjieController;

		public function JingjieController()
		{
			DataKey.instance.register(PacketSCBourn.id, _responseSCBourn);
			DataKey.instance.register(PacketSCEatPill.id, _responseSCEatPill);
//			DataKey.instance.register(PacketSCBuyPill.id,_responseSCBuyPill);
//			DataKey.instance.register(PacketSCBournAward.id,_responseSCBournAward);
		}

		public static function getInstance():JingjieController
		{
			if (null == m_instance)
			{
				m_instance=new JingjieController();
			}
			return m_instance;
		}

		/**
		 * 吃丹药 [废弃]
		 *
		 */
		public function chiDanYao(item:StructBagCell2, index:int=0):void
		{
//			if(null == item)
//			{
//				return ;
//			}
//			
//			if(!JingjieWindow.getInstance().isOpen)
//			{
//				JingjieWindow.getInstance().open();
//				
//				JingjieWindow.getInstance().changeTo(index);
//			}
//			
//			if(index <0 || index>3)
//			{
//				return ;
//			}
//			
//			requestCSEatPill(item.pos,index);
		}

		/**
		 * 查询某个角色或者伙伴的境界的值 (0玩家 123伙伴栏位置)
		 *
		 */
		public function requestCSBourn(index:int):void
		{
			if (index < 0 || index > 3)
			{
				return;
			}
			if (m_test)
			{
				var _testP:PacketSCBourn=new PacketSCBourn();
				_responseSCBourn(_testP);
			}
			else
			{
				var _p:PacketCSBourn=new PacketCSBourn();
				DataKey.instance.send(_p);
			}
		}

		/**
		 * 服务器返回 查询某个角色或者伙伴的境界的值
		 * @param p
		 *
		 */
		private function _responseSCBourn(p:IPacket):void
		{
			var _p:PacketSCBourn=p as PacketSCBourn;
			var _e:JingJieEvent=new JingJieEvent(JingJieEvent.JING_JIE_EVENT);
			dispatchEvent(_e);
		}

		/**
		 *  向服务器发送吃丹药消息
		 * @param bagIndex   药品在背包中的索引信息
		 * @param index   某个角色或者伙伴索引 (0玩家 123伙伴栏位置)
		 *
		 */
		public function requestCSEatPill(itemId:int, pos:int, useIngot:Boolean):void
		{
			if (m_test)
			{
				var _testP:PacketSCEatPill=new PacketSCEatPill();
				_testP.pos=pos;
				_responseSCEatPill(_testP);
			}
			else
			{
				var _p:PacketCSEatPill=new PacketCSEatPill();
				_p.toolid=itemId;
				_p.pos=pos;
				_p.flag=useIngot ? 1 : 0;
				DataKey.instance.send(_p);
			}
//			if(index < 0 || index >3)
//			{
//				return ;
//			}
			//吃药的时候比较一下当前境界的等级 与 自身的等级是否相符合
//			if(m_test)
//			{
//				var _testP:PacketSCEatPill = new PacketSCEatPill();
//				_testP.type = index;
//				_testP.bourn = 3;
//				_testP.exp = 80;
//				
//				_responseSCEatPill(_testP);
//			}
//			else
//			{
//				var _p:PacketCSEatPill = new PacketCSEatPill();
//				_p.type = index;
//				_p.index = bagIndex;
//				
//				DataKey.instance.send(_p);
//			}
		}

		private function _responseSCEatPill(p:IPacket):void
		{
			var _p:PacketSCEatPill=p as PacketSCEatPill;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			//JingJie2Win.IsLevelUp=true;
			//更新的目标位置
			var pos:int=_p.pos;
			var index:int=int((pos - 1) / JingjieModel.LIMIT);
//			JingJie2Win.getInstance().updateContent(index);
			//JingJie2Win.getInstance().levelupBallByPos(pos);
			var _e:JingJieEvent=new JingJieEvent(JingJieEvent.JING_JIE_EVENT);
			dispatchEvent(_e);
		}

		/**
		 * 买并吃(策划只购买不再吃了)
		 * @param pillid
		 * @param num
		 * @param index  "0玩家 123伙伴栏位置"
		 */
		public function requestCSBuyPill(pillid:int, num:int, index:int):void
		{
				var _p:PacketCSBuyPill=new PacketCSBuyPill();
				_p.pillid=pillid;
				_p.num=num;
//				_p.type = index;
				DataKey.instance.send(_p);
		}

		private function _responseSCBuyPill(p:IPacket):void
		{
			var _p:PacketSCBuyPill=p as PacketSCBuyPill;
			if (0 != _p.tag)
			{
				Lang.showMsg(Lang.getServerMsg(_p.tag));
				return;
			}
			//JingjieModel.getInstance().setJingjie(_p.type,_p.bourn);
			//JingjieModel.getInstance().setJingjieValue(_p.type,_p.exp);
			//JingjieModel.getInstance().setJingjieAdd2(_p.type,_p.arrItemattr);
			//--废弃
//			JingjieWindow.getInstance().repaint(true);
//			GameMusic.playWave(WaveURL.ui_up_head);
			var _e:JingJieEvent=new JingJieEvent(JingJieEvent.JING_JIE_EVENT);
			dispatchEvent(_e);
		}
	}
}
