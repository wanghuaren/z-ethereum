package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerPlayerPkInfo2
    /** 
    *获得当前pk服务器信息
    */
    public class PacketWCCurServerPkInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40003;
        /** 
        *人数列表
        */
        public var arrItemman_list:Vector.<StructServerPlayerPkInfo2> = new Vector.<StructServerPlayerPkInfo2>();
        /** 
        *当前阶段 1 - 6 阶段
        */
        public var cur_step:int;
        /** 
        *当前状态 1 比赛前 2 比赛中 3 比赛后
        */
        public var cur_state:int;
        /** 
        *第几届
        */
        public var cur_no:int;
        /** 
        *进入16强编号
        */
        public var no_1:int;
        /** 
        *进入8强编号
        */
        public var no_2:int;
        /** 
        *进入4强编号
        */
        public var no_3:int;
        /** 
        *进入2强编号
        */
        public var no_4:int;
        /** 
        *进入1强编号
        */
        public var no_5:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemman_list.length);
            for each (var man_listitem:Object in arrItemman_list)
            {
                var objman_list:ISerializable = man_listitem as ISerializable;
                if (null!=objman_list)
                {
                    objman_list.Serialize(ar);
                }
            }
            ar.writeInt(cur_step);
            ar.writeInt(cur_state);
            ar.writeInt(cur_no);
            ar.writeInt(no_1);
            ar.writeInt(no_2);
            ar.writeInt(no_3);
            ar.writeInt(no_4);
            ar.writeInt(no_5);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemman_list= new  Vector.<StructServerPlayerPkInfo2>();
            var man_listLength:int = ar.readInt();
            for (var iman_list:int=0;iman_list<man_listLength; ++iman_list)
            {
                var objServerPlayerPkInfo:StructServerPlayerPkInfo2 = new StructServerPlayerPkInfo2();
                objServerPlayerPkInfo.Deserialize(ar);
                arrItemman_list.push(objServerPlayerPkInfo);
            }
            cur_step = ar.readInt();
            cur_state = ar.readInt();
            cur_no = ar.readInt();
            no_1 = ar.readInt();
            no_2 = ar.readInt();
            no_3 = ar.readInt();
            no_4 = ar.readInt();
            no_5 = ar.readInt();
        }
    }
}
