package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *新手引导数据
    */
    public class StructNewStepInfo implements ISerializable
    {
        /** 
        *当前常规引导ID
        */
        public var commid:int;
        /** 
        *当前常规引导步骤
        */
        public var commstep:int;
        /** 
        *特殊引导数据
        */
        public var specint:int;
        /** 
        *特殊引导步骤
        */
        public var specstep:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(commid);
            ar.writeInt(commstep);
            ar.writeInt(specint);
            ar.writeInt(specstep);
        }
        public function Deserialize(ar:ByteArray):void
        {
            commid = ar.readInt();
            commstep = ar.readInt();
            specint = ar.readInt();
            specstep = ar.readInt();
        }
    }
}
