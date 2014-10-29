package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设置显示称号
    */
    public class PacketCSDisplayTitleSet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 35105;
        /** 
        *称号id
        */
        public var title:int;
        /** 
        *flag,1为装备，0为卸下
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(title);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            title = ar.readInt();
            flag = ar.readInt();
        }
    }
}
