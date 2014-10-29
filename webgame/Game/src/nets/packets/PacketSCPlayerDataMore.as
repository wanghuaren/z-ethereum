package nets.packets
{
	import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
	/** 
	 *玩家数据更新
	 */
	public class PacketSCPlayerDataMore implements IPacket
	{
		/**
		 *id
		 */
		public static const id:int = 1802;

		/**
		 * 标志位
		 */
		public var flags:int;
		/**
		 * 标志位2
		 */
		public var flags1:int;
		/**
		 * 标志位3
		 */
		public var flags2:int;
		/**
		 * 编号
		 */
		public var objid:int;
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
		 * 阵营
		 */
		public var campid:int;		     
		/**
		 *职业
		 */
		public var metier:int;        
		/**
		 * 性别
		 */
		public var sex:int;   
		/**
		 * 游戏币
		 */
		public var coin1:int;         
		/**
		 * 礼金
		 */
		public var coin2:int;         
		/**
		 * 元宝
		 */
		public var coin3:int;         
		/**
		 * 仓库游戏币MP
		 */
		public var coin4:int;         
		/**
		 *绑定游戏币
		 */
		public var  Coin5:int;
		/**
		 *背包总格数
		 */
		public var  BagSize:int;  
		/**
		 *未开格开始位置
		 */
		public var  BagStart:int; 
		/**
		 *未开格结束位置
		 */
		public var  BagEnd:int;
		/**
		 *仓库总格数
		 */
		public var  BankSize:int; 
		/**
		 *未开格开始位
		 */
		public var  BankStart:int; 
		/**
		 *未开格结束位置
		 */
		public var  BankEnd:int;	
		/**
		 * 声望
		*/
		public var Renown:int;
		/**
		* 伙伴栏状态，位表示
		*/
		public var PetSlot:int;
		/**
		* 炼骨点
		*/
		public var Bone:int;
		/**
		* 战力值
		*/
		public var FightValue:int;
		/**
		 * 队伍id
		 */
		public var TeamId:int;
		/**
		 * 队长id
		 */
		public var TeamLeader:int;
		/**
		 * 当前宠物id
		 */
		public var CurPetId:int;
		/**
		 * 当前宠物id
		 */
		public var Exercise:int;
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
		 *PK模式，0表示和平模式，1表示阵营模式
		 */
		public var  PkMode:int; 
		/**
		 *地图区域类型,1打怪区，只允许攻击敌对NPC	2阵营区，允许攻击敌对阵营 3安全区，不允许任何形势的攻击
		 */
		public var  MapZoneType:int ;
		/**
		 * 称号(用位表示，从低到高依次是战力第一，战力第二，伙伴第一，伙伴第二。。。。。)
		 */
		public var Title:int;
		/**
		 * VIP
		 */
		public var Vip:int;
		/**
		*合成背包无效开始位置
		*/
		public var StarComposeStart:int; 
		/**
		*结束位置
		*/
		public var StarComposeEnd:int;
		/**
		*	排行榜排行
		*/
		public var RankLevel:int;
		/**
		*	家族id
		*/
		public var GuildId:int;
		/**
		*	家族名称
		*/
		public var GuildName:String = new String();
		/**
		*	家族职位
		*/
		public var GuildDuty:int;
		public var  Icon:int; 
		public var  DefaultSkillId:int;  
		/**
		*	是否皇族
		*/
		public var GuildIsWin:int;
		/**
		 *VIP试用等级
		*/
		public var	TestVip:int;
		/**
		 *特殊标记
		*/
		public var	SpecialFlag:int;
		/**
		 *QQ黄钻等级
		*/
		public var	QQYellowVip:int;
		/**
		 *神兽魂器强化等级
		*/
		public var	HorseStrongLvl:int;
		/**
		 *神器外观
		*/
		public var	r1:int;
		/**
		 *经验2(阅历)
		*/
		public var	exp2:int;
		/**
		 *未分配天赋点(技能点)
		*/
		public var	SkillPoint:int;

		/**
		 *快捷栏锁标记(0:未锁 1:锁)
		*/
		public var	ShortKeyLock:int;
		/**
		 *显示称号
		*/
		public var	DisplayTitle:int;

		/**
		 *累计在线时间(单位分钟)
		*/
		public var	OnlineMinute:int;

		/**
		 *背包开启,元宝开启的时间
		*/
		public var	RmbBuySecs:int;

		/**
		 *累计离线时间(单位秒)
		*/
		public var	OfflineSecs:int;
		/**
		 *星耀值
		*/
		public var	StarValue:int;
		/**
		 *玉佩碎片
		*/
		public var	Value1:int;
		/**
		 *护镜碎片
		*/
		public var	Value2:int;
		/**
		 *荣誉
		*/
		public var	Value3:int;
		/**
		 *coin6
		*/
		public var	coin6:int;
		/**
		 *天劫等级
		*/
		public var	soarlvl:int;
		/**
		 *天劫修为值
		*/
		public var	soarexp:int;
		/**
		 *功勋等级
		*/
		public var	ploitLv:int;
		/**
		 *暗器碎片
		*/
		public var	Value4:int;
		/**
		 *剑灵值
		*/
		public var	Value5:int;
		/**
		 *神铁碎片
		*/
		public var	Value6:int;
		/**
		 *神器等级
		*/
		public var	GodLv:int;
		/**
		 *翅膀等级
		*/
		public var	WingLv:int;
		/**
		 *总成就点
		*/
		public var	Ar_total_point:int;
			
		public function GetId():int{return id;}
		public function Serialize(ar:ByteArray):void
		{			
			
		}
		public function Deserialize(ar:ByteArray):void
		{
			objid = ar.readInt();
			flags = ar.readInt();
			flags1 = ar.readInt();
			flags2 = ar.readInt();
			
			if (flags & (1<<0)) {
				var king_nameLength:int = ar.readInt();
				name = ar.readMultiByte(king_nameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
				name = null;
			}
			
			if (flags & (1<<1)) {
				s0 = ar.readInt();
			}
			else{
				s0 = -1;
			}
			
			if (flags & (1<<2)) {
				s1 = ar.readInt();
			}
			else{
				s1 = -1;
			}
			
			if (flags & (1<<3)) {
				s2 = ar.readInt();
			}
			else{
				s2 = -1;
			}
			
			if (flags & (1<<4)) {
				s3 = ar.readInt();
			}
			else{
				s3 = -1;
			}
			
			if (flags & (1<<5)) {
				campid = ar.readInt();
			}
			else{
				campid = -1;
			}			

			if (flags & (1<<6)) {
				metier = ar.readInt();
			}
			else{
				metier = -1;
			}

			if (flags & (1<<7)) {
				sex = ar.readInt();
			}
			else{
				sex = -1;
			}

			if (flags & (1<<8)) {
				coin1 = ar.readInt();
			}
			else{
				coin1 = -1;
			}

			if (flags & (1<<9)) {
				coin2 = ar.readInt();
			}
			else{
				coin2 = -1;
			}

			if (flags & (1<<10)) {
				coin3 = ar.readInt();
			}
			else{
				coin3 = -1;
			}

			if (flags & (1<<11)) {
				coin4 = ar.readInt();
			}
			else{
				coin4 = -1;
			}

			if (flags & (1<<12)) {
				Coin5 = ar.readInt();
			}
			else{
				Coin5 = -1;
			}

			if (flags & (1<<13)) {
				BagSize = ar.readInt();
			}
			else{
				BagSize = -1;
			}

			if (flags & (1<<14)) {
				BagStart = ar.readInt();
			}
			else{
				BagStart = -1;
			}

			if (flags & (1<<15)) {
				BagEnd = ar.readInt();
			}
			else{
				BagEnd = -1;
			}

			if (flags & (1<<16)) {
				BankSize = ar.readInt();
			}
			else{
				BankSize = -1;
			}

			if (flags & (1<<17)) {
				BankStart = ar.readInt();
			}
			else{
				BankStart = -1;
			}

			if (flags & (1<<18)) {
				BankEnd = ar.readInt();
			}
			else{
				BankEnd = -1;
			}
						
			if (flags & (1<<19)) {
				Renown=ar.readInt();
			}
			else{
				Renown=-1;
			}
			if (flags & (1<<20)) {
				PetSlot=ar.readInt();
			}
			else{
				PetSlot=-1;
			}
			if (flags & (1<<21)) {
				Bone=ar.readInt();
			}
			else{
				Bone=-1;
			}
			if (flags & (1<<22)) {
				FightValue=ar.readInt();
			}
			else{
				FightValue=-1;
			}
			if (flags & (1<<23)) {
				TeamId=ar.readInt();
			}
			else{
				TeamId=-1;
			}
			if (flags & (1<<24)) {
				TeamLeader=ar.readInt();
			}
			else{
				TeamLeader=-1;
			}
			if (flags & (1<<25)) {
				CurPetId=ar.readInt();
			}
			else{
				CurPetId=-1;
			}
			if (flags & (1<<26)) {
				Exercise=ar.readInt();
			}
			else{
				Exercise=-1;
			}
			if (flags & (1<<27)) {
				UnderWrite=ar.readInt();
			}
			else{
				UnderWrite=-1;
			}
			if (flags & (1<<28)) {
				UnderWrite_p1=ar.readInt();
			}
			else{
				UnderWrite_p1=-1;
			}
			if (flags & (1<<29)) {
				UnderWrite_p2=ar.readInt();
			}
			else{
				UnderWrite_p2=-1;
			}
			if (flags & (1<<30)) {
				PkMode=ar.readInt();
			}
			else{
				PkMode=-1;
			}

			if(flags &(1<<31)){
				MapZoneType=ar.readInt();
			}
			else{
				MapZoneType=-1;
			}
			if(flags1 &(1<<32-32)){
				Title=ar.readInt();
			}
			else{
				Title=-1;
			}
			if(flags1 &(1<<33-32)){
				Vip=ar.readInt();
			}
			else{
				Vip=-1;
			}
			if(flags1 &(1<<34-32)){
				StarComposeStart=ar.readInt();
			}
			else{
				StarComposeStart=-1;
			}
			if(flags1 &(1<<35-32)){
				StarComposeEnd=ar.readInt();
			}
			else{
				StarComposeEnd=-1;
			}
			if(flags1 &(1<<36-32)){
				RankLevel=ar.readInt();
			}
			else{
				RankLevel=-1;
			}
			if(flags1 &(1<<37-32)){
				GuildId=ar.readInt();
			}
			else{
				GuildId=-1;
			}
			if(flags1 &(1<<38-32)){
				var guild_nameLength:int = ar.readInt();
				GuildName = ar.readMultiByte(guild_nameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
				GuildName=null;
			}
			if(flags1 &(1<<39-32)){
				GuildDuty=ar.readInt();
			}
			else{
				GuildDuty=-1;
			}

			if (flags1 & (1<<40-32)) {
				Icon = ar.readInt();
			}
			else{
				Icon = -1;
			}
				
			if (flags1 & (1<<41-32)) {
				DefaultSkillId= ar.readInt();
			}
			else{
				DefaultSkillId= -1;
			}

			if (flags1 & (1<<42-32)) {
				GuildIsWin= ar.readInt();
			}
			else{
				GuildIsWin= -1;
			}
			if(flags1 & (1<<43-32)){
				TestVip = ar.readInt();
			}
			else{
				TestVip=-1;
			}
			if(flags1 & (1<<44-32)){
				SpecialFlag = ar.readInt();
			}
			else{
				SpecialFlag=-1;
			}
			if(flags1 & (1<<45-32)){
				QQYellowVip = ar.readInt();
			}
			else{
				QQYellowVip=-1;
			}
			if(flags1 & (1<<46-32)){
				HorseStrongLvl = ar.readInt();
			}
			else{
				HorseStrongLvl=-1;
			}

			if(flags1 & (1<<47-32)){
				r1 = ar.readInt();
			}
			else{
				r1=-1;
			}
			if(flags1 & (1<<48-32)){
				exp2 = ar.readInt();
			}
			else{
				exp2=-1;
			}
			if(flags1 & (1<<49-32)){
				SkillPoint = ar.readInt();
			}
			else{
				SkillPoint=-1;
			}
			if(flags1 & (1<<50-32)){
				ShortKeyLock = ar.readInt();
			}
			else{
				ShortKeyLock=-1;
			}
			if(flags1 & (1<<51-32)){
				DisplayTitle = ar.readInt();
			}
			else{
				DisplayTitle=-1;
			}
			if(flags1 & (1<<52-32)){
				OnlineMinute = ar.readInt();
			}
			else{
				OnlineMinute=-1;
			}
			if(flags1 & (1<<53-32)){
				RmbBuySecs = ar.readInt();
			}
			else{
				RmbBuySecs=-1;
			}
			if(flags1 & (1<<54-32)){
				OfflineSecs = ar.readInt();
			}
			else{
				OfflineSecs=-1;
			}
			if(flags1 & (1<<55-32)){
				StarValue = ar.readInt();
			}
			else{
				StarValue=-1;
			}
			if(flags1 & (1<<56-32)){
				Value1 = ar.readInt();
			}
			else{
				Value1=-1;
			}
			if(flags1 & (1<<57-32)){
				Value2 = ar.readInt();
			}
			else{
				Value2=-1;
			}
			if(flags1 & (1<<58-32)){
				Value3 = ar.readInt();
			}
			else{
				Value3=-1;
			}
			if(flags1 & (1<<59-32)){
				coin6 = ar.readInt();
			}
			else{
				coin6=-1;
			}
			if(flags1 & (1<<60-32)){
				soarlvl = ar.readInt();
			}
			else{
				soarlvl=-1;
			}
			if(flags1 & (1<<61-32)){
				soarexp = ar.readInt();
			}
			else{
				soarexp=-1;
			}
			if(flags1 & (1<<62-32)){
				ploitLv = ar.readInt();
			}
			else{
				ploitLv=-1;
			}			
			if(flags1 & (1<<63-32)){
				Value4 = ar.readInt();
			}
			else{
				Value4=-1;
			}
			if(flags2 & (1<<64-64)){
				Value5 = ar.readInt();
			}
			else{
				Value5=-1;
			}
			if(flags2 & (1<<65-64)){
				Value6 = ar.readInt();
			}
			else{
				Value6=-1;
			}
			if(flags2 & (1<<66-64)){
				GodLv = ar.readInt();
			}
			else{
				GodLv=-1;
			}
			if(flags2 & (1<<67-64)){
				WingLv = ar.readInt();
			}
			else{
				WingLv=-1;
			}
			if(flags2 & (1<<68-64)){
				Ar_total_point = ar.readInt();
			}
			else{
				Ar_total_point=-1;
			}
		}
	}
}
