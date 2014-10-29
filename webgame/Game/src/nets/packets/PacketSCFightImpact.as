package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *人物/怪物攻击效果
    */
    public class PacketSCFightImpact implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14028;
        /** 
        *人物/怪物编号
        */
        public var objid:int;
        /** 
        *效果编号
        */
        public var impactid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(impactid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            impactid = ar.readInt();
        }
    }
}
