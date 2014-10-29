package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructDiGongBossState2
    /** 
    *获取地宫boss状态
    */
    public class PacketSCGetDiGongBossState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51202;
        /** 
        *boss状态列表
        */
        public var arrItemboss_list:Vector.<StructDiGongBossState2> = new Vector.<StructDiGongBossState2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemboss_list.length);
            for each (var boss_listitem:Object in arrItemboss_list)
            {
                var objboss_list:ISerializable = boss_listitem as ISerializable;
                if (null!=objboss_list)
                {
                    objboss_list.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemboss_list= new  Vector.<StructDiGongBossState2>();
            var boss_listLength:int = ar.readInt();
            for (var iboss_list:int=0;iboss_list<boss_listLength; ++iboss_list)
            {
                var objDiGongBossState:StructDiGongBossState2 = new StructDiGongBossState2();
                objDiGongBossState.Deserialize(ar);
                arrItemboss_list.push(objDiGongBossState);
            }
        }
    }
}
