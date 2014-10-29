package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBuff2
    /** 
    *人物/怪物Buff添加
    */
    public class PacketSCBuffNew implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14026;
        /** 
        *人物/怪物编号
        */
        public var objid:int;
        /** 
        *buff信息
        */
        public var buff:StructBuff2 = new StructBuff2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            buff.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            buff.Deserialize(ar);
        }
    }
}
