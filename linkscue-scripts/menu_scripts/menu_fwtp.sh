#!/bin/bash

#self
script_self=$(readlink -f $0)

#dir
TOPDIR=${script_self%/linkscue-scripts/menu_scripts/menu_fwtp.sh}
scripts_dir=$TOPDIR/linkscue-scripts
sub_menu_dir=$scripts_dir/menu_scripts
zipalign=$TOPDIR/linkscue-scripts/zipalign

framework_res_apk=$1/framework-res.apk
framework_res_dir=${framework_res_apk%.*}
framework_res_dirname=`dirname $framework_res_apk`
framework_res_new=$framework_res_dirname/framework-res_new.apk
style=$framework_res_dir/res/values/styles.xml
color=$framework_res_dir/res/values/colors.xml
mkframeworktp_dir=$TOPDIR/linkscue-scripts/mkframeworktp
change_xml=$mkframeworktp_dir/change_xml.sh
merge_apk=$scripts_dir/apktool/mergeapk.sh
apktool=$scripts_dir/apktool/apktool

#init
clear
echo "
欢迎使用linkscue 全局透明定制厨房工具！
"
echo "
要求已配置好java环境，否则这一步将无法执行。
"

while [[ ! -f $framework_res_dirname/framework-res.apk ]];do 
read -p "请把framework-res.apk放置于$(basename $1):"
echo ""
done

while [[ $(which java) == "" ]]; do
    read -p "请先把java环境配置好，否则无法反编译framework-res.apk:"
    echo ""
	read -p "请按任意键返回主菜单:"
	$TOPDIR/scue_kitchen.sh
done

if [[ ! -e $framework_res_apk ]]; then
    echo "I: can't find the framework-res.apk"
    exit 1
else 
    echo "I: 正在制作全局透明界面 .."
    $apktool install-framework $framework_res_apk
    echo "I: 正在反编译framework-res.apk，并执行修改，请您耐心等待几分钟 .."
    $apktool d -f $framework_res_apk $framework_res_dir 2> /dev/null
    clear
    echo ""
    echo "欢迎使用linkscue 全局透明定制厨房工具！"
    echo ""
    if [[ $? != 0 ]]; then
        echo "I: please install apktool to ~/bin/apktool."
        exit 1
    else
        echo ""
        echo "I: 正在修改主题文件.."
        echo ""
        $change_xml $style $color 
        $merge_apk -r $framework_res_dir $framework_res_new &> /dev/null
        echo ""
        echo "I: 支持全局透明背景文件已位于 $(basename $framework_res_dirname)/$(basename $framework_res_new)"
    fi

fi

echo ""
read -p "请按任意键返回主菜单:"
$TOPDIR/scue_kitchen.sh
