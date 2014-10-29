package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *树的信息
    */
    public class PacketWCGuildTreeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39241;
        /** 
        *level
        */
        public var level:int;
        /** 
        *exp
        */
        public var exp:int;
        /** 
        *maxexp
        */
        public var maxexp:int;
        /** 
        *领取的物品
        */
        public var itemid:int;
        /** 
        *是否领取0：可以领取1:未成熟2：领取过高级果实
        */
        public var hasitem:int;
        /** 
        *已有的操作次数：浇水，施肥，除虫
        */
        public var arrItemoptimes:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(level);
            ar.writeInt(exp);
            ar.writeInt(maxexp);
            ar.writeInt(itemid);
            ar.writeInt(hasitem);
            ar.writeInt(arrItemoptimes.length);
            for each (var optimesitem:int in arrItemoptimes)
            {
                ar.writeInt(optimesitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            level = ar.readInt();
            exp = ar.readInt();
            maxexp = ar.readInt();
            itemid = ar.readInt();
            hasitem = ar.readInt();
            arrItemoptimes= new  Vector.<int>();
            var optimesLength:int = ar.readInt();
            for (var ioptimes:int=0;ioptimes<optimesLength; ++ioptimes)
            {
                arrItemoptimes.push(ar.readInt());
            }
        }
    }
}
