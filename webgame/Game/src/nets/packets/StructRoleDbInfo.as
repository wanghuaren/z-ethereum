package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructDBTaskList2
    import netc.packets2.StructDBHistoryTask2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructSkillList2
    import netc.packets2.StructShortKeyList2
    import netc.packets2.StructEquipStrongItems2
    import netc.packets2.StructItemContainer2
    import netc.packets2.Structpets2
    import netc.packets2.StructInstanceInfo2
    import netc.packets2.StructPetShoutDatas2
    import netc.packets2.StructDBLimitData2
    import netc.packets2.StructTeamMember2
    import netc.packets2.StructExercise2
    import netc.packets2.StructLogInfo2
    import netc.packets2.StructActInfo2
    import netc.packets2.StructAutoData2
    import netc.packets2.StructLogInfo2
    import netc.packets2.StructBournList2
    import netc.packets2.StructGradeInfo2
    import netc.packets2.Structpara2
    import netc.packets2.StructStarWatchData2
    import netc.packets2.StructAr_Point2
    import netc.packets2.StructPrizeMsgDbInfoList2
    import netc.packets2.StructNewStepInfo2
    import netc.packets2.StructDoubleExpInfo2
    import netc.packets2.StructExpBackData2
    import netc.packets2.StructImpactDbInfoList2
    import netc.packets2.StructClientPara2
    import netc.packets2.StructSignIn2
    import netc.packets2.StructCardInfo2
    import netc.packets2.StructGuildPlayerData2
    import netc.packets2.StructCDList2
    import netc.packets2.StructHorseSkillItem_l2
    import netc.packets2.StructGameVipTypeInfo2
    import netc.packets2.StructEnemyList2
    import netc.packets2.StructFollowUnits2
    import netc.packets2.StructBladeInfo2
    import netc.packets2.StructGuildShop2
    import netc.packets2.StructRoleGemInfo2
    /** 
    *角色数据信息
    */
    public class StructRoleDbInfo implements ISerializable
    {
        /** 
        *账号ID
        */
        public var accountID:int;
        /** 
        *角色ID
        */
        public var roleID:int;
        /** 
        *角色原有区
        */
        public var role_field:int;
        /** 
        *角色名字
        */
        public var rolename:String = new String();
        /** 
        *头像
        */
        public var icon:int;
        /** 
        *生命值
        */
        public var hp:int;
        /** 
        *魔法值
        */
        public var mp:int;
        /** 
        *活力值
        */
        public var vim:int;
        /** 
        *声望
        */
        public var renown:int;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *性别
        */
        public var sex:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *经验
        */
        public var exp:Number;
        /** 
        *金钱
        */
        public var coin_1:int;
        /** 
        *礼金
        */
        public var coin_2:int;
        /** 
        *元宝
        */
        public var coin_3:int;
        /** 
        *仓库金钱
        */
        public var coin_4:int;
        /** 
        *绑定金钱
        */
        public var coin_5:int;
        /** 
        *充值元宝，提取用
        */
        public var coin_6:int;
        /** 
        *阵营编号
        */
        public var camp_id:int;
        /** 
        *地图编号
        */
        public var mapid:int;
        /** 
        *地图X
        */
        public var mapx:int;
        /** 
        *地图Y
        */
        public var mapy:int;
        /** 
        *进入前地图编号
        */
        public var mapid_b:int;
        /** 
        *进入前地图X
        */
        public var mapx_b:int;
        /** 
        *进入前地图Y
        */
        public var mapy_b:int;
        /** 
        *登录次数
        */
        public var logintimes:int;
        /** 
        *PK模式
        */
        public var pkmode:int;
        /** 
        *角色皮肤
        */
        public var s0:int;
        /** 
        *角色皮肤
        */
        public var s1:int;
        /** 
        *角色皮肤
        */
        public var s2:int;
        /** 
        *角色皮肤
        */
        public var s3:int;
        /** 
        *当前坐骑位置
        */
        public var ride:int;
        /** 
        *战力值
        */
        public var fightvalue:int;
        /** 
        *炼骨点
        */
        public var boneNum:int;
        /** 
        *任务
        */
        public var task_all:StructDBTaskList2 = new StructDBTaskList2();
        /** 
        *任务历史
        */
        public var task_his:StructDBHistoryTask2 = new StructDBHistoryTask2();
        /** 
        *背包物品
        */
        public var bagItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *任务物品
        */
        public var taskItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *身上装备
        */
        public var equipItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *仓库
        */
        public var bankItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *观星背包
        */
        public var starWatchItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *合成背包
        */
        public var starComposeItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *星魂背包
        */
        public var starItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *活动仓库背包
        */
        public var actBankItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *技能列表
        */
        public var skillList:StructSkillList2 = new StructSkillList2();
        /** 
        *快捷键
        */
        public var shortKeyList:StructShortKeyList2 = new StructShortKeyList2();
        /** 
        *强化槽列表信息
        */
        public var strongItemList:StructEquipStrongItems2 = new StructEquipStrongItems2();
        /** 
        *坐骑列表
        */
        public var horselist:StructItemContainer2 = new StructItemContainer2();
        /** 
        *伙伴数据信息
        */
        public var petlist:Structpets2 = new Structpets2();
        /** 
        *副本数据信息
        */
        public var instancelist:StructInstanceInfo2 = new StructInstanceInfo2();
        /** 
        *高位key
        */
        public var key_hi:int;
        /** 
        *低位key
        */
        public var key_low:int;
        /** 
        *喊话数据
        */
        public var petshoutdata:StructPetShoutDatas2 = new StructPetShoutDatas2();
        /** 
        *角色限制数据
        */
        public var limit:StructDBLimitData2 = new StructDBLimitData2();
        /** 
        *队伍ID
        */
        public var teamid:int;
        /** 
        *队伍阵法ID
        */
        public var teamskill:int;
        /** 
        *队伍成员数据
        */
        public var arrItemteammember:Vector.<StructTeamMember2> = new Vector.<StructTeamMember2>();
        /** 
        *系统设置
        */
        public var systemsetting:int;
        /** 
        *系统签名
        */
        public var underwrite:int;
        /** 
        *系统签名
        */
        public var underwrite_p1:int;
        /** 
        *系统签名
        */
        public var underwrite_p2:int;
        /** 
        *VIP等级
        */
        public var vip:int;
        /** 
        *QQ 黄钻VIP等级
        */
        public var qqyellowvip:int;
        /** 
        *防沉迷状态
        */
        public var fcmstate:int;
        /** 
        *修炼数据
        */
        public var exercisedata:StructExercise2 = new StructExercise2();
        /** 
        *日志信息数据
        */
        public var loginfo:StructLogInfo2 = new StructLogInfo2();
        /** 
        *活动,成就信息数据
        */
        public var actinfo:StructActInfo2 = new StructActInfo2();
        /** 
        *自动挂机数据
        */
        public var autodata:StructAutoData2 = new StructAutoData2();
        /** 
        *world使用日志信息数据
        */
        public var worldloginfo:StructLogInfo2 = new StructLogInfo2();
        /** 
        *境界
        */
        public var bourn:StructBournList2 = new StructBournList2();
        /** 
        *战力值
        */
        public var gradeinfor:StructGradeInfo2 = new StructGradeInfo2();
        /** 
        *要保持的数据
        */
        public var para:Structpara2 = new Structpara2();
        /** 
        *充值元宝总数
        */
        public var coin_6all:int;
        /** 
        *后台充值元宝
        */
        public var coin_6gm:int;
        /** 
        *上次保存充值元宝总数
        */
        public var coin_6last:int;
        /** 
        *充值元宝总数
        */
        public var coinall:int;
        /** 
        *阵营奖励金币
        */
        public var campawardcoin:int;
        /** 
        *阵营奖励声望
        */
        public var campawardrenown:int;
        /** 
        *观星数据
        */
        public var starwatch:StructStarWatchData2 = new StructStarWatchData2();
        /** 
        *星魂战力值
        */
        public var starvalue:int;
        /** 
        *成就点数
        */
        public var ar_total_point:int;
        /** 
        *成就分类点数
        */
        public var ar_point:StructAr_Point2 = new StructAr_Point2();
        /** 
        *消息奖励
        */
        public var prizemsg:StructPrizeMsgDbInfoList2 = new StructPrizeMsgDbInfoList2();
        /** 
        *新手引导
        */
        public var newstep:StructNewStepInfo2 = new StructNewStepInfo2();
        /** 
        *双倍经验
        */
        public var doubleexp:StructDoubleExpInfo2 = new StructDoubleExpInfo2();
        /** 
        *排行榜排名
        */
        public var ranklevel:int;
        /** 
        *经验找回
        */
        public var expback:StructExpBackData2 = new StructExpBackData2();
        /** 
        *GM等级
        */
        public var gmpower:int;
        /** 
        *是否禁言
        */
        public var cantsay:int;
        /** 
        *buff
        */
        public var impact:StructImpactDbInfoList2 = new StructImpactDbInfoList2();
        /** 
        *客户端参数
        */
        public var client:StructClientPara2 = new StructClientPara2();
        /** 
        *cdkey兑换的记录
        */
        public var cdkey_ver:int;
        /** 
        *签到
        */
        public var signin:StructSignIn2 = new StructSignIn2();
        /** 
        *卡片信息
        */
        public var buffcard:StructCardInfo2 = new StructCardInfo2();
        /** 
        *升级奖励
        */
        public var levelupGift:int;
        /** 
        *家族数据
        */
        public var guildplayerdata:StructGuildPlayerData2 = new StructGuildPlayerData2();
        /** 
        *家族id
        */
        public var guildid:int;
        /** 
        *掌教至尊信息
        */
        public var guildfight:int;
        /** 
        *大乱斗信息
        */
        public var guildmelee:int;
        /** 
        *最后充值兑现记录
        */
        public var paylastid:int;
        /** 
        *皇城争霸称号
        */
        public var guildcity:int;
        /** 
        *pk之王称号
        */
        public var pkking:int;
        /** 
        *登录类型
        */
        public var login_type:int;
        /** 
        *境界战力值
        */
        public var grade_value_bourn:int;
        /** 
        *重铸战力值
        */
        public var grade_value_refound:int;
        /** 
        *魔纹战力值
        */
        public var grade_value_evilgrain:int;
        /** 
        *藏经阁
        */
        public var grade_value_card:int;
        /** 
        *cd时间
        */
        public var cd:StructCDList2 = new StructCDList2();
        /** 
        *神兽魂器强化等级
        */
        public var horse_strong:int;
        /** 
        *外形效果
        */
        public var r1:int;
        /** 
        *创建角色服务器时间
        */
        public var startserver_date:int;
        /** 
        *QQ黄钻充值续费次数
        */
        public var payvip_times:int;
        /** 
        *上次保存的QQ黄钻充值续费次数
        */
        public var payvip_times_last:int;
        /** 
        *阅历
        */
        public var exp2:int;
        /** 
        *未分配的天赋点
        */
        public var skillpoint:int;
        /** 
        *人物坐骑技能
        */
        public var horseskillinfo:StructHorseSkillItem_l2 = new StructHorseSkillItem_l2();
        /** 
        *vip特权信息
        */
        public var vipType:StructGameVipTypeInfo2 = new StructGameVipTypeInfo2();
        /** 
        *任务集市状态
        */
        public var task_status:int;
        /** 
        *仇敌列表
        */
        public var enemyList:StructEnemyList2 = new StructEnemyList2();
        /** 
        *角色创建日期
        */
        public var rolecreatedate:int;
        /** 
        *角色创建时间
        */
        public var rolecreatetime:int;
        /** 
        *星耀值
        */
        public var star_exp:int;
        /** 
        *星界等级
        */
        public var star_id:int;
        /** 
        *PK值
        */
        public var pkvalue:int;
        /** 
        *功勋值
        */
        public var ploit:int;
        /** 
        *功勋等级
        */
        public var ploit_level:int;
        /** 
        *值1(玉佩碎片)
        */
        public var value1:int;
        /** 
        *值2(护镜碎片)
        */
        public var value2:int;
        /** 
        *值3(荣誉)
        */
        public var value3:int;
        /** 
        *值4(暗器碎片)
        */
        public var value4:int;
        /** 
        *值5(剑灵值)
        */
        public var value5:int;
        /** 
        *天劫等级
        */
        public var soarlvl:int;
        /** 
        *天劫修为值
        */
        public var soarexp:int;
        /** 
        *坐骑升星等级
        */
        public var horsestarlevel:int;
        /** 
        *最大攻击力
        */
        public var attack:int;
        /** 
        *召唤怪
        */
        public var units:StructFollowUnits2 = new StructFollowUnits2();
        /** 
        *补偿礼金
        */
        public var redeem_coin2:int;
        /** 
        *补偿元宝
        */
        public var redeem_coin3:int;
        /** 
        *披风等级
        */
        public var shoulder_level:int;
        /** 
        *剑灵数据
        */
        public var bladeinfo:StructBladeInfo2 = new StructBladeInfo2();
        /** 
        *妻子角色id
        */
        public var wife_roleid:int;
        /** 
        *妻子名称
        */
        public var wife_name:String = new String();
        /** 
        *妻子原有区
        */
        public var wife_src_field:int;
        /** 
        *帮派商店
        */
        public var guildshop:StructGuildShop2 = new StructGuildShop2();
        /** 
        *天书等级
        */
        public var heavenbookLv:int;
        /** 
        *天书碎片数量
        */
        public var heavenbookExp:int;
        /** 
        *宝石信息
        */
        public var geminfo:StructRoleGemInfo2 = new StructRoleGemInfo2();
        /** 
        *值6(神铁碎片)
        */
        public var value6:int;
        /** 
        *神器等级
        */
        public var god_level:int;
        /** 
        *翅膀等级
        */
        public var wing_level:int;
        /** 
        *成就排名
        */
        public var ar_rank:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(accountID);
            ar.writeInt(roleID);
            ar.writeInt(role_field);
            PacketFactory.Instance.WriteString(ar, rolename, 32);
            ar.writeInt(icon);
            ar.writeInt(hp);
            ar.writeInt(mp);
            ar.writeInt(vim);
            ar.writeInt(renown);
            ar.writeInt(metier);
            ar.writeInt(sex);
            ar.writeInt(level);
            ar.writeDouble(exp);
            ar.writeInt(coin_1);
            ar.writeInt(coin_2);
            ar.writeInt(coin_3);
            ar.writeInt(coin_4);
            ar.writeInt(coin_5);
            ar.writeInt(coin_6);
            ar.writeInt(camp_id);
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
            ar.writeInt(mapid_b);
            ar.writeInt(mapx_b);
            ar.writeInt(mapy_b);
            ar.writeInt(logintimes);
            ar.writeInt(pkmode);
            ar.writeInt(s0);
            ar.writeInt(s1);
            ar.writeInt(s2);
            ar.writeInt(s3);
            ar.writeInt(ride);
            ar.writeInt(fightvalue);
            ar.writeInt(boneNum);
            task_all.Serialize(ar);
            task_his.Serialize(ar);
            bagItem.Serialize(ar);
            taskItem.Serialize(ar);
            equipItem.Serialize(ar);
            bankItem.Serialize(ar);
            starWatchItem.Serialize(ar);
            starComposeItem.Serialize(ar);
            starItem.Serialize(ar);
            actBankItem.Serialize(ar);
            skillList.Serialize(ar);
            shortKeyList.Serialize(ar);
            strongItemList.Serialize(ar);
            horselist.Serialize(ar);
            petlist.Serialize(ar);
            instancelist.Serialize(ar);
            ar.writeInt(key_hi);
            ar.writeInt(key_low);
            petshoutdata.Serialize(ar);
            limit.Serialize(ar);
            ar.writeInt(teamid);
            ar.writeInt(teamskill);
            ar.writeInt(arrItemteammember.length);
            for each (var teammemberitem:Object in arrItemteammember)
            {
                var objteammember:ISerializable = teammemberitem as ISerializable;
                if (null!=objteammember)
                {
                    objteammember.Serialize(ar);
                }
            }
            ar.writeInt(systemsetting);
            ar.writeInt(underwrite);
            ar.writeInt(underwrite_p1);
            ar.writeInt(underwrite_p2);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
            ar.writeInt(fcmstate);
            exercisedata.Serialize(ar);
            loginfo.Serialize(ar);
            actinfo.Serialize(ar);
            autodata.Serialize(ar);
            worldloginfo.Serialize(ar);
            bourn.Serialize(ar);
            gradeinfor.Serialize(ar);
            para.Serialize(ar);
            ar.writeInt(coin_6all);
            ar.writeInt(coin_6gm);
            ar.writeInt(coin_6last);
            ar.writeInt(coinall);
            ar.writeInt(campawardcoin);
            ar.writeInt(campawardrenown);
            starwatch.Serialize(ar);
            ar.writeInt(starvalue);
            ar.writeInt(ar_total_point);
            ar_point.Serialize(ar);
            prizemsg.Serialize(ar);
            newstep.Serialize(ar);
            doubleexp.Serialize(ar);
            ar.writeInt(ranklevel);
            expback.Serialize(ar);
            ar.writeInt(gmpower);
            ar.writeInt(cantsay);
            impact.Serialize(ar);
            client.Serialize(ar);
            ar.writeInt(cdkey_ver);
            signin.Serialize(ar);
            buffcard.Serialize(ar);
            ar.writeInt(levelupGift);
            guildplayerdata.Serialize(ar);
            ar.writeInt(guildid);
            ar.writeInt(guildfight);
            ar.writeInt(guildmelee);
            ar.writeInt(paylastid);
            ar.writeInt(guildcity);
            ar.writeInt(pkking);
            ar.writeInt(login_type);
            ar.writeInt(grade_value_bourn);
            ar.writeInt(grade_value_refound);
            ar.writeInt(grade_value_evilgrain);
            ar.writeInt(grade_value_card);
            cd.Serialize(ar);
            ar.writeInt(horse_strong);
            ar.writeInt(r1);
            ar.writeInt(startserver_date);
            ar.writeInt(payvip_times);
            ar.writeInt(payvip_times_last);
            ar.writeInt(exp2);
            ar.writeInt(skillpoint);
            horseskillinfo.Serialize(ar);
            vipType.Serialize(ar);
            ar.writeInt(task_status);
            enemyList.Serialize(ar);
            ar.writeInt(rolecreatedate);
            ar.writeInt(rolecreatetime);
            ar.writeInt(star_exp);
            ar.writeInt(star_id);
            ar.writeInt(pkvalue);
            ar.writeInt(ploit);
            ar.writeInt(ploit_level);
            ar.writeInt(value1);
            ar.writeInt(value2);
            ar.writeInt(value3);
            ar.writeInt(value4);
            ar.writeInt(value5);
            ar.writeInt(soarlvl);
            ar.writeInt(soarexp);
            ar.writeInt(horsestarlevel);
            ar.writeInt(attack);
            units.Serialize(ar);
            ar.writeInt(redeem_coin2);
            ar.writeInt(redeem_coin3);
            ar.writeInt(shoulder_level);
            bladeinfo.Serialize(ar);
            ar.writeInt(wife_roleid);
            PacketFactory.Instance.WriteString(ar, wife_name, 32);
            ar.writeInt(wife_src_field);
            guildshop.Serialize(ar);
            ar.writeInt(heavenbookLv);
            ar.writeInt(heavenbookExp);
            geminfo.Serialize(ar);
            ar.writeInt(value6);
            ar.writeInt(god_level);
            ar.writeInt(wing_level);
            ar.writeInt(ar_rank);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountID = ar.readInt();
            roleID = ar.readInt();
            role_field = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            icon = ar.readInt();
            hp = ar.readInt();
            mp = ar.readInt();
            vim = ar.readInt();
            renown = ar.readInt();
            metier = ar.readInt();
            sex = ar.readInt();
            level = ar.readInt();
            exp = ar.readDouble();
            coin_1 = ar.readInt();
            coin_2 = ar.readInt();
            coin_3 = ar.readInt();
            coin_4 = ar.readInt();
            coin_5 = ar.readInt();
            coin_6 = ar.readInt();
            camp_id = ar.readInt();
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
            mapid_b = ar.readInt();
            mapx_b = ar.readInt();
            mapy_b = ar.readInt();
            logintimes = ar.readInt();
            pkmode = ar.readInt();
            s0 = ar.readInt();
            s1 = ar.readInt();
            s2 = ar.readInt();
            s3 = ar.readInt();
            ride = ar.readInt();
            fightvalue = ar.readInt();
            boneNum = ar.readInt();
            task_all.Deserialize(ar);
            task_his.Deserialize(ar);
            bagItem.Deserialize(ar);
            taskItem.Deserialize(ar);
            equipItem.Deserialize(ar);
            bankItem.Deserialize(ar);
            starWatchItem.Deserialize(ar);
            starComposeItem.Deserialize(ar);
            starItem.Deserialize(ar);
            actBankItem.Deserialize(ar);
            skillList.Deserialize(ar);
            shortKeyList.Deserialize(ar);
            strongItemList.Deserialize(ar);
            horselist.Deserialize(ar);
            petlist.Deserialize(ar);
            instancelist.Deserialize(ar);
            key_hi = ar.readInt();
            key_low = ar.readInt();
            petshoutdata.Deserialize(ar);
            limit.Deserialize(ar);
            teamid = ar.readInt();
            teamskill = ar.readInt();
            arrItemteammember= new  Vector.<StructTeamMember2>();
            var teammemberLength:int = ar.readInt();
            for (var iteammember:int=0;iteammember<teammemberLength; ++iteammember)
            {
                var objTeamMember:StructTeamMember2 = new StructTeamMember2();
                objTeamMember.Deserialize(ar);
                arrItemteammember.push(objTeamMember);
            }
            systemsetting = ar.readInt();
            underwrite = ar.readInt();
            underwrite_p1 = ar.readInt();
            underwrite_p2 = ar.readInt();
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
            fcmstate = ar.readInt();
            exercisedata.Deserialize(ar);
            loginfo.Deserialize(ar);
            actinfo.Deserialize(ar);
            autodata.Deserialize(ar);
            worldloginfo.Deserialize(ar);
            bourn.Deserialize(ar);
            gradeinfor.Deserialize(ar);
            para.Deserialize(ar);
            coin_6all = ar.readInt();
            coin_6gm = ar.readInt();
            coin_6last = ar.readInt();
            coinall = ar.readInt();
            campawardcoin = ar.readInt();
            campawardrenown = ar.readInt();
            starwatch.Deserialize(ar);
            starvalue = ar.readInt();
            ar_total_point = ar.readInt();
            ar_point.Deserialize(ar);
            prizemsg.Deserialize(ar);
            newstep.Deserialize(ar);
            doubleexp.Deserialize(ar);
            ranklevel = ar.readInt();
            expback.Deserialize(ar);
            gmpower = ar.readInt();
            cantsay = ar.readInt();
            impact.Deserialize(ar);
            client.Deserialize(ar);
            cdkey_ver = ar.readInt();
            signin.Deserialize(ar);
            buffcard.Deserialize(ar);
            levelupGift = ar.readInt();
            guildplayerdata.Deserialize(ar);
            guildid = ar.readInt();
            guildfight = ar.readInt();
            guildmelee = ar.readInt();
            paylastid = ar.readInt();
            guildcity = ar.readInt();
            pkking = ar.readInt();
            login_type = ar.readInt();
            grade_value_bourn = ar.readInt();
            grade_value_refound = ar.readInt();
            grade_value_evilgrain = ar.readInt();
            grade_value_card = ar.readInt();
            cd.Deserialize(ar);
            horse_strong = ar.readInt();
            r1 = ar.readInt();
            startserver_date = ar.readInt();
            payvip_times = ar.readInt();
            payvip_times_last = ar.readInt();
            exp2 = ar.readInt();
            skillpoint = ar.readInt();
            horseskillinfo.Deserialize(ar);
            vipType.Deserialize(ar);
            task_status = ar.readInt();
            enemyList.Deserialize(ar);
            rolecreatedate = ar.readInt();
            rolecreatetime = ar.readInt();
            star_exp = ar.readInt();
            star_id = ar.readInt();
            pkvalue = ar.readInt();
            ploit = ar.readInt();
            ploit_level = ar.readInt();
            value1 = ar.readInt();
            value2 = ar.readInt();
            value3 = ar.readInt();
            value4 = ar.readInt();
            value5 = ar.readInt();
            soarlvl = ar.readInt();
            soarexp = ar.readInt();
            horsestarlevel = ar.readInt();
            attack = ar.readInt();
            units.Deserialize(ar);
            redeem_coin2 = ar.readInt();
            redeem_coin3 = ar.readInt();
            shoulder_level = ar.readInt();
            bladeinfo.Deserialize(ar);
            wife_roleid = ar.readInt();
            var wife_nameLength:int = ar.readInt();
            wife_name = ar.readMultiByte(wife_nameLength,PacketFactory.Instance.GetCharSet());
            wife_src_field = ar.readInt();
            guildshop.Deserialize(ar);
            heavenbookLv = ar.readInt();
            heavenbookExp = ar.readInt();
            geminfo.Deserialize(ar);
            value6 = ar.readInt();
            god_level = ar.readInt();
            wing_level = ar.readInt();
            ar_rank = ar.readInt();
        }
    }
}
