package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRank_List2
    /** 
    *boss活动数据刷新
    */
    public class PacketSCBossInfoUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20035;
        /** 
        *boss 模板id
        */
        public var bossres:int;
        /** 
        *boss当前生命
        */
        public var curhp:int;
        /** 
        *boss最大生命
        */
        public var maxhp:int;
        /** 
        *剩余时间
        */
        public var lefttime:int;
        /** 
        *参与人数
        */
        public var gameman:int;
        /** 
        *排行数据
        */
        public var arrItemrank_list:Vector.<StructRank_List2> = new Vector.<StructRank_List2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(bossres);
            ar.writeInt(curhp);
            ar.writeInt(maxhp);
            ar.writeInt(lefttime);
            ar.writeInt(gameman);
            ar.writeInt(arrItemrank_list.length);
            for each (var rank_listitem:Object in arrItemrank_list)
            {
                var objrank_list:ISerializable = rank_listitem as ISerializable;
                if (null!=objrank_list)
                {
                    objrank_list.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            bossres = ar.readInt();
            curhp = ar.readInt();
            maxhp = ar.readInt();
            lefttime = ar.readInt();
            gameman = ar.readInt();
            arrItemrank_list= new  Vector.<StructRank_List2>();
            var rank_listLength:int = ar.readInt();
            for (var irank_list:int=0;irank_list<rank_listLength; ++irank_list)
            {
                var objRank_List:StructRank_List2 = new StructRank_List2();
                objRank_List.Deserialize(ar);
                arrItemrank_list.push(objRank_List);
            }
        }
    }
}
