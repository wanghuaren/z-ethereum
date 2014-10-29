package nets.packets
{
	import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;


	/** 
	 *玩家状态更新
	 */
	public class PacketSCPlayerDetail implements IPacket
	{
		/**
		 *id
		 */
		public static const id:int = 1997;
		
		/**
		 * 标志位
		 */
		public var flags:int;
		/**
		 * 标志位2
		 */
		public var flags1:int;
		/**
		 * 编号
		 */
		public var objid:int;
		/**
		 * 等级
		 */
		public var level:int;
		/**
		 * 角色名
		 */
		public var name:String = new String();
		/**
		 * 形象0
		 */
		public var s0:int;
		/**
		 * 形象1
		 */
		public var s1:int;
		/**
		 * 形象2
		 */
		public var s2:int;
		/**
		 * 形象3
		 */
		public var s3:int;
		/**
		 * 战斗阵营
		 */
		public var campid:int;
		/**
		 * 当前活力值
		 */
		public var vim:int;
		/**
		 * 最大活力值
		 */
		public var maxvim:int;
		/**
		 * 队伍id
		 */
		public var teamid:int;
		/**
		 * 队长id
		 */
		public var teamleader:int;
		/**
		 * 是否在修炼
		 */
		public var exercise:int;
		/**
		 * 系统签名
		*/
		public var UnderWrite:int;
		/**
		 * 系统签名参数
		*/
		public var UnderWrite_p1:int;
		/**
		 * 系统签名参数
		*/
		public var UnderWrite_p2:int;
		/**
		 *地图区域类型,1打怪区，只允许攻击敌对NPC	2阵营区，允许攻击敌对阵营 3安全区，不允许任何形势的攻击
		 */
		public var  MapZoneType:int; 
		/**
		 *PK模式，0表示和平模式，1表示阵营模式
		 */
		public var  PkMode:int; 
		/**
		 * 称号(用位表示，从低到高依次是战力第一，战力第二，伙伴第一，伙伴第二。。。。。)
		 */
		public var Title:int;
		/**
		 * VIP
		 */
		public var Vip:int;
		/**
		 *攻击速度
		 */
		public var  AtkSpeed:int;//
		/**
		 *家族id
		 */
		public var  GuildId:int;//
		/**
		 *家族名称
		 */
		public var  GuildName:String = new String();
		/**
		 *家族职位
		 */
		public var  GuildDuty:int;
		/**
		 * 基本阵营
		 */
		public var basecampid:int;
		/**
		 * 是否皇族
		 */
		public var guildiswin:int;
		/**
		 * 合体对象id
		 */
		public var coupleid:int;
		/**
		 * 神器外观数据
		 */
		public var r1:int;
		/**
		 * 是否西天取经
		 */
		public var IsXiYou:int;
		/**
		 * 队伍成员数量
		 */
		public var TeamNum:int;
		/**
		 *摊位名称
		 */
		public var  boothName:String = new String();
		/**
		 *PK值
		 */
		public var  pkvalue:int;
		/**
		 *功勋
		 */
		public var  ploit:int;
		/**
		*伴侣名称
		*/
		public var  wifeName:String = new String();
		
		public function GetId():int{return id;}

		public function Serialize(ar:ByteArray):void
		{			

		}
		public function Deserialize(ar:ByteArray):void
		{
			objid = ar.readInt();
			flags = ar.readInt();
			flags1 = ar.readInt();
			
			if (flags & (1<<0)) {
				level = ar.readInt();
			}
			else{
			    level = -1;
			}
			
			if (flags & (1<<1)) {
				var king_nameLength:int = ar.readInt();
				name = ar.readMultiByte(king_nameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
			    name = null;
			}
			
			if (flags & (1<<2)) {
				s0 = ar.readInt();
			}
			else{
			    s0 = -1;
			}
			
			if (flags & (1<<3)) {
				s1 = ar.readInt();
			}
			else{
			    s1 = -1;
			}

			if (flags & (1<<4)) {
				s2 = ar.readInt();
			}
			else{
			    s2 = -1;
			}
			
			if (flags & (1<<5)) {
				s3 = ar.readInt();
			}
			else{
			    s3 = -1;
			}
			
			if (flags & (1<<6)) {
				campid = ar.readInt();
			}
			else{
			    campid = -1;
			}			

			if (flags & (1<<7)) {
				vim = ar.readInt();
			}
			else{
			    vim = -1;
			}

			if (flags & (1<<8)) {
				maxvim = ar.readInt();
			}
			else{
			    maxvim = -1;
			}

			if (flags & (1<<9)) {
				teamid = ar.readInt();
			}
			else{
			    teamid = -1;
			}

			if (flags & (1<<10)) {
				teamleader = ar.readInt();
			}
			else{
			    teamleader = -1;
			}
			if (flags & (1<<11)) {
				exercise = ar.readInt();
			}
			else{
			    exercise = -1;
			}
			if(flags &(1<<12)){
				UnderWrite=ar.readInt();
			}
			else{
				UnderWrite=-1;
			}
			if(flags &(1<<13)){
				UnderWrite_p1=ar.readInt();
			}
			else{
				UnderWrite_p1=-1;
			}
			if(flags &(1<<14)){
				UnderWrite_p2=ar.readInt();
			}
			else{
				UnderWrite_p2=-1;
			}
			if(flags &(1<<15)){
				PkMode=ar.readInt();
			}
			else{
				PkMode=-1;
			}
			if(flags &(1<<16)){
				MapZoneType=ar.readInt();
			}
			else{
				MapZoneType=-1;
			}
			if(flags &(1<<17)){
				Title=ar.readInt();
			}
			else{
				Title=-1;
			}
			if(flags &(1<<18)){
				Vip=ar.readInt();
			}
			else{
				Vip=-1;
			}

			if (flags & (1<<19)) {
				AtkSpeed = ar.readInt();
			}
			else{
				AtkSpeed = -1;
			}

			if (flags & (1<<20)) {
				GuildId = ar.readInt();
			}
			else{
				GuildId = -1;
			}

			if (flags & (1<<21)) {
				var guild_nameLength:int = ar.readInt();
				GuildName = ar.readMultiByte(guild_nameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
				GuildName = null;
			}

			if (flags & (1<<22)) {
				GuildDuty = ar.readInt();
			}
			else{
				GuildDuty = -1;
			}

			if (flags & (1<<23)) {
				basecampid = ar.readInt();
			}
			else{
				basecampid = -1;
			}

			if (flags & (1<<24)) {
				guildiswin = ar.readInt();
			}
			else{
				guildiswin = -1;
			}

			if (flags & (1<<25)) {
				coupleid = ar.readInt();
			}
			else{
				coupleid = -1;
			}

			if (flags & (1<<26)) {
				r1 = ar.readInt();
			}
			else{
				r1 = -1;
			}

			if (flags & (1<<27)) {
				TeamNum = ar.readInt();
			}
			else{
				TeamNum = -1;
			}

			if (flags & (1<<28)) {
				IsXiYou = ar.readInt();
			}
			else{
				IsXiYou = -1;
			}

			if (flags & (1<<29)) {
				var booth_nameLength:int = ar.readInt();
				boothName = ar.readMultiByte(booth_nameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
				boothName = null;
			}

			if (flags & (1<<30)) {
				pkvalue = ar.readInt();
			}
			else{
				pkvalue = -1;
			}

			if (flags & (1<<31)) {
				ploit = ar.readInt();
			}
			else{
				ploit = -1;
			}
			if (flags1 & (1<<32-32)) {
				var wife_nameLength:int = ar.readInt();
				wifeName = ar.readMultiByte(wife_nameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
				wifeName = null;
			}
		}
	}
}
