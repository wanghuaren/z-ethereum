package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSignInItem2
    /** 
    *抽奖数据
    */
    public class PacketSCSignInAwardData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37004;
        /** 
        *抽奖池列表
        */
        public var arrItemitemlist:Vector.<StructSignInItem2> = new Vector.<StructSignInItem2>();
        /** 
        *上次奖励物品id
        */
        public var lastgiftId:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemitemlist.length);
            for each (var itemlistitem:Object in arrItemitemlist)
            {
                var objitemlist:ISerializable = itemlistitem as ISerializable;
                if (null!=objitemlist)
                {
                    objitemlist.Serialize(ar);
                }
            }
            ar.writeInt(lastgiftId);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitemlist= new  Vector.<StructSignInItem2>();
            var itemlistLength:int = ar.readInt();
            for (var iitemlist:int=0;iitemlist<itemlistLength; ++iitemlist)
            {
                var objSignInItem:StructSignInItem2 = new StructSignInItem2();
                objSignInItem.Deserialize(ar);
                arrItemitemlist.push(objSignInItem);
            }
            lastgiftId = ar.readInt();
        }
    }
}
