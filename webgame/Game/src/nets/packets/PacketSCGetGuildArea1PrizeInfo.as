package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildArea1Info2
    /** 
    *查询是否可以领取工会领地争夺1返回
    */
    public class PacketSCGetGuildArea1PrizeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 52205;
        /** 
        *当前活动状态 0 未开启 1 开启中 2 已开启 
        */
        public var act_state:int;
        /** 
        *工会领地争夺领取信息
        */
        public var arrItemguildarea1:Vector.<StructGuildArea1Info2> = new Vector.<StructGuildArea1Info2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(act_state);
            ar.writeInt(arrItemguildarea1.length);
            for each (var guildarea1item:Object in arrItemguildarea1)
            {
                var objguildarea1:ISerializable = guildarea1item as ISerializable;
                if (null!=objguildarea1)
                {
                    objguildarea1.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            act_state = ar.readInt();
            arrItemguildarea1= new  Vector.<StructGuildArea1Info2>();
            var guildarea1Length:int = ar.readInt();
            for (var iguildarea1:int=0;iguildarea1<guildarea1Length; ++iguildarea1)
            {
                var objGuildArea1Info:StructGuildArea1Info2 = new StructGuildArea1Info2();
                objGuildArea1Info.Deserialize(ar);
                arrItemguildarea1.push(objGuildArea1Info);
            }
        }
    }
}
