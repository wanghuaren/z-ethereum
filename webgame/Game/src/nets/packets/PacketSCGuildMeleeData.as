package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildRankList2
    /** 
    *家族大乱斗排名数据
    */
    public class PacketSCGuildMeleeData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39501;
        /** 
        *自己家族排名
        */
        public var guildno:int;
        /** 
        *自己家族的积分
        */
        public var guildvalue:int;
        /** 
        *自己的积分
        */
        public var playervalue:int;
        /** 
        *杀死敌对玩家个数
        */
        public var killnum:int;
        /** 
        *家族排名信息
        */
        public var arrItemranklist:Vector.<StructGuildRankList2> = new Vector.<StructGuildRankList2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildno);
            ar.writeInt(guildvalue);
            ar.writeInt(playervalue);
            ar.writeInt(killnum);
            ar.writeInt(arrItemranklist.length);
            for each (var ranklistitem:Object in arrItemranklist)
            {
                var objranklist:ISerializable = ranklistitem as ISerializable;
                if (null!=objranklist)
                {
                    objranklist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildno = ar.readInt();
            guildvalue = ar.readInt();
            playervalue = ar.readInt();
            killnum = ar.readInt();
            arrItemranklist= new  Vector.<StructGuildRankList2>();
            var ranklistLength:int = ar.readInt();
            for (var iranklist:int=0;iranklist<ranklistLength; ++iranklist)
            {
                var objGuildRankList:StructGuildRankList2 = new StructGuildRankList2();
                objGuildRankList.Deserialize(ar);
                arrItemranklist.push(objGuildRankList);
            }
        }
    }
}
