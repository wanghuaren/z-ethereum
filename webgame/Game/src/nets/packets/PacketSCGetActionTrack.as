package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *日常活动状态
    */
    public class PacketSCGetActionTrack implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53301;
        /** 
        *任务状态 0:不显示，1:显示
        */
        public var arrItemstate:Vector.<int> = new Vector.<int>();
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemstate.length);
            for each (var stateitem:int in arrItemstate)
            {
                ar.writeInt(stateitem);
            }
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemstate= new  Vector.<int>();
            var stateLength:int = ar.readInt();
            for (var istate:int=0;istate<stateLength; ++istate)
            {
                arrItemstate.push(ar.readInt());
            }
            tag = ar.readInt();
        }
    }
}
