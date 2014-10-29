package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *打怪获得经验
    */
    public class PacketSCMonsterExp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14029;
        /** 
        *人物编号
        */
        public var objid:int;
        /** 
        *当前经验
        */
        public var exp:Number;
        /** 
        *连斩得到的经验
        */
        public var exp_ck:int;
        /** 
        *当前等级
        */
        public var level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeDouble(exp);
            ar.writeInt(exp_ck);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            exp = ar.readDouble();
            exp_ck = ar.readInt();
            level = ar.readInt();
        }
    }
}
