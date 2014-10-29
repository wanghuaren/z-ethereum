package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTeamLists2
    /** 
    *附近队伍信息
    */
    public class PacketWCTeamDesc implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18022;
        /** 
        *队伍信息
        */
        public var arrItemteam:Vector.<StructTeamLists2> = new Vector.<StructTeamLists2>();
        /** 
        *当前第几页
        */
        public var curpage:int;
        /** 
        *总共页数
        */
        public var totalpage:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemteam.length);
            for each (var teamitem:Object in arrItemteam)
            {
                var objteam:ISerializable = teamitem as ISerializable;
                if (null!=objteam)
                {
                    objteam.Serialize(ar);
                }
            }
            ar.writeInt(curpage);
            ar.writeInt(totalpage);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemteam= new  Vector.<StructTeamLists2>();
            var teamLength:int = ar.readInt();
            for (var iteam:int=0;iteam<teamLength; ++iteam)
            {
                var objTeamLists:StructTeamLists2 = new StructTeamLists2();
                objTeamLists.Deserialize(ar);
                arrItemteam.push(objTeamLists);
            }
            curpage = ar.readInt();
            totalpage = ar.readInt();
        }
    }
}
