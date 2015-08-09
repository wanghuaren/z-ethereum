package netc.dataset
{
	import com.engine.utils.HashMap;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_Underwrite_TypeResModel;
	
	import engine.event.DispatchEvent;
	import engine.net.dataset.VirtualSet;
	import engine.support.IPacket;
	
	import model.jingjie.JingjieModel;
	
	import netc.Data;
	import netc.packets2.PacketSCEnemyList2;
	import netc.packets2.PacketSCSayPrivate2;
	import netc.packets2.PacketWCFriendAdd2;
	import netc.packets2.PacketWCFriendDel2;
	import netc.packets2.PacketWCFriendList2;
	import netc.packets2.PacketWCFriendUpdate2;
	import netc.packets2.StructEnemyItem2;
	import netc.packets2.StructFriendData2;
	
	import world.FileManager;

	/**
	 *  好友数据
	 *  andy 2011-12-27
	 */
	public class HaoYouSet extends VirtualSet
	{
		private var item:StructFriendData2;
		private var freindData:Vector.<StructFriendData2>;
		private var mapChat:HashMap=new HashMap();
		private var itemChat:PacketSCSayPrivate2;
		
		
		public static const MAX_CHAT:int=30;
		//好友每页显示数量
		public static const PAGE_COUNT:int=10;
		public static const PAGE_COUNT_ENEMY:int=8;
		public static const FRIEND_UPDATE:String="FRIEND_UPDATE";
		public static const PRIVATE_CHAT_UPDATE:String="PRIVATE_CHAT_UPDATE";
		public function HaoYouSet(pz:HashMap)
		{
			refPackZone(pz);
		}
		
		/**
		 *	获得好友全部数据 
		 */
		public function setHaoYouList(p:PacketWCFriendList2):void{
			if(p!=null){
				for each(item in p.arrItemfriend_list){
					fillFreind(item);
				}
				freindData=p.arrItemfriend_list;
			}else{
				freindData=new Vector.<StructFriendData2>;
			}
			//测试
//			freindData=new Vector.<StructFriendData2>;
//			var item:StructFriendData2;
//			for(var i:int=1;i<=300;i++){
//				item=new StructFriendData2();
//				item.roleid=i;
//				item.rolename=i+"";
//				item.type=i%5;
//				item.vip=5;
//				if(i%2==0)item.vip=1 else item.online=1;
//				freindData.push(item);
//			}
		}	

		/**
		 *	根据类型得到好友信息【排序规则：在线，vip】 
		 *  @type 1.好友2.仇人4.黑名单
		 */
		public function getHaoYouListByType(type:int=0):Vector.<StructFriendData2>{
			var ret1:Vector.<StructFriendData2>=new Vector.<StructFriendData2>;
			var ret2:Vector.<StructFriendData2>=new Vector.<StructFriendData2>;
			var ret3:Vector.<StructFriendData2>=new Vector.<StructFriendData2>;
			var ret4:Vector.<StructFriendData2>=new Vector.<StructFriendData2>;
			for each(item in freindData){
				if(item.type&type){
					if(item.online==1){
						item.vip>0?ret1.push(item):ret2.push(item);
					}else{
						item.vip>0?ret3.push(item):ret4.push(item);
					}
				}
			}
			return ret1.concat(ret2).concat(ret3).concat(ret4);
		}
		/**
		 *	好友分页【由于好友上限为100个，加载过卡，现在分页】 
		 *  @2012-08-01
		 */
		public function getFriendByPage(page:int=1,type:int=1):Vector.<StructFriendData2>{
			var ret:Vector.<StructFriendData2>=new Vector.<StructFriendData2>;
			var now:Vector.<StructFriendData2>=getHaoYouListByType(type);
			page=page<1?1:page;
			var start:int=(page-1)*PAGE_COUNT;
			var end:int=page*PAGE_COUNT;
			if(end>now.length)end=now.length;
			for(var i:int=start;i<end;i++){
				ret.push(now[i]);
			}
			return ret;
		}
		/**
		 *	分类总数量 
		 *  @type 
		 */
		public function getFriendCount(type:int=1):int{
			var ret:int=0;
			for each(item in freindData){
				if(item.type&type){
					ret++;
				}
			}
			return ret;
		}
		/**
		 *	好友 
		 */
		/**
		 *	添加好友【黑名单】 
		 *  @type 1.好友2.仇人3.黑名单
		 */
		public function addHaoYou(p:PacketWCFriendAdd2):void{
			fillFreind(p.newfriend);
			freindData.push(p.newfriend);
			this.dispatchEvent(new DispatchEvent(FRIEND_UPDATE,p.newfriend));
		}
		
		/**
		 *	删除好友【黑名单】 
		 *  @type 1.好友2.仇人4.黑名单
		 */
		public function delHaoYou(p:PacketWCFriendDel2):void{
			for each(item in freindData){
				if(item.roleid==p.roleid&&item.type==p.type){
					freindData.splice(freindData.indexOf(item),1);
					break;
				}
			}
			this.dispatchEvent(new DispatchEvent(FRIEND_UPDATE,p));
		}
		
		/**
		 *	好友数据有变化 
		 */
		public function updHaoYou(p:PacketWCFriendUpdate2):void{
			for each(item in freindData){
				if(item.roleid==p.frienddata.roleid){
					if(p.frienddata.type!=-1){
						item.type=p.frienddata.type;
					}
					if(p.frienddata.online!=-1){
						item.online=p.frienddata.online;
					}
					if(p.frienddata.level!=-1){
						item.level=p.frienddata.level;
					}
					if(p.frienddata.underwrite!=-1){
						item.underwrite=p.frienddata.underwrite;
					}
					if(p.frienddata.underwrite_p1!=-1){
						item.underwrite_p1=p.frienddata.underwrite_p1;
					}
					if(p.frienddata.underwrite_p2!=-1){
						item.underwrite_p2=p.frienddata.underwrite_p2;
					}
					if(p.frienddata.vip!=-1){
						item.vip=p.frienddata.vip;
					}
					
					if(p.frienddata.camp!=-1){
						item.camp=p.frienddata.camp;
					}
					
					if(p.frienddata.underwrite!=-1||p.frienddata.underwrite_p1!=-1||p.frienddata.underwrite_p2!=-1){
						item.qianMing=getQianMing(item.underwrite,item.underwrite_p1,item.underwrite_p2);
					}
					
					if(item.type==0){
						freindData.splice(freindData.indexOf(item),1);
					}
					break;
				}
			}
			this.dispatchEvent(new DispatchEvent(FRIEND_UPDATE,p));
		}
		/**
		 *	好友聊天信息【接受】 
		 */
		public function privateChat(p:PacketSCSayPrivate2):void{
			//是否已读，自己的信息默认为已读
			var isRead:Boolean= p.userid==Data.myKing.roleID;
			//自己和对方聊天内容 都存在对方的消息里边
			var recordId:int= isRead?p.touserid:p.userid;
			if(mapChat.containsKey(recordId)){
				var say:PacketSCSayPrivate2=mapChat.get(recordId) as PacketSCSayPrivate2;
				if(say.arrMsg.length>MAX_CHAT)say.arrMsg.shift();
				say.arrMsg.push(fmtChat(p.username,p.content));
				say.isRead=isRead;
			}else{
				p.arrMsg.push(fmtChat(p.username,p.content));
				p.isRead=isRead;
				mapChat.put(recordId,p);
			}
			//sthis.dispatchEvent(new DispatchEvent(PRIVATE_CHAT_UPDATE,p));
		}
		/**
		 *	获得某个好友所有聊天信息【只保存30条】 
		 */
		public function getChatById(roleId:int):PacketSCSayPrivate2{
			return mapChat.get(roleId) as PacketSCSayPrivate2;
		}
		/**
		 *	获得某个好友的签名【动态生成】
		 *  @param v1 签名类型
		 *  @param v2 签名参数1
		 *  @param v2 签名参数2 
		 */
		//public function getQianMing(v1:int,v2:int,v3:int):String{
		public function getQianMing(v1:int,v2:int,v3:int,isShort:Boolean=false):String
		{		
			var ret:String="";
			var type:Pub_Underwrite_TypeResModel=XmlManager.localres.getUnderwriteTypeXml.getResPath(v1) as Pub_Underwrite_TypeResModel;
			if(type==null)return ret;
			ret=type.underwrite_content;
			switch(v1){
				case 1:
					//角色升级
					ret=ret.replace("#param",v2);
					break;
				case 2:
					//炼骨

					break;
				case 8:
					//境界
					var jingJieName:String=JingjieModel.getInstance().getNameByLevel(v2);
					ret=ret.replace("#param",jingJieName);
					break;
				case 3:
					//强化
					var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(v2) as Pub_ToolsResModel;
					ret=ret.replace("#param",tool==null?v2:tool.tool_name);
					ret=ret.replace("#param",v3);
					break;
				case 4:
				case 5:
				case 6:
				case 7:
					tool=XmlManager.localres.getToolsXml.getResPath(v2) as Pub_ToolsResModel;
					ret=ret.replace("#param",tool==null?v2:tool.tool_name)
					break;
			}
			
			//不再加点点点
//			if(isShort&&ret!="")ret=ret.substr(0,10)+"...";
			
			return ret;
		}
		
		override public function sync(v:IPacket):void{

			
		}
		/**
		 *	好友聊天信息格式化 
		 */
		public function fmtChat(roleName:String,content:String):String{
			var date:Date=new Date();
			return "["+roleName+"  "+date.hours+":"+date.minutes+"]<br/>"+content;
		}
		private function fillFreind(p:StructFriendData2):void{
			p.jobName=XmlRes.GetJobNameById(p.job);
			p.headIconPath=FileManager.instance.getHeadIconSById(p.headicon);
			p.qianMing=this.getQianMing(p.underwrite,p.underwrite_p1,p.underwrite_p2);
		}
		
		/**
		 *	仇人数据
		 *  2013-11-08 
		 */
		private var enemy:PacketSCEnemyList2=new PacketSCEnemyList2();
		public function setEnemyList(v:PacketSCEnemyList2):void{
			enemy=v;
			//test
//			enemy=new PacketSCEnemyList2();
//			var item:StructEnemyItem2=new StructEnemyItem2();
//			item.userid=1;item.killtime=1000000;item.king_name="adny";item.map_id=20210011;
//			enemy.arrItemEnemyItemList.push(item);
		}
		
		public function getEnemyCount(type:int=1):int{
			if(enemy==null)return 0;
			var ret:int=enemy.arrItemEnemyItemList.length;
			return ret;
		}
		
		public function getEnemyByPage(page:int=1):Vector.<StructEnemyItem2>{
			var ret:Vector.<StructEnemyItem2>=new Vector.<StructEnemyItem2>;
			var now:Vector.<StructEnemyItem2>=enemy.arrItemEnemyItemList;
			page=page<1?1:page;
			var start:int=(page-1)*PAGE_COUNT_ENEMY;
			var end:int=page*PAGE_COUNT_ENEMY;
			if(end>now.length)end=now.length;
			for(var i:int=start;i<end;i++){
				ret.push(now[i]);
			}
			return ret;
		}
	}
}