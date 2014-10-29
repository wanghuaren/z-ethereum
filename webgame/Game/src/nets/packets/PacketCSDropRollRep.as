package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *掉落拾取Roll点
    */
    public class PacketCSDropRollRep implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14044;
        /** 
        *拾取包id
        */
        public var objid:int;
        /** 
        *0:放弃 1:roll点
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            flag = ar.readInt();
        }
    }
}
