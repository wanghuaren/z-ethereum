package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructClientPara2
    /** 
    *角色列表
    */
    public class StructDCRoleList implements ISerializable
    {
        /** 
        *角色id
        */
        public var userid:int;
        /** 
        *角色名称
        */
        public var king_name:String = new String();
        /** 
        *角色等级
        */
        public var king_level:int;
        /** 
        *角色职业
        */
        public var king_metier:int;
        /** 
        *头像
        */
        public var king_icon:int;
        /** 
        *状态
        */
        public var user_state:int;
        /** 
        *剩余时间
        */
        public var lefttime:int;
        /** 
        *角色性别
        */
        public var king_sex:int;
        /** 
        *角色皮肤0
        */
        public var s0:int;
        /** 
        *角色皮肤1
        */
        public var s1:int;
        /** 
        *角色皮肤2
        */
        public var s2:int;
        /** 
        *角色皮肤3
        */
        public var s3:int;
        /** 
        *外形效果
        */
        public var r1:int;
        /** 
        *角色场景id
        */
        public var mapid:int;
        /** 
        *是否提示pk,0表示提示,1表示不提示
        */
        public var show_pk:int;
        /** 
        *角色设置
        */
        public var sys_config:int;
        /** 
        *参数数据
        */
        public var data:StructClientPara2 = new StructClientPara2();
        /** 
        *角色创建日期
        */
        public var create_date:int;
        /** 
        *离线时间
        */
        public var leave_date:int;
        /** 
        *是否可以修改名称,1可以修改
        */
        public var can_changename:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, king_name, 50);
            ar.writeInt(king_level);
            ar.writeInt(king_metier);
            ar.writeInt(king_icon);
            ar.writeInt(user_state);
            ar.writeInt(lefttime);
            ar.writeInt(king_sex);
            ar.writeInt(s0);
            ar.writeInt(s1);
            ar.writeInt(s2);
            ar.writeInt(s3);
            ar.writeInt(r1);
            ar.writeInt(mapid);
            ar.writeInt(show_pk);
            ar.writeInt(sys_config);
            data.Serialize(ar);
            ar.writeInt(create_date);
            ar.writeInt(leave_date);
            ar.writeInt(can_changename);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var king_nameLength:int = ar.readInt();
            king_name = ar.readMultiByte(king_nameLength,PacketFactory.Instance.GetCharSet());
            king_level = ar.readInt();
            king_metier = ar.readInt();
            king_icon = ar.readInt();
            user_state = ar.readInt();
            lefttime = ar.readInt();
            king_sex = ar.readInt();
            s0 = ar.readInt();
            s1 = ar.readInt();
            s2 = ar.readInt();
            s3 = ar.readInt();
            r1 = ar.readInt();
            mapid = ar.readInt();
            show_pk = ar.readInt();
            sys_config = ar.readInt();
            data.Deserialize(ar);
            create_date = ar.readInt();
            leave_date = ar.readInt();
            can_changename = ar.readInt();
        }
    }
}
