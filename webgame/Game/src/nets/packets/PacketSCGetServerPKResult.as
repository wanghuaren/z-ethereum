package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerPlayerPkInfo2
    import netc.packets2.StructServerPlayerPkInfo2
    /** 
    *获得玩家比赛结果返回
    */
    public class PacketSCGetServerPKResult implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40012;
        /** 
        *玩家1
        */
        public var man_1:StructServerPlayerPkInfo2 = new StructServerPlayerPkInfo2();
        /** 
        *玩家2
        */
        public var man_2:StructServerPlayerPkInfo2 = new StructServerPlayerPkInfo2();
        /** 
        *胜利玩家no
        */
        public var win_no:int;
        /** 
        *押注阶段
        */
        public var step:int;
        /** 
        *比分
        */
        public var reslut:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            man_1.Serialize(ar);
            man_2.Serialize(ar);
            ar.writeInt(win_no);
            ar.writeInt(step);
            ar.writeInt(reslut);
        }
        public function Deserialize(ar:ByteArray):void
        {
            man_1.Deserialize(ar);
            man_2.Deserialize(ar);
            win_no = ar.readInt();
            step = ar.readInt();
            reslut = ar.readInt();
        }
    }
}
