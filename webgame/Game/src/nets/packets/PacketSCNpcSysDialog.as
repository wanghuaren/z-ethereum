package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *NPC对话打开对话框
    */
    public class PacketSCNpcSysDialog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 7003;
        /** 
        *1.打开对话框2.关闭对话框
        */
        public var r_id:int;
        /** 
        *参数1
        */
        public var param1:int;
        /** 
        *参数2
        */
        public var param2:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(r_id);
            ar.writeInt(param1);
            ar.writeInt(param2);
        }
        public function Deserialize(ar:ByteArray):void
        {
            r_id = ar.readInt();
            param1 = ar.readInt();
            param2 = ar.readInt();
        }
    }
}
