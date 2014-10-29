package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *取得角色头像编号
    */
    public class PacketCDRoleHeadList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 120;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *性别
        */
        public var sex:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(metier);
            ar.writeInt(sex);
        }
        public function Deserialize(ar:ByteArray):void
        {
            metier = ar.readInt();
            sex = ar.readInt();
        }
    }
}
